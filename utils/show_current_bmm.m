figure(10); clf;
idx = 0;
for i=1:6
    subplot(2,3,i);
    draw_environment(envs{i});
    for j=1:length(predicates{i})
        idx = idx + 1;
        [~,labels] = max((bmm.A{idx} .* bmm.B{idx})');
        for k=1:bmm.k
            % plot trials of each color
            x = trials{i}{j}.x(:,labels==k);
            y = trials{i}{j}.y(:,labels==k);
            w = trials{i}{j}.w(:,labels==k);
            u = cos(w);
            v = sin(w);
            %quiver(x, y, u, v, 'color', colors(k));
            plot(x,y,'.','color', colors(k));
        end
        axis([0 2500 0 1500]);
    end
end

if HOLD_OUT
    figure(11); clf;
    idx = 0;
    for i=1:6
        subplot(2,3,i);
        draw_environment(envs{i});
        for j=1:length(test_predicates{i})
            idx = idx + 1;
            [~,labels] = max((bmm2.A{idx} .* bmm2.B{idx})');
            for k=1:bmm.k
                % plot trials of each color
                x = test_trials{i}{j}.x(:,labels==k);
                y = test_trials{i}{j}.y(:,labels==k);
                w = test_trials{i}{j}.w(:,labels==k);
                u = cos(w);
                v = sin(w);
                %quiver(x, y, u, v, 'color', colors(k));
                plot(x,y,'.','color', colors(k));
            end
        end
    end
end