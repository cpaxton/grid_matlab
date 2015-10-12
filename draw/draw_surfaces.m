function draw_surfaces(surfaces)
tissue = [232/255 146/255 124/255];
deepTissue = [207/255 69/255 32/255];

hold on;
for i=1:length(surfaces)
    
    if surfaces{i}.isDeepTissue
        color = deepTissue;
    else
        color = tissue;
    end
    
    fill(surfaces{i}.bounds(1,:), surfaces{i}.bounds(2,:), color);
end
end