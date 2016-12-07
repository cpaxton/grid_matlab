% A Matlab implementation of a MultiLayer perceptron with
% backpropagation training with momentum.
% 
% 
% by: José Antonio Martín H. <jamartinh [*AT*] fdi ucm es>
% 
% 
% Placed in the public domain. August 23, 2008


clc
clear all
close all

inputs = [ 0 0 0 ; 0 1 0 ; 1 0 1 ; 1 1 1];
targets = [ 1 1  ; -1 -1 ; -1 -1 ; 1 1];


inputs
targets

ni    = 3;
nh    = 4;
no    = 2;
wsize = ((ni+1)*nh)+(nh*no); % +1 for bias;
net   = 4*rand(1,wsize)-2;
ci    = zeros(ni+1,nh);
co    = zeros(nh,no);


for i=1:1000
    error = 0;
    for j=1:4
        [ net,co,ci,err ] = BackProp(net,inputs(j,:),targets(j,:),ni,nh,no,co,ci ); 
        error = error + err;
    end
    if mod(i,100)==0
    display([' Error ',num2str(error)])
    end
end

%test newtork function
for j=1:4
         output  = EvalNN( inputs(j,:),net,ni,nh,no );
         display([' Inputs [',num2str(inputs(j,:)),'] --> outputs:  [',num2str(output),']']) 
end
    
