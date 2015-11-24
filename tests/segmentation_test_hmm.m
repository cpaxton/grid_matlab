%rng(102);

NVIEWS = 3;
NCLASSES = 4;
LEN = 5;
CLASS_LENS = [2,3,4,3];

%% initialize variables
x = cell(LEN,NVIEWS);
y = floor(rand(LEN,1)*NCLASSES)+1;
py = zeros(LEN,NCLASSES);
s = 0.5*ones(NCLASSES,NVIEWS);
models = cell(NCLASSES,NVIEWS);
background = cell(NVIEWS,1);

%T = rand(NCLASSES,NCLASSES) + 3*eye(NCLASSES);
%T = T ./ repmat(sum(T,2),1,4);
%T0 = ones(NCLASSES,1) / NCLASSES;
%hmm = struct('nviews',NVIEWS,'nclasses',NCLASSES,'T0',T0,'T',T,'models',{models},'s',s);

%% create fake data
% Fake data is sometimes missing.
% We have some hidden features telling us how often data is totally missing
% When missing and irrelevant it's drawn from the background distribution
% for each view.

trueT = rand(NCLASSES,NCLASSES); %+ 3*eye(NCLASSES);
trueT = trueT ./ repmat(sum(trueT,2),1,4);
T0 = ones(NCLASSES,1) / NCLASSES;

truth = zeros(LEN,1);
truth(1) = ceil(rand()*NCLASSES);
for i = 2:LEN
    truth(i) = rand_hmm_transition(truth(i-1),trueT);
end

true_s = zeros(NCLASSES,NVIEWS);
for i = 1:NCLASSES
    true_s(i,ceil(rand()*NVIEWS)) = 1;
end

for j=1:NVIEWS
    mu = ones(CLASS_LENS(j),1);
    sigma = eye(CLASS_LENS(j));
    model = struct('mu',mu,'sigma',sigma);
    background{j} = model;
end
for i=1:NCLASSES
    for j=1:NVIEWS
        mu = (rand(CLASS_LENS(j),1)*2 - 1) + 10*i;
        sigma = eye(CLASS_LENS(j));%*2*rand();
        model = struct('mu',mu,'sigma',sigma);
        models{i,j} = model;
    end
end

for i = 1:LEN
    for j = 1:NVIEWS
        yt = truth(i);
        if true_s(yt,j) == 1
            x{i,j} = mvnrnd(models{yt,j}.mu,models{yt,j}.sigma)';
        else
            x{i,j} = mvnrnd(background{j}.mu,background{j}.sigma)';
        end
    end
end

%% create the hmm struct
hmm = struct('nviews',NVIEWS,'nclasses',NCLASSES,'T0',T0,'T',trueT,'models',{models},'s',s);

%% example
i = 1;

for i = 1:LEN
    fprintf('===== %d ======\n',i);
    if i == 1
        for yi = 1:4
            %p = unary({x{i,:}},s(yi,:),{models{yi,:}})  + log(T(truth(i),yi));
            %pt = unary({x{i,:}},true_s(yi,:),{models{yi,:}});
            p = unary({x{i,:}},s(yi,:),{models{yi,:}}) ;%* (T0(yi));
            pt = unary({x{i,:}},true_s(yi,:),{models{yi,:}});
            fprintf('y=%d, truth=%d, p=%f, w/ true s=%f\n',yi,truth(i),p,pt);
            py(i,yi) = p;
        end
    else
        for yi = 1:4
            %p = unary({x{i,:}},s(yi,:),{models{yi,:}})  + log(T(truth(i),yi));
            %pt = unary({x{i,:}},true_s(yi,:),{models{yi,:}});
            p = unary({x{i,:}},s(yi,:),{models{yi,:}}) ;%* (trueT(truth(i-1),yi));
            pt = unary({x{i,:}},true_s(yi,:),{models{yi,:}});
            fprintf('y=%d, truth=%d, p=%f, w/ true s=%f\n',yi,truth(i),p,pt);
            py(i,yi) = p;
        end
    end
end

[~,idx] = max(py');
y = idx';

%disp([truth y])

%% alpha
alpha = hmm_forward(x,hmm);
beta = hmm_backward(x,hmm);
gamma = hmm_gamma(alpha,beta);

[~,idx] = max(gamma');
yalpha = idx';

disp([truth y yalpha])