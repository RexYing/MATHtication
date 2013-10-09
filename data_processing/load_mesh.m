function [ verts, faces ] = load_mesh( filename )
%%
%
% * SYNTAX
%
%   [ vertices, faces ] = load_mesh(filename);
%
% * INPUT
%
% filename    name of the file containing the mesh in ply format
%
% * OUTPUT
%
% vertices    [N-by-3] matrix representing vertices
% faces       [N-by-3] matrix representing faces
%
% * DESCRIPTION
%
% load mesh with "standard options" ie. black-white, smooth.
% The script reads from ply files to give vertices and faces for the mesh
% and visualize them.
%
% * DEPENDENCIES
%
% toolbox_graph by Gabriel Peyr?
%
% * REFERENCES
%
% * AUTHOR
%
% Rex Ying
%

%name = 'lower_cropped-downsampled.ply';
options.name = filename;
[verts, faces]=read_mesh(filename);
options.face_vertex_color = repmat([0.5, 0.5, 0.5], size(verts, 1), 1);
shading interp;
%plot_mesh(verts, faces, options);


% -------------------------------
% Date : May 10, 2013
% Rex Ying
% Duke University
% Revision :
% ------------------------------
