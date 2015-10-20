function ex = show_loglikelihood( model, pt, env, conf, bmm )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

HUGE = true;
if HUGE
    x = 1:10:1501;
    y = 900:-10:-900;
else
    x = 1:10:1501;
    y = 1:-10:-601;
end

for i=1:length(x);
    for j=1:length(y);
        
        if model.use_gate
            f = get_gate_distances([x(i);y(j);0],env.gates{conf.gate}{conf.opt});
        else
            f = [];
        end
        if model.use_prev_gate
            f = [f;get_gate_distances([x(i);y(j);0],env.gates{conf.prev_gate}{conf.prev_opt})];
        end
        if model.use_exit
            f = [f;get_end_distance([x(i);y(j);0],env.exit)];
        end
        
        idx1 = ((j-1) * 10) + 1;
        idx2 = ((i-1) * 10) + 1;
        img(idx1:idx1+10,idx2:idx2+10) = compute_loglik([1000;x(i)-pt(1);y(j)-pt(2);f(model.in_naf)],model.Mu,model.Sigma,model,model.in_na);
        %img(idx1:idx1+10,idx2:idx2+10) = compute_loglik([x(i)-pt(1);y(j)-pt(2);f(model.in_naf)],model.Mu,model.Sigma,model,model.in_na(2:end));
    end
end

[v,Y] = max(img);
[v,X] = max(v);
if HUGE
    fprintf('max=%f at (%d,%d)\n',v,X,-Y(X)-min(y)+1);
else
    fprintf('max=%f at (%d,%d)\n',v,X,-Y(X));
end
figure(3);clf;
image(img,'CDataMapping','scaled');

figure(4);clf;hold on;
if model.use_gate
    draw_gates({env.gates{conf.gate}{conf.opt}});
end
if model.use_prev_gate
    draw_gates({env.gates{conf.prev_gate}{conf.prev_opt}});
end

if model.use_exit
    draw_frame_angle(env.exit(1:2),env.exit(3),100);
end
if HUGE
    plot(X,-Y(X)-min(y)+1,'*','color',model.color);
else
    plot(X,-Y(X),'*','color',model.color);
end

ex = eval_model(model,pt,env,conf);
tmp = [];
tmp.data = ex;
draw_segments(tmp,4);


end

