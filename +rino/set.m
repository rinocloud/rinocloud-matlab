function [ response ] = set(ID, param, value)
%set - sets a metadata parameter.
%   The set function is a shortcut to the update_metadata function. 
%   The function takes three input arguments, the ID of the object to be
%   updated, the parameter name of the metadata to be updated and the new
%   metadata variable. e.g. rino.set(6479, 'power', '6 nW');

checkID(ID);
checkparam(param);

metadata = struct(param, value);

response=rino.update_metadata(ID, metadata);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Checking inputs

    function TF = checkID(x)
        TF = false;
        if isstr(x) || isnumeric(x)
            if isstr(x)
               if length(str2num(x))<1
                   error('Object must be specified by its object ID - the object ID is a number, not a file name.')
               end
            end
            TF = true;
        else
            error('Object should be specified and the object ID of the parent folder. This can be specified as a string or a number.');
        end
    end

    function TF = checkparam(x)
        TF = false;
        if ischar(x) && length(strfind(x, ' '))==0
            TF = true;
        else
            error('Specify the parameter name as a string with no spaces.');
        end
    end

end

