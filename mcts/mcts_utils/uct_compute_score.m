function score = uct_compute_score(sum, nb, t, C)
    score = (sum / (nb + 1)) + (C * sqrt(log(t)/(nb + 1)));
    %score = sum / nb;
    %score = (sum / (nb + 1)) * (1 + (C * sqrt(log(t)/(nb + 1))));
end