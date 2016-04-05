function [ output_args ] = setparent(parent)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

persistent parentOut;

if nargin ==1
    parentOut = parent;
end
    
if nargin == 0
    if length(parentOut) == 0
        output_args = 0;
    end
    output_args = parentOut;
end 
end

