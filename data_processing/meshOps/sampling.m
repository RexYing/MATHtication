%% Fast Marching sampling
%
% verts_upper = verts_upper';
% faces_upper = faces_upper';

sampleSize = 2000;
% indSample = perform_farthest_point_sampling_mesh(verts_upper, faces_upper, [], sampleSize);
% axes_upper_sample = find_axes(verts_upper(indSample, :));
% 
% indSample = perform_farthest_point_sampling_mesh(verts_lower, faces_lower, [], sampleSize);
% axes_lower_sample = find_axes(verts_lower(indSample, :));

landmarks = zeros(1, sampleSize);
landmarks(1) = 1;
[D, ~, ~] = perform_fast_marching_mesh(verts_upper, faces_upper, landmarks(1));
for i = 2: sampleSize
    progressbar( i, sampleSize );
    [tmp, landmarks(i)] = max(D);
    options.constraint_map = D;
    [D1, ~, ~] = perform_fast_marching_mesh(verts_upper, faces_upper, landmarks(1: i), options);
    D = min(D,D1);
end

clf; hold on;
options.face_vertex_color = mod( 20*D/max(D),1 );
plot_mesh(verts_upper, faces_upper, options);
colormap jet(256);
h = plot3(verts_upper(1, landmarks), verts_upper(2, landmarks), verts_upper(3, landmarks), 'r.');
set(h, 'MarkerSize', 20);

%% Geodesic Delaunay Triangulation

[D, Z, Q] = perform_fast_marching_mesh(verts_upper, faces_upper, landmarks);

% Count the number d(i) of different voronoi indexes for each face i. 
V = Q(faces_upper); V = sort(V,1);
V = unique(V', 'rows')';
d = 1 + (V(1, :) ~= V(2,:)) + (V(2,:) ~= V(3,:));
% Select the faces with 3 different indices, they correspond to geodesic Delaunay faces.
I = find(d == 3); I = sort(I);
% Build the Delaunay faces set.
z = zeros(size(verts_upper, 2), 1);
z(landmarks) = (1: sampleSize)';
facesV = z(V(:,I));

% Position of the vertices of the subsampled mesh.
vertexV = verts_upper(:, landmarks);
% Re-orient the faces so that they point outward of the mesh.
options.method = 'slow';
options.verb = 0;
facesV = perform_faces_reorientation(vertexV, facesV, options);

% Display the sub-sampled mesh.
clf;
options.face_vertex_color = [];
plot_mesh(vertexV, facesV, options);
%shading faceted;

