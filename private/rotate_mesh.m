% [S] = ROTATE_MESH( S, rot ) 
% Rotates a mesh around the x, y and z axes.
% The rotation is done in an YXZ order since that makes it easy to rotate a
% shape around the y axis which is the most useful rotation.
%
% rot = degrees of rotation around the x, y and z axes respectively.
%
% ----------------------------------------------------------------------
% This function is a part of the SPRender package. The package creates
% high quality rendering of shapes withing matlab for research and 
% publication purposes.
%
% Created by Yanir Kleiman, 2017.
% http://www.yanirk.com
function [ S ] = rotate_mesh( S, rot )

    xyz = [S.X S.Y S.Z];
    rx = rot(1);
    ry = rot(2);
    rz = rot(3);

    % Building rotation matrix for each axis:
    ang = ry/180*pi;
    roty = [cos(ang) 0 -sin(ang); 0 1 0; sin(ang) 0 cos(ang)];
    
    ang = rx/180*pi;
    rotx = [1 0 0 ; 0 cos(ang) -sin(ang); 0 sin(ang) cos(ang)];
    
    ang = rz/180*pi;
    rotz = [cos(ang) -sin(ang) 0; sin(ang) cos(ang) 0; 0 0 1];
    
    % Rotating shape:
    xyz = xyz * roty * rotx * rotz;
    S.X = xyz(:, 1);
    S.Y = xyz(:, 2);
    S.Z = xyz(:, 3);

end

