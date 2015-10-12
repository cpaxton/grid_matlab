USE_XY=true;
HUGE=true;

figure(1); clf;
figure(2); clf;
k=4;
for VAR=1:6
    
    %% gp setup
    if USE_XY
        D = length(models{k}.in_naf)+2;
    else
        D = length(models{k}.in_naf);
    end
    hyp = [];
    sf = 2;
    ell = 0.9;
    L = rand(D,1);
    sn = 0.1;
    %meanfunc = {@meanConst}; hyp.mean = 0.0;
    meanfunc = [];
    %covfunc = @covSEiso; hyp.cov = log([ell;sf]);
    %covfunc = @covSEard; hyp.cov = log([L;sf]);
    covfunc = {@covPoly,3}; c = 2; hypp = log([c;sf]);   % third order poly
    likfunc = @likGauss; hyp.lik = log(sn);
    
    %% learning
    t = [ap{k}.t];
    trainingData = [];
    if models{k}.use_gate
        trainingData = [trainingData;ap{k}.gate_features];
    end
    if models{k}.use_prev_gate
        trainingData = [trainingData;ap{k}.prev_gate_features];
    end
    if models{k}.use_exit
        trainingData = [trainingData;ap{k}.exit_features];
    end
    trainingData = trainingData(models{k}.in_naf,:);
    pts = [ap{k}.trainingData];
    if USE_XY
        trainingData = [pts(1:2,:);trainingData];
    end
    
    %hyp2 = minimize(hyp, @gp, -100, @infExact, meanfunc, covfunc, likfunc, t', x');
    hyp2 = minimize(hyp, @gp, -100, @infExact, meanfunc, covfunc, likfunc, trainingData', t');
    
    %% tests
    %subplot(2,3,VAR); hold on; grid on;
    
    %xlabel('input, t');
    %ylabel('output, x');
    %
    %nt = linspace(0,1000)';
    %[m s2] = gp(hyp2, @infExact, meanfunc, covfunc, likfunc, t', x', nt);
    %f = [m+2*sqrt(s2); flipdim(m-2*sqrt(s2),1)];
    %fill([nt; flipdim(nt,1)], f, [7 7 7]/8);
    %
    %for i=1:5 %length(ap{k})
    %	plot(ap{k}(i).t, ap{k}(i).gate_features(VAR,:),'+');
    %end
    
    %indices = [1; 6; 10];
    indices = floor(linspace(1,length(ap{k}),3));
    for EX = 1:3
        test_idx = indices(EX);
        fprintf('level %d...\n',test_idx);
        
        f = get_reproduction_features([200;-10;0],models{k},ap{k}(test_idx));
        f = f(models{k}.in_naf,:);
        if USE_XY
            f = [200;-10;f];
        end
        disp([trainingData(:,10) f])
        disp(gp(hyp, @infExact, meanfunc, covfunc, likfunc, trainingData', t', f'));
        disp(gp(hyp, @infExact, meanfunc, covfunc, likfunc, trainingData', t', trainingData(:,10)'));
        
        %x = floor(ap{k}(test_idx).gate.x)-1000:10:ceil(ap{k}(test_idx).gate.x)+1000;
        %y = ceil(ap{k}(test_idx).gate.y)+1000:-10:floor(ap{k}(test_idx).gate.y)-1000;
        if HUGE
            x = 1:10:1500;
            y = 900:-10:-900;
        else
            x = 1:10:1500;
            y = 1:-10:-600;
        end
        %img=zeros(-1*min(y),max(x));
        img = zeros(10*length(y),10*length(x));
        
        env = ap{k}(test_idx);
        env.gate = move_gate(10, 120, env.gate);
        for ii=1:length(x);
            X = ones(size(y)) * x(ii);
            f = get_reproduction_features([X;y;zeros(size(y))],models{k},env);
            f = f(models{k}.in_naf,:);
            if USE_XY
                f = [X;y;f];
            end
            
            %[m,c,lm,lc,ll] = gp(hyp2, @infExact, meanfunc, covfunc, likfunc, trainingData', t', f', ones(size(y))*1000);
            [m,c,lm,lc] = gp(hyp2, @infExact, meanfunc, covfunc, likfunc, trainingData', t', f');
            %[~,~,~,~,ll] = gp(hyp2, @infExact, meanfunc, covfunc, likfunc, trainingData', t', f', m);
            
            %img(:,ii) = ll(end:-1:1);
            idx2 = ((ii-1) * 10) + 1;
            for jj=length(y):-1:1;
                idx1 = ((jj-1) * 10) + 1;
                %img(idx1:idx1+10,idx2:idx2+10) = ll(length(y)-jj+1);
                img(idx1:idx1+10,idx2:idx2+10) = m(length(y)-jj+1);
            end
        end
        figure(1);
        subplot(1,3,EX); hold on;
        image(img,'CDataMapping','scaled');
        a0 = axis();
        a = a0 + [min(x) min(x) min(y) min(y)];
        plot(env.gate.corners(1,:)-min(x),env.gate.corners(2,:)-min(y),'w*');
        axis(a0);
        figure(2); hold on;
        subplot(1,3,EX); axis(a);
        if models{k}.use_gate
            draw_gates({env.gate},true);
        end
        if models{k}.use_prev_gate
            draw_gates({env.prev_gate},true);
        end
        
        draw_segments(ap{k}(test_idx),2);
        if models{k}.use_exit
            draw_frame_angle(ap{k}(test_idx).exit(1:2),ap{k}(test_idx).exit(3),100);
        end
    end
    break;
end