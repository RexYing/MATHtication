a = MeshModel(verts_lower, faces_lower);
a.createModel(1);

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

