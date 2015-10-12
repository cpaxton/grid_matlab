%% plot the pca results
function [img, ex] = show_pca_results(ap,models,k,skip_img)

if nargin < 4
    skip_img = false;
end

HUGE = true;

if ~skip_img
    figure(10+2*k);clf;
end
figure(11+2*k);clf;
for idx=1:3:16
    if idx > length(ap{k})
        break;
    end
    
    if HUGE
        x = 1:10:1501;
        y = 900:-10:-900;
    else
        x = 1:10:1501;
        y = 1:-10:-601;
    end
    img = zeros(-1*min(y),max(x));
    
    env = [];
    env.exit = ap{k}(idx).exit;
    if models{k}.use_gate
        env.gate = ap{k}(idx).gate;
    end
    if models{k}.use_prev_gate
        env.prev_gate = ap{k}(idx).prev_gate;
    end
%     if models{k}.use_gate
%         %tgate = relative_gate(-50,50,-pi/16,ap{k}(idx).gate);
%         tgate = relative_gate(0,0,0,ap{k}(idx).gate);
%         env.gate = tgate;
%     elseif models{k}.use_prev_gate
%         %tgate = relative_gate(-50,50,-pi/16,ap{k}(idx).prev_gate);
%         tgate = relative_gate(0,0,0,ap{k}(idx).prev_gate);
%         env.prev_gate = tgate;
%     end

    texit = ap{k}(idx).exit;
    env.exit = texit;
    
    if ~skip_img
        for i=1:length(x);
            
            f = get_reproduction_features([repmat(x(i),1,length(y));y;zeros(3,length(y))],models{k},env);
            ll = compute_loglik([1000*ones(1,length(y));f(models{k}.in_naf,:)],models{k}.Mu,models{k}.Sigma,models{k},[models{k}.in_na]);
                
            for j=1:length(y);

                
%                 if models{k}.use_gate
%                     f = get_gate_distances([x(i);y(j);0],ap{k}(idx).gate);
%                 else
%                     f = [];
%                 end
%                 if models{k}.use_prev_gate
%                     f = [f;get_gate_distances([x(i);y(j);0],ap{k}(idx).prev_gate)];
%                 end
%                 if models{k}.use_exit
%                    f = [f;get_end_distance([x(i);y(j);0],texit)];
%                 end
                
                %f2 = apply_preprocessor([x(i);y(j);f],models{1});
                idx1 = ((j-1) * 10) + 1;
                idx2 = ((i-1) * 10) + 1;
                
                img(idx1:idx1+10,idx2:idx2+10) = ll(j);
                %img(idx1:idx1+10,idx2:idx2+10) = compute_loglik([1000;x(i);y(j);f(models{k}.in_naf,j)],models{k}.Mu,models{k}.Sigma,models{k},[models{k}.in_na]);
                %%img(idx1:idx1+10,idx2:idx2+10) = compute_loglik([x(i);y(j);f(models{k}.in_naf)],models{k}.Mu,models{k}.Sigma,models{k},models{k}.in_na(2:end));
            end
        end
    end
    
    sss = ((idx-1) / 3) + 1;
    ssss = [1,2,0,3];
    if sss == 1 | sss == 2 | sss == 4
      if ~skip_img
          [v,Y] = max(img);
          [v,X] = max(v);
          if HUGE
              fprintf('%d: max=%f at (%d,%d)\n',idx,v,X,-Y(X)-min(y)+1);
          else
              fprintf('%d: max=%f at (%d,%d)\n',idx,v,X,-Y(X));
          end
          figure(10+2*k);

          subplot(1,3,ssss(sss));
          image(img,'CDataMapping','scaled');
      end
      
      figure(11+2*k); hold on;
      subplot(1,3,ssss(sss));
      if models{k}.use_gate
          draw_gates({ap{k}(idx).gate},true);
      end
      if models{k}.use_prev_gate
          draw_gates({ap{k}(idx).prev_gate},true);
      end
      
      draw_segments(ap{k}(idx),11+2*k);
      if models{k}.use_exit
          draw_frame_angle(ap{k}(idx).exit(1:2),ap{k}(idx).exit(3),100);
      end
      if ~skip_img
          if HUGE
              plot(X,-Y(X)-min(y)+1,'*','color',models{k}.color);
          else
              plot(X,-Y(X),'*','color',models{k}.color);
          end
      end
      
      ex = [];
      for i=1:10
          [ex(i).data, ex(i).cost] = create_path(models{k},env,models{k}.steps,0,0,0);
      end
      
      [~,i] = max([ex.cost]);
      draw_segments(ex(i),11+2*k);
      axis([min(x) max(x) min(y) max(y)]);
      %draw_segments(ex,11+2*k);
      
    end
    
end

% lltitle = sprintf('Log Likelihood for Action Primitive %d',k);
% trajtitle = sprintf('Trajectory Reproduction for Action Primitive %d',k);
% figure(10+2*k); hold on; suptitle(lltitle);
% figure(11+2*k); hold on; suptitle(trajtitle);

end
