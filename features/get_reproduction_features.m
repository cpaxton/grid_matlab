function f = get_reproduction_features(pt,model,local_env,prev_f)
f = [];

%% compute standard features
if model.use_in_gate
    f = [f; in_gates(pt(1,:),pt(2,:),local_env.gates) > 0];
end
if model.use_in_tissue
    f = [f; in_tissue(pt, local_env.obstacles)];
end
if model.use_xy
    f = [f; pt(1:3,:)];
end
if model.use_effort
    %f = [f; abs(pt(4:5,:))];
    f = [f; abs(pt(5,:))];
    %[mean(pt(5,:)) size(f,1)]
end
if model.use_surface_proximity
   prox = zeros(1,size(pt,2));
   for i = 1:length(local_env.surfaces)
       if local_env.surfaces{i}.isDeepTissue
           prox = surface_proximity(pt,local_env.surfaces{i}.bounds);
       end
   end
   f = [f; bounds];
end
if model.use_gate
    f = [f; get_gate_distances(pt(1:3,:),local_env.gate)];
    if model.use_param
        f = [f; repmat([local_env.gate.width; local_env.gate.height],1,size(pt,2))];
    end
end
if model.use_prev_gate
    f = [f; get_gate_distances(pt(1:3,:),local_env.prev_gate)];
    if model.use_param
        f = [f; repmat([local_env.prev_gate.width; local_env.prev_gate.height],1,size(pt,2))];
    end
end
if model.use_exit
    f = [f; get_end_distance(pt(1:3,:),local_env.exit)];
end

%% differentials
% let's say we care about how fast we are moving relative to each of these
% features. this assumes you provided an extra
if model.use_diff
    if nargin > 3
        if size(prev_f,2) == 1
            of = repmat(prev_f,1,size(f,2));
            of = of(1:size(f,1),:); % only use the correct number of features
            f = [f; f - of];
        else
            f = [f; f - prev_f(1:size(f,1),:)];
        end
    else
        f = [f;zeros(size(f))];
    end
    
    if model.use_param
        f = f(1:end-2,:); % get rid of the empty rows at the end
    end
end

end