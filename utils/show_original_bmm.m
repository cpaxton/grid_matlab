
figure(2); clf;
for i=1:6
    h = subplot(,6,i);
    draw_environment(envs{i}, true);
    for j=1:length(predicates{i})
        labels = BernoulliAssign(bmm,predicates{i}{j}');
        for k=1:bmm.k
            % plot trials of each color
            x = trials{i}{j}.x(:,labels==k);
            y = trials{i}{j}.y(:,labels==k);
            w = trials{i}{j}.w(:,labels==k);
            u = cos(w);
            v = sin(w);
            %quiver(x, y, u, v, 'color', colors(k));
            plot(x,y,markers(k),'color', colors(k), 'markerSize', 0.1);
        end
    end
    axis equal;
    axis([0, 2048, -256, 1280])
    set(h,'XTick',[]);
    set(h,'YTick',[]);
    box on;
    h.XColor = 0.66*ones(1,3);
    h.YColor = 0.66*ones(1,3);
end
%suptitle('Training Demonstrations on Levels 1-6');
