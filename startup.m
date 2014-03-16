% startup.m
%
% script
% to set up path structure within this directory
%
clear all;
close all;

% function handle for adding a directory and its subdirectory
addsubdir = @(dir) addpath(genpath(dir));

%add utility routines
addsubdir('lib');

% add code
addsubdir('data_processing')
addpath javacode
addpath javacode/lib

% add data
addpath data

% add java path
% jar file should be compiled with jre in Matlabroot/sys/java/jre and make
% sure there is no version incompatibility
% classes should be public
javaaddpath javacode.jar
javaaddpath javacode/lib/ejml-0.23.jar

clearvars addsubdir

% -------------------------------
% Date : April 15, 2013
% Rex Ying
% Duke University
% Revision : May 11, 2013
% ------------------------------