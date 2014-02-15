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
[axesLowerCropped, temp, w1] = find_sym(verts_lower, faces_lower, vertsTypeLower, facesTypeLower, 'lower');
%meanpt=mean_pt(verts_lower);
meanpt = ((w1 ~= 0)' * verts_lower) / sum((w1 ~= 0));
%meanpt = (w1' * verts_lower) / sum(w1);
vExportLower = verts_lower - repmat(meanpt, length(verts_lower), 1);
vExportLower = vExportLower * axesLowerCropped;

disp('process upper');
axesUpperRaw = identify_axes(verts_upper, find_axes(verts_upper));

[vertsTypeUpper, facesTypeUpper] = find_condiles(verts_upper, faces_upper, axesUpperRaw);
[axesUpperCropped, temp, w2] = find_sym(verts_upper, faces_upper, vertsTypeUpper, facesTypeUpper, 'upper');
meanpt = ((w2 ~= 0)' * verts_upper) / sum((w2 ~= 0));
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

vExportLower = adjust_axes(vExportLower, w1);

%% Record
export_data
