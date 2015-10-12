function [ vector ] = model_denormalize( vector, indices, model)
%MODEL_DENORMALIZE Use learned model struct to adjust data
%   Indices denote which parts of the mean/std dev to use

vector = vector + model.mean(indices);


vector2 = vector .* model.stdev(indices);
vector(~isnan(vector2)) = vector2(~isnan(vector2));

end
