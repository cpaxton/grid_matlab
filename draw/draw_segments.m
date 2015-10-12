function draw_segments(ap,num)

if nargin < 2
    figure();hold on;
else
    figure(num);hold on;
end

for i=1:length(ap)
    u = cos(ap(i).data(3,:));
    v = sin(ap(i).data(3,:));
    
    %quiver(ap(i).data(1,:),ap(i).data(2,:),u,v);
    plot(ap(i).data(1,:),ap(i).data(2,:),'.');
end


end
