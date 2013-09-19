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

[axes,score,latent,tsquared] = pca(vertices);
cumPercentVar = cumsum(latent) / sum(latent);
fprintf('Two of the dimensions account for %3.1f%% of the variance.\n', ...
    cumPercentVar(2));


end

