function [path, cost] = create_path(model,env,steps,x,y,w)
% CREATE_PATH creates a path based on sampling

NSAMPLES = 250;

if nargin < 4
    x = 0;
    y = 0;
    w = 0;
end

path=[]; %zeros(5,steps+2);
gate_features=zeros(length(model.in)-1,steps+1);
cost = 0;

path(1:3,1) = [x;y;w];
t = 0;
%for i = 1:steps+1
i = 1;
while t < 1000
            
    %t = (i-1) / (steps) * 1000;
    f = [];
    
    x = path(1,i);
    y = path(2,i);
    w = path(3,i);
    
    if i > 1
        F = [gate_features(:,i)];
    else
        %F = [t;x;y;w];%get_reproduction_features([x;y;w;movement;rotation],model,env)];
        %F = [0;x;y;w];
        F = get_reproduction_features([x;y;w;0;0],model,env);
    end
    
    % NOTE: this has changed enough that it really doesn't matter what data
    % I send in
    [out,dt] = GMRsample(model,repmat(F,1,NSAMPLES));
    %out = GMR(model.Priors,model.Mu,model.Sigma,[t;x;y;w;f],model.in,model.out);
    %m = 1;
    
    x = repmat(x,1,NSAMPLES);
    y = repmat(y,1,NSAMPLES);
    w = repmat(w,1,NSAMPLES);
    movement = out(1,:);
    rotation = out(2,:);
    
    [x,y,w] = needle_update(x,y,w,movement,rotation,env);
    
    ts = repmat(t,1,NSAMPLES) + dt;
    %ts = ones(1,length(x))*((i+1) / (steps) * 1000);
    %ts = ones(1,length(x)) * 1000;

    f = get_reproduction_features([x;y;w;movement;rotation],model,env,F);

    ll = compute_loglik([ts;f],model.Mu,model.Sigma,model,model.in);
    %ll = compute_loglik([ts;x;y;w;f],model.Mu,model.Sigma,model,model.in);
    %%ll = compute_loglik([x;y;w;f],model.Mu,model.Sigma,model,model.in);
    [pc,m] = max(ll);
    
    cost = cost + pc; %update total path cost
    
    path(1:3,i+1) = [x(m);y(m);w(m)];
    path(4:5,i) = [movement(m);rotation(m)];
    gate_features(:,i+1) = f(:,m);
    
    %t = t + (1000 / model.steps); %ts(m);
    t = ts(m);
    i = i + 1;
    %[ts(m) x(m) y(m) w(m) movement(m) rotation(m)]
end
%path = path(:,1:steps);

end