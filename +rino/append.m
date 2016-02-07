function [ response_struct ] = append( ID, chunk)
%append - appends data to an existing file.
%   append takes two arguments, the ID of the file to be appended to and
%   the chunk of data to be appended.

    %Check inputs
    checkID(ID);

        %Get APIToken
    APIToken = rino.authentication;
    
    %JSONify metadata_struct
    metadatajson = savejson('', rino.catstruct(struct('chunk', chunk), struct('id', ID)), struct('Compact', 1));
    
    %Prepare http headers
    headers = [rino.http_createHeader('Authorization',APIToken), rino.http_createHeader('Content-Type','application/json')];



    
        %Make post request
    try
        response = rino.urlread2(strcat(rino.api,'/files/append/'),'POST',metadatajson, headers);
    catch
        warning('An error occured and your computer did not connect to Rinocloud.');
    end

    try
        response_struct = loadjson(response);
    catch
        try
            response_struct = response;
        catch
            warning('An error occured and your computer did not recieve a response from Rinocloud.');
            response_struct='error';
        end
    end
    


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Checking inputs
    function TF = checkID(x)
        TF = false;
        if isstr(x) || isnumeric(x)
            if isstr(x)
               if length(str2num(x))<1
                   error('File must be specified by its object ID - the object ID is a number, not a file name.')
               end
            end
            TF = true;
        else
            error('File ID should be specified. This can be specified as a string or a number.');
        end
    end




end

