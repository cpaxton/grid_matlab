net = fitnet([10 10]);
[net, tr] = train(net, training_data{4}.features, training_data{4}.controls);