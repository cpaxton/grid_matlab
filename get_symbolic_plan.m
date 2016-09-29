function [plan, prev_gate, next_gate] = get_sumbolic_plan(env)
% plan ends with an "exit" action and goes to the final exit state
plan = [1 5];
ngates = length(env.gates);

prev_gate = [];
next_gate = [];

if ngates > 0
    
    plan = [2 plan];
    
    prev_gate = ngates;
    next_gate = ngates+1;
    
    if ngates > 1
        for i = 1:(ngates-1)
            plan = [2 3 plan];
            ii = ngates - i;
            prev_gate = [ii ii prev_gate];
            next_gate = [ii+1 ii+1 next_gate ];
        end
    end
    
    % "approach" for the first gate
    plan = [4 plan];
    prev_gate = [0 prev_gate];
    next_gate = [1 next_gate];
end

prev_gate = [prev_gate ngates ngates];
next_gate = [next_gate ngates+1 ngates+1];
end