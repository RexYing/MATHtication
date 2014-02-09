function [ overlap ] = tri_overlap( tr1, tr2 )
% TRI_OVERLAP Robust triangle intersection test
% Check if trangle overlaps.
%
% Determine if 2 triangles overlap. 
%
% tr1, tr2: triangles as 3*3 matrix. each ROW represents a point
%
% overlap: 0 value represents triangles do not overlap; otherwise they MUST
% overlap each other at some parts of the triangles
%
% Dependency: tri_project6
%

% new coordinate system so that p1 is at (0,0,0).
temp = repmat(tr1(1, :), 3, 1);
tr1 = tr1 - temp;
tr2 = tr2 - temp;

% vectors corresponding to triangle edges
% Change to column vectors (same for all vectors below that will be the
% testing axes).
v1 = zeros(3, 3);
v1(:, 1) = (tr1(2, :) - tr1(1, :)).';
v1(:, 2) = (tr1(3, :) - tr1(2, :)).';
v1(:, 3) = (tr1(1, :) - tr1(3, :)).';
v2 = zeros(3, 3);
v2(:, 1) = (tr2(2, :) - tr2(1, :)).';
v2(:, 2) = (tr2(3, :) - tr2(2, :)).';
v2(:, 3) = (tr2(1, :) - tr2(3, :)).';

% normal vectors of the triangles - axes group1
n = zeros(3, 2);
n(:, 1) = cross(v1(:, 1), v1(:, 2));
n(:, 2) = cross(v2(:, 1), v2(:, 2));

% vectors perpendicular to normals and edges - axes group2
u1 = zeros(3, 3);
u2 = zeros(3, 3);
for i = 1: 3
    u1(:, i) = cross(v1(:, i), n(:, 1));
    u2(:, i) = cross(v2(:, i), n(:, 2));
end

% vectors normal to edge pairs from both triangles (outwards) - axes group3
ind = 1;
axes = zeros(3, 9);
for i = 1: 3
    for j = 1: 3
        axes(:, ind) = cross(v1(:, i), v2(:, j));
    end
end

% combine: total 17 testing axes
axes = [v1, v2, n, axes];

% test 2 triangles against all these axes
overlap = 1;
for i = 1: 17
    if (tri_project6(axes(:, i), tr1, tr2) == 0)
        overlap = 0;
        break;
    end
end

end

