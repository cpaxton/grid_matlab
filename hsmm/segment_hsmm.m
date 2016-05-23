function [actions,model,new_labels]=segment_hsmm(features, labels, nstates)
% load('allfeat');
% load('labels');
% allfeat=cell2mat(features);
allfeat=features;
% [nbVar,~]=size(allfeat);
nbD = 80; %Number of maximum duration step to consider in the HSMM
nbStates=nstates;
if(nargin<3)
    nbStates = 5; %Number of states in the HSMM
end
counter=1;
dim=min(size(features,1),size(features,2));

for i=1:length(labels)
    l=length(cell2mat(labels{i}));
    s(i).Data = allfeat(:,counter:counter+l-1); %Copy trajectory in a structure 's(n)'
    s(i).nbData = size(s(i).Data,2);
    counter=counter+l;
end

[MuTmp, SigmaTmp] = EM_init_regularTiming(allfeat, nbStates);
m.Mu = MuTmp;
m.Sigma = SigmaTmp;
m.Trans = ones(nbStates,nbStates) * 0.01;

for i=1:nbStates-1
    m.Trans(i,i) = 0.9;
    m.Trans(i,i+1) = 0.08;
end

m.Trans(nbStates,nbStates) = 0.97;
m.StatesPriors = ones(nbStates,1) * .1;
m.StatesPriors(1) = 0.7;
m.Pd = repmat(gaussPDF(0:nbD-1, nbD/2, nbD)', nbStates, 1);

%Normalization
m.Trans = m.Trans ./ repmat(sum(m.Trans,2),1,nbStates);
m.StatesPriors = m.StatesPriors / sum(m.StatesPriors);
m.Pd = m.Pd ./ repmat(sum(m.Pd,2), 1, nbD);
nstates=nbStates;

%Estimate HSMM parameters with EM algorithm
model = EM_HSMM(s, m);
model2={};
model2.emission.mu=model.Mu;
model2.emission.Sigma=model.Sigma;
model2.cpdType='condGauss';
model2.nstates=nstates;
model2.A=model.Trans;
model2.d=dim;
model2.pi=model.StatesPriors;
model2.emission.d=dim;
model2.emission.cpdType='condGauss';
model2.emission.nstates=nstates;
new_labels = hmmMap(model2, allfeat);
actions=cell(1,nstates);
for i=1:length(actions)
    actions{1,i}=allfeat(:,new_labels==i);
end




