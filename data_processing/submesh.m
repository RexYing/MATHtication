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
% Gabriel Peyre 2007
%
% Modified by Rex Ying
% It is now able to accept file as a path name containing multiple '.'
% File extension is determined by examining the string after the last '.'
%

AdjMat = mesh2sparse(faces);
[S, C] = graphconncomp(AdjMat);

