set(0,'DefaultFigureWindowStyle','docked')

format compact
format short e

addpath('./bernoulli');
addpath('./data');

%% Early environment and feature definitions
addpath('./environment');
addpath('./features');

%% Utility code
% Visualization, data creation scripts, etc.
addpath('./utils');
addpath('./utils/sampling');
addpath('./utils/environment');
addpath('./utils/tightfig');
addpath('./utils/make_fig');

%% Draw different things
addpath('./draw');

%% Contains MCTS-related tools
addpath('./mcts');
addpath('./mcts/metrics');
addpath('./mcts/mcts_utils');
addpath('./mcts/pw');
addpath('./mcts/simulation');
addpath('./mcts/configs');

%% Motion and Trajectory Optimization
addpath('./motion');
addpath('./motion/samplers');
addpath('./motion/helpers');
addpath('./motion/goal');
addpath('./motion/naive');
addpath('./motion/tree');

%% GMM/GMR Specific Tools
addpath('./gmmgmr');

addpath('./tests');
addpath('./tests/dev');
addpath('./tests/conference');

%% Task Modeling and Specification
addpath('./segmentation');
addpath('./task');

%% External Dependencies
addpath('./EXTERNAL');
addpath('./EXTERNAL/dynamic_time_warping_v2.1');
addpath('./EXTERNAL/GMM-GMR-v2.0');
addpath('./EXTERNAL/barwitherr');
addpath('./EXTERNAL/subaxis');
addpath('./EXTERNAL/gpml-matlab-v4.0-2016-10-19/');

% Call GPML Startup Code
gpml_startup;
