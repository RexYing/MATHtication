function [ new_v ] = transform( v, translate, rotate )
%TRANSFORM Summary of this function goes here
%   transform the mesh by translate and rotate

center = center_v(v);
center = center + [translate(1), translate(2), translate(3)];
%new_v = rotate_mesh(center, rotate(1), rotate(2), rotate(3), v, 1);
%new_v = transformPoint3d(new_v, createTranslation3d(translate));
new_v = rotate_mesh(center, rotate(1), rotate(2), rotate(3), v, 0);
new_v(1,4) = translate(1);
new_v(2,4) = translate(2);
new_v(3,4) = translate(3);
new_v = transformPoint3d(v, new_v);
end
