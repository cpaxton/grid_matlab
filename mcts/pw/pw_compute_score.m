function score = pw_compute_score(sum, nb, t, C, alpha)
    k = ceil(C * t^alpha);
    score = (sum / (nb + 1)) + (k * sqrt(log(t)/(nb + 1)));
end