function [ response_struct ] = get_children( ID)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    if nargin==1
        checkID(ID);
    end

    %Get APIToken
    APIToken = rino.authentication;
    
    %Prepare http headers
    headers = [rino.http_createHeader('Authorization',APIToken), rino.http_createHeader('Content-Type','application/json')];
    try
        if nargin==1
            response = rino.urlread2(strcat(rino.api,'/files/children/'),'POST', savejson('', struct('id', ID)), headers);
        end
        if nargin==0
            response = rino.urlread2(strcat(rino.api,'/files/children/'),'POST', '', headers);
        end
    catch
        warning('An error occured and your computer did not connect to Rinocloud.');
    end
    
    try
        response_struct = loadjson(response);
    catch
        try
        response_struct = response;
        catch
            warning('An error occured and your computer did not recieve a response from Rinocloud.');
            response_struct='error';
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
