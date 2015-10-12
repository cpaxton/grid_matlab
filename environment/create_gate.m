function gate = create_gate( x,y,w,width,height )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

bad_factor = 0.18519; %0.092593;

wi = width/2;
h = height/2;
badh = h*(1-bad_factor);

% set up shapes
corners = [x-wi x-wi x+wi x+wi; y+h y-h y-h y+h];
top = [x-wi x-wi x+wi x+wi; y+badh y+h y+h y+badh];
bottom = [x-wi x-wi x+wi x+wi; y-badh y-h y-h y-badh];

gate = struct('x',x,'y',y,'w',0,'corners',corners,'top',top, ...
    'bottom',bottom,'height',height,'width',width);

if w ~= 0
   gate = rotate_gate(x,y,w,gate); 
end

end

