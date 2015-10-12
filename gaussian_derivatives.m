function [ l, lx, lu, lxx, luu, lux] = gaussian_derivatives( model, t, x, u, f)
% GAUSSIAN_DERIVATIVES returns gradient and Hessain of ll function
% The goal is to return the gradient and Hessian of a Gaussian estimated at
% each time step in the procedure, with respect both to the action and the
% state at that time.

[mus,sigmas] = GMR(model.priors,model.mu,model.sigma,t,model.in_t,model.in_data);

[~,len] = size(t);

l = zeros(1,len);
lx = zeros(model.len_x,len);
lu = zeros(model.len_u,len);
lxx = zeros(model.len_x,model.len_x,len);
luu = zeros(model.len_u,model.len_u,len);
lux = zeros(model.len_u,model.len_x,len);

% get the right indices for each thing we want to return
idx_x = 1:model.len_x;
idx_u = model.len_x + (1:model.len_u);
idx_f = model.len_x + model.len_u + (1:model.len_f);

for i = 1:length(t)
    mu = mus(:,i);
    sigma = sigmas(:,:,i);
    %invsigma = eye(size(sigma)); %inv(sigma);
    invsigma = inv(sigma);
    
    lxx(:,:,i) = invsigma(idx_x,idx_x);
    luu(:,:,i) = invsigma(idx_u,idx_u);
    lux(:,:,i) = invsigma(idx_u,idx_x);
    %diff_data = [x(:,i);u(:,i);f(:,i)] - mu;
    
    l(i) = ([x(:,i);u(:,i);f(:,i)] - mu)'*invsigma(:,:)*([x(:,i);u(:,i);f(:,i)] - mu);
    %-log(1/((sqrt((2*pi)))^nbVar * (abs(det(sigma))+realmin)));
    lx(:,i) = invsigma(idx_x,:) * ([x(:,i);u(:,i);f(:,i)] - mu);
    lu(:,i) = invsigma(idx_u,:) *([x(:,i);u(:,i);f(:,i)] - mu);
    
    % these are actually the correct ESTIMATES of x1 relative to x0 and u
    %fx(:,i) = mu + (sigma(idx_x1,idx_x0)/sigma(idx_x0,idx_x0) * (x(:,i) - mu));
    %fu(:,i) = mu + (sigma(idx_x1,idx_u)/sigma(idx_u,idx_u) * (x(:,i) - mu));
    %fx(:,:,i) = sigma(idx_x1,idx_x0)/sigma(idx_x0,idx_x0);
    %fu(:,:,i) = sigma(idx_x1,idx_u)/sigma(idx_u,idx_u);
end

end

