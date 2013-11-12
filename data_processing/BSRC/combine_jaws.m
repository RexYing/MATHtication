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
csvwrite('data/f_lower_inds.csv', fInds);
[vTypeUpper, fTypeUpper] = find_condiles(verts_upper, faces_upper, axes_upper_cropped);
disp('write to data/f_upper_inds.csv ...');
csvwrite('data/f_upper_inds.csv', fInds);

% find symmetry plane

% find orientation of axes
axes_lower_cropped = find_orientation(verts_lower, axes_lower_cropped, vTypeLower);
axes_upper_cropped = find_orientation(verts_upper, axes_upper_cropped, vTypeUpper);

% transform jaws to align

% fit