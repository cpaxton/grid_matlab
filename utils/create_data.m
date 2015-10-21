%% configuration
plot_data = false;
plot_data = true;
gmmColors = [1.0 0.0 0.0 1.0 0.0 1.0;
             0.0 1.0 0.0 0.0 1.0 1.0;
             0.0 0.0 1.0 1.0 1.0 0.0];
colors = 'rgbmcy';
markers = '......';
primitive_names = {'Approach','Pass-Through','Connect','Exit'};

%% how I created the list of trials
% trial_directory_info_v3 = dir('needle_master_trials_v3/trial_*');
% trial_directory_info_v4 = dir('needle_master_trials_v4/trial_*');

%% load things

envs = {load_environment('./trials/environment_0.txt'),...
    load_environment('./trials/environment_1.txt'),...
    load_environment('./trials/environment_2.txt'),...
	load_environment('./trials/environment_3.txt'),...
	load_environment('./trials/environment_4.txt'),...
	load_environment('./trials/environment_5.txt'),...
    load_environment('./trials/environment_6.txt'),...
    load_environment('./trials/environment_7.txt'),...
    load_environment('./trials/environment_8.txt'),...
    load_environment('./trials/environment_9.txt'),...
    load_environment('./trials/environment_10.txt'),...
    load_environment('./trials/environment_11.txt'),...
    load_environment('./trials/environment_12.txt'),...
    };
    %load_environment('./trials/environment_13.txt')};

%% placeholder because partner gates aren't set up right yet
envs{11}.gates = {{envs{11}.gates{1}{1},envs{11}.gates{2}{1}}};

%% get training data
fprintf('Loading training data...\n');
[trials, predicates] = load_dataset(envs,'./trials/',14);

%% apply corrections based on training data
% this portion of the code assumes users are passing through the gates from
% "left" to "right" all of the time
% the issue is that gates arent' really given in a unified coordinate
% frame
% for i = 1:length(envs)
%    w = trials{i}{1}.w;
%    [gate,opt] = in_gates(trials{i}{1}.x,trials{i}{1}.y,envs{i}.gates);
%    for j = 1:length(gate)
%        if gate(j) > 0
%            
%        end
%    end
% end

%% hack to fix levels 9/12 to be in line with gate orientation
% used in training the rest of the examples

envs{9}.gates{1}{1} = rotate_gate(envs{9}.gates{1}{1}.x, ...
    envs{9}.gates{1}{1}.y, ...
    -pi, ...
    envs{9}.gates{1}{1});


envs{12}.gates{1}{1} = rotate_gate(envs{12}.gates{1}{1}.x, ...
    envs{12}.gates{1}{1}.y, ...
    -pi, ...
    envs{12}.gates{1}{1});

%% plot data showing levels and trials

if plot_data
    figure(1); clf;
    for sub=1:12
        subplot(4,3,sub);
        draw_environment(envs{sub});
        for i=1:length(trials{sub})
           draw_trial(trials{sub}{i}); 
        end
    end
end
