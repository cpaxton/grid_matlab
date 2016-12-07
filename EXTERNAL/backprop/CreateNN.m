function [ net ] = CreateNN( ni,nh,no )
% A Matlab implementation of a MultiLayer perceptron with
% backpropagation training with momentum.
% 
% 
% by: José Antonio Martín H. <jamartinh [*AT*] fdi ucm es>
% 
% 
% Placed in the public domain. August 23, 2008

wsize   = ((ni+1)*nh)+(nh*no); % +1 for bias;
net.w   = 4*rand(1,wsize)-2;
net.ci  = zeros(ni+1,nh);
net.co  = zeros(nh,no);
net.ni  = ni;
net.nh  = nh;
net.no  = no;
