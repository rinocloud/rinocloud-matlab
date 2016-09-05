function [ output ] = download(ID, varargin)
    % download -  downloads the file specifed by the object id to the current
    % working directory
    % download has one required argument, the object ID of the files to
    % download.
    % download also takes the following optional arguments:
    % totext - setting totext to be true casts the downloaded data to text -
    % e.g. rino.download(575, 'totext', true). Otherwise the data will be
    % treated as uint8. Sepecifing totext to be true automaticaly sets tofile
    % to be false.
    % tofile - by default this is set to true, if it is set to false, the
    % downloaded data to read into a MATLAB variable and not saved to a file.
    % e.g. rino.download(575, 'tofile', false).
    % format - this is passed to the function as a string. The format string
    % specifys the the format of data saved in a text file. Giving a format
    % string automatically tells the function to read the data into a matlab
    % array. For example, if the object 6767 is a text file
    % containing two columns of floating point numbers separated by a space,
    % in order to read them into a variable we woud enter:
    % rino.download(6767, 'format', '%f %f');

    checkID(ID);

    p = inputParser;
    addOptional(p, 'tofile', true, @check01)
    addOptional(p, 'totext', false, @check01)
    addParamValue(p,'newname','',@checknewname);
    addParamValue(p,'format','',@checkformat);

    p.parse(varargin{:});
    input=p.Results;

    if sum(size(input.format)) > 0
        input.totext = true;
    end
    if input.totext == true
        input.tofile = false;
    end

    % Set filename - Set file name if newname given, leave as original name if no name given
    metadata = rino.get_metadata(ID);

    size_on_rinocloud = metadata.size;

    if sum(size(input.newname)) > 0
        fname=input.newname;
    else
        fname = metadata.name;
    end

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

    %Get APIToken
    APIToken = rino.authentication;
    % create http headers
    headers = [rino.http_createHeader('Authorization',APIToken), rino.http_createHeader('Content-Type','application/json')];

    %convert ID to string
    if isnumeric(ID)
        ID = num2str(ID);
    end

    downloadeddata = rino.urlread2(strcat(strcat(rino.api,'/files/download/?id='), ID),'GET', '', headers,'CAST_OUTPUT', input.totext);

    %save to file or return binary data if requested

    if input.tofile == true
        newDir = 'rinodata';
        if ~exist(newDir, 'dir')
            mkdir(newDir);
        end
        fdl = fopen([newDir, '/', fname],'wb');
        fwrite(fdl, downloadeddata);
        fclose(fdl);
        output=setfield(metadata, 'name', fname);

        s = dir([newDir, '/', fname]);
        assert(size_on_rinocloud == s.bytes, 'Downloaded file size is not the same as on Rinocloud')
    else
        if sum(size(input.format)) > 0
            output = textscan(downloadeddata, input.format);
        else
            output = downloadeddata;
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

    function TF = checkformat(x)
        TF = false;
        if ischar(x)
            TF = true;
        else
            error('Specify the format as a string.');
        end
    end

end
