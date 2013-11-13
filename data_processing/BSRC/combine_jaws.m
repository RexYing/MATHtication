%% Combine jaws 
% align axes; move them as close as possible by moving along vertical axes
%

load raw_mesh
load axes

% identify axes
axes_lower_cropped = identify_axes(verts_lower, axes_lower_cropped);
axes_upper_cropped = identify_axes(verts_upper, axes_upper_cropped);

% find condiles
[vTypeLower, fTypeLower] = find_condiles(verts_lower, faces_lower, axes_lower_cropped);
disp('write to data/f_lower_inds.csv ...');
csvwrite('data/f_lower_inds.csv', fTypeLower);
[vTypeUpper, fTypeUpper] = find_condiles(verts_upper, faces_upper, axes_upper_cropped);
disp('write to data/f_upper_inds.csv ...');
csvwrite('data/f_upper_inds.csv', fTypeUpper);

% find symmetry plane

% find orientation of axes
axes_lower_cropped = find_orientation(verts_lower, axes_lower_cropped, vTypeLower);
axes_upper_cropped = find_orientation(verts_upper, axes_upper_cropped, vTypeUpper);

%% transform jaws to align
mean_jaw_upper = mean_pt(verts_upper(vTypeUpper == 0, :));
mean_jaw_lower = mean_pt(verts_lower(vTypeUpper == 0, :));
verts_upper = verts_upper - repmat(mean_jaw_upper, length(verts_upper), 1);
verts_lower = verts_lower - repmat(mean_jaw_lower, length(verts_lower), 1);
% change of basis
verts_upper = verts_upper * axes_upper_cropped;
verts_lower = verts_lower * axes_upper_cropped;
disp('record processed data ...');
write_ply(verts_upper, faces_upper, 'data/upper_processed.ply');
write_ply(verts_lower, faces_lower, 'data/lower_processed.ply');


% fit
