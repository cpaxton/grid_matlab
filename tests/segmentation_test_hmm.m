

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
