function draw_nodes(nodes)

for i = 1:length(nodes)
    for j = 1:length(nodes(i).trajs)
       plot(nodes(i).trajs{j}(1,:),nodes(i).trajs{j}(2,:),...
           'color',nodes(i).models{nodes(i).action_idx }.color);
    end
end

end