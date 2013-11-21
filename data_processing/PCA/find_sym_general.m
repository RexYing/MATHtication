function [ axes, dists, weights ] = find_sym_general( verts, faces, vertsType, facesType )
%FIND_SYM Find symmetry plane of the given mesh
%   plane: 2 3D vectors that defines a plane (2 principle components)
% Assume that the mesh has already been cleaned (no vertices that have no 
% faces that contain it)
%
% Return axes: still first column post-anterior and last column vertical.
%

% Scale factor
scaleFactorRatio = 1.4826;

% init weights: vertex area
%[meanpt] = mean_pt(verts, faces, 'unweighted');
vertAreas = mesh_weights(verts, faces);
vertAreas = vertAreas(:) / 3;
% set weights for vertices with vertsType != 0 to 0 (do not consider
% condiles)
weights = vertAreas;
weights(vertsType ~= 0, :) = 0;
meanpt = (weights' * verts) / sum(weights);

% symmetry plane is estimated by 
% axes(:, 1): the post-anterior axis of the jaw, and
% axes(:, 3): the vertical axis of the jaw
verts = verts - repmat(meanpt, length(verts), 1);
%axes = identify_axes(verts, find_axes(verts(weights ~= 0, :), weights(weights ~= 0)));
axes = identify_axes(verts, find_axes(verts(weights ~= 0, :)));

% reflection transformation matrix A = I - 2N*N'
N = axes(:, 2) / norm(axes(:, 2));
reflMat = eye(3) - 2*(N)*(N');

%% init
disp('first iteration');
centroids = zeros(length(faces), 3);
for i = 1: length(faces)
    centroids(i, :) = (verts(faces(i, 1), :) + verts(faces(i, 2), :) + ...
        verts(faces(i, 3), :)) / 3;
end
% statistics toolbox
kdtree = KDTreeSearcher(centroids, 'distance', 'euclidean');
%reflPoints = zeros(length(verts), 3);
reflPoints = zeros(length(verts), 3);
dists = zeros(length(verts), 1);
for i = 1: length(reflPoints)
    reflPoints(i, :) = (reflMat * verts(i, :)')';
end
inds = knnsearch(kdtree, reflPoints);


%% crop out asymmetric
%
    function d = calc_dist(x)
        if weights(x) == 0
            d = -1;
            return;
        end
        p1 = verts(faces(inds(x), 1), :);
        p2 = verts(faces(inds(x), 2), :);
        p3 = verts(faces(inds(x), 3), :);
        v1 = p2 - p1;
        v2 = p3 - p1;
        d = abs(distancePointPlane(reflPoints(x, :), [p1 v1 v2]));
    end
calcDist = @calc_dist;

for iter = 1: 1
    % shortest distance from mesh to reflected points
    dists = arrayfun(calcDist, 1: length(inds));
    scaleFactor = scaleFactorRatio * median(dists) * 3;
    scaleFactor
    hist(dists(dists > 0), 100)
    for i = 1: length(faces)
        if dists(faces(i, 1)) > scaleFactor || dists(faces(i, 2)) > scaleFactor || ...
                dists(faces(i, 3)) > scaleFactor
            for j = 1: 3
                weights(faces(i, j)) = 0;
            end
        end
    end
    fprintf('#iter: 2\n');
    axes = identify_axes(verts, find_axes(verts(weights ~= 0, :)));
end


end

