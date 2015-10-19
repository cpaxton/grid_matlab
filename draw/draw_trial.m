function draw_trial( trial )
%DRAW_TRIAL Summary of this function goes here
%   Detailed explanation goes here

u = cos(trial.w);
v = sin(trial.w);
%quiver(trial.x, trial.y, u, v);
plot(trial.x,trial.y);

end

