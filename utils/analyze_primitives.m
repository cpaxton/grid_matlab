function [models] = analyze_primitives(ap,models)
% ANALYZE_PRIMITIVES
%

for k=1:length(models)
    tmp = [];
   for i=1:length(ap{k})
       tmp = [tmp; ap{k}(1).data];
   end
   k
   
   models{k}.movement_dev = std(tmp(4,:));
   models{k}.movement_mean = mean(tmp(4,:));
   models{k}.movement_min = min(tmp(4,:));
   models{k}.movement_max = max(tmp(4,:));
   models{k}.rotation_dev = std(tmp(5,:));
   models{k}.rotation_mean = mean(tmp(5,:));
   models{k}.rotation_min = min(tmp(5,:));
   models{k}.rotation_max = max(tmp(5,:));
end

end