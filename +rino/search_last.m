function [ ids ] = search_last(number)
%search_last - returns ids of last 'number' of objects
%   Detailed explanation goes here

    APIToken = rino.authentication;
    headers = [rino.http_createHeader('Authorization',APIToken), rino.http_createHeader('Content-Type','application/json')];
    metadata = rino.urlread2(strcat(rino.api,'/files/search/'),'POST', rino.savejson('', struct('query', '*','limit',number)), headers);
    structure=rino.loadjson(metadata);
    result=structure.result;
    
    ids={};
    for tt=1:length(result)
        ids{tt}=result{tt}.id;
    end
end

