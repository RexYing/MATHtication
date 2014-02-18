clearvars a b
v1 = [0 0 0; 0 1 0; 0 2 0; 0 1 1];
f1 = [1 2 4; 2 3 4];
v2 = [0 2.1 0; 0 3 1; 0 3 9; 0 1.9 0];
f2 = [1 2 3; 1 2 4];
a = MeshModel(v1, f1);
b = MeshModel(v2, f2);
res = identify_collision(eye(3), zeros(3, 1), a, eye(3), zeros(3, 1), b, 1);
%%
clearvars a b res
disp('building model for the lower jaw');
m1 = MeshModel(verts_lower, faces_lower);
disp('building model for the upper jaw');
m2 = MeshModel(verts_upper, faces_upper);
disp('finished building');
%res = identify_collision(eye(3), zeros(3, 1), a, eye(3), zeros(3, 1), b, 1);

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

