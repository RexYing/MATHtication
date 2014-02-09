function [ overlap ] = tri_project6( axis, tr1, tr2 )
%TRI_PROJECT6 Perform projection of 6 edges of 2 triangles on axis to
%determine overlap of the 2 trangles
%
% for 3D axis and triangles
%
% axis: column vector representing axis
% tr1, tr2: triangles as 3*3 matrix. each ROW represents a point
% 
% overlap: 0 value represents triangles do not overlap; otherwise they MAY
% overlap but not are necessarily overlapping
%

p1 = tr1 * axis;
p2 = tr2 * axis;
overlap = 1;
% impossible to collide if their projection onto the same axis does not overlap
if (min(p1) > max(p2)) || (min(p2) > max(p1))
    overlap = 0;

end

