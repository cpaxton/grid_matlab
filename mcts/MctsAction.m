classdef MctsAction
    %MctsAction Stores a single instantiation of an action for tree search
    %   Defines an action as an arc with a constant rotation, velocity, and
    %   a duration.
    
    properties (GetAccess = public, SetAccess = protected)
        % duration
        t
        
        % velocity
        v
        
        % rotation
        dw
        
        % full trajectory
        traj
    end
    
    methods (Access = public)
        
    end
    
end

