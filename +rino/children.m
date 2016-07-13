function [ response_struct ] = children(ID, recursive)
    % children - returns the metadata for a given object ID
    % e.g. rino.children(6645);

    if nargin < 2
      recursive = false;
    end

    checkID(ID);

    % Get APIToken
    APIToken = rino.authentication;

    % Prepare http headers
    headers = [rino.http_createHeader('Authorization', APIToken), rino.http_createHeader('Content-Type','application/json')];
    response = rino.urlread2(strcat(rino.api,'/files/get_metadata/'),'POST', savejson('', struct('id', ID)), headers);
    top = loadjson(response);

    headers = [rino.http_createHeader('Authorization', APIToken), rino.http_createHeader('Content-Type','application/json')];
    response = rino.urlread2(strcat(rino.api,'/files/children/'),'POST', savejson('', struct('id', ID)), headers);
    top_level_response = loadjson(response);

    response_struct = top_level_response.result;

    if recursive
      for idx = 1:numel(response_struct)
          element = response_struct{idx};
          if strcmp(element.type, 'folder')
            response_struct{idx}.children = rino.children(element.id);
          end
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
