function score = prior_compute_score(sum, nb, p, t, C)
    assert (nb <= t);
    if t == 0
        score = Inf;
    else
        score = (sum / (nb + 1)) + (C * p * sqrt(t)/(nb + 1));
    end
end