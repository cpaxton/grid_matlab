function data = apply_preprocessor(data, preprocessor)
%APPLY_PREPROCESSOR Take a preprocessor struct and use it on data
%   Requires a preprocessor struct creatd by apply_pca_to_data
nExamples = size(data,2);
data = data - repmat(preprocessor.mean',1,nExamples);
data = data ./ repmat(preprocessor.stdev',1,nExamples);
if preprocessor.use_pca
    data = (data' * preprocessor.coef)';
end
end
