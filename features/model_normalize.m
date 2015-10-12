function [ vector ] = model_normalize( vector, indices, model)
%MODEL_NORMALIZE Use learned model struct to adjust data
%   Indices denote which parts of the mean/std dev to use

vector = vector - model.mean(indices);

%vector2 = vector ./ model.stdev(indices);
%vector(~isnan(vector2)) = vector2(~isnan(vector2));

vector = vector ./ model.stdev(indices);
vector(isnan(vector)) = 0;

end

