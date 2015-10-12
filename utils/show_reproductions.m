%figure(20);
HIDE_AXIS_TITLES = false;

%% initialize random number generator
%rng('default')

figure(101);
clf;
for i=1:6
    h = subplot(2,3,i);
    fprintf('Plotting for level %d...\n',i);
    evaluate([150,950,-0.060]',envs{i},bmm,models)
    axis([0 2500 0 1500]);
end

%for i=1:6
    %figure(10);
    %subplot(2,3,i);
    %tmp = axis;
    %figure(20);
    %subplot(2,3,i);
    %axis(tmp);
%end
%suptitle('Reproduction on Levels 1-6');
%     axis equal;
%     axis([0, 2048, -256, 1280])
%     set(h,'XTick',[]);
%     set(h,'YTick',[]);
%     box on;
%     h.XColor = 0.66*ones(1,3);
%     h.YColor = 0.66*ones(1,3);
% end

if HIDE_AXIS_TITLES
    for i=1:6
        figure(101);hold on;
        h = subplot(1,6,i);hold on;
        set(h,'XTick',[]);
        set(h,'YTick',[]);
        axis([0, 2048, -256, 1280]);
        box on;
        h.XColor = 0.66*ones(1,3);
        h.YColor = 0.66*ones(1,3);
    end
else
    suptitle('Reproduction on Levels 1-6');
end