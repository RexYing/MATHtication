clf;
name = 'new optimal lower';
options.name = name;
% options.face_color_r = 1;
% options.face_color_g = 1;
% options.face_color_b = 0;
options.face_vertex_color = repmat([0.8, 0.4, 0.5], size(new_v_l,1), 1);

shading interp;
plot_mesh(new_v_l, faces_l, options);

name = 'upper';
options.name = name;
options.face_vertex_color = repmat([0.5, 0.5, 0.5], size(vertex_u,1), 1);
plot_mesh(vertex_u, faces_u, options);
