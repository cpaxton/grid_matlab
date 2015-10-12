% BSPLINE FITTING TEST
% used for interpolation

%% get trajectory
traj = ap{3}(1).originalData;
traj2 = ap{3}(2).originalData;
%t = ap{3}(1).t / 1000;

figure; hold on;
plot(traj(1,:),traj(2,:),'b');

%% spline fitting
k = 5; % spline order
t = 0:0.1:1;
D = bspline_estimate(k,t,traj);
E = bspline_deboor(k,t,D);
D2 = bspline_estimate(k,t,traj2);
E2 = bspline_deboor(k,t,D2);

plot(D(1,:),D(2,:),'g');
plot(E(1,:),E(2,:),'r');
plot(D2(1,:),D2(2,:),'g');
plot(E2(1,:),E2(2,:),'r');

figure;
subplot(1,2,1); hold on;
draw_trajectory(E,'r');
draw_trajectory(traj,'b');
subplot(1,2,2); hold on;
draw_trajectory(E2,'r');
draw_trajectory(traj2,'b');