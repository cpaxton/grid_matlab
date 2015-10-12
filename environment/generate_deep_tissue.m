function tissue = generate_deep_tissue( x, y, spread )
%GENERATE_DEEP_TISSUE Generates a small blob of deep tissue centered at (x,y)
%   Detailed explanation goes here

npts = 3 + floor(rand()*4);

bounds = zeros(2,npts);

for i = 1:npts
    dist = normrnd(spread,spread/10);
    angle = normrnd(i/npts * 2 * pi,0.2);
    
    bounds(:,i) = [x+(dist*cos(angle));y+(dist*sin(angle))];
    
end

tissue = struct('isDeepTissue',true,'bounds',bounds);

end

