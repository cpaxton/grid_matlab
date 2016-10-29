function x = weighted_ends_mean(ends, p)
    if length(p) > 1
        x = sum(ends' .* repmat(p, 1, 5)) / sum(p)';
    else
        x = ends;
    end
end