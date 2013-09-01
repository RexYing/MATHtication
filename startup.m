% startup.m
%
% script
% to set up path structure within this directory
%

% add directory and its subdirectory
addsubdir = @(dir) addpath(genpath(dir));

%add utility routines
addsubdir('lib');

% add code
addsubdir('data_processing')

% add data
addpath data

% -------------------------------
% Date : April 15, 2013
% Rex Ying
% Duke University
% Revision : May 11, 2013
% ------------------------------
