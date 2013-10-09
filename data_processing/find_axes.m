%% read_mesh - read data from OFF, PLY, SMF or WRL file.
function [ axes ] = find_axes( vertices, faces )
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
sampleSize = 5000;
indSample = perform_farthest_point_sampling_mesh(vertices, faces, [], sampleSize);
vSample = vertices(indSample, :);

C = cov(vSample);
[axes, D] = eig(C);
latent = diag(D);
% reverse order: from most significant component to the least significant
latent = latent(end: -1: 1);
axes = axes(:, end: -1: 1);
cumPercentVar = cumsum(latent) / sum(latent);
fprintf('Two of the dimensions account for %3.1f%% of the variance.\n', ...
     cumPercentVar(2) * 100);

 
 
end

