%% Find teeth axes script
% 
% Sampling
% PCA
%

%% PCA directly on upper/lower jaw
% Upper jaw is well cropped; the lower one is not
%

axes_upper_raw = find_axes(verts_upper);
axes_lower_raw = find_axes(verts_lower);

%% Fast Marching sampling
sampleSize = 1000;
indSample = perform_farthest_point_sampling_mesh(verts_upper, faces_upper, [], sampleSize);
axes_upper_sample = find_axes(verts_upper(indSample, :));

indSample = perform_farthest_point_sampling_mesh(verts_lower, faces_lower, [], sampleSize);
axes_lower_sample = find_axes(verts_lower(indSample, :));

%% Adjust


%% Record
export_data
