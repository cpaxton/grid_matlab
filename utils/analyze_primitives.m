function [models] = analyze_primitives(ap,models)
% ANALYZE_PRIMITIVES

for k=1:length(models)
    tmp = [];
    lens = [];
   for i=1:length(ap{k})
       tmp = [tmp ap{k}(i).data];
       lens = [lens length(ap{k}(i).data)];
   end
   
   models{k}.movement_dev = std(tmp(4,:));
   models{k}.movement_mean = mean(tmp(4,:));
   models{k}.movement_min = min(tmp(4,:));
   models{k}.movement_max = max(tmp(4,:));
   models{k}.rotation_dev = std(tmp(5,:));
   models{k}.rotation_mean = mean(tmp(5,:));
   models{k}.rotation_min = min(tmp(5,:));
   models{k}.rotation_max = max(tmp(5,:));
   models{k}.len_mean = mean(lens);
   models{k}.len_std = std(lens);
   models{k}.len_min = min(lens);
   models{k}.len_max = max(lens);

   models{k}.steps_mean = mean(lens / 4);
   models{k}.steps_std = std(lens / 4);

   
end

end