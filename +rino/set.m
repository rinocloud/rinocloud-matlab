function [ response ] = set(ID, param, value)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

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
