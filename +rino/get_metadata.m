function [ response_struct ] = get_metadata(ID)
% get_metadata - returns the metadata for a given object ID
%   e.g. rino.get_metadata(6645);

    checkID(ID);

    %Get APIToken
    APIToken = rino.authentication;
    
    %Prepare http headers
    headers = [rino.http_createHeader('Authorization',APIToken), rino.http_createHeader('Content-Type','application/json')];
    try
        response = rino.urlread2(strcat(rino.api,'/files/get_metadata/'),'POST', savejson('', struct('id', ID)), headers);
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
            error('File should be specified and the object ID of the parent folder. This can be specified as a string or a number.');
        end
    end

end

