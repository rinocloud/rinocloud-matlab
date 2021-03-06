function [ ids ] = search_last(number)
%search_last - returns ids of last 'number' of objects
%   

    APIToken = rino.authentication;
    headers = [rino.http_createHeader('Authorization',APIToken), rino.http_createHeader('Content-Type','application/json')];
    try
        metadata = rino.urlread2(strcat(rino.api,'/files/search/'),'POST', savejson('', struct('query', '*','limit',number)), headers);
        structure=loadjson(metadata);
        result=structure.result;
    catch
        warning('An error occured and your computer did not connect to Rinocloud.');
    end
    
    ids={};
    try
        for tt=1:length(result)
            ids{tt}=result{tt}.id;
        end
    catch
        warning('An error occured and search_last did not recieve a list of ocject IDs from Rinocloud.');
    end
end

