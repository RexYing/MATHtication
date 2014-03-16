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
vertsLower = verts_lower - repmat(meanpt, length(verts_lower), 1);
vertsLower = vertsLower * axesLowerCropped;
facesLower = faces_lower;

disp('process upper');
axesUpperRaw = identify_axes(verts_upper, find_axes(verts_upper));

[vertsTypeUpper, facesTypeUpper] = find_condiles(verts_upper, faces_upper, axesUpperRaw);
[axesUpperCropped, temp, w2] = find_sym(verts_upper, faces_upper, vertsTypeUpper, facesTypeUpper, 'upper');
meanpt = ((w2 ~= 0)' * verts_upper) / sum((w2 ~= 0));
vertsUpper = verts_upper - repmat(meanpt, length(verts_upper), 1);
vertsUpper = vertsUpper * axesUpperCropped;
facesUpper = faces_upper;

%clearvars verts_upper faces_upper verts_lower faces_lower


%% Adjust

vertsLower = adjust_axes(vertsLower, w1);

%% Record
vertsLower = vertsLower;
vertsUpper = vertsUpper;
export_data;
