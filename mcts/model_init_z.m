function Z = model_init_z(model, num_steps, num_primitives, num_primitive_params)
    movement_guess = model.movement_mean;
    rotation_guess = model.rotation_mean;
    
    assert (num_primitive_params == 3);
    num_z_dim = num_primitives * num_primitive_params;
    
    mu = normrnd(1,0.1,num_z_dim,1).*repmat([rotation_guess;movement_guess;num_steps],num_primitives,1);
    cv = [model.movement_dev 0 0; 0 model.rotation_dev 0; 0 0 1];
    sigma = eye(num_z_dim);
    for i=1:3:num_z_dim
        sigma(i:(i+2),i:(i+2)) = cv;
    end
    Z  = struct('mu',mu,'sigma',sigma);
end