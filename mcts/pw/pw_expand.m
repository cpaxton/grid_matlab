function should_expand = pw_expand(num_visits, num_children, C, alpha)
    should_expand = num_children < ceil(C * (num_visits ^ alpha));
end