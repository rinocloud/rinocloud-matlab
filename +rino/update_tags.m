function [ response_struct ] = update_tags( ID, tags )
%update_tags - overwrites old tags with new specified tags.
%   Takes two arguments - object ID of the object to be updated and the new
%   tags as a cell array of strings. e.g. rino.update_tags(657, {'newtag1',
%   'newtag2'});

    %Check inputs
    checkID(ID);
    checktags(tags);
    
    %Get APIToken
    APIToken = rino.authentication;
    
    %JSONify metadata_struct
    metadatajson = savejson('', rino.catstruct(struct('tags',char([tags,{''}, {''}])), struct('id', ID)), struct('Compact', 1));

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

