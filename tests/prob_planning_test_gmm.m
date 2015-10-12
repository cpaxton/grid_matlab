% prob_planning

STEP_SIZE = 0.5;
N_SAMPLES = 250;
N_ITER = 20;
N_PRIMITIVES = 4;
N_ELITE = 240;
N_Z_DIM = 2*N_PRIMITIVES;
N_STEPS = 10;
MOVE_X = 50;
MOVE_Y = -250;

FIG_SAMPLES = 1;

x0 = [190,1000,0,0,0]'; 
local_env = [];
local_env.exit = [envs{2}.width;envs{2}.height / 2; 0];
local_env.gate = move_gate(MOVE_X,MOVE_Y,envs{2}.gates{1});
next_env = [];
next_env.exit = local_env.exit;
next_env.prev_gate = local_env.gate;

xg = x(1:2) - [local_env.gate.x local_env.gate.y];
movement_guess = norm(xg) / (N_PRIMITIVES * N_STEPS);

mu = normrnd(1,0.1,N_Z_DIM,1).*repmat([0.0;movement_guess],N_PRIMITIVES,1);
%cv = 0.01*cov([trials{1}{1}.rotation;trials{1}{1}.movement]');
cv = [1 0; 0 25];
sigma = eye(N_Z_DIM);
for i=1:2:N_Z_DIM
    sigma(i:(i+1),i:(i+1)) = cv;
end
Z  = struct('mu',mu,'sigma',sigma);

current = models{4};
goal = models{2};

traj = prob_planning(x0,current,goal,local_env,next_env);

figure(1); clf;
%draw_environment(envs{2});
draw_gates({local_env.gate});
plot(traj(1,:),traj(2,:));