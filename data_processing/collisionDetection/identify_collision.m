function [ res ] = identify_collision( R1, T1, meshModel1, R2, T2, ...
    meshModel2, findAll )
%IDENTIFY_COLLISION Detects collision between two meshes
%
% [R1, T1] is the placement of model 1 in the world. (rotation matrix and
% translation vector)
% [R2, T2] is the placement of model 2 in the world.
%
% The columns of each 3x3 matrix R1/R2 are the basis vectors for the model
% in world coordinates (normalized)
%
% meshModel1 and meshModel2 are models representing the mesh. Internally as
% a tree of bounding volumes.
%
% if findAll is 0, return after finding 1 collision place (1 trangle pair);
% otherwise find all places where collision occurs (all triangle pairs).
% DEFAULTL findAll = 1 (find all pairs)
%
% Idea from: UNC research 
% OBBTree: A Hierarchical Structure for Rapid Interference Detection,
% Stefan Gottschalk, Ming C. Lin, and Dinesh Manocha, Proc. ACM SIGGRAPH, 
% pp. 171-180, Aug. 1996. Also available as tech. rep. TR96-013, 
% Dept. Comput. Sci., Univ. N. Carolina Chapel Hill, 1996.
%
% Rex Ying
%

if nargin == 6
    findAll = 1;
end

% [R,T] = [R1,T1]'[R2,T2] = [R1',-R1'T][R2,T2] = [R1'R2, R1'(T2-T1)]
R = R1' * R2;
T = R1' * (T2 - T1);

bvR = (meshModel1.bvs(1).rotMat)' * R * meshModel2.bvs(1).rotMat;

temp = R * meshModel2.bvs(1).pos + T - meshModel1.bvs(1).pos;
bvT = (meshModel1.bvs(1).rotMat)' * temp;

maxNumPairs = max([meshModel1.numFaces, meshModel2.numFaces, 10]);
collisionPairs = zeros(maxNumPairs, 2);

% nTriTests is only incremented when tri_overlap is called. 2 triangles
% whose bvs do not overlap will not cause a triTest
res = struct('nBvTests', 0, 'nTriTests', 0, 'nPairs', 0, 'R', R, 'T', T, ...
    'pairs', collisionPairs);

% start from top level bounding volumns on both trees
res = collide_recurse(res, bvR, bvT, meshModel1, 1, meshModel2, 1, findAll);

end

