
function model=gmmemtrain(data,ncenters,iter)

%         data=cell2mat(data);
        
        data=data'; 
        
        dim=size(data,2);

        %MIX=gmm(dim,ncenters,'ppca');
        MIX=gmm(dim,ncenters,'full');
        
        options=foptions;
        
        options(14)=5;
        
        MIX=gmminit(MIX,data,options);
        
        options=zeros(1,18);
        
        options(1)=-1;
        
        options(14)=iter;
        
        [MIX , ~, ~]=gmmem(MIX,data,options);
        
        
       model.Mu=MIX.centres;
       model.Sigma=MIX.covars;
       model.in=MIX.nin;
       model.priors=MIX.priors;
       
        
























