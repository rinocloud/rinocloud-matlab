function [  ] = liveplot( seconds )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
for tt=1:seconds
    Data=rino.download(943, 'format', '%s %f');
    ToPlot
    plot(sin(4*0.01*Data{2}))
    pause(1);
end

end

