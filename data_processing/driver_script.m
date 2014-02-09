%% Driver script
% load_jaws (either original or after removing far-away vertices)
%
% Find axes
%

clear all
close all

data_folder = '../data/';

%% load_jaws
% The script reads from 2 ply files to give:
%
% verts_lower, faces_lower: vertices and faces list of lower jaw mesh
%
% verts_upper, faces_upper: vertices and faces list of upper jaw mesh

% Original
[verts_lower, faces_lower] = load_mesh('lower_cropped-downsampled.ply');
hold on;
[verts_upper, faces_upper] = load_mesh('upper_cropped-downsampled.ply');

% [verts_lower, faces_lower] = load_mesh('LokiSaimiriLower1.ply');
% hold on;
% [verts_upper, faces_upper] = load_mesh('LokiSaimiriUpper1.ply');
% 
% [verts_lower, faces_lower] = load_mesh('PapiomaleLower.ply');
% hold on;
% [verts_upper, faces_upper] = load_mesh('PapiomaleUpper.ply');


% after removing far-away vertices
%load_mesh('lower_cropped-downsampled.ply');
%load_mesh('upper_cropped-downsampled.ply');

