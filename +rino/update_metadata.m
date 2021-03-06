function [ response_struct ] = update_metadata(ID, metadata )
%update_metadata - used to update the metadata of an object. 
%   update_metadata takes two arguments. The object ID of the object to be 
%   updated and the new metadata as a structure array. e.g
%   rino.update_metadata(6473, struct('Power', '7 mW'));

    %Check inputs
    checkID(ID);
    checkmetadata(metadata);

    %Get APIToken
    APIToken = rino.authentication;
    
    %JSONify metadata_struct
    metadatajson = savejson('', rino.catstruct(struct('metadata', metadata), struct('id', ID)), struct('Compact', 1));
    
    %Prepare http headers
    headers = [rino.http_createHeader('Authorization',APIToken), rino.http_createHeader('Content-Type','application/json')];

    %Make post request
    try
        response = rino.urlread2(strcat(rino.api,'/files/update_metadata/'),'POST',metadatajson, headers);
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

    function TF = checkmetadata(x)
        TF = false;
        if isstruct(x)
            TF = true;
        else
            error('The metadata should be passed to the update_metadata function as a structure array. See http://uk.mathworks.com/help/matlab/ref/struct.html for information of how to create structure arrays.');
        end
    end

end

