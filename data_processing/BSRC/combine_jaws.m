%% Combine jaws 
% align axes; move them as close as possible by moving along vertical axes
%

load raw_mesh
load axes

[vInds, fInds] = find_condiles(verts_lower, faces_lower, axes_lower_cropped);
csvwrite('f_lower_inds.csv', fInds);
[vInds, fInds] = find_condiles(verts_upper, faces_upper, axes_upper_cropped);
csvwrite('f_upper_inds.csv', fInds);
