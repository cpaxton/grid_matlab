function all_labels = vec_to_labeled_graphs(trials,envs,vec,num_levels,colors)

if nargin < 5
   colors = 'rgbmcy'; 
end

all_labels = cell(num_levels,1);

idx = 1;
for i = 1:num_levels
    all_labels{i} = cell(length(trials{i}),1);
    for j = 1:length(trials{i})
        
        all_labels{i}{j} = vec(idx:(idx - 1 + length(trials{i}{j}.x)));
        idx = idx + length(trials{i}{j}.x);
    end
end

for i = 1:num_levels
   
    figure(i); clf;
    
    draw_environment(envs{i});
    
    hold on;
    
    for j = 1:length(trials{i})
       
        for idx = 1:length(trials{i}{j}.x)
           x = trials{i}{j}.x(idx);
           y = trials{i}{j}.y(idx);
           plot(x,y,['.' colors(all_labels{i}{j}(idx))]);
        end
        
    end
    
end

end