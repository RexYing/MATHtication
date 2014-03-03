function [ bv ] = obb_fit_to_tris( bv, orient, verts )
%OBB_FIT_TO_TRIS Fit triangle into an oriented bounding box
%   Find the smallest OBB that can contain the triangle, and determine the
%   dimension and rotation matrix o the OBB.
%
%  bv: the struct representing an OBB bounding volumn.
%
%  verts: vertices contained in the OBB

bv.rotMat = orient;
verts = verts * bv.rotMat;

% for OBB
maxCoords = max(verts).';
minCoords = min(verts).';
meanPt = (maxCoords + minCoords) / 2;
% columns of rotMat form an orthonormal basis
% so the expression holds: rotMat * meanPt = (meanPt * inv(rotMat)).'
% Convert back to global basis (corresponding to identity matrix)
bv.pos = bv.rotMat * meanPt;
bv.halfDim = (maxCoords - minCoords) / 2;
% square of the length of half the diagonal of the bv
bv.size = dot(bv.halfDim, bv.halfDim);

end

