% dpgmm_testing
data = [];
for i = 1:length(atraj)
    data = [data; atraj{i}(1:3,:)'];
end

% fit dpmm
a = dpmm(data,5);

%% plot
figure(1); hold on;
N = size(data,2);
nc = max(a(end).classes);
for i = 1:nc
    subset = data(a(end).classes==i,:);
    mu = mean( subset )';
    sigma = cov ( subset )';
    plotGMM(mu(1:2),sigma(1:2,1:2),rand(3,1)',1,0.5);
end
plot(data(:,1),data(:,2),'.');

%% second version
data = [trials{2}{1}.x;trials{2}{1}.y;trials{2}{1}.w]';
a = dpmm(data,100);
%% plot second version
figure(2); hold on;
draw_environment(envs{2});
N = size(data,2);
nc = max(a(end).classes);
for i = 1:nc
    subset = data(a(end).classes==i,:);
    mu = mean( subset )';
    sigma = cov ( subset )';
    plotGMM(mu(1:2),sigma(1:2,1:2),rand(3,1)',1,0.5);
end
plot(data(:,1),data(:,2),'.');

