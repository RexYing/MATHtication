function [ axes, dists, weights ] = find_sym( verts, faces, vertsType, facesType )
%FIND_SYM_DIST Summary of this function goes here
%   Detailed explanation goes here

orig_verts = verts;

vertAreas = mesh_weights(verts, faces);
vertAreas = vertAreas(:) / 3;
weights = vertAreas;
weights(vertsType ~= 0, :) = 0;
meanpt = ((weights ~= 0)' * verts) / sum((weights ~= 0));

verts = verts - repmat(meanpt, length(verts), 1);
axes = identify_axes(verts, find_axes(verts(weights ~= 0, :)));
axes
N = axes(:, 2) / norm(axes(:, 2));
reflMat = eye(3) - 2*(N)*(N');

%% projection to vertical axis

    function [smallestNElements, smallestNIdx] = get_n_largest_elem(A, n)
        [ASorted, AIdx] = sort(A, 'descend');
        smallestNElements = ASorted(1:n);
        smallestNIdx = AIdx(1:n);
    end

num = sum(weights ~= 0);
for i = 1: 2
    vals = abs(verts * axes(:, 3));

    thresh_ratio = 0.002;

    wInds = find(weights ~= 0);
    thresh = floor(thresh_ratio * num);
    num = num - thresh;
    [dists, inds] = get_n_largest_elem(vals(weights ~= 0), thresh);
    weights(wInds(inds)) = 0;

    meanpt = ((weights ~= 0)' * orig_verts) / sum((weights ~= 0));

    verts = orig_verts - repmat(meanpt, length(verts), 1);
    axes = identify_axes(verts, find_axes(verts(weights ~= 0, :)));
    axes
end
end

