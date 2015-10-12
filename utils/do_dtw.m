function apk = do_dtw(apk,model)

for i = 2:length(apk)
    
    %s = [apk(1).data];
    %t = [apk(i).data];
    
    s = [];
    t = [];
    
    if model.use_gate
        s = [s;apk(1).gate_features];
        t = [t;apk(i).gate_features];
    end
    if model.use_prev_gate
        s = [s;apk(1).prev_gate_features];
        t = [t;apk(i).prev_gate_features];
    end
    if model.use_exit
        s = [s;apk(1).exit_features];
        t = [t;apk(i).exit_features];
    end
    
    [d,D,x,y] = dtw(s',t',20);
    si = length(s);
    [~,idx] = min(D(si,y(si,:)<=size(t,2)));
    ti = y(si,idx);
    %fprintf('D(%d,%d)=%f\n',si,ti,D(si,ti));
    path = [];
    
    while si ~= 0 && ti ~= 0
        
        path = [[si;ti] path];
        
        si2 = x(si,ti);
        ti2 = y(si,ti);
        
        si = si2;
        ti = ti2;
    end
    
    %s = s(:,path(1,1:(end-1)));
    %t = t(:,path(2,1:(end-1)));
    %fprintf('original=%f, new=%f\n',d,dtw(s',t'));
    
    apk(i).data = apk(i).data(:,path(2,1:(end-1)));
    if model.use_gate
        apk(i).gate_features = apk(i).gate_features(:,path(2,1:(end-1)));
    end
    if model.use_prev_gate
        apk(i).prev_gate_features = apk(i).prev_gate_features(:,path(2,1:(end-1)));
    end
    if model.use_exit
        apk(i).exit_features = apk(i).exit_features(:,path(2,1:(end-1)));
    end
    
    apk(i).t = (0:(size(apk(i).data,2)-1)) / (size(apk(i).data,2)-1);
end
end