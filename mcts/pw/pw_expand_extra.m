function should_expand = pw_expand_extra(num_visits, num_children, C, alpha, extra)
    should_expand = num_children < extra + ceil(C * (num_visits ^ alpha));
end