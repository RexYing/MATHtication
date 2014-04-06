clearvars a b
v1 = [0 0 0; 0 1 0; 0 2 0; 0 1 1; 0 0 1; 0 2 1; 0 0 2; 0 1 2; 0 2 2];
f1 = [1 2 4; 2 3 4; 1 4 5; 3 4 6; 4 5 7; 4 6 8];
v2 = [0 2.1 0; 0 2 1.1; 0 1 -1; 0 1.9 0; 0 0 -1];
f2 = [2 3 5; 1 2 4];
%a1 = MeshModel(v1, f1);
a = build_mesh_model(v1, f1);
b = build_mesh_model(v2, f2);
disp('should intersect');
res = identify_collision(eye(3), zeros(3, 1), a, eye(3), zeros(3, 1), b, 1);
%%
clearvars a b res
disp('building model for the lower jaw');
%m1 = MeshModel(verts_lower, faces_lower);
m1 = build_mesh_model(vertsLower, facesLower);
disp('building model for the upper jaw');
%m2 = MeshModel(verts_upper, faces_upper);
m2 = build_mesh_model(vertsUpper, facesUpper);
disp('finished building');
res = identify_collision(eye(3), zeros(3, 1), m1, eye(3), zeros(3, 1), m2, 1);

%% Triangle overlap test
a = [0 2 3; 0 0 0; 0 2 0];
b = [0 2.1 0; 0 3 1; 0 3 9];
tri_project6([1;1;1], a, b); % might be if using this axis
tri_project6([0;1;0], a, b); % not intersecting using this axis
tri_overlap(a, b); % actually not intersecting

a = [0 2 3; 0 0 0; 0 2 0];
b = [0 1.9 1; 0 3 1; 0 3 9];
tri_overlap(a, b); % intersecting

%% Bounding volumn
dim1 = [1; 1; 1];
dim2 = [1; 1; 1];
rotMat = eye(3);
trans = [1.9; -1; 2];
OBB.obbDisjoint(rotMat, trans, dim1, dim2);

