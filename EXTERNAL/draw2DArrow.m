function draw2DArrow(pos,dir,col)
% 
% Author:	Sylvain Calinon, 2013
%         http://programming-by-demonstration.org/SylvainCalinon

plot([pos(1) pos(1)+dir(1)], [pos(2) pos(2)+dir(2)], '-','linewidth',1,'color',col);
sz = 3E-2;
pos = pos+dir;
dir = dir/norm(dir);
prp = [dir(2); -dir(1)];
dir = dir*sz;
prp = prp*sz;
msh = [pos pos-dir-prp/2 pos-dir+prp/2 pos];
patch(msh(1,:),msh(2,:),col,'edgecolor',col);
