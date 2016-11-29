set(0,'DefaultFigureWindowStyle','docked')

format compact
format short e

addpath([pwd '/bernoulli']);
addpath([pwd '/data']);

%% Early environment and feature definitions
addpath([pwd '/environment']);
addpath([pwd '/features']);

%% Utility code
% Visualization, data creation scripts, etc.
addpath([pwd '/utils']);
addpath([pwd '/utils/sampling']);
addpath([pwd '/utils/environment']);
addpath([pwd '/utils/tightfig']);
addpath([pwd '/utils/make_fig']);

%% Draw different things
addpath([pwd '/draw']);

%% Contains MCTS-related tools
addpath([pwd '/mcts']);
addpath([pwd '/mcts/metrics']);
addpath([pwd '/mcts/mcts_utils']);
addpath([pwd '/mcts/pw']);
addpath([pwd '/mcts/simulation']);
addpath([pwd '/mcts/configs']);
addpath([pwd '/mcts/optimization']);

%% Motion and Trajectory Optimization
addpath([pwd '/motion']);
addpath([pwd '/motion/samplers']);
addpath([pwd '/motion/helpers']);
addpath([pwd '/motion/goal']);
addpath([pwd '/motion/naive']);
addpath([pwd '/motion/tree']);

%% GMM/GMR Specific Tools
addpath([pwd '/gmmgmr']);

addpath([pwd '/tests']);
addpath([pwd '/tests/dev']);
addpath([pwd '/tests/conference']);

%% Task Modeling and Specification
addpath([pwd '/segmentation']);
addpath([pwd '/task']);

%% External Dependencies
addpath([pwd '/EXTERNAL']);
addpath([pwd '/EXTERNAL/dynamic_time_warping_v2.1']);
addpath([pwd './EXTERNAL/GMM-GMR-v2.0']);
addpath([pwd '/EXTERNAL/barwitherr']);
addpath([pwd '/EXTERNAL/subaxis']);
addpath([pwd '/EXTERNAL/gpml-matlab-v4.0-2016-10-19/']);

% Call GPML Startup Code
gpml_startup;
