function [ response_struct ] = create_folder( folder_name )
%UNTITLED10 Summary of this function goes here
%   Detailed explanation goes here

    checkfoldername(folder_name);

    %Get APIToken
    APIToken = rino.authentication;
    
    %create http headers
    headers = [rino.http_createHeader('Authorization',APIToken), rino.http_createHeader('Content-Type','application/json')];
try
    response = rino.urlread2(strcat(rino.api,'/files/create_folder/'),'POST',savejson('', struct('name',folder_name)), headers);
    
    try
        response_struct = loadjson(response);
    catch
        response_struct = response;
    end
catch
     warning('An error occured.');
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

end

