% [ cmap ] = get_colormap( nc )
% Returns a color map with n distinct colors to be used for segment colors etc.
%
% input: nc (optional) = number of colors to return;
% output: a color map with the colors listed below.
%         note that the first color is very dark gray to denote "no color"
%         or "no segmentation".
%
% ----------------------------------------------------------------------
% This function is a part of the SPRender package. The package creates
% high quality rendering of shapes withing matlab for research and 
% publication purposes.
%
% Created by Yanir Kleiman, 2017.
% http://www.yanirk.com
function [ cmap ] = get_colormap( nc )

% Color map: [Yellow, Purple, Turquoise, Green, Blue, Orange, Red, Dark Blue, Dark Green, Dark Red, Light Gray, Dark Gray, Pink, 
%              Dark Dark Green, Dark Dark Red, Dark Dark Blue, Dark Dark Cyan, Dark Dark Brown, Dark Dark Purple, Dark Dark Gray (Black)
%               Saturated Yellow, Saturated Green, Saturated Blue]
cmap = [0.2 0.2 0.2 % Very dark gray = no match
          0.88 0.86 0.45;
          0.55 0.33 0.7;
          0.5 0.8 0.45;
          0.35 0.45 1;
          1 0.55 0.3;
          1 0.33 0.4;
          0.2 0.6 0.8;
          0.2 0.8 0.5;
          0.66 0.2 0.2;
          0.75 0.75 0.75;
          0.5 0.5 0.5;
          0.95 0.65 0.8;
          0.1 0.5 0.1;
          0.5 0.1 0.3;
          0.1 0.1 0.5;
          0.1 0.4 0.4;
          0.4 0.4 0.1;
          0.4 0.1 0.4;
          0.9 0.9 0.1;
          0.1 0.9 0.1;
          0.1 0.1 0.9;
          0.47 0.78 0.7;
          1 0.6 0.6;   % light red
          0.6 1 0.6;   % light green
          0.6 0.6 1;   % light blue
          0.5 0.1 0.1; % dark red
          0.1 0.5 0.1; % dark green
          0.1 0.1 0.5; % dark blue
          1 0.8 0.5;   % orange?
          0.6 0.5 0;   % brown?
          0.7 0.3 1;   % purple?
          0.7 0.7 0.7; % light gray% % [x, ~] = eigs(Aff, 1);
          0.4 0.4 0.4; % dark gray
          0.9 0.1 0.1; % red
          0.1 0.9 0.1; % green% % [x, ~] = eigs(Aff, 1);
          0.1 0.1 0.9; % blue
          1.0 1.0 0.0;       % yellow
          0.0 1.0 1.0;       % cyan
          1.0 0.0 1.0;       % magenta
          0.24 0.53 0.66; % random 1
          0.04 0.69 0.3;  % random 2
          0.9 0.4 0.67;   % random 3
          0.4 0.5 0.6];     % random 4

if (nargin > 0)
    if (nc < 45)
        cmap = cmap(1:nc, :);
    else
        while (length(cmap) < nc)
            c = rand(1, 3);
            % The darkest random color would be [0.33, 0.33, 0.33]:
            if (sum(c) < 1)
                c = c / sum(c);
            end;
            cmap(end+1, 1:3) = c;
        end;
    end;
end;

end

