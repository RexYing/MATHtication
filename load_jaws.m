clf;
name = 'lower_cropped-downsampled.ply';
options.name = name;
% options.face_color_r = 1;
% options.face_color_g = 1;
% options.face_color_b = 0;
[vertex_l,faces_l]=read_mesh(name);
options.face_vertex_color = repmat([0.5, 0.5, 0.5], size(vertex_l,1), 1);
shading interp;
plot_mesh(vertex_l, faces_l, options);

name = 'upper_cropped-downsampled.ply';
options.name = name;
[vertex_u,faces_u]=read_mesh(name);
options.face_vertex_color = repmat([0.5, 0.5, 0.5], size(vertex_u,1), 1);
plot_mesh(vertex_u, faces_u, options);
% 
% name = 'Lower_1.ply';
% options.name = name;
% [v_l1,f_l1]=read_mesh(name);
% clf;
% shading interp;
% plot_mesh(v_l1, f_l1);
% 
% name = 'Lower_2.ply';
% options.name = name;
% [v_l2,f_l2]=read_mesh(name);
% shading interp;
% plot_mesh(v_l2, f_l2);
% 
% name = 'Lower_3.ply';
% options.name = name;
% [v_l3,f_l3]=read_mesh(name);
% shading interp;
% plot_mesh(v_l3, f_l3);
% 
% name = 'Lower_4.ply';
% options.name = name;
% [v_l4,f_l4]=read_mesh(name);
% shading interp;
% plot_mesh(v_l4, f_l4);
% 
% name = 'Upper_1.ply';
% options.name = name;
% [v_u1,f_u1]=read_mesh(name);
% shading interp;
% plot_mesh(v_u1, f_u1);
% 
% name = 'Upper_2.ply';
% options.name = name;
% [v_u2,f_u2]=read_mesh(name);
% shading interp;
% plot_mesh(v_u2, f_u2);
% 
% name = 'Upper_3.ply';
% options.name = name;
% [v_u3,f_u3]=read_mesh(name);
% shading interp;
% plot_mesh(v_u3, f_u3);
% 
% name = 'Upper_4.ply';
% options.name = name;
% [v_u4,f_u4]=read_mesh(name);
% shading interp;
% plot_mesh(v_u4, f_u4);
% 
% v_l(1) = v_l1;
% v_l(2) = v_l2;
% v_l(3) = v_l3;
% v_l(4) = v_l4;