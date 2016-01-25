function [ output_args ] = authentication( APIToken )
%authentication - Sets the API Token when given an API Token, otherwise returns the API Token
% 
    persistent APITokenOut;
    if nargin ==1
        if ischar(APIToken) ~= 1
            error('API Token must be given as a string.')
        end
        APITokenOut=APIToken;
    end
    
    if length(APITokenOut) == 0
        error('Please set your API Token')
    end

    output_args = ['Token ' ,APITokenOut];
end

