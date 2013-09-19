%% submesh - find submeshes of a mesh. 
%
% Vertices of each submesh forms a connected component.
function [visited] = submesh(faces)

%%
%
% * SYNTAX
%
%   [submeshList] = submesh(faces);
%
% * INPUT
%
% faces    faces of mesh
%
% * OUTPUT
%
% 
%
% * DESCRIPTION
%
% identify different connected components of mesh
%
% * ACKNOWLEDGEMENT
%
% Gabriel Peyre
%
% * DEPENDENCIES
%
% mesh2sparse.m
%
% * REFERENCES
%
% * AUTHOR
%
% Rex Ying
%

AdjMat = mesh2sparse(faces);
[S, C] = graphconncomp(AdjMat);

