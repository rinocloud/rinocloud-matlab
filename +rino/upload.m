function [ output_args ] = upload(varargin)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%Parse the input
p = inputParser;
addParamValue(p,'metadata','',@checkmetadata);
addParamValue(p,'newname','',@checknewname);
addParamValue(p,'parent','',@checkparent);
p.parse(varargin{:});
output=p.Results;


%Get APIToken
APIToken = rino.authentication;




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
        if isstr(x) || isnumeric(x) && size(str2num(x))>0
            TF = true;
        else
            error('Parent should be specified and the object ID of the parent folder. This can be specified as a string or a number.');
        end
    end

end

