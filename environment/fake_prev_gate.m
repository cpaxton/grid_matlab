function gate = fake_prev_gate(env)
    width = 0.6 * env.height;
    gate = create_gate(-width/2,env.height/2,0,width,env.height);
end