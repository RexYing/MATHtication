%% Find teeth axes script
% 
% Sampling
% PCA
%

disp('cleaning meshes ... ');
[verts_lower, faces_lower] = clean_mesh(verts_lower, faces_lower);
[verts_upper, faces_upper] = clean_mesh(verts_upper, faces_upper);

%% PCA on upper/lower jaw
% adaptively crop

disp('process lower');
axesLowerRaw = identify_axes(verts_lower, find_axes(verts_lower));

[vertsTypeLower, facesTypeLower] = find_condiles(verts_lower, faces_lower, axesLowerRaw);
[axesLowerCropped, temp1, w] = find_sym(verts_lower, faces_lower, vertsTypeLower, facesTypeLower, 'lower');
meanpt = ((w ~= 0)' * verts_lower) / sum((w ~= 0));
vExportLower = verts_lower - repmat(meanpt, length(verts_lower), 1);
vExportLower = vExportLower * axesLowerCropped;

disp('process upper');
axesUpperRaw = identify_axes(verts_upper, find_axes(verts_upper));

[vertsTypeUpper, facesTypeUpper] = find_condiles(verts_upper, faces_upper, axesUpperRaw);
[axesUpperCropped, temp, w] = find_sym(verts_upper, faces_upper, vertsTypeUpper, facesTypeUpper, 'upper');
meanpt = ((w ~= 0)' * verts_upper) / sum((w ~= 0));
vExportUpper = verts_upper - repmat(meanpt, length(verts_upper), 1);
vExportUpper = vExportUpper * axesUpperCropped;

%% Fast Marching sampling
% sampleSize = 1000;
% indSample = perform_farthest_point_sampling_mesh(verts_upper, faces_upper, [], sampleSize);
% axes_upper_sample = find_axes(verts_upper(indSample, :));
% 
% indSample = perform_farthest_point_sampling_mesh(verts_lower, faces_lower, [], sampleSize);
% axes_lower_sample = find_axes(verts_lower(indSample, :));

%% Adjust


%% Record
export_data
