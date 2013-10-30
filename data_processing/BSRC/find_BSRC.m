%% Initial condition
% run_java
% mesh1 = Mesh(verts_lower, faces_lower);
% mp_lower = mesh1.meanPoint;
% clearvars mesh1;
% mesh2 = Mesh(verts_upper, faces_upper);
% mp_upper = mesh2.meanPoint;
% clearvars mesh2;


plane1 = [0, 0, 0, axes_lower_cropped(:, 1)', axes_lower_cropped(:, 2)'];
plane2 = [0, 0, 0, axes_upper_cropped(:, 2)', axes_upper_cropped(:, 1)'];
basisTransMat = createBasisTransform3d(plane2, plane1);

disp('transformation beween bases of 2 coordinate systems (upper and lower jaws respectively):');
basisTransMat = basisTransMat(1:3, 1:3);
disp(basisTransMat);



%% Start search

% Lower jaw to origin
mean_lower = mean_pt(verts_lower, faces_lower);
mean_upper = mean_pt(verts_upper, faces_upper);

% transform both jaws such that mean_lower becomes origin
% TODO: condiles
verts_lower = verts_lower - repmat(mean_lower, length(verts_lower), 1);
verts_upper = verts_upper - repmat(mean_lower, length(verts_upper), 1);

disp('Constructing bounding box hierarchy structure...');

obj_lower = pqp_createmodel(verts_lower', faces_lower');
obj_upper = pqp_createmodel(verts_upper', faces_upper');

intersects = pqp_intersect(obj_upper, obj_lower, eye(3), [0; 0; 0], 1);
fprintf('Number of bad faces: %d\n', length(intersects));

intersects = pqp_intersect(obj_upper, obj_lower, basisTransMat, [0; 0; 0], 1);
fprintf('Number of bad faces after face alignment: %d\n', length(intersects) - 1000);



%% End
pqp_deletemodel(obj_lower);
pqp_deletemodel(obj_upper);
