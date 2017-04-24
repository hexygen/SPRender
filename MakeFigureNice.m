% MakeFigureNice:
% Makes a rendered trimesh figure nice looking by applying good lighting
% and rendering attributes to it.
% It takes no parameters because it should work well for every shape.
%
% ----------------------------------------------------------------------
% This function is a part of the SPRender package. The package creates
% high quality rendering of shapes withing matlab for research and 
% publication purposes.
%
% Created by Yanir Kleiman, 2017.
% http://www.yanirk.com
function [ ] = MakeFigureNice( )

        % Set aspect ratio
        daspect([1 1 1]);
        axis equal;
        axis off;

        material dull;

        % Set lightning:
        % camlight;
%         lighting flat;
        lighting gouraud;
        % lighting phong;

        %%% EIGHT point lighting !!!
        light('Position',[1 1 1],'Style','infinite', 'Color', [0.5 0.5 0.5]);
        light('Position',[1 1 -1],'Style','infinite', 'Color', [0.6 0.6 0.6]);
        light('Position',[1 -1 1],'Style','infinite', 'Color', [0.7 0.7 0.7]);
        light('Position',[1 -1 -1],'Style','infinite', 'Color', [0.3 0.3 0.3]);
        light('Position',[-1 1 1],'Style','infinite', 'Color', [0.4 0.4 0.4]);
        light('Position',[-1 1 -1],'Style','infinite', 'Color', [0.4 0.4 0.4]);
        light('Position',[-1 -1 1],'Style','infinite', 'Color', [0.8 0.8 0.8]);
        light('Position',[-1 -1 -1],'Style','infinite', 'Color', [0.2 0.2 0.2]);
        
        
        % BLUISH Ambient:
%         set(gca, 'AmbientLightColor', [0.45 0.57 0.65]);

        % CLAY Ambient (play with this value for different effects):
%         set(gca, 'AmbientLightColor', [0.5 0.36 0.3]);
        set(gca, 'AmbientLightColor', [0.5 0.4 0.35]);

    end
