function [ axes ] = find_orientation( verts, axes, vertsType )
%
% Axes in the order of post-anterior; lateral; vertical
% the result will be 3 vectors each of which is the same or the opposite of
% the corresponding axes
% 
% The vertical axis' direction is pointing upwards for lower jaw, and
% downwards for upper jaw (For primates specifically, condiles have bigger
% vertical coordinate values than 
%

% just raw axis for this test
verts = verts - repmat(mean_pt(verts), length(verts), 1);

% Find the direction of posterior-anterior axis
% find the group of vertices that have the most negative projection onto the
% axis, and the group that have the most positive
% for each group, cluster them into 2 parts. The group with smaller
% distance between centroids of its 2 parts should point towards positive
% direction.
%
vals = verts * axes(:, 1);
maxVal = max(vals); % max value of projection onto one axes
minVal = min(vals);
% this might not be robust enough under extreme circumstances where raw axis is
% very tilted
upperThresh = maxVal * 0.90;
lowerThresh = minVal * 0.90;
group1Verts = verts(vals > upperThresh, :);
group2Verts = verts(vals < lowerThresh, :);
[~, centroids1] = kmeans(group1Verts, 2);
dist1 = norm(centroids1(1, :) - centroids1(2, :));
[~, centroids2] = kmeans(group2Verts, 2);
dist2 = norm(centroids2(1, :) - centroids2(2, :));

if dist1 > dist2
    % change direction of post-ant
    disp('Change the orientation of the posterior-anterior axis');
    axes(:, 1) = -axes(:, 1);
end

% Determine direction of vertical axis according to the jaw's relative 
% position to the condiles

meanJaw = mean_pt(verts(vertsType == 0, :));
meanCondile = mean_pt(verts(vertsType ~= 0, :));
proj = dot(meanCondile - meanJaw, axes(:, 3));
if (proj < 0)
    disp('Change the orientation of vertical axis');
    axes(:, 3) = -axes(:, 3);
end

% Lateral axis is determined by the right-hand rule, after the post-ant and
% vertical axes' directions are know.
axes(:, 2) = cross(axes(:, 1), axes(:, 3));
    
end

