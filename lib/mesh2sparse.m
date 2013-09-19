%% mesh2sparse - use the triangular mesh face information to form a sparse matrix representing the connectivity
function [AdjMat] = mesh2sparse(faces)

%%
%
% * SYNTAX
%
%   [AdjMat] = mesh2sparse(faces);
%
% * INPUT
%
% faces    faces of the triangular mesh
%
% * OUTPUT
%
% The sparse adjacency matrix representing the connectivity of the mesh
% vertices.
%
% * DESCRIPTION
%
% Each face is represented by the indices of the vertices that form the
% face. So the vertices that forms the triangular face are connected.
%
% The weight of each edge is 0
%
% * DEPENDENCIES
%
% geom3d/meshes3d/computeMeshEdges.m
%
% * REFERENCES
%
% * AUTHOR
%
% Rex Ying
%

edges = computeMeshEdges(faces);
nVerts = max(max(faces) );
weights = ones(size(edges, 1), 1);
i = edges(:, 1);
j = edges(:, 2);
AdjMat = sparse(i, j, weights, nVerts, nVerts);
% symmetric
AdjMat = AdjMat + AdjMat';

