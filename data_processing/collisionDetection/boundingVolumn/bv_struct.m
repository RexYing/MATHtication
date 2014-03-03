% An illustration of bv struct

% OBB's bv struct:
%  bv.pos: position of obb (centroid)
%  bv.halfDim: half dimension of OBB
%  bv.rotMat: rotational matrix
%  bv.firstChild: the index of its first child (negative if it is a leaf,
%  in which case -bv.firstChild is the index of the obb itself.
%  bv.size: square of the length of half the diagonal of the bv
bv(10) = struct('pos', [], 'halfDim', [], 'rotMat', [], 'firstChild', [], 'size', []);

