function path = evaluate(pt,env,bmm,models)

% until done
iter = 0;
[p, state] = compute_predicates(pt,env);

draw_environment(env)

while pt(1) < env.width && iter < 20
    [label,prob,z] = BernoulliAssign(bmm,p');

    conf = [];
    conf.gate = state.next_gate;
    conf.prev_gate = state.next_gate - 1;
    conf.opt = 1;
    conf.prev_opt = 1;
    path = eval_model(models{label},pt,env,conf);

    repeat = true;
    pt = path(1:3,end);
    for i=1:size(path,2)
        [p, state] = compute_predicates(path(:,i),env,state);
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
    draw_trajectory(path,models{label}.color)

    iter = iter + 1;
end
end
