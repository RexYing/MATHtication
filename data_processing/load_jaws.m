%% Load jaws in ply format
% load_jaws.m
%
% Load the raw mesh data of jaws in ply format
%
% The script reads from 2 ply files to give:
%
% verts_lower, faces_lower: vertices and faces list of lower jaw mesh
%
% verts_upper, faces_upper: vertices and faces list of upper jaw mesh
%

clear all
close all

data_folder = '../data/';

clf;
name = 'lower_cropped-downsampled.ply';
options.name = name;
[verts_lower, faces_lower]=read_mesh(name);
options.face_vertex_color = repmat([0.5, 0.5, 0.5], size(verts_lower, 1), 1);
shading interp;
plot_mesh(verts_lower, faces_lower, options);

name = 'upper_cropped-downsampled.ply';
options.name = name;
[verts_upper,faces_upper]=read_mesh(name);
options.face_vertex_color = repmat([0.5, 0.5, 0.5], size(verts_upper,1), 1);
plot_mesh(verts_upper, faces_upper, options);

% name = strcat('upper_cropped-molars.ply');
% options.name = name;
% [verts_upper, faces_upper]=read_mesh(name);
% options.face_vertex_color = repmat([0.5, 0.5, 0.5], size(verts_upper, 1), 1);
% plot_mesh(verts_upper, faces_upper, options);

% -------------------------------
% Date : May 10, 2013
% Rex Ying
% Duke University
% Revision :
% ------------------------------
