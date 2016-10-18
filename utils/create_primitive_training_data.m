function [trainingData,norm_mean,norm_std] = create_primitive_training_data(model,ap)

trainingData = [];

for i = 1:length(ap)
    
    data = traj_get_reproduction_features(ap(i).data,model,ap(i).local_env);
    len = size(data,2);
    data = [1000 * (1:len) / len; data];
    %fprintf('WARNING: time wrong');
    
    trainingData = [trainingData data];
end


norm_mean = mean(trainingData,2);
norm_std = std(trainingData')';
norm_std(norm_std == 0) = 1;
end