function [ axes, dists ] = find_sym( verts, faces, vertsTypes )
%FIND_SYM Find symmetry plane of the given mesh
%   plane: 2 3D vectors that defines a plane (2 principle components)
% Assume that the mesh has already been cleaned (no vertices that have no 
% faces that contain it)
%
% Return axes: still first column post-anterior and last column vertical.
%

scaleFactor = 0.2;

[meanpt, weights] = mean_pt(verts, faces, 'weighted');
% set weights for vertices with vertsType != 0 to 0 (do not consider
% condiles)
weights(vertsTypes ~= 0, :) = 0;
% symmetry plane is estimated by 
% axes(:, 1): the post-anterior axis of the jaw, and
% axes(:, 3): the vertical axis of the jaw
verts = verts - repmat(meanpt, length(verts), 1);
axes = identify_axes(verts, find_axes(verts));

% reflection transformation matrix A = I - 2N*N'
N = axes(:, 2) / norm(axes(:, 2));
reflMat = eye(3) - 2*(N)*(N');

%% init
supportRegion = ones(length(faces), 1);
% statistics toolbox
kdtree = KDTreeSearcher(verts, 'distance', 'euclidean');
reflPoints = zeros(length(verts), 3);
dists = zeros(length(verts), 1);
for i = 1: length(dists)
    reflPoints(i, :) = (reflMat * verts(i, :)')';
end
inds = knnsearch(kdtree, reflPoints);

dists = arrayfun(@(x) norm(verts(inds(x), :) - reflPoints(x, :)), 1: length(verts));

end

