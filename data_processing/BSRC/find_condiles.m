function [ vertexInds, faceInds ] = find_condiles( verts, faces, axis )
% 
% given verts and axes in order (post-ant, lateral, vertical)
% indices of condiles (left: 1, right: 2)
% verts: [N-by-3] matrix whos rows represent points
%   

vals = zeros(length(verts), 1);
% make the centroid of verts to be the origin in the new coords system
verts = verts - repmat(mean_pt(verts), length(verts), 1);

% project onto the post-anterior axis
for i = 1: length(verts)
    vals(i) = verts(i, :) * axis(:, 1);
end
[vals, inds] = sort(vals);
% vals(ind + 1) - vals(ind) is the maximum
[~, ind] = max(vals(2: end) - vals(1: end - 1));

vertexInds = zeros(length(verts), 1);
% Now use size to determine which side is the condile
% Should not be a problem because condiles should always be smaller in size
% than tooth rows
if ind > length(vals) / 2
    for i = ind + 1: length(vals)
        vertexInds(inds(i)) = 1;
    end
else
    for i = 1: ind
        vertexInds(inds(i)) = 1;
    end
end

faceInds = zeros(length(faces), 1);
for i = 1: length(faces)
    if (vertexInds(faces(i, 1)) == 1)
        faceInds(i) = 1;
    end
end

end

