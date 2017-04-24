% [ fig, S1, S2 ] = CompareSegmentedPointClouds( shape1, segs1, shape2, segs2, show_edges, rotation, savename, fig )
% Render two segmented point clouds side by side.
% Segments are marked by a different color.
%
% Input:
%   shape1, shape2 =
%               either file names that contain the shapes in OFF format, 
%               or the shapes in a structure with the following fields: 
%               X, Y, Z, TRIV, nv.
%               You can build the shape structure from a list of vertices
%               and triangles using S = ShapeStruct(vertices, triangles);
%   segs1, segs2 =
%               lists of segments ID for each vertex in each shape, or the
%               names of files that contain such lists.
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
% ----------------------------------------------------------------------
% This function is a part of the SPRender package. The package creates
% high quality rendering of shapes withing matlab for research and 
% publication purposes.
%
% Created by Yanir Kleiman, 2017.
% http://www.yanirk.com
function [ fig, S1, S2 ] = CompareSegmentedPointClouds( shape1, segs1, shape2, segs2, rotation, savename, fig )

% Optional parameters:
if (nargin < 5)
    rotation = [];
end;
if (nargin < 6)
    savename = [];
end;
if (nargin < 7 || isempty(fig))
    fig = figure;
end;

% Rendering first figure:
subplot(1, 2, 1);

[~, S1] = RenderPointCloudSegments(shape1, segs1, rotation, savename, fig);

% Rendering second figure:
subplot(1, 2, 2);

[~, S2] = RenderPointCloudSegments(shape2, segs2, rotation, savename, fig);

end

