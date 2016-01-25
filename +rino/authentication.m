function [ output_args ] = authentication( ~ )
%authentication - returns the authentication token
% 
Token='df8f94649696abc16270369405a2f491b7c2cfd0';
if strcmp(Token,'Your API Token goes here.')
    error('You have not set your API Token. Copy and paste your API Token (found on the "Integrations" section of the Rinocloud website) into the authentication.m function found in the +rino folder.')
end
output_args=['Token ',Token];   

end

