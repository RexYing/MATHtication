% startup.m
%
% script
% to set up path structure within this directory
%

% function handle for adding a directory and its subdirectory
addsubdir = @(dir) addpath(genpath(dir));

%add utility routines
addsubdir('lib');

% add code
addsubdir('data_processing')
addpath javacode

% add data
addpath data

% add java path
% jar file should be compiled with jre in Matlabroot/sys/java/jre and make
% sure there is no version incompatibility
% classes should be public
javaaddpath javacode.jar

clearvars addsubdir

% -------------------------------
% Date : April 15, 2013
% Rex Ying
% Duke University
% Revision : May 11, 2013
% ------------------------------