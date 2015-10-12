
tmeans = zeros(bmm.k,1);
vmeans = zeros(bmm.k,1);
tdev = zeros(bmm.k,1);
vdev = zeros(bmm.k,1);

for k=1:bmm.k
    
    trainingData = [ap{k}.t;ap{k}.trainingData];
    if models{k}.use_gate
        trainingData = [trainingData;ap{k}.gate_features];
    end
    if models{k}.use_prev_gate
        trainingData = [trainingData;ap{k}.prev_gate_features];
    end
    if models{k}.use_exit
        trainingData = [trainingData;ap{k}.exit_features];
    end
    
    testData = [apt{k}.t;apt{k}.trainingData];
    if models{k}.use_gate
        testData = [testData;apt{k}.gate_features];
    end
    if models{k}.use_prev_gate
        testData = [testData;apt{k}.prev_gate_features];
    end
    if models{k}.use_exit
        testData = [testData;apt{k}.exit_features];
    end
    
    
    test_ll = compute_loglik(testData(models{k}.in,:),models{k}.Mu,models{k}.Sigma,models{k},models{k}.in);
    train_ll = compute_loglik(trainingData(models{k}.in,:),models{k}.Mu,models{k}.Sigma,models{k},models{k}.in);
    figure();hold on;
    scatter(testData(1,:),test_ll);
    scatter(trainingData(1,:),train_ll);
    
    fprintf('k=%d,test=%f,train=%f\n',k,mean(test_ll),mean(train_ll));
    tmeans(k) = mean(train_ll);
    vmeans(k) = mean(test_ll);
    tdev(k) = std(train_ll);
    vdev(k) = std(test_ll);
end
figure();
tmeans = -1*tmeans;
vmeans = -1*vmeans;
barwitherr([tdev vdev],[tmeans vmeans]);
xlabel('Cluster');
ylabel('-log likelihood');
legend('Training','Validation');
title('Comparison of Demonstrated Action Primitives');