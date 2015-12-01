
%% setup standard "test" task
names = {'EXIT','PASS-THROUGH','CONNECT','APPROACH','DONE'};
EXIT = 1;
PASS_THROUGH = 2;
CONNECT = 3;
APPROACH = 4;
DONE = 5;

% no self transitions
transitions = zeros(5,5);
transitions(EXIT, DONE) = 1;
transitions(PASS_THROUGH, EXIT) = 1;
transitions(PASS_THROUGH, CONNECT) = 1;
transitions(CONNECT, PASS_THROUGH) = 1;
transitions(APPROACH, PASS_THROUGH) = 1;

initial = zeros(5,1);
initial(APPROACH) = 1;
initial(EXIT) = 1;

gate_change = zeros(5,1);
% does the gate change when we start this action?
gate_change(PASS_THROUGH) = 1;

%% turn this into a "plan" (an MDP for a new environment)
env = envs{4};
plans = create_task_model(transitions,initial,gate_change,models,env);