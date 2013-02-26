options.face_vertex_color =  [];
vertex1 = perform_normal_displacement(vertex_u',faces_u', .03);

clf;
subplot(1,2,1);
plot_mesh(vertex_u,faces_u,options); shading interp; axis tight;
subplot(1,2,2);
plot_mesh(vertex1,faces_u,options); shading interp; axis tight;