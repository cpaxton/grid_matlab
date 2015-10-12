function [ trials ] = fix_downsampled_movement( trials )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


for i = 1:length(trials)
    for j = 1:length(trials{i})
        for k = 1:length(trials{i}{j}.t)-1
            x = trials{i}{j}.x(k+1) - trials{i}{j}.x(k); 
            y = trials{i}{j}.y(k+1) - trials{i}{j}.y(k); 
            
            trials{i}{j}.movement(k) = norm([x;y]);
            trials{i}{j}.rotation(k) = atan2(y,x);
        end
    end
end

end
