function path = evaluate_tree(pt,env,bmm,models,plan)

% until done
iter = 0;
[p, state] = compute_predicates(pt,env);

%figure();
%clf;
draw_environment(env, true)
f=[];
pt_prob = 0;
step = 1;
fprintf('Starting tree search:\n');
while pt(1) < env.width && iter < 10 && step < length(plan-1)
    label = BernoulliAssign(bmm,p');

    if label == plan(step+1)
        step = step + 1;
    elseif label ~=plan(step)
        fprintf('ERROR: wrong step!');
    end
        
    
    goal_conf = [];
    goal_conf.valid_sampler = @(x)(sample_environment(env.width,env.height,x));
    if label == 3
        goal_conf.goal_sampler = @(x)(sample_gate(env.gates{state.next_gate},x));
        goal_conf.test_goal = @(x)(in_regions(x,{env.gates{state.next_gate}.corners}));
        %goal_conf.goal_label = [2 5];
    elseif label == 4
        goal_conf.goal_sampler = @(x)(sample_gate(env.gates{state.next_gate},x));
        goal_conf.test_goal = @(x)(in_regions(x,{env.gates{state.next_gate}.corners}));
        %goal_conf.goal_label = [2 5];
    elseif label == 1
        goal_conf.goal_sampler = @(x)(sample_environment(env.width,env.height,x) + [env.width;0;0]);
        %goal_conf.goal_label = 0;
    elseif label == 2
        goal_conf.goal_sampler = @(x)(sample_environment(env.width,env.height,x));
        %goal_conf.goal_label = 3;
    elseif label == 5
        goal_conf.goal_sampler = @(x)(sample_environment(env.width,env.height,x));
        %goal_conf.goal_label = 1;
    end
    goal_conf.label = plan(step);
    goal_conf.goal_label = plan(step+1);
    goal_conf.valid = {[1 env.width env.width 1; 1 1 env.height env.height]};
    goal_conf.bmm = bmm;
    goal_conf.obs = {};
    goal_conf.num_iter = 2000;
    goal_conf.ll_threshold = 50;
    goal_conf.goal_threshold = 0.2;
    goal_conf.n_samples = 10;
    goal_conf.gate = state.next_gate;
    goal_conf.prev_gate = state.next_gate - 1;
    
    fprintf('\t- planning action %d\n',label);
    if goal_conf.goal_label == 0
    [pts,parents,cprob,goal_met,goal_parents,f] = build_tree(pt,...
        pt_prob,...
        models{goal_conf.label},...
        [],...
        env,...
        goal_conf,state,f);
    else
    [pts,parents,cprob,goal_met,goal_parents,f] = build_tree(pt,...
        pt_prob,...
        models{goal_conf.label},...
        models{goal_conf.goal_label},...
        env,...
        goal_conf,state,f);
    end
    %path = tree_find_path(pts, parents, cprob, goal_met, goal_parents);
    
    if ~isempty(goal_met)
        pt = goal_met(1:3,:);
        pt_prob = cprob;
        [p,state] = compute_predicates(goal_met(:,1),env,state);
        fprintf('\t... goal found!\n');
    else
        fprintf('\ttrying again... goal not found!\n');
    end
%     for i=1:size(path,2)
%         [p, state] = compute_predicates(path(:,i),env,state);
%         [next_label,~] = BernoulliAssign(bmm,p');
%         if next_label ~= label
%             fprintf('too far! %d should be %d\n',label,next_label);
%             pt = path(1:3,i);
%             path = path(:,1:i);
%             repeat = false;
%             break;
%         end
%     end
%     if repeat
%         fprintf('no change in model before end of segment!\n');
%         pt = path(1:3,end);
%     end
    draw_trajectory(pts,models{label}.color,models{label}.marker)
    
    prev_label = label;
    iter = iter + 1;
end
end
