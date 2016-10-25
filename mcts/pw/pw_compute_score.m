function score = pw_compute_score(sum, nb, p, t, C, alpha)
    k = ceil(C * t^alpha);
    %fprintf('%f %f/%f\n',k,nb,t);
    %fprintf(' -- %f\n',sqrt(log(t)/(nb + 1)));
    assert (nb <= t);
    if t == 0
        score = Inf;
    else
        score = (sum / (nb + 1)) + (k * sqrt(log(t)/(nb + 1)));
    end
    %score = (sum / (nb + 1)) * (1 + (k * sqrt(log(t)/(nb + 1))));
end