function [ response_struct ] = delete(ID)
%delete - deletes object specified by given object ID
%   Detailed explanation goes here
    checkID(ID);

    %Get APIToken
    APIToken = rino.authentication;
    try
    %Prepare http headers
    headers = [rino.http_createHeader('Authorization',APIToken), rino.http_createHeader('Content-Type','application/json')];
    response = rino.urlread2(strcat(rino.api,'/files/delete/'),'POST', savejson('', struct('id', ID)), headers);

    if isempty(response)
        response_struct = 'Object deleted';
    else
        try
            response_struct = rino.loadjson(response);

        catch
            response_struct = response;
        end
    end
    catch
         warning('An error occured.');
         response_struct='error';
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

