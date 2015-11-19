

NVIEWS = 3;
NCLASSES = 4;
LEN = 20;
CLASS_LENS = [2,3,4,3];

%% initialize variables
x = cell(LEN,NVIEWS);
y = rand(LEN,1);
s = rand(NCLASSES,NVIEWS);
models = cell(NCLASSES,NVIEWS);

%% create fake data

%% example
i = 1;
yi = 1;
unary(x{yi,:},yi,s(yi,:),models{yi,:});