function [ verts_type, faces_type ] = find_condiles( verts, faces, axes )
% 
% given verts and axes in order (post-ant, lateral, vertical)
% indices of condiles (left: 1, right: 2)
% verts: [N-by-3] matrix whos rows represent points
%
% The axes are raw axis (before actually finding the accurate symmetry plane)
%   

vals = zeros(length(verts), 1);
% make the centroid of verts to be the origin in the new coords system
verts = verts - repmat(mean_pt(verts), length(verts), 1);

% project onto the post-anterior axis
for i = 1: length(verts)
    vals(i) = verts(i, :) * axes(:, 1);
end
[vals, inds] = sort(vals);
% vals(ind + 1) - vals(ind) is the maximum
[~, ind] = max(vals(2: end) - vals(1: end - 1));

verts_type = zeros(length(verts), 1);
% Now use size to determine which side is the condile
% Should not be a problem because condiles should always be smaller in size
% than tooth rows
if ind > length(vals) / 2
    inds = inds(ind + 1: length(vals));
else
    inds = inds(1: ind);
end
% distinguish left and right condiles
verts_type(inds) = left_right_condiles(verts(inds, :), axes, verts_type(inds));

faces_type = zeros(length(faces), 1);
for i = 1: length(faces)
    if (verts_type(faces(i, 1)) == 1)
        faces_type(i) = 1;
    elseif (verts_type(faces(i, 1)) == 2)
        faces_type(i) = 2;
    end
end

end

