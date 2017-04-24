% RenderShapeBase:
% Base function for rendering a single shape. Shape can be
% rendered as a triangular mesh or point clouds and with a function value, 
% a given segmentation, a border between segments, and feature points, or
% any mix of the above.
% This function has many optional parameters that cover many different
% scenarios; see specialized functions for specific scenarios with less
% parameters.
%
% Input:
%   shape =     either a file name that contains the shape in OFF format, 
%               or the shape in a structure with the following fields: 
%               X, Y, Z, TRIV, nv.
%               You can build the shape structure from a list of vertices
%               and triangles using S = ShapeStruct(vertices, triangles);
%
%   *** all of the following parameters are optional:
%   segs =      a list of segments ID for each vertex in the shape, or the
%               name of a file that contains such list.
%   f =         a function value for each vertex in the shape.
%   features =  a list of features to highlight (vertex indices).
%   is_pcd =    is the input shape a point cloud (default is 0).
%   show_segs = whether to show the segments of the shape (default is 1,
%               otherwise the shape is rendered with a single color).
%   show_edges = whether to show the edges between segments (default is 0).
%                This flag is independent of show_segs.
%   show_marker_edge = whether markers of feature points have an edge or not (default is 0).
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
%   face_color = if the shape is rendered with a single color, provides an
%               alternative color for the shape.
%   marker_color = provides an alternative color for the marker edge if
%               show_marker_edge = 1.
%
% Output:
%   fig =       resulting figure (if input figure is provided will retain 
%               the same handle)
%   S =         Shape structure, useful if the shape is loaded from file.
%
% ----------------------------------------------------------------------
% Examples of use:
%
%   Render an OFF file with a single color:
%   [fig, S] = RenderShapeBase(filename);
%
%   Render a segmented shape loaded from an OFF file and a segmentation file,
%   where segments are marked with different colors:
%   [fig, S] = RenderShapeBase(filename, seg_filename);
%
%   Render a segmented shape with edges between segments:
%   [fig, S] = RenderShapeBase(filename, seg_filename, [], [], 0, 1, 1);
%
%   Render a segmented shape with edges between segments and a single color
%   (all segments in the same color):
%   [fig, S] = RenderShapeBase(filename, seg_filename, [], [], 0, 0, 1);
%
%   Render a function over a shape:
%   [fig, S] = RenderShapeBase(S, [], f);
%
%   Render a function over a shape with edges that indicate segment
%   borders:
%   [fig, S] = RenderShapeBase(S, segs, f, [], 0, 0, 1);
%
%   Render a segmented shape from 'FAUST' dataset and save image file:
%   [fig, S] = RenderShapeBase(filename, seg_filename, [], [], 0, 1, 0, 0, 'faust', savename);
%
% ----------------------------------------------------------------------
% This function is a part of the SPRender package. The package creates
% high quality rendering of shapes withing matlab for research and 
% publication purposes.
%
% Created by Yanir Kleiman, 2017.
% http://www.yanirk.com
function [ fig, S ] = RenderShapeBase( shape, segs, f, features, is_pcd, show_segs, show_edges, show_marker_edge, rotation, savename, fig, face_color, marker_color )

%%% CONSTANTS PARAMETERS:
% MARKER_COLOR = [0.7 0.8 1];
MARKER_COLOR = [0 1 0.6];
FACE_COLOR = [0.5 0.65 0.9];
% FEATURE_COLOR = [0.9 0.5 0.65];
FEATURE_COLOR = MARKER_COLOR * 0.7;
FEATURE_MARKER_SIZE = 60;
PCD_EDGE_COLOR = [0.3 0.3 0.3];
PCD_EDGE_ALPHA = 0.6;
PCD_EDGE_WIDTH = 0.5;
PCD_MARKER_SIZE = 12;

%%% Optional parameters:
if ((nargin < 13) || isempty(marker_color))
    marker_color = MARKER_COLOR;
end;
if ((nargin < 12) || isempty(face_color))
    face_color = FACE_COLOR;
end;
if ((nargin < 11) || isempty(fig))
    fig = figure;
end;
if (nargin < 10)
    savename = [];
end;
if (nargin < 9)
    rotation = [];
end;
if (nargin < 8)
    show_marker_edge = 0;
end;
if (nargin < 7)
    show_edges = 0;
end;
if (nargin < 6)
    show_segs = 1;
end;
if (nargin < 5)
    is_pcd = 0;
end;
if (nargin < 4)
    features = [];
end;
if (nargin < 3)
    f = [];
end;



if (ischar(shape))
    % shape is a filename - load file:
    display(['Loading file ' shape]);
    
    [X, T] = readOff(shape);
    S = ShapeStruct(X, T);
else
    % Assume shape is already given in the correct structure:
    S = shape;
    if (~(isfield(S, 'X') && isfield(S, 'Y') && isfield(S, 'Z') && isfield(S, 'TRIV')))
        error('RenderMeshBase: wrong shape format. Use ShapeStruct to construct shape struct.');
    end;
end;

if (nargin < 2 || isempty(segs))
    % No segments are necessary:
    segs = ones(length(S.X), 1);
    show_segs = 0;
else
    % Load segments from file if necessary:
    if (ischar(segs))
        % segs is a filename - load file:
        display(['Loading file ' segs]);

        x = load(segs);
        segs = x;
    end;    
end;


if (ischar(rotation))
    rot = get_rotation(rotation);
