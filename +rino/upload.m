function [ response_struct ] = upload(fname, varargin)
%upload - used to upload files to rinocloud
%   Full description from MD text

    %Parse the input and validate optional arguments
    p = inputParser;
    addParamValue(p,'metadata','',@checkmetadata);
    addParamValue(p,'tags','',@checktags);
    addParamValue(p,'newname','',@checknewname);
    addParamValue(p,'parent','',@checkparent);
    p.parse(varargin{:});
    input=p.Results;

    %Load binary data from file
    fid = fopen(fname, 'rb');
    binary_data = fread(fid,Inf,'*uint8');
    fclose(fid);

    % Set filename struct - Set file name if newname given, leave as original name if no name
    %given
    if sum(size(input.newname)) > 0
        namestruct = struct('name', input.newname);
    else
        namestruct = struct('name', fname);
    end
    
    %Set tags struct
    if sum(size(input.tags)) > 0
        tagsstruct = struct('tags',char([input.tags], {''}, {''})); 
    else
        tagsstruct = struct();
    end
    
    %Set metadata struct
    if sum(size(input.metadata)) > 0
        metadata = input.metadata;
    else
        metadata = struct();
    end
    
    %set parent struct
    if sum(size(input.parent)) > 0
        parentstruct = struct('parent',input.parent);
    else
        parentstruct = struct();
    end
    
    %Get APIToken
    APIToken = rino.authentication;
    
    %JSONify metadata and tags
    metadatajson = rino.savejson('', rino.catstruct(metadata, tagsstruct, namestruct, parentstruct), struct('Compact', 1));
        
    %Set http request headers
    headers = [rino.http_createHeader('Authorization',APIToken), rino.http_createHeader('Content-Type','application/json'), rino.http_createHeader('rinocloud-api-payload', metadatajson)];

    %Make http request
    response = rino.urlread2(strcat(rino.api,'/files/upload_binary/'),'POST', binary_data, headers);
    
    try
        response_struct = rino.loadjson(response);
    catch
        response_struct = response;
    end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Input verification functions
    function TF = checkmetadata(x)
        TF = false;
        if isstruct(x)
            TF = true;
        else
            error('The metadata should be passed to the upload function as a structure array. See http://uk.mathworks.com/help/matlab/ref/struct.html for information of how to create structure arrays.');
        end
    end

    function TF = checknewname(x)
        TF = false;
        if isstr(x)
            TF = true;
            if 2 > length(regexp(x, '\.', 'split'))
                warning('Your new file name does not include a file extention. Your data will still be saved to Rinocloud, but the file type will be unspecified and may be hard to open. You should always include the file extension of the original file in new file names.')
            end
        
        else
            error('The new file name (newname) should be passed to the upload function as a string.');
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

    function TF = checktags(x)
        TF = false;
        if  (iscell(x) && (sum(cellfun(@ischar,x))==length(x)))
            TF = true;
        else
            error('The tags should be input as strings in a cell array.');
        end
    end

end

