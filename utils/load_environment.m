function [ env ] = load_environment( filename, fig )
% READ_EVIRONMENT Load a single environment file created by the Needle
% Master android game.
%   This program lets us read in a single level, and adjusts values such as
%   x/y coordinates to make them accurate for plotting and experimenting in
%   MATLAB.

%% open a file
file = fopen(filename);

%% read in dimensions of the environment
D = textscan(file, 'Dimensions: %f,%f', 1);
width = D{1};
height = D{2};

%% read in number of gates
D = textscan(file, 'Gates: %f', 1);
nGates = D{1};

gates = cell(nGates, 1);

%% scan in all gates
for i=1:nGates
    
    D = textscan(file, 'GatePos: %f,%f,%f', 1);
    gateX = width*D{1};
    gateY = height*D{2};
    gateW = D{3};
    
    gateCorners = zeros(2,4);
    D = textscan(file, 'GateX: %f,%f,%f,%f', 1);
    for j=1:4
        gateCorners(1, j) = D{j};
    end
    D = textscan(file, 'GateY: %f,%f,%f,%f', 1);
    for j=1:4
        gateCorners(2, j) = height - D{j};
    end
    
    gateTop = zeros(2,4);
    D = textscan(file, 'TopX: %f,%f,%f,%f', 1);
    for j=1:4
        gateTop(1, j) = D{j};
    end
    D = textscan(file, 'TopY: %f,%f,%f,%f', 1);
    for j=1:4
        gateTop(2, j) = height - D{j};
    end
    
    gateBottom = zeros(2,4);
    D = textscan(file, 'BottomX: %f,%f,%f,%f', 1);
    for j=1:4
        gateBottom(1, j) = D{j};
    end
    D = textscan(file, 'BottomY: %f,%f,%f,%f', 1);
    for j=1:4
        gateBottom(2, j) = height - D{j};
    end
    
    gateW = -1*gateW;
    if gateW < 0
        gateW = gateW + (pi * 2);
    end
    if gateW >= pi
        gateW = gateW - pi;
        gateCorners(:,:) = gateCorners(:,[3 4 1 2]);
        gateTop(:,:) = gateTop(:,[3 4 1 2]);
        gateBottom(:,:) = gateBottom(:,[3 4 1 2]);
    end
    gateW = gateW - (pi/2);
    
    topY = mean(gateTop(2,:));
    bottomY = mean(gateBottom(2,:));

    if topY < bottomY
       tmp = gateTop;
       gateTop = gateBottom;
       gateBottom = tmp;
    end
    
    gate = struct('x',gateX, 'y', gateY, 'w', gateW, ...
        'corners', gateCorners, ...
        'top', gateTop, ...
        'bottom', gateBottom);
    
    corners = rotate_trajectory([gate.corners;zeros(1,4)],-gate.w);
    gate.width = (max(corners(1,:)) - min(corners(1,:)));
    gate.height = (max(corners(2,:)) - min(corners(2,:)));
    
    gates{i} = gate;
end

%% read in number of surfaces
D = textscan(file, 'Surfaces: %f', 1);
nSurfaces = D{1};

surfaces = cell(nSurfaces, 1);

%% scan in all surfaces
for i=1:nSurfaces
   D = textscan(file, 'IsDeepTissue: %s');
   isDeepTissue = false;
   if strcmp(D{1},'true')
       isDeepTissue = true;
   end
   
   
   D = textscan(file, 'SurfaceX: %s', 1);
   x = str2double(strsplit(char(D{1}),','));
   D = textscan(file, 'SurfaceY: %s', 1);
   y = str2double(strsplit(char(D{1}),','));
   
   bounds = [x;y];
   
   surface = struct('isDeepTissue', isDeepTissue, 'bounds', bounds);
   surfaces{i} = surface;
end

%% close the file when we are done with it
fclose(file);

env = struct('width', width, 'height', height, 'gates', {gates}, 'surfaces', {surfaces});

end

