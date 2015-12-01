
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

%%