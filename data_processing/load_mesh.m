function [ verts, faces, weights ] = load_mesh( filename )
%%
%
% * SYNTAX
%
%   [ vertices, faces ] = load_mesh(filename);
%   [ vertices, faces, weights ] = load_mesh(filename);
%
% * INPUT
%
% filename    name of the file containing the mesh in ply format
%
% * OUTPUT
%
% vertices    [N-by-3] matrix representing vertices
% faces       [N-by-3] matrix representing faces
% weights     [N] vector representing weights of each vertex (optional)
%
% * DESCRIPTION
%
% load mesh with "standard options" ie. black-white, smooth.
% The script reads from ply files to give vertices and faces for the mesh
% and visualize them.
%
% * DEPENDENCIES
%
% clean_mesh.m
% toolbox_graph by Gabriel Peyr?
%
% * REFERENCES
%
% * AUTHOR
%
% Rex Ying
%

options.name = filename;
[verts, faces]=read_mesh(filename);
options.face_vertex_color = repmat([0.5, 0.5, 0.5], size(verts, 1), 1);
plot_mesh(verts, faces, options);
shading interp;
if nargout == 3
    % find weights
    weights = zeros(1);
end

% -------------------------------
% Date : May 10, 2013
% Rex Ying
% Duke University
% ------------------------------
