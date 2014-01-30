function [ axes ] = identify_axes( verts, axes )
%IDENTIFY_AXES identify 3 axis and sort in order: post-ant; lateral;
%vertical
%  
% executed before finding condiles
%
% Column vectors of axes are the axes (normalize to unit vectors first)
%

% Normalize
for i = 1: 3
    axes(:, i) = axes(:, i) / norm(axes(:, i));
end

% make the centroid of verts to be the origin in the new coords system
% the centroid includes condiles (only a raw approximation is needed for
% the following computation.
verts = verts - repmat(mean_pt(verts), length(verts), 1);

% 3rd axes must be vertical from raw pca (least variance)
% Identify post-ant axis and lateral axis:
% Find points with smaller absoluate value of projection to an axis, 
% 1 cluster implies that the axis is lateral; 
% if there are 2 clusters, then the axis is post-anterior

    function centroids = cluster_test(axis)
        % axis should be column vector
        vals = verts * axis; % projection
        
        maxVal = max(abs(vals)); % max value of projection onto one axes

        % Find points with smaller distance to axis (1/20 of max dot product value)
        threshold = maxVal / 20;
        closeVerts = verts(abs(vals) < threshold, :);
        [~, centroids] = kmeans(closeVerts, 2);
    end

centroids = cluster_test(axes(:, 1));
dist1 = norm(centroids(1, :) - centroids(2, :));
centroids = cluster_test(axes(:, 2));
dist2 = norm(centroids(1, :) - centroids(2, :));

if (dist2 > dist1)
    disp('Change axes order: the first column is now the post-anterior axis');
    % axes(:, 1) is the lateral axis
    axes(:, [1, 2, 3]) = axes(:, [2, 1, 3]);
end
end

