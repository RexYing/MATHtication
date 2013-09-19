%% read_mesh - read data from OFF, PLY, SMF or WRL file.
function [ axes ] = find_axes( vertices )
%%
%
% * SYNTAX
%
%   [ axes ] = find_axes(vertices);
%
% * INPUT
%
% vertices    [3-by-N] matrix representing all the points
%
% * OUTPUT
%
% axes        [3-by-3] matrix, each column is an axis
%
% * DESCRIPTION
%
% Principle component analysis
% Find axes of best fit ellipsoid using SVD
%
% * DEPENDENCIES
%
% NONE
%
% * REFERENCES
%
% * AUTHOR
%
% Rex Ying
%

[coeff,score,latent,tsquared] = pca(___)



end

