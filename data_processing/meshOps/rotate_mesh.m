function [ result ] = rotate_mesh( center, alpha, beta, gamma, vertices )
%ROTATION 
%   
%center = center_v(vertices);
% option = 0: only return rotation matrix
x_dir = [1 0 0];
y_dir = [0 1 0];
z_dir = [0 0 1];
rot_x = createRotation3dLineAngle([center x_dir], alpha);
rot_y = createRotation3dLineAngle([center y_dir], beta);
rot_z = createRotation3dLineAngle([center z_dir], gamma);
rot = composeTransforms3d(rot_x, rot_y, rot_z);
if nargin == 4
    result = rot;
else
    result = transformPoint3d(vertices, rot);
end
end

