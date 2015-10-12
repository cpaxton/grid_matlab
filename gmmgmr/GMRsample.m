function [out,dt] = GMRsample(model,data)
% produce a number of different examples by sampling from the GMM

% [Mu,Sigma] = GMR_fast(model.Priors,model.Mu,model.Sigma,model.inInvSigma,data,model.in,model.out);
% %[Mu,Sigma] = GMR(model.Priors,model.Mu,model.Sigma,data(1,:),1,model.out);
% 
% %% produce a movement/rotation at random
% out = zeros(length(model.out),size(data,2));
% for i = 1:size(data,2)
%     
%     if ~all(eig(Sigma(:,:,i)) > 0)
%         %fprintf('err\n');
%         break;
%     end
%     
%     c = chol(Sigma(:,:,i));
%     Z = 4*rand(length(model.out))-2;
%     out(:,i) = sum(c'*Z,2) + Mu(:,i);
% end

out = rand(length(model.out),size(data,2));
% out(1,:) = (out(1,:) * 40) + 12;
% out(2,:) = (out(2,:) * 1) - 0.5;
out(1,:) = (out(1, :) * (4*model.movement_dev)) + (model.movement_mean - model.movement_dev);
out(2, :) = (out(2,:) * 12*model.rotation_dev) + (model.rotation_mean - (6*model.rotation_dev));
%dt = 1 + (rand(1,size(data,2)) * 2 * 1000) / model.steps;
dt = (rand(1,size(data,2)) * 20) - 10 + (1000/model.steps);

end