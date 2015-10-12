function [ trainingData, points ] = create_training_data( predicates, features, trials, bmm, dxdy )
%CREATE_TRAINING_DATA Process trials.
%   Detailed explanation goes here

trainingData = cell(bmm.k,1);
points = cell(bmm.k,1);

for i=1:4
    for j=1:length(predicates{i})
        labels = BernoulliAssign(bmm,predicates{i}{j}');
        for k=1:bmm.k
            if dxdy
                dx = trials{i}{j}.movement(:,labels==k) .* cos(trials{i}{j}.w(:,labels==k));
                dy = trials{i}{j}.movement(:,labels==k) .* sin(trials{i}{j}.w(:,labels==k));

                tmp = [
                    dx; dy; ...
                    features{i}{j}(:,labels==k); ...
                    ];
            else
                tmp = [
                    trials{i}{j}.movement(:,labels==k); ...
                    trials{i}{j}.rotation(:,labels==k); ...
                    features{i}{j}(:,labels==k); ...
                    ];
            end
            
            pts_tmp = [trials{i}{j}.x(:,labels==k); ...
                trials{i}{j}.y(:,labels==k); ...
                trials{i}{j}.w(:,labels==k); ...
                ];
            
            trainingData{k} = [trainingData{k} tmp];
            points{k} = [points{k} pts_tmp];
        end
    end
end

end

