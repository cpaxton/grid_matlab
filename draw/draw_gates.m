function draw_gates( gates, gray )

  if nargin < 2
    gray = false;
  end

c1 = [251/255 216/255 114/255];
c2 = [255/255 50/255 12/255];
c3 = [255/255 12/255 150/255 ];
ce = [0,0,0];

if gray
  c1 = [0.95, 0.95, 0.95];
  c2 = [0.75,0.75,0.75];
  c3 = [0.75,0.75,0.75];
  ce = [0.66, 0.66, 0.66];
end

hold on;
for i=1:length(gates)
   fill(gates{i}.corners(1,:), gates{i}.corners(2,:), c1,'edgeColor',ce);
   fill(gates{i}.top(1,:), gates{i}.top(2,:), c2,'edgeColor',ce);
   fill(gates{i}.bottom(1,:), gates{i}.bottom(2,:), c3,'edgeColor',ce);
end

end

