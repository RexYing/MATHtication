%Takes four arguments:
% obj1 - PQP object for the first object
% obj2 - PQP object for the first object
% R    - 3x3 rotation matrix
% T    - 3x1 translation vector
% type - 0 to return any pair of faces that intersect ; 1 to return all
%        pairs of faces that intersect
% Returns indices of faces that intersect according to the rotation
% and translation applied to the first object and compared to the second one. 
% R*V1+T
