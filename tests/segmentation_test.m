

NVIEWS = 3;
NCLASSES = 4;
LEN = 20;
CLASS_LENS = [2,3,4,3];

%% initialize variables
x = cell(LEN,NVIEWS);
y = floor(rand(LEN,1)*NCLASSES)+1;
s = 0.5*ones(NCLASSES,NVIEWS);
models = cell(NCLASSES,NVIEWS);
background = cell(NVIEWS,1);

%% create fake data
% Fake data is sometimes missing.
% We have some hidden features telling us how often data is totally missing
% When missing and irrelevant it's drawn from the background distribution
% for each view.

truth = floor(rand(LEN,1)*NCLASSES)+1;
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
        mu = rand(CLASS_LENS(j),1)*10 - 5;
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
            mvnpdf(x{i,j},models{yt,j}.mu,models{yt,j}.sigma)
        else
            x{i,j} = mvnrnd(background{j}.mu,background{j}.sigma)';
        end
    end
end


%% example
i = 1;
for i = 1:10
    fprintf('===== %d ======\n',i);
for yi = 1:4
    p = unary({x{i,:}},s(yi,:),{models{yi,:}});
    pt = unary({x{i,:}},true_s(yi,:),{models{yi,:}});
    fprintf('y=%d, truth=%d, p=%f, w/ true s=%f\n',yi,truth(i),p,pt);
end
end