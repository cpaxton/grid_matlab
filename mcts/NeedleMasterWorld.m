classdef NeedleMasterWorld
    %NMWorld Creates and defines a needle master world.
    %   Main goal is to check termination and failure conditions
    
    properties
        env
    end
    
    methods
        function obj = NeedleMasterWorld(env)
            obj.env = env;
        end
        
        function local_env = make_local_env(obj, prev_gate, next_gate, prev_gate_opt, next_gate_opt)
            local_env = [];
            local_env.exit = [obj.env.width; obj.env.height / 2; 0];
            local_env.obstacles = obj.env.surfaces;
            local_env.gates = obj.env.gates;
            if next_gate > 0 && next_gate < length(obj.env.gates)
                local_env.gate = obj.env.gates{next_gate}{next_gate_opt};
            end
            if prev_gate > 0 && prev_gate < length(obj.env.gates)
                local_env.prev_gate = obj.env.gates{prev_gate}{prev_gate_opt};
            end
        end
        
        % 0 if not terminal
        % -1 if failure
        % 1 if success
        function res = terminal(obj, pt, state)
           res = 0;
           if check_collisions(pt, obj.env.obstacles) > 0
              res = -1;
           elseif pt(0) > obj.env.width
               res = 1;
           end
        end
    end
    
end

