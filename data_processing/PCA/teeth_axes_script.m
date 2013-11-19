%% Find teeth axes script
% 
% Sampling
% PCA
%

%disp('cleaning meshes ... ');
%[verts_lower, faces_lower] = clean_mesh(verts_lower, faces_lower);

%% PCA directly on upper/lower jaw
% Upper jaw is well cropped; the lower one is not
%

%axesUpperRaw = find_axes(verts_upper);
axesLowerRaw = identify_axes(verts_lower, find_axes(verts_lower));

[vertsTypeLower, facesTypeLower] = find_condiles(verts_lower, faces_lower, axesLowerRaw);
[planeLower, temp] = find_sym(verts_lower, faces_lower, vertsTypeLower);


%% Fast Marching sampling
% sampleSize = 1000;
% indSample = perform_farthest_point_sampling_mesh(verts_upper, faces_upper, [], sampleSize);
% axes_upper_sample = find_axes(verts_upper(indSample, :));
% 
% indSample = perform_farthest_point_sampling_mesh(verts_lower, faces_lower, [], sampleSize);
% axes_lower_sample = find_axes(verts_lower(indSample, :));

%% Adjust


%% Record
%export_data
