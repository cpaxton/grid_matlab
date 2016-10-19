function score = pw_compute_score(sum, nb, t, C, alpha)
    k = ceil(C * t^alpha);
    fprintf('%f %f/%f\n',k,nb,t);
    fprintf(' -- %f\n',sqrt(log(t)/(nb + 1)));
    score = (sum / (nb + 1)) + (k * sqrt(log(t)/(nb + 1)));
    %score = (sum / (nb + 1)) * (1 + (k * sqrt(log(t)/(nb + 1))));
end