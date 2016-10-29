function Z = model_init_z_env(model, local_env, config)

    x0 = [190; 1000; 0; 0; 0];
    if ~local_env.fake_prev_gate
        local_env.prev_gate
    end

    N_Z_DIM = 3*config.n_primitives;
    if model.in_gate
        xg = local_env.prev_gate.width;
        local_env.prev_gate.corners
        rg = 0;
    elseif model.use_gate
        % handle models that go to a gate
        xg = x0(1:2)' - [local_env.gate.x local_env.gate.y];
        rg = atan2(local_env.gate.y-x0(2),local_env.gate.x-x0(1));
        if rg < -pi
            rg = rg + pi;
        elseif rg > pi
            rg = rg - pi;
        end
    else
        xg = x0(1) - local_env.exit(1);
        rg = 0;
    end
    movement_guess = model.movement_mean;
    N_STEPS = ceil(norm(xg) / config.n_primitives / movement_guess);
    
    rg = rg / (config.n_primitives*N_STEPS) * 20;
    mu = normrnd(1,0.1,N_Z_DIM,1).*repmat([rg;movement_guess;N_STEPS],config.n_primitives,1);
    cv = [model.movement_dev 0 0; 0 model.rotation_dev 0; 0 0 1];
    sigma = eye(N_Z_DIM);
    for i=1:3:N_Z_DIM
        sigma(i:(i+2),i:(i+2)) = cv * 1e-1;
    end
    Z  = struct('mu',mu,'sigma',sigma);
end