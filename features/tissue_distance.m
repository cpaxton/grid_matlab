%% TISSUE_DISTANCE
% compute basically everything to do with the tissues
function [td, dtd, xtd, ytd, tw, ...
    xdtd, ydtd, dtw] ...
    = tissue_distance(pt, surfaces, m)

dtd = m;
td = m;
xtd = m;
ytd = m;
xdtd = m;
ydtd = m;
tw = pi / 2;
dtw = pi / 2;

for i=1:length(surfaces)
    [tmp, cpt] = closest_distance(pt, surfaces{i}.bounds);
    if surfaces{i}.isDeepTissue && tmp < dtd
        dtd = tmp;
        xdtd = cpt(1);
        ydtd = cpt(2);
        dtw = atan2(cpt(2),cpt(1));
    elseif tmp < td
        td = tmp;
        xtd = cpt(1);
        ytd = cpt(2);
        tw = atan2(cpt(2),cpt(1));
    end
end
end

