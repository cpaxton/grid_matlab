% bernoulli EM test
input = [1 1 0 0 0 1; 1 0 1 0 0 0; 0 0 0 1 1 1; 0 0 0 1 1 0];

bmm = BernoulliEM(input,2);
labels = BernoulliAssign(bmm,input);