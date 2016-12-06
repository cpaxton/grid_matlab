function draw_nn_test(x,y,g,fig)

if nargin < 4
    fig = 1;
end

figure(fig); hold on;

plot(g(1), g(2), 'r*');
plot(x(:,1),x(:,2), 'g.');
x2  = x + y;
plot(x2(:,1),x2(:,2), 'b.');

end