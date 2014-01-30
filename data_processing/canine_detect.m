% For some teeth, the canine is protruding very far, causing inaccuracy in
% determining vertical axis as well as symmetry to some extent.

%proj = verts_lower * axesLowerCropped(:, 3);
figure(1)
disp('Distribution along vertical axis:');

subplot(1, 2, 1)
proj = verts_lower(vertsTypeLower == 0, :) * axesLowerCropped(:, 3);
hist(proj, 50);
[distLower, binCentersLower] = hist(proj, 50);
title('Loki Saimiri lower jaw');

subplot(1, 2, 2)
proj = verts_upper(vertsTypeUpper == 0, :) * -axesUpperCropped(:, 3);
hist(proj, 50);
[distUpper, binCentersUpper] = hist(proj, 50);
title('Loki Saimiri upper jaw');
