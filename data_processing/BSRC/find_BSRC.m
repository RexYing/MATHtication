function [ vertsLower, vertsUpper ] = find_BSRC( vertsLower, facesLower, ...
    vTypeLower, vertsUpper, facesUpper, vTypeUpper )
% Find Bilateral Stable Reference Configuration
% Assume already aligned according to their symmetry plane
%

toothRowIndsLower = vTypeLower == 0;
toothRowIndsUpper = vTypeUpper == 0;
% For tooth rows. Move upper jaw maxVerticalDiff for initial position
maxVerticalDiffLower = max(vertsLower(toothRowIndsLower, 3)) - ...
    min(vertsLower(toothRowIndsLower, 3));
maxVerticalDiffUpper = max(vertsUpper(toothRowIndsUpper, 3)) - ...
    min(vertsUpper(toothRowIndsUpper, 3));
maxVerticalDiff = max([max(vertsLower(toothRowIndsLower, 3)) - ...
    min(vertsUpper(toothRowIndsUpper, 3)), ...
    max(vertsUpper(toothRowIndsUpper, 3)) - ...
    min(vertsLower(toothRowIndsLower, 3))]);
% the jaws shouldn't intersect after moving this much
%vertsUpper = vertsUpper + repmat([0, 0, maxVerticalDiff], length(vertsUpper), 1);

% build bounding volumn tree
%obj_lower = pqp_createmodel(vertsLower', facesLower');
%obj_upper = pqp_createmodel(vertsUpper', facesUpper');

% move upper jaw close as possible in vertical direction
lower_bound = 0;
upper_bound = maxVerticalDiff;

for i = 1: 10
    mid = (upper_bound + lower_bound) / 2;
    
    intersects = pqp_intersect(obj_upper, obj_lower, eye(3), ...
        mid, 1);
    if (isempty(intersects))
        upper_bound = mid;
    else
        lower_bound = mid;
    end
end



end

