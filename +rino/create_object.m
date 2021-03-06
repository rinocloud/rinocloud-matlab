function [ response_struct ] = create_object( name, varargin  )
%create_object - This function creates an object with noassociated file, it
%just contains metadata. 
%   create_object has one required argument, the name of the object as a
%   string. It also takes the following optional arguments:
%   metadata - passed to the function as a struct containing key value pairs. e.g. rino.create_object('ControlObj', 'metadata', struct('Temperature', '5 K') )
%   tags - passed to the function as a cell array of strings. e.g. rino.create_object('ControlObj', 'tags', {'good data', 'test tag'})
%   parent - a number specifying the object id of the folder that you want the object to be saved into. e.g. rino.create_object('ControlObj', 'parent', 6667)


 checkname(name);
 
 
     %Parse the input and validate optional arguments
    p = inputParser;
    addParamValue(p,'metadata','',@checkmetadata);
    addParamValue(p,'tags','',@checktags);
    addParamValue(p,'parent','',@checkparent);
    p.parse(varargin{:});
    input=p.Results;

    
    
     
    
        %Set tags struct
    if sum(size(input.tags)) > 0
        tagsstruct = struct('tags',char([input.tags, {''}, {''}])); 
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
    metadatajson = savejson('', rino.catstruct(struct('metadata', metadata), tagsstruct, struct('name',name), parentstruct), struct('Compact', 1));
 
    
    %create http headers
    headers = [rino.http_createHeader('Authorization',APIToken), rino.http_createHeader('Content-Type','application/json')];
 
try
    response = rino.urlread2(strcat(rino.api,'/files/create_object/'),'POST',metadatajson , headers);
    
    try
        response_struct = loadjson(response);
    catch
        response_struct = response;
    end
catch
     warning('An error occured and you computer could not connect to Rinocloud');
     response_struct='error.';
end


 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Input verification functions
    function TF = checkname(x)
        TF = false;
        if ischar(x)
            TF = true;
        else
            error('Specify the file name as a string.');
        end
    end
 

   function TF = checkmetadata(x)
        TF = false;
        if isstruct(x)
            TF = true;
        else
            error('The metadata should be passed to the upload function as a structure array. See http://uk.mathworks.com/help/matlab/ref/struct.html for information of how to create structure arrays.');
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





