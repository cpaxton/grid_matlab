function plans = create_task_model(transitions,initial,gate_change,models,env)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
len = length(initial);
plans = {};
next_plan = 1;
for i = 1:len
    if initial(i) > 0
        p = initial(i);
        seq = i;
        plan = struct('p',p,'seq',seq,'prev_gate',0,'next_gate',1);
        plans{next_plan} = plan;
        next_plan = next_plan + 1;
    end
end

while true
    modified = false;
    new_plans = {};
    next_new_plan = 1;
    for i = 1:length(plans)
        plan = plans{i};
        
        cur = plan.seq(end);
        if cur == len
            new_plans{next_new_plan} = plan;
            next_new_plan = next_new_plan + 1;
            continue;
        else
            for j = 1:len
               if transitions(cur,j) > 0
                   
                   new_plan = plan;
                   new_plan.p = new_plan.p * transitions(cur,j);
                   new_plan.seq = [new_plan.seq j];

                   % this is where we would reproduce the plans again if change
                   % was a probability
                   if gate_change(j) == 1
                      new_plan.next_gate = new_plan.next_gate + 1;
                      new_plan.prev_gate = new_plan.prev_gate + 1;
                   end
                   
                   % make sure this makes sense
                   if ~models{j}.use_gate || new_plan.next_gate <= length(env.gates)
                       % add to list
                       new_plans{next_new_plan} = new_plan;
                       next_new_plan = next_new_plan + 1;
                       
                       modified = true;
                   end
               end
            end
        end
    end
    
    if ~modified
        break;
    else
        plans = new_plans;
    end
end