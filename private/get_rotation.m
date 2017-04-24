% [ rot ] = get_rotation( key )
% Returns a built in rotation factor which matches the given key.
% Key can be:
%   'tosca' = to display shapes from the TOSCA dataset.
%   'faust' = to display shapes from the FAUST dataset.
%   'shrec' = to display shapes from the SHREC dataset.
%   'scape' = to display shapes from the SCAPE dataset (TBD).
%   'fourleg1' = to display fourleg shapes from SHREC dataset.
%
% Rotation factor is given as [rx, ry, rz] which specify the rotation
% degrees around the x, y, and z axes respectively.
% 
% ----------------------------------------------------------------------
% This function is a part of the SPRender package. The package creates
% high quality rendering of shapes withing matlab for research and 
% publication purposes.
%
% Created by Yanir Kleiman, 2017.
% http://www.yanirk.com
function [ rot ] = get_rotation( key )

switch key
    case 'tosca'
        rot = [20, 30, -20];
    case 'faust'
        rot = [-80, 0, 60];
    case 'shrec'
        rot = [0, 0, 0];
    case 'fourleg1'
        rot = [-60 -30 40];
    case 'fourleg2'
        rot = [0 25 -50];
    case 'fourleg3'
        rot = [30 0 50];
    otherwise
        rot = [0, 0, 0];
end;

end

