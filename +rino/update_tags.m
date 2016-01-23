function [ response_struct ] = update_tags( ID, tags )
%update_tags - overwrites old tags with new specified tags.
%   Detailed explanation goes here

    %Check inputs
    checkID(ID);
    checktags(tags);
    
    %Get APIToken
    APIToken = rino.authentication;
    
    %JSONify metadata_struct
    metadatajson = rino.savejson('', rino.catstruct(struct('tags',char([tags,{''}, {''}])), struct('id', ID)), struct('Compact', 1))

        %Prepare http headers
    headers = [rino.http_createHeader('Authorization',APIToken), rino.http_createHeader('Content-Type','application/json')];

    %Make post request
    response = rino.urlread2(strcat(rino.api,'/files/update_metadata/'),'POST',metadatajson, headers);
    
    try
        response_struct = rino.loadjson(response);
    catch
        response_struct = response;
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

    function TF = checktags(x)
        TF = false;
        if  (iscell(x) && (sum(cellfun(@ischar,x))==length(x)))
            TF = true;
        else
            error('The tags should be input as strings in a cell array.');
        end
    end
end
