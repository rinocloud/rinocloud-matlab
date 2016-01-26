function [ output ] = download_last(number ,varargin)
% download -  downloads the file specifed by the object id to the current
% working directory
%   Detailed explanation goes here

    %if only key-value pairs included, download most recent.


    checknumber(number);

    %search
    ids=rino.search_last(number);
    
    %Parse input
    p = inputParser;
    addOptional(p, 'totext', false, @check01)
    addOptional(p, 'tofile', true, @check01)
    addParamValue(p,'format','',@checkformat)
    p.parse(varargin{:});
    input=p.Results;
    

    if sum(size(input.format)) > 0
        input.totext = true;
    end
    if input.totext == true
        input.tofile = false;
    end
    
    
    %Get token
    APIToken = rino.authentication;
    % create http headers
    headers = [rino.http_createHeader('Authorization',APIToken), rino.http_createHeader('Content-Type','application/json')];
    
    output={};
    %Loop to multi_download
    
    for mm=1:length(ids)
        
        
        ID=ids{mm};
    
        % Set filename - Set file name if newname given, leave as original name if no name given
        metadata = rino.get_metadata(ID);
        fname = metadata.name;


        %Check to see if file exists
        if exist(fname, 'file') == 2
            basefname=fname;
            for tt=1:1000
                if exist(fname, 'file') == 2
                   filebits=regexp(basefname, '\.', 'split');
                   file=char(filebits(1:end-1));
                   ext=char(filebits(end));
                   fname=char(strcat(file,'(', num2str(tt),').', ext));
                else
                    break
                end
                if tt == 1000
                    error('You have 1000 files with this name in this directory - please choose a different filename.')
                end
            end
        end


        %convert ID to string
        if isnumeric(ID)
            ID = num2str(ID);
        end
        %download data
        downloadeddata = rino.urlread2(strcat(strcat(rino.api,'/files/download/?id='), ID),'GET', '', headers,'CAST_OUTPUT', input.totext);

        %save to file or return binary data if requested

        if input.tofile == true
            fdl = fopen(fname,'wb');
            fwrite(fdl, downloadeddata);
            fclose(fdl);
            output{mm}=setfield(metadata, 'name', fname);
        else
            if sum(size(input.format)) > 0
            output{mm} = textscan(downloadeddata, input.format);
            else
            output{mm} = downloadeddata;
            end
        end
    end
    
    
    if length(output)==1
        output=output{1};
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


    function TF = check01(x)
        TF = false;
        if (x==1 || x==0)
            TF = true;
        else
            error('Input should be 0 (false) or 1 (true)');
        end
    end

    function TF = checknewname(x)
        TF = false;
        if isstr(x)
            TF = true;
            if 2 > length(regexp(x, '\.', 'split'))
                warning('Your new file name does not include a file extention.')
            end
        
        else
            error('The new file name (newname) should be passed to the download function as a string.');
        end
    end
   
    function TF = checknumber(x)
        TF = false;
        if isnumeric(x)
            TF = true;
        else
            error('The number of last files must be a number');
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

end

