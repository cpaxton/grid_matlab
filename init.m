clear all;

%% add paths
startup

%% load data
load('data/2015_09_09.mat');

%% set up other variables and settings         
gmmColors = [1.0 0.0 0.0 1.0 0.0 1.0;
             0.0 1.0 0.0 0.0 1.0 1.0;
             0.0 0.0 1.0 1.0 1.0 0.0];
colors = 'rgbmcy';
markers = '......';
primitive_names = {'Approach','Pass-Through','Connect','Pass-Through-To-Exit','Exit'};
APPROACH = 1;
PASS = 2;
CONNECT = 3;
PASS_EXIT = 4;
EXIT = 5;
IN_EXIT = 6;

%% show current
if ~HOLD_OUT
    show_original_bmm;
end
