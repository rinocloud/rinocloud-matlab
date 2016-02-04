function [ output_args ] = authentication( APIToken )
%authentication - Sets the API Token when given an API Token, otherwise returns the API Token
% 
    persistent APITokenOut;
    if nargin ==1
        if ischar(APIToken) ~= 1
            error('API Token must be given as a string.')
        end
        APITokenOut=APIToken;
        disp(sprintf ( '\nAPI Token set.') )       
    end
    
    if nargin == 0
    
    if length(APITokenOut) == 0 || strcmp(APITokenOut, '0000000000000000000000000000')
        error('Please set your API Token.')
    end

    output_args = ['Token ' ,APITokenOut];
    end
end

