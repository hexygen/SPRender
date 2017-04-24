% RenderPointCloudFunction:
% Renders a function value over the given point cloud.
%
% Input:
%   shape =     either a file name that contains the shape in OFF format, 
%               or the shape in a structure with the following fields: 
%               X, Y, Z, TRIV, nv.
%               You can build the shape structure from a list of vertices
%               and triangles using S = ShapeStruct(vertices, triangles);
%               For point clouds, the triangles in the OFF / shape structure 
%               are not used.
%   f =         a function value for each vertex in the shape.
%
%   *** the following parameters are optional:
%   rotation =  rotation of the shape before rendering. It is important to
%               rotate the shape to the desired orientation before rendering
%               for two reasons: 1. for automatically saving a figure using
%               print. 2. the back of the shape is not well lit by default.
%               Rotation is given as [x,y,z] values or a string which
%               matches one of the following presets:
%                  'tosca' = to display shapes from the TOSCA dataset.
%                  'faust' = to display shapes from the FAUST dataset.
%                  'shrec' = to display shapes from the SHREC dataset.
%                  'fourleg1', 'fourleg2', 'fourleg3' 
%                       = some presets to display fourleg shapes from SHREC
%                         dataset, which have many different orientations. 
%   savename =  if provided, the image is automatically saved with given name.
%   fig =       if a figure handle is provided, the figure is resued.
%
% Output:
%   fig =       resulting figure (if input figure is provided will retain 
%               the same handle)
%   S =         Shape structure, useful if the shape is loaded from file.
%
% ----------------------------------------------------------------------
% This function is a part of the SPRender package. The package creates
% high quality rendering of shapes withing matlab for research and 
% publication purposes.
%
% Created by Yanir Kleiman, 2017.
% http://www.yanirk.com
function [ fig, S ] = RenderPointCloudFunction( shape, f, rotation, savename, fig )

% Optional parameters:
if (nargin < 3)
    rotation = [];
end;
if (nargin < 4)
    savename = [];
end;
if (nargin < 5)
    fig = [];
end;

% Call RenderShapeBase with appropriate parameters:
[fig, S] = RenderShapeBase(shape, [], f, [], 1, 0, 0, 0, rotation, savename, fig);

end

