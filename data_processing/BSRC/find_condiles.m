function [ vertsType, facesType ] = find_condiles( verts, faces, axes )
% 
% given verts and axes in order (post-ant, lateral, vertical)
% indices of condiles (left: 1, right: 2, teeth: 0)
% verts: [N-by-3] matrix whos rows represent points
%
% The axes are raw axis (before actually finding the accurate symmetry plane)
%   

% make the centroid of verts to be the origin in the new coords system
verts = verts - repmat(mean_pt(verts), length(verts), 1);

% project onto the post-anterior axis
vals = verts * axes(:, 1);
[vals, inds] = sort(vals);
% vals(ind + 1) - vals(ind) is the maximum
[~, ind] = max(vals(2: end) - vals(1: end - 1));

vertsType = zeros(length(verts), 1);
% Now use size to determine which side is the condile
% Should not be a problem because condiles should always be smaller in size
% than tooth rows
if ind > length(vals) / 2
    inds = inds(ind + 1: length(vals));
else
    inds = inds(1: ind);
end
% distinguish left and right condiles
vertsType(inds) = left_right_condiles(verts(inds, :), axes, vertsType(inds));

facesType = zeros(length(faces), 1);
for i = 1: length(faces)
    if (vertsType(faces(i, 1)) == 1)
        facesType(i) = 1;
    elseif (vertsType(faces(i, 1)) == 2)
        facesType(i) = 2;
    end
end

end

