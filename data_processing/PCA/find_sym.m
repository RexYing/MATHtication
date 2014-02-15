function [ axes, dists, weights ] = find_sym( verts, faces, vertsType, facesType, jawType )
%FIND_SYM_DIST Summary of this function goes here
%   Detailed explanation goes here

orig_verts = verts;

vertAreas = mesh_weights(verts, faces);
weights = vertAreas;
weights(vertsType ~= 0, :) = 0;
meanpt = ((weights ~= 0)' * verts) / sum((weights ~= 0));
%meanpt = (weights' * verts) / sum(weights);

verts = verts - repmat(meanpt, length(verts), 1);
axes = identify_axes(verts, find_axes(verts(weights ~= 0, :)) );
%axes = identify_axes(verts, find_axes(verts, weights));
axes = find_orientation(verts, axes, vertsType);
N = axes(:, 2) / norm(axes(:, 2));
reflMat = eye(3) - 2*(N)*(N');

%% projection to vertical axis

    function [largestNElements, largestNIdx] = get_n_largest_elem(A, n)
        [ASorted, AIdx] = sort(A, 'descend');
        largestNElements = ASorted(1:n);
        largestNIdx = AIdx(1:n);
    end

thresh_ratio = 0.1;
vertsDiffToleranceRatio = 0.01;
num = sum(weights ~= 0);
% to recover from a bad crop
prev = Inf;
% in case it didn't get assigned, ie. return on first iteration
dists = 0;
for i = 1: 20
    disp(i);
    vals = verts * axes(:, 2);
    if abs(sum(vals > 0) - sum(vals < 0)) < length(orig_verts) * vertsDiffToleranceRatio
        disp('Satisfy symmetry requirements');
        break;
    else
        disp(abs(sum(vals > 0) - sum(vals < 0)) / length(orig_verts));
    end
    if prev < abs(sum(vals > 0) - sum(vals < 0))
        disp('Cannot crop in vertical direction at the back of the teeth any more.');
        weights = prevWeights;
        break;
    end
    prev = abs(sum(vals > 0) - sum(vals < 0));
    
    vAxis = axes(:, 3);
    if strcmp(jawType, 'lower')
        vAxis = -vAxis;
    end
    vals = verts * vAxis;
    %hist(vals, 100);
    
    wInds = find(weights ~= 0);
    thresh = floor(thresh_ratio * num);
    num = num - thresh;
    [dists, inds] = get_n_largest_elem(vals(weights ~= 0), thresh);
    prevWeights = weights;
    weights(wInds(inds)) = 0;

    meanpt = ((weights ~= 0)' * orig_verts) / sum((weights ~= 0));
    %meanpt = (weights' * orig_verts) / sum(weights);

    verts = orig_verts - repmat(meanpt, length(verts), 1);
    axes = identify_axes(verts, find_axes(verts(weights ~= 0, :)));
    %axes = identify_axes(verts, find_axes(verts, weights));
    axes = find_orientation(verts, axes, vertsType);

    if i == 20
        disp('Exceed max number of iteration'); 
    end
end
end

