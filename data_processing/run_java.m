addpath javacode

import mesh.Mesh;
import mesh.proximity_query.OBBTree;

load raw_mesh
%obbTree = OBBTree(verts_upper, faces_upper);
mesh = Mesh(verts_upper, faces_upper);
pt = mesh.meanPointConvexHull();

v = [0 0 0];
for i = 1: length(faces_upper)
    v = v + verts_upper(faces_upper(i, 1), :) + verts_upper(faces_upper(i, 2), :) + verts_upper(faces_upper(i, 3), :);
end
v = v / (6 * length(faces_upper));
