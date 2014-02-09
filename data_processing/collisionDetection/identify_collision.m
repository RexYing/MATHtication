function [ result ] = identify_collision( R1, T1, meshModel1, R2, T2, ...
    meshModel2, findAll )
%IDENTIFY_COLLISION Detects collision between two meshes
%   Detailed explanation goes here
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


end

