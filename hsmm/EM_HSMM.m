function m = EM_HSMM(s, m)
% Expectation-Maximization estimation of the HSMM parameters.
% Authors: Shun-Zheng Yu, with adaptation to Gaussian distributions by Sylvain Calinon and Antonio Pistillo
% 
% Reference: "Practical Implementation of an Efficient Forward-Backward Algorithm for an Explicit Duration 
% Hidden Markov Model" by Shun-Zheng Yu and H. Kobayashi, IEEE Transactions on Signal Processing, 
% Vol. 54, No. 5, May 2006, pp. 1947-1951 
% 
% This program is free software; you can redistribute it and/or
% modify it under the terms of the GNU General Public License
% as published by the Free Software Foundation; either version
% 2 of the License, or (at your option) any later version.
% http://www.gnu.org/licenses/gpl.txt

maxIter = 20;
nbSamples = length(s);
nbVar = size(s(1).Data,1);
nbStates = length(m.StatesPriors);
nbD = size(m.Pd,2);
lkh3 = 0;

for iter=1:maxIter
  lkh2 = 0; 
  exp_num_visits1 = zeros(nbStates,1);
  exp_num_trans = zeros(nbStates,nbStates);
  exp_num_visit_qd = zeros(nbStates,nbD);
  m.Muest_cumul = zeros(nbVar,nbStates);
  m.Sigmaest_cumul = zeros(nbVar,nbVar,nbStates);
  GAMMAcumul2 = zeros(nbStates,1);

  for smp=1:nbSamples
    lkh = 0;
    clear obs;
    obs = s(smp).Data; 
    nbData = size(obs,2);
    ALPHA = zeros(nbStates,nbD);
    bmx = zeros(nbStates,nbData);
    S = zeros(nbStates,nbData);
    E = zeros(nbStates,nbData);
    BETA = ones(nbStates,nbD);
    Ex = ones(nbStates,nbD);
    Sx = ones(nbStates,nbD);
    GAMMA = zeros(nbStates,1);
    Pest = zeros(nbStates,nbD);
    Aest = zeros(nbStates,nbStates);

    for i=1:nbStates
      Btmp(i,1) = gaussPDF(obs(:,1),m.Mu(:,i),m.Sigma(:,:,i)); 
    end
    Btmp = Btmp./sum(Btmp);

    %++++++++++++++++++     Forward     +++++++++++++++++
    %---------------    Initialization    ---------------
    ALPHA(:)=0; ALPHA=repmat(m.StatesPriors,1,nbD).*m.Pd;	%Equation (13)
    r = (Btmp'*sum(ALPHA,2));	%Equation (3)
    bmx(:,1) = Btmp./r;	%Equation (2)
    E(:)=0; E(:,1)=bmx(:,1).*ALPHA(:,1); %Equation (5)
    S(:)=0; S(:,1)=m.Trans'*E(:,1);	%Equation (6)
    lkh = log(r);
    %---------------    Induction    ---------------
    for t=2:nbData
      for i=1:nbStates
        Btmp(i,1) = gaussPDF(obs(:,t), m.Mu(:,i), m.Sigma(:,:,i)); 
      end
      Btmp = Btmp./sum(Btmp);
      ALPHA = [repmat(S(:,t-1),1,nbD-1).*m.Pd(:,1:nbD-1)+repmat(bmx(:,t-1),1,nbD-1).*ALPHA(:,2:nbD),S(:,t-1).*m.Pd(:,nbD)];	%Equation (12)
      r = (Btmp'*sum(ALPHA,2));	%Equation (3)
      bmx(:,t) = Btmp./r;	%Equation (2)
      E(:,t) = bmx(:,t).*ALPHA(:,1); %Equation (5)
      S(:,t) = m.Trans' * E(:,t);	%Equation (6)
      lkh = lkh + log(r);
    end

    %++++++++ Backward and Parameter Reestimation ++++++++
    %---------------    Initialization    ---------------
    Aest(:)=0; Aest=E(:,nbData)*ones(1,nbStates); 
    Pest(:) = 0;  
    GAMMA = bmx(:,nbData).*sum(ALPHA,2);
    BETA = repmat(bmx(:,nbData),1,nbD);	%Equation (7)
    Ex = sum(m.Pd.*BETA,2);	%Equation (8)
    Sx = m.Trans * Ex; %Equation (9)
    GAMMAcumul = GAMMA;
    m.Muest = zeros(nbVar,nbStates);
    m.Sigmaest = zeros(nbVar,nbVar,nbStates); 
    %---------------    Induction    ---------------
    for t=(nbData-1):-1:1         
      Aest = Aest + E(:,t)*Ex';  % Equation (25)
      Pest = Pest + repmat(S(:,t),1,nbD).*BETA; % Equation (26)   
      GAMMA = GAMMA+E(:,t).*Sx-S(:,t).*Ex; % Equation (16)
      GAMMA(GAMMA<0) = 0; %Eliminate errors due to inaccuracy of computation
      for i=1:nbStates
        m.Muest(:,i) = m.Muest(:,i) + GAMMA(i).*obs(:,t);
        m.Sigmaest(:,:,i) = m.Sigmaest(:,:,i) + GAMMA(i).*((obs(:,t)-m.Mu(:,i))*(obs(:,t)-m.Mu(:,i))');
      end
      GAMMAcumul = GAMMAcumul+GAMMA;
      BETA = repmat(bmx(:,t),1,nbD).*[Sx,BETA(:,1:nbD-1)]; %Equation (14)
      Ex = sum(m.Pd.*BETA,2); %Equation (8)
      Sx = m.Trans*Ex; %Equation (9)
    end

    Pest = Pest + repmat(m.StatesPriors,1,nbD).*BETA;

    %Output computation
    priors_prev = GAMMA./sum(GAMMA);
    exp_num_visits1 = exp_num_visits1 + priors_prev; 
    Aest = Aest .* m.Trans;   
    exp_num_trans = exp_num_trans + Aest;
    Pest = Pest.*m.Pd;   
    exp_num_visit_qd = exp_num_visit_qd + Pest; 
    m.Muest_cumul = m.Muest_cumul + m.Muest;
    m.Sigmaest_cumul = m.Sigmaest_cumul + m.Sigmaest;
    GAMMAcumul2 = GAMMAcumul2 + GAMMAcumul;
    
    lkh2 = lkh2 + lkh;        
  end %nbSamples

  %Normalization 
  m.StatesPriors = exp_num_visits1 / sum(exp_num_visits1);
  m.Trans = exp_num_trans ./ repmat(sum(exp_num_trans,2),1,nbStates);
  m.Pd = exp_num_visit_qd ./ repmat(sum(exp_num_visit_qd,2),1,nbD);

%   %Approximation of Pd as Gaussian distribution
%   for i=1:nbStates
%     m.Mu_Pd(1,i) = exp_num_visit_qd(i,:) * [0:nbD-1]' / sum(exp_num_visit_qd(i,:));
%     m.Sigma_Pd(1,1,i) = exp_num_visit_qd(i,:) * ([0:nbD-1]-m.Mu_Pd(1,i)).^2' / sum(exp_num_visit_qd(i,:));
%     %Optional regularization terms to avoid singularities
%     m.Sigma_Pd(1,1,i) = m.Sigma_Pd(1,1,i) + 1E1;
%     m.Pd(i,:) = gaussPDF([0:nbD-1], m.Mu_Pd(1,i), m.Sigma_Pd(1,1,i));
%   end
%   m.Pd = m.Pd ./ repmat(sum(m.Pd,2),1,nbD);
  
  for i=1:nbStates
    m.Mu(:,i) = m.Muest_cumul(:,i) / GAMMAcumul2(i); 
    m.Sigma(:,:,i) = m.Sigmaest_cumul(:,:,i) / GAMMAcumul2(i);
    %Optional regularization terms to avoid singularities
    m.Sigma(:,:,i) = m.Sigma(:,:,i) + eye(nbVar)*1E-1;
  end

  %Check if the likelihood has increased
  if abs(lkh2-lkh3)<.01
    break;
  end
  lkh3 = lkh2;
end

%Final approximation of Pd with Gaussian
for i=1:nbStates
  m.Mu_Pd(1,i) = exp_num_visit_qd(i,:) * [0:nbD-1]' / sum(exp_num_visit_qd(i,:));
  m.Sigma_Pd(1,1,i) = exp_num_visit_qd(i,:) * ([0:nbD-1]-m.Mu_Pd(1,i)).^2' / sum(exp_num_visit_qd(i,:));
  %Optional regularization terms to avoid singularities
  m.Sigma_Pd(1,1,i) = m.Sigma_Pd(1,1,i) + 1E1;
  m.Pd(i,:) = gaussPDF([0:nbD-1], m.Mu_Pd(1,i), m.Sigma_Pd(1,1,i));
end
m.Pd = m.Pd ./ repmat(sum(m.Pd,2),1,nbD);



  
