function [ verts_type ] = left_right_condiles( verts, faces, axes, verts_type )
%
% given the condile indices, separate them into 2 groups, each of which
% represents a condile.
% For find_condiles

% Here assume the centroid of verts is at the origin
verts = verts - repmat(mean_pt(verts), length(verts), 1);

vals = zeros(length(verts), 1);
% project onto the lateral axis to differentiate two condiles
for i = 1: length(verts)
    vals(i) = verts(i, :) * axes(:, 1);
end
[vals, inds] = sort(vals);
% vals(ind + 1) - vals(ind) is the maximum
[~, ind] = max(vals(2: end) - vals(1: end - 1));


end

