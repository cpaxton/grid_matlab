function feat=proc_cell_feat(f)

feat=[];

for i=1:length(f)
    
    
    for j=1:length(f{i})
    
        feat=[feat f{i}{j}];
   
    end

end

feat=feat';