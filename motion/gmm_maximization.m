function [path, ll ] = gmm_maximization(model,local_env)

opts = optimset('fminsearch');%,'MaxIter','2000*numberofvariables','MaxFunEvals','2000*numberofvariables');
opts.MaxIter = 20000;
opts.MaxFunEvals = 20000;
%opts = optimoptions('fmincon','GradObj','on');

path = [];
ll = [];

%[pt,~] = GMR(model.Priors,model.Mu,model.Sigma,[0;0;0;0],1:4,5:max(model.in));
%[x,y,w] = needle_update(0,0,0,pt(4),pt(5),local_env);
%pt = [x;y;w;pt];
%pt
%pause
x = [0;0;0;0;0];%get_gate_distances([0;0;0],local_env.gate)];
% come up with an initial guess
if model.use_gate
    x = [local_env.gate.x;local_env.gate.y;local_env.gate.w;0;0];
elseif model.use_exit
    x = [local_env.exit(1);local_env.exit(2);local_env.exit(3);0;0];
elseif model.use_prev_gate
    x = [local_env.prev_gate.x;local_env.prev_gate.y;local_env.prev_gate.w;0;0];
end

% create the appropriate mixture for each step and maximize it
for i = 1:1 %1:model.steps
        t = (model.steps+i) / model.steps * 1000;
        %t = 1000;
        
        [Mu,Sigma] = GMR(model.Priors,model.Mu,model.Sigma,t,1,2:max(model.in)); %model.in(2:end));
        
        %tol = 10*eps(max(abs(diag(Sigma))))
        %max(max(abs(Sigma - Sigma')))

        %% set up objective and gradient
        %obj = @(x) -1 * mvnpdf(x,Mu,Sigma);
        invSigma = inv(Sigma);
         obj = @(x) -1*gaussPDF_fast([x; get_reproduction_features(x,model,local_env)],Mu,Sigma,invSigma);
%         obj = @(x)deal(gaussPDF_fast(x,Mu,Sigma,invSigma), ...
%            gaussPDF_fast(x,Mu,Sigma,invSigma) * Sigma \ (x - Mu));
        %l = @(x) mvnpdf(x, Mu, Sigma) * (Sigma \ (x - Mu));
        %dobj = @(x) deal(-1 * mvnpdf(x,Mu,Sigma),mvnpdf(x, Mu, Sigma) * (Sigma \ (x - Mu)));
        
        %gc1 = @(x)deal([],gate_distance_constraint(x,local_env.gate));
        
        %obj(x)
        %pause
        
        %% run
        %x = Mu + rand(size(Mu))/10;
        %[z,p] = fmincon(obj,x,[],[],[],[],[],[],gc1,opts);
        [z,p] = fminsearch(obj,x,opts);
        
        path = [path z(1:3)];
        ll = [ll log(-1*p)];
        
        pt = z;
        [x,y,w] = needle_update(pt(1),pt(2),pt(3),pt(4),pt(5),local_env);
        pt(1:3) = [x;y;w];
        x = pt;
end

end