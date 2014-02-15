function [ meshModel ] = build_mesh_model( verts, faces )
%BUILD_MESH_MODEL Build a model of mesh for collision detection
% 
%
% Rex

numFaces = size(faces, 1);
% number of bounding volumn objects initialized so far
numBvs = 0;
% calculate centroids
centroids = zeros(numFaces, 3);
for i = 1: numFaces
    centroids(i, :) = mean(verts(faces(i, :), :));
end

% Initialize bounding volumns
% an array of BoundingVolumn objects
for iBv = (2 * numFaces - 1): -1: 1
    bvs(iBv) = OBB;
end
% Ready to build model
build_model();
% write results into struct
meshModel = struct('bvs', bvs);



% Build the tree model for a mesh once. There is no need to do this
% again afterwards, even if it gets rotated and translated.
function build_model()
    % 2: the index of the first child of the first bounding volumn
    numBvs = 2;
    % building tree of bounding volumns recursively
    success = buildRecurse(1, 1: numFaces);
    if (~success)
        disp('Failed when building MeshModel recursively');
        return;
    end

    % change BV orientations from world-relative to parent-relative
    makeParentRelative(1, eye(3), [0; 0; 0]);
end

% Fits m->child(bn) to the num_tris triangles starting at first_tri
% Then, if num_tris is greater than one, partitions the tris into two
% sets, and recursively builds two children of m->child(bn)
%
% faceInds: 1-by-N, denoting indices of faces that are in a bv
% The vertex indices for first triangle are faces(faceInds(1), :)
function isBuilt = buildRecurse(bvInd, faceInds)
    bv = bvs(bvInd);
    if (mod(bvInd, 1000) == 0)
        disp(bvInd);
    end
    face = faces(faceInds, :);
    bvVerts = verts(face, :);
    % axes/rotation matrix in decreasing order
    C = cov(bvVerts);
    [axes, D] = eig(C);
    [~, ind] = max(diag(D));
    % the axis that has the most variance
    splittingAxis = axes(:, ind);

    bv.fitToTris(axes, bvVerts);
    if (length(faceInds) == 1)
        % base case:
        % a leaf bv: index a triangle/face distinguished by a negative 
        % sign, instead of bv index
        bv.firstChild = -faceInds(1);
    else
        % index a bounding volumn
        bv.firstChild = numBvs;
        numBvs = numBvs + 2;

        meanpt = mean_pt(bvVerts)';
        % project centroid onto the splitting axis
        coord = dot(meanpt, splittingAxis);
        [numFirstHalf, faceInds] = split_tris(faceInds, splittingAxis, coord);

        % recursion - 2 children bvs
        buildRecurse(bvs(bvInd).firstChild, ...
            faceInds(1: numFirstHalf - 1) );
        buildRecurse(bvs(bvInd).firstChild + 1, ...
            faceInds(numFirstHalf: end) );
    end
    isBuilt = true;
end

% Given a list of triangles, a splitting axis, and a coordinate (centroid) on
% that axis, partition the triangles into two groups according to
% where their centroids fall on the axis (under axial projection).
% Returns the number of tris in the first half
%
% splittingAxis: 3-by-1 column vector
%
% faceInds is modified in the process: some are swapped depending
% on whether they are supposed to be in the first sub-bv or second
% sub-bv.
function [numFirstHalf, faceInds] = split_tris(faceInds, splittingAxis, coord)
    % index of faceInds at which group 2 ends (EXCLUSIVE)
    % will be returned in the end as numFirstHalf
    group1End = 1;
    % group2End: index of faceInds at which group 2 ends 
    % group2End is exclusive at the beginning of each loop but 
    % inclusive at the end of each loop
    projs = centroids(faceInds, :) * splittingAxis;
    for group2End = 1: length(faceInds)
        proj = projs(group2End);

        if (proj <= coord)
            % supposed to be in group 1. swap with first half
            faceInds([group1End, group2End]) = faceInds([group2End, group1End]);
            group1End = group1End + 1;
        end
    end
    % split arbitrarily if one of the groups is empty
    if (group1End == 1) || (group1End == length(faceInds) + 1)
        group1End = round(length(faceInds) / 2) + 1; % +1: exclusive
    end
    numFirstHalf = group1End;
end

% Descends the hierarchy, converting world-relative transforms to 
% parent-relative transforms
%
% Before making this call, the tree hierarchy of bounding volumns 
% should have already been built.
%
% R: parent rotation matrix
% T: parent translation column vector
function makeParentRelative(bvInd, R, T)

end


end

