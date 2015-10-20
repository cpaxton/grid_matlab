clear all;

%% add paths
startup

%% load data
load('data/current.mat');

%% set up other variables and settings         
gmmColors = [1.0 0.0 0.0 1.0 0.0 1.0;
             0.0 1.0 0.0 0.0 1.0 1.0;
             0.0 0.0 1.0 1.0 1.0 0.0];
colors = 'rgbmcy';
markers = '......';
primitive_names = {'Approach','Pass-Through','Connect','Exit'};
APPROACH = 4;
PASS = 2;
CONNECT = 3;
%PASS_EXIT = 4;
EXIT = 1;
AT_EXIT = 5;

%% show current
HOLD_OUT = false;
if ~HOLD_OUT
    show_original_bmm;
end
