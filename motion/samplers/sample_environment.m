function pt = sample_environment(width, height,num)
pt = rand(3,num) .* repmat([width; height; 2*pi],1,num);
end