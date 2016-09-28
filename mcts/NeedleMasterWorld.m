classdef NeedleMasterWorld
    %NMWorld Creates and defines a needle master world.
    %   Detailed explanation goes here
    
    properties
        env
    end
    
    methods
        function obj = NeedleMasterWorld(env)
            obj.env = env;
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

