function [trainingData,norm_mean,norm_std] = create_primitive_training_data(model,ap)

if ~model.use_diff
    trainingData = [ap.t];
    if model.use_in_gate
       trainingData = [trainingData; ap.predicates(1,:)]; 
    end
    if model.use_in_tissue
       trainingData = [trainingData; ap.in_tissue]; 
    end
    if model.use_xy
        trainingData = [trainingData;ap.trainingData];
    end
    if model.use_effort
        trainingData = [trainingData;ap.effort_features];
    end
    
    if model.use_gate
        trainingData = [trainingData;ap.gate_features];
        if model.use_param
            
            params=[];
            for i = 1:length(ap)
                params = [params ...
                    repmat([ap(i).gate.width; ap(i).gate.height], ...
                    1,size(trainingData,2))];
            end
            
            trainingData = [trainingData; params];
        end
    end
    if model.use_prev_gate
        trainingData = [trainingData;ap.prev_gate_features];
        if model.use_param
            
            params = [];
            for i = 1:length(ap)
                params = [params ...
                    repmat([ap(i).prev_gate.width; ap(i).prev_gate.height], ...
                    1,size(trainingData,2))];
            end
            
            trainingData = [trainingData; params];
        end
    end
    if model.use_exit
        trainingData = [trainingData;ap.exit_features];
    end
else
    trainingData = [];
    for i = 1:length(ap)
        f = ap(i).t;
        
        if model.use_in_gate
           f = [f; ap(i).predicates(1,:)]; 
        end
        if model.use_in_tissue
           f = [f; ap(i).in_tissue]; 
        end
        if model.use_xy
            f = [f;ap(i).trainingData];
        end
        if model.use_effort
            f = [f;ap(i).effort_features];
        end
        if model.use_gate
            f = [f;ap(i).gate_features];
            
            if model.use_param
                
                params = [repmat([ap(i).gate.width; ap(i).gate.height], ...
                    1,size(f,2))];
                
                f = [f; params];
            end
        end
        if model.use_prev_gate
            f = [f;ap(i).prev_gate_features];
            
            if model.use_param
                
                params = [repmat([ap(i).prev_gate.width; ap(i).prev_gate.height], ...
                    1,size(f,2))];
                
                f = [f; params];
            end
        end
        if model.use_exit
            f = [f;ap(i).exit_features];
        end
        
        df = diff(f(2:end,:)')';
        f = f(:,2:(end)); % get rid of first position
        if model.use_param
            %trainingData = [trainingData [f;df(1:end-2,:)]];
            trainingData = [trainingData [f;df(1:end-2,:)]];
        else
            trainingData = [trainingData [f;df]];
        end
    end
end

norm_mean = mean(trainingData,2);
norm_std = std(trainingData')';
norm_std(norm_std == 0) = 1;
end