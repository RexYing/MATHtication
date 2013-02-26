function [ dist ] = check_intersect( v1, f1, v2, f2, translate, rotate )
% CHECK_INTERSECTION between two meshes

t = cputime;

obj_upper = pqp_createmodel(v2', f2');
obj_lower = pqp_createmodel(v1', f1');
center = center_v(v1);
x = translate(1);
y = translate(2);
z = translate(3);
i = rotate(1);
j = rotate(2);
k = rotate(3);
translation_vec = [x y z]';
rotation_mat = rotate_mesh(center, i, j, k, v1, 0);
rotation_mat = rotation_mat(1:3, 1:3);
dist = pqp_distance(obj_lower,obj_upper,rotation_mat,translation_vec);

pqp_deletemodel(obj_upper);
pqp_deletemodel(obj_lower);

disp(cputime - t);
end