else
    if (~isempty(rotation))
        rot = rotation;
    else
        rot = [0, 0, 0];
    end;
end;

S = rotate_mesh(S, rot);
nf = length(S.TRIV);


%% Setting colors of vertices and faces, for use with show_segs and show_edges:
% Color index for each vertex:
c = segs + 1;

if (is_pcd)
    cf = c;
else
    
    % Set the color of each face according to the segment with the largest
    % id - this is arbitrary but it generates rather smooth segments:
    cf = zeros(nf, 1); % color faces instead of vertices

    for i=1:nf
        face = S.TRIV(i, :);
        cf(i) = max(c(face));
    end;
    
end;


if (~isempty(f))

    %% Rendering a function over a shape:
    render_mesh_or_pcd(S, f, is_pcd);
else
    
    %% Rendering a segmented shape:

    if (show_segs)

        % make sure color map is the same length as actual faces:
        cmap = get_colormap(max(cf));

        if (min(cf) > 1)
            if (is_pcd)
                % Add dummy point to distribute colors correctly:
                S.X(end+1) = mean(S.X);
                S.Y(end+1) = mean(S.Y);
                S.Z(end+1) = mean(S.Z);
                % Give dummy point the first color in the color map:
                cf(end+1) = 1;
            else
                % Add dummy face to distribute colors correctly:
                S.TRIV(end + 1, :) = [1 1 1];
                % Give dummy face the first color in the color map:
                cf(end + 1) = 1;
            end
        end;

        colormap(cmap);
    else
        colormap(face_color);
    end;

    render_mesh_or_pcd(S, cf, is_pcd);

end;

%% Rendering edges between segments as a separate layer:
if (show_edges && ~isempty(segs) && ~is_pcd)
    new_faces = [];
    T = S.TRIV;

    for i=1:S.nv

        % Find all faces of each vertex:
        faces = find(T(:, 1) == i | T(:, 2) == i | T(:, 3) == i);
        [faces_x, ~] = ind2sub([nf 3], faces);

        % Within faces_x, find the faces which share an edge, which are
        % actually faces that have both i and another vertex j in
        % common:
        verts = T(faces_x, :);
        verts = unique(verts(:));

        for jj=1:length(verts)
            j = verts(jj);
            if (j ~= i)
                % Find the faces that have j in common:
                faces2 = find(T(faces_x, 1) == j | T(faces_x, 2) == j | T(faces_x, 3) == j);
                [faces2_ind, ~] = ind2sub([size(faces_x, 1), 3], faces2);
                faces_y = faces_x(faces2_ind);

                % find colors of two faces:
                c_faces = unique(cf(faces_y));
                if (length(c_faces) > 1)
                    % Faces have two different colors - create a new face
                    % for the edge shape:
                    new_faces(end+1, :) = [i j i];
                end;
            end;
        end;
    end;

    if (show_segs)
        % Change colormap accordingly:
        cmap = [0 0 0; cmap];
        colormap(cmap);
    end;
    
    hold on;
    trimesh(new_faces, S.X, S.Y, S.Z, 'EdgeColor', 'black', 'FaceColor', 'none', 'LineWidth', 1)
    hold off;
end;

%% Render feature points:
if (~isempty(features))
    
    if (ischar(features))
        x = load(features);
        features = x(:, 1) + 1;
    end;
    
    xp = S.X(features);
    yp = S.Y(features);
    zp = S.Z(features);
    
    if (~isempty(f))
        % Feature point color is based on the function value:
        cp = f(features);
    else
        if (max(c(features)) == 2)
            cp = FEATURE_COLOR;
        else
            cmap = get_colormap(max(c(features)));
            % Feature point color is based on the segmentation:
            cp = cmap(c(features), :)*0.7;
        end;
    end;
    
    hold on;
    if (show_marker_edge)
        scatter3(xp, yp, zp, FEATURE_MARKER_SIZE, cp, 'filled', ...
                    'MarkerFaceAlpha', 1, ...
                    'MarkerEdgeColor', marker_color, ...
                    'MarkerEdgeAlpha', 1, ...
                    'LineWidth', 1);
    else
        scatter3(xp, yp, zp, FEATURE_MARKER_SIZE, cp, 'filled', ...
                    'MarkerFaceAlpha', 1, ...
                    'MarkerEdgeColor', 'none', ...
                    'LineWidth', 1);
    end;
    hold off;
    
end;

%% Make figure nice and save:
MakeFigureNice();

if (~isempty(savename))
    print(fig, savename, '-r300', '-dpng');
end;

    %% Sub function for rendering mesh or point cloud:
    function [] = render_mesh_or_pcd(S, f, is_pcd)
        if (is_pcd)
            scatter3(S.X, S.Y, S.Z, PCD_MARKER_SIZE, f, 'filled', ...
                'MarkerFaceAlpha', 1, ...
                'MarkerEdgeColor', PCD_EDGE_COLOR, ...
                'MarkerEdgeAlpha', PCD_EDGE_ALPHA, ...
                'LineWidth', PCD_EDGE_WIDTH);
%                 'MarkerEdgeColor', [0.5 0.5 0.5], ...
%                 'MarkerEdgeAlpha', 0.5, ...
        else
            trimesh(S.TRIV, S.X, S.Y, S.Z, f, ...
                'EdgeColor', 'none', 'FaceColor', 'flat', 'FaceLighting','flat');
        %         'EdgeColor', 'interp', 'FaceColor', 'interp');
        end;
    end

end

