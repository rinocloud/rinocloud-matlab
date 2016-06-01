function [ response_struct ] = create_folder( folder_name, varargin )
% create_folder -  creates a folder
%   create_folder takes on argument (the folder name) and one optional
%   argument, the id of the folders parent folder. e.g. to create a folder
%   called 'new data' inside a parent folder with ID=7575, enter
%   rino.create_folder('new data', 'parent', '7575');

    checkfoldername(folder_name);
    p = inputParser;
    addParamValue(p,'parent','',@checkparent);
    p.parse(varargin{:});
    input=p.Results;


    %Get APIToken
    APIToken = rino.authentication;

    %set parent struct
    if sum(size(input.parent)) > 0
        parentstruct = struct('parent',input.parent);
    else
        parentstruct = struct();
    end

    %create http headers
    headers = [rino.http_createHeader('Authorization',APIToken), rino.http_createHeader('Content-Type','application/json')];
    try
        response = rino.urlread2(strcat(rino.api,'/files/create_folder_if_not_exist/'),'POST',savejson('', rino.catstruct(struct('name',folder_name), parentstruct)), headers);
        response_struct = loadjson(response);

        if isfield(response_struct,'error')
          if strcmp(response_struct.error, 'Folder name conflict.')~=1
            warning(['error: ', response_struct.error]);
          end
        end
    catch
         warning('An error occured and your computer could not connect to Rinocloud.');
         response_struct='error.';
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Input verification functions
    function TF = checkfoldername(x)
        TF = false;
        if ischar(x)
            TF = true;
        else
            error('Specify the folder name as a string.');
        end
    end

    function TF = checkparent(x)
        TF = false;
        if isstr(x) || isnumeric(x)
            if isstr(x)
               if length(str2num(x))<1
                   error('Parent must be specified by its object ID - the object ID is a number, not a file name.')
               end
            end
            TF = true;
        else
            error('Parent should be specified and the object ID of the parent folder. This can be specified as a string or a number.');
        end
    end

end
