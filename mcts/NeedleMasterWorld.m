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
            
        end
    end
    
end

