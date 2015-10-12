function env = generate_environment(width,height,num_gates,num_deep_tissue)

if num_deep_tissue > num_gates + 1
    num_deep_tissue = num_gates + 1;
end

gates = cell(num_gates,1);
surfaces = cell(num_deep_tissue,1);

spacing = 1;
if num_deep_tissue == 0
    spacing = 2;
end

y = height/2;
x_step = width/(num_gates+num_deep_tissue+spacing);

placed_gates = 0;
placed_tissue = 0;

for i=1:(num_gates+num_deep_tissue)
    gate_x = normrnd(x_step*(i+0.5),x_step/10);
    gate_y = normrnd(y,height/10);
    if placed_gates <= placed_tissue || placed_tissue >= num_deep_tissue
        gate_height = 100+normrnd(0.1*height,0.04*height);
        gate_width = 0.6*gate_height; %normrnd(0.21*height,0.10*height);
        w = normrnd(0,0.1);
        gates{placed_gates+1} = create_gate(gate_x,gate_y,w,gate_width,gate_height);
        placed_gates = placed_gates + 1;
    else
        spread = 0.05*height;
        surfaces{placed_tissue+1} = generate_deep_tissue(gate_x,gate_y,spread);
        placed_tissue = placed_tissue + 1;
    end
    %fprintf('gates: %d, obstacles: %d\n', placed_gates, placed_tissue);
end

env = struct('width',width,'height',height,'gates',{gates},'surfaces',{surfaces});

end