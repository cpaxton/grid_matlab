function [out,dt] = sample_movement(model,num)
out = rand(length(model.out),num);
out(1,:) = abs((out(1, :) * (4*model.movement_dev)) + (model.movement_mean - 2*model.movement_dev));
out(2, :) = (out(2,:) * 16*model.rotation_dev) + (model.rotation_mean - (8*model.rotation_dev));
%dt = (rand(1,num) * 100) - 50 + (1000/model.steps);
dt = rand(1,num) * (6000/model.steps);

end