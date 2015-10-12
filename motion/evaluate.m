function path = evaluate(pt,env,bmm,models)

% until done
iter = 0;
[~, p, state] = get_features_for_point(pt(1),pt(2),pt(3),0,0,env);

draw_environment(env, true)

prev_label = 0;

while pt(1) < env.width && iter < 20
    [label,prob,z] = BernoulliAssign(bmm,p');

    conf = [];
    conf.gate = state.next_gate;
    conf.prev_gate = state.next_gate - 1;
    path = eval_model(models{label},pt,env,conf);

    repeat = true;
    pt = path(1:3,end);
    for i=1:size(path,2)
        [~, p, state] = get_features_for_point(path(1,i),path(2,i),path(3,i),0,0,env,state);
        %[next_label,~] = HmmAssign(bmm,p',label);
        [next_label,~] = BernoulliAssign(bmm,p');
        if next_label ~= label
           fprintf('too far! %d should be %d\n',label,next_label);
           pt = path(1:3,i);
           path = path(:,1:i);
           repeat = false;
           break;
        end
    end
    if repeat
        fprintf('no change in model before end of segment!\n');
        pt = path(1:3,end);
    end
    draw_trajectory(path,models{label}.color,models{label}.marker)

    prev_label = label;
    iter = iter + 1;
end
end
