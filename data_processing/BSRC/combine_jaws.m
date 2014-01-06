%% Combine jaws 
% align axes; move them as close as possible by moving along vertical axes
%

load raw_mesh
load axes

% identify axes
axesLowerCropped = identify_axes(verts_lower, axesLowerCropped);
axesUpperCropped = identify_axes(verts_upper, axesUpperCropped);

% find condiles
[vertsTypeLower, facesTypeLower] = find_condiles(verts_lower, faces_lower, axesLowerCropped);
disp('write to data/f_lower_inds.csv ...');
csvwrite('data/f_lower_inds.csv', facesTypeLower);
[vertsTypeUpper, facesTypeUpper] = find_condiles(verts_upper, faces_upper, axesUpperCropped);
disp('write to data/f_upper_inds.csv ...');
csvwrite('data/f_upper_inds.csv', facesTypeUpper);

% find symmetry plane

% find orientation of axes
axesLowerCropped = find_orientation(verts_lower, axesLowerCropped, vertsTypeLower);
axesUpperCropped = find_orientation(verts_upper, axesUpperCropped, vertsTypeUpper);

%% transform jaws to align
meanJawUpper = mean_pt(verts_upper(vertsTypeUpper == 0, :));
meanJawLower = mean_pt(verts_lower(vertsTypeUpper == 0, :));
verts_upper = verts_upper - repmat(meanJawUpper, length(verts_upper), 1);
verts_lower = verts_lower - repmat(meanJawLower, length(verts_lower), 1);
% change of basis
verts_upper = verts_upper * axesUpperCropped;
verts_lower = verts_lower * axesUpperCropped;
disp('record processed data ...');
write_ply(verts_upper, faces_upper, 'data/upper_processed.ply');
write_ply(verts_lower, faces_lower, 'data/lower_processed.ply');


% fit
find_BSRC( verts_lower, faces_lower, vertsTypeLower, ...
    verts_upper, faces_upper, vertsTypeUpper );

