% [ S ] = ShapeStruct( vertices, triangles )
% Builds a shape struct from a vertices matrix and a list of
% triangles.
% 
% ----------------------------------------------------------------------
% This function is a part of the RenderMat package. The package creates
% high quality rendering of shapes withing matlab for research and 
% publication purposes.
%
% Created by Yanir Kleiman, 2017.
% http://www.yanirk.com
function [ S ] = ShapeStruct( vertices, triangles )

if (size(vertices, 2) < 3)
    error('ShapeStruct: vertices matrix should have at least 3 columns.');
end;

if (max(max(triangles)) > size(vertices, 1))
    error('ShapeStruct: triangles matrix does not match number of vertices.');
end;

S.X = vertices(:, 1);
S.Y = vertices(:, 2);
S.Z = vertices(:, 3);
S.TRIV = triangles;
S.nv = length(S.X);

end

