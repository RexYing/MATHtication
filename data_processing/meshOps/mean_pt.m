function [ meanPoint, weights ] = mean_pt( verts, faces, option )
%MEAN_PT Summary of this function goes here
%   mean point. The current implementation is average of all points

if nargin < 3 || strcmp(option, 'unweighted')
    meanPoint = [0 0 0];
    for i = 1: 3
        meanPoint(i) = mean(verts(:, i));
    end
elseif strcmp(option, 'weighted')
    weights = mesh_weights(verts, faces);
    meanPoint = (weights' * verts) / sum(weights);
end

end

