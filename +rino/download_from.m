function [ output ] = download_from( ID, from, varargin )
%download_from downloads data from a text file from a specified location
%until the end of the file.
%   download_from downloads data from a text file from a specified location
%   until the end of the file. This is useful for live plotting/updating.
%   The function takes two input arguments and an optional third format
%   argumment. The required arguments are the object ID of the file to
%   download and the size in bytes of the first part of the file to ignore.
%   The optional argument is the format string. For example, to download a
%   a file (object ID - 7575) of two columns of space separated floating point numbers from 
%   the 800 byte mark, we enter rino.download_from(7575, 800, 'format', '%f %f')

    %Check inputs

    checkID(ID);
    checkfrom(from);
    from = num2str(from);
    
    %parse input
    p = inputParser;
    addParamValue(p,'format','',@checkformat);
    p.parse(varargin{:});
    input=p.Results;
    
        %Get APIToken
    APIToken = rino.authentication;
    % create http headers
    headers = [rino.http_createHeader('Authorization',APIToken), rino.http_createHeader('Content-Type','application/json')];

    %convert ID to string
    if isnumeric(ID)
        ID = num2str(ID);
    end
    
try
    %download data
    downloadeddata = rino.urlread2(strcat(strcat(rino.api,'/files/download/?id='), ID, '&from=', from),'GET', '', headers,'CAST_OUTPUT', true);
catch
    warning('An error occurred and you computer did not connect to Rinocloud.') 
end

try
    if sum(size(input.format)) > 0
            output = textscan(downloadeddata, input.format);
    else
            output = downloadeddata;
    end
catch
         warning('An error occured and your computer did not recieve a response from Rinocloud.');
         output = 'error.';
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


    function TF = checkformat(x)
        TF = false;
        if ischar(x)
            TF = true;
        else
            error('Specify the format as a string.');
        end
    end

    function TF = checkfrom(x)
        TF = false;
        if isnumeric(x)
            TF = true;
        else
            error('Specify the format as a string.');
        end
    end
    
    
end

