function draw_registered_action_primitives(bmm,ap)
figure(9);clf;
if bmm.k > 3
    height = 2;
    width = ceil(bmm.k / 2);
    primitive_names = {'Exit','Pass-Through','Connect','Approach','Pass-Exit','Exit'};
    for k=1:bmm.k
        subplot(height,width,k);
        set(gca, 'XTickLabel', [], 'YTickLabel', [], 'nextplot', 'add');
        title(primitive_names{k});
        draw_segments(ap{k}(:),9); % show an example of a set of individual segments
        axis equal;
    end
    suptitle('Registered Action Primitives');
else
    height = 1;
    width = ceil(bmm.k);
    primitive_names = {'Exit','Pass-Through','Approach'};
    for k=1:bmm.k
        subplot(height,width,k);
        set(gca, 'XTickLabel', [], 'YTickLabel', [], 'nextplot', 'add');
        title(primitive_names{k});
        draw_segments(ap{k}(:),9); % show an example of a set of individual segments
        axis equal;
    end
    suptitle('Registered Action Primitives');
end
end