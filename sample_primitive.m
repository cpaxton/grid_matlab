function x=sample_primitive(x0,ui,vi,ti)
%% sample a trajectory primitive
% this is a small sub-section of a trajectory parameterized by a duration
% and a constant control
% 
% vi=10;
% NUM_PTS = 10;
% t = linspace(0,ti,NUM_PTS);
% x = repmat(x0,1,NUM_PTS);
% if ui ~= 0
%     x(1,:) = x(1,:) + (vi / ui)*(sin(x(3,:) + (t * ui)) - sin(x(3,:)));
%     x(2,:) = x(2,:) + (vi / ui)*(cos(x(3,:) + (t * ui)) - cos(x(3,:)));
% else
%     x(1,:) = x(1,:) + vi*t.*sin(x(3,:));
%     x(2,:) = x(2,:) + vi*t.*cos(x(3,:));
% end
% x(3,:) = x(3,:) + (t * ui);

assert(size(x0,1) == 5);

len = max(ceil(ti),1)+1;
x = repmat(x0,1,len);
for i = 2:len
   x(1:3,i) = dynamics(x(1:3,i-1),[vi;ui]);
   x(4:5,i-1) = [vi;ui];
end
x(4:5,i) = [vi,ui];

%x = x(:,2:end);

end