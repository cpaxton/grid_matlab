function [ Z ] = init_z( x0, model, local_env, N_PRIMITIVES, N_Z_DIM )
    if model.in_gate
        xg = local_env.prev_gate.width;
        local_env.prev_gate.corners
    elseif model.use_gate
        xg = x0(1:2)' - [local_env.gate.x local_env.gate.y];
    else
        xg = x0(1) - local_env.exit(1);
    end
    movement_guess = model.movement_mean;
    N_STEPS = ceil(norm(xg) / N_PRIMITIVES / movement_guess);
    
    mu = normrnd(1,0.1,N_Z_DIM,1).*repmat([0;movement_guess;N_STEPS],N_PRIMITIVES,1);
    cv = [model.movement_dev 0 0; 0 model.rotation_dev 0; 0 0 1];
    sigma = eye(N_Z_DIM);
    for i=1:3:N_Z_DIM
        sigma(i:(i+2),i:(i+2)) = cv;
    end
    Z  = struct('mu',mu,'sigma',sigma);
end

