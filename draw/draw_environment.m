function draw_environment( env, gray, gamebg )

if nargin < 2
    gray = false;
    gamebg = false;
elseif nargin < 3
    gamebg = false;
end

tissue = [232/255 146/255 124/255];
deepTissue = [207/255 69/255 32/255];
bg = [99/255 153/255 174/255];

hold on;
for i=1:length(env.surfaces)
    
    if env.surfaces{i}.isDeepTissue
        color = deepTissue;
    else
        color = tissue;
    end
    
    fill(env.surfaces{i}.bounds(1,:), env.surfaces{i}.bounds(2,:), color,'edgeColor',color);
end

draw_gates(env.gates, gray, gamebg)
axis([1 env.width 1 env.height])

if gamebg
    set(gca,'color',bg);
end

end

% helper function to create gates -- we don't really need this to be a
% separate thing.
function draw_gates( gates, gray, gamebg )

c1 = [251/255 216/255 114/255];
c2 = [255/255 50/255 12/255];
c3 = [255/255 12/255 150/255 ];
ce = [0,0,0];

if gray
    c1 = [0.95, 0.95, 0.95];
    c2 = [0.75,0.75,0.75];
    c3 = [0.75,0.75,0.75];
    ce = [0.66, 0.66, 0.66];
end

if gamebg
    c3 = c2;
end

hold on;
for i=1:length(gates)
    for j=1:length(gates{i})
        fill(gates{i}{j}.corners(1,:), gates{i}{j}.corners(2,:), c1,'edgeColor',c1);
        fill(gates{i}{j}.top(1,:), gates{i}{j}.top(2,:), c2,'edgeColor',c2);
        fill(gates{i}{j}.bottom(1,:), gates{i}{j}.bottom(2,:), c3,'edgeColor',c3);
        if ~gamebg
            draw_frame_angle([gates{i}{j}.x;gates{i}{j}.y],gates{i}{j}.w,100);
        end
    end
end

end

