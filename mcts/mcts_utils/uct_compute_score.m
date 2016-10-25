function score = uct_compute_score(sum, nb, p, t, C)
    assert (nb <= t);
    if t == 0
        score = Inf;
    else
        score = (sum / (nb + 1)) + (C * sqrt(log(t)/(nb + 1)));
    end
    %score = sum / nb;
    %score = (sum / (nb + 1)) * (1 + (C * sqrt(log(t)/(nb + 1))));
end