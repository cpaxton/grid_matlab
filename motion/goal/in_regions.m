function goal_met = in_regions(pt,in)
goal_met = false;
for j=1:length(in)
    if inpolygon(pt(1,:),pt(2,:),in{j}(1,:),in{j}(2,:))
        goal_met = true;
        break;
    end
end
end