function [trainingData,norm_mean,norm_std] = create_primitive_training_data(model,ap)

trainingData = [];

for i = 1:length(ap)
    
    data = traj_get_reproduction_features(ap(i).originalData,model,ap(i).local_env);
    len = size(data,2);
    if model.use_avg_len
        max_t = ceil(model.len_mean);
    else
        max_t = len;
    end
    data = [1000 * (1:len) / max_t; data];
    %fprintf('WARNING: time wrong');
    
    trainingData = [trainingData data];
end


norm_mean = mean(trainingData,2);
norm_std = std(trainingData')';
norm_std(norm_std == 0) = 1;
end