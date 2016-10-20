function config = make_fixed_action_config()
    config = make_default_action_config();
    config.allow_repeat = false;
    config.fixed_num_primitives = true;
end