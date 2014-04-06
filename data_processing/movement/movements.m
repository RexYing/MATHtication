%% prep
close all;

%transform = eulerAnglesToRotation3d[()
%[vertsLower, faces_lower] = load_mesh('lower_fit.ply');

% left 1, right 2; see find_condyles.m
uCondyle1 = vertsUpper(vertsTypeUpper == 1, :);
uCondyle2 = vertsUpper(vertsTypeUpper == 2, :);
lCondyle1 = vertsLower(vertsTypeUpper == 1, :);
lCondyle2 = vertsLower(vertsTypeUpper == 2, :);

uCondyleCenter1 = mean_pt(uCondyle1);
uCondyleCenter2 = mean_pt(uCondyle2);
lCondyleCenter1 = mean_pt(lCondyle1);
lCondyleCenter2 = mean_pt(lCondyle2);

trans = createTranslation3d(-1.56, 0, -1.977);
trans = composeTransforms3d(eulerAnglesToRotation3d(-0.044, -0.093, -4.09), trans);
%vertsLower1 = vertsLower - repmat([0 0 1], length(vertsLower), 1);

%% rotate around condyles
% angle each step in degrees
latAngleStep = pi/360;
orig = lCondyleCenter1;
dir = lCondyleCenter1 - lCondyleCenter2;
transStep = createRotation3dLineAngle([orig dir], latAngleStep);
transi = trans;
num = 20;
CollisionNum = zeros(num, 1);
for i = 1: num
    progressbar(i, num);
    res = identify_collision(transi(1:3, 1:3), transi(1:3, 4), m1, eye(3), zeros(3, 1), m2, 1);
    CollisionNum(i) = res.nPairs;
    if (res.nPairs == 0)
        disj = i;
        break;
    end
    transi = composeTransforms3d(transi, transStep);
end
plot(1: num, CollisionNum);
fprintf('\n At %d angle of lateral rotation, the jaws are disjoint.\n\n', disj * latAngleStep);
%% rotate around one condyle in z-dir
verAngleStep = pi/720;
verOrig = lCondyleCenter1;
verDir = [0 0 1];
verTransStep = createRotation3dLineAngle([verOrig verDir], verAngleStep);
transj = trans;
CollisionNum = zeros(30, 1);
for i = 1: 30
    %vertsLower1 = transformPoint3d(vertsLower1, transMat);
    res = identify_collision(transj(1:3, 1:3), transj(1:3, 4), m1, eye(3), zeros(3, 1), m2, 1);
    CollisionNum(i) = res.nPairs;
    transj = composeTransforms3d(transj, transStep);
end

%% combine
latAngleStep = pi/720;
orig = lCondyleCenter1;
dir = lCondyleCenter1 - lCondyleCenter2;
% controls opening and closing of jaw
transStep = createRotation3dLineAngle([orig dir], -latAngleStep);
transi = trans;
CollisionNum = zeros(40, 20);
% vertical
verAngleStep = pi/720;
verOrig = lCondyleCenter1;
verDir = [0 0 1];
% controls rotation around z-axis
verTransStep = createRotation3dLineAngle([verOrig verDir], verAngleStep);
for i = 1: 10 % open and close
    transj = transi;
    for j = 1: 10
        res = identify_collision(transj(1:3, 1:3), transj(1:3, 4), m1, eye(3), zeros(3, 1), m2, 1);
        CollisionNum(i, j) = res.nPairs;
        res.nPairs
        transj = composeTransforms3d(transj, verTransStep);
    end
    transi = composeTransforms3d(transi, transStep);
end
figure(2);
surf(0: verAngleStep: verAngleStep * 9, 0: latAngleStep: latAngleStep * 9, CollisionNum(1:10, 1:10));
shading interp;
xlabel('Vertical rotation angle');
ylabel('Lateral rotation angle');
zlabel('Collision score');

%% Translation
apStep = 0.1;
apTransStep = createTranslation3d(apStep, 0, 0);
transi = trans;
transi = composeTransforms3d(transi, createTranslation3d(-1, 0, 0));
CollisionNum = zeros(30, 1);
for i = 1: 30
    progressbar(i, 30);
    res = identify_collision(transi(1:3, 1:3), transi(1:3, 4), m1, eye(3), zeros(3, 1), m2, 1);
    if (res.nPairs > 2000)
        CollisionNum(i) = -10;
    else
        CollisionNum(i) = res.nPairs;
    end
    transi = composeTransforms3d(transi, apTransStep);
end
xgrid = linspace(-1, -1 + apStep * 29, 30);
scatter(xgrid, CollisionNum);
xlabel('Translation');

% rotation3dToEulerAngles(transi);
%% shortest distance (kdtree)
% Rotate around the line connecting 2 condyles

%vertsLower = vertsLower * trans(1: 3, 1: 3)' + repmat(trans(1: 3, 4)', size(vertsLower, 1), 1);
tmp = transformPoint3d(vertsLower, trans);
sampleSize = 2000;
%sampleInds = farthest_point_downsample(vertsLower, facesLower, sampleSize);
sampleInds = load('landmarks_lower_2000');
if isfield(sampleInds, 'sample')
    sampleInds = sampleInds.sample;
end
%min(tmp(:, 3))
latAngleStep = pi/90;
orig = lCondyleCenter1;
dir = lCondyleCenter1 - lCondyleCenter2;
transStep = createRotation3dLineAngle([orig dir], latAngleStep);

% construct kdtree for all centroids on the upper jaw
centroids = zeros(length(facesUpper), 3);
for i = 1: length(facesUpper)
    centroids(i, :) = (vertsUpper(facesUpper(i, 1), :) + vertsUpper(facesUpper(i, 2), :) + ...
        vertsUpper(facesUpper(i, 3), :)) / 3;
end
kdtree = KDTreeSearcher(centroids, 'distance', 'euclidean');

sampleInds = 1: size(vertsLower, 1);
for i = 1: 5
    sampleLower = tmp(sampleInds, :);
    [inds, D] = knnsearch(kdtree, sampleLower);
    tmp = transformPoint3d(tmp, transStep);
    figure(i);
    hist(D, 100);
    %min(tmp(:, 3))
end

%% Dummy triangle
vLine = [0, 0, 0; 0, 0, 1000000];
fLine = [1, 1, 2];
mLine = build_mesh_model(vLine, fLine);

%% Vertical distance
tmp = transformPoint3d(vertsLower, trans);
result = zeros(length(sampleInds), 1);
count = 0;
for i = 1: length(sampleInds)
    progressbar(i, length(sampleInds));
    line = [tmp(sampleInds(i), :), 0, 0, 1];
    %[~, pos, ~] = intersectLineMesh3d(line, vertsUpper, facesUpper);
    intersection = identify_collision(eye(3), tmp(sampleInds(i), :)', mLine, eye(3), zeros(3, 1), m2, 0);
    if intersection.nPairs > 0
        faceInd = intersection.pairs(1, 2);
        tri = vertsUpper(facesUpper(faceInd, :), :);
        pt = intersectLineTriangle3d(line, tri);
        diff = pt - tmp(sampleInds(i), :);
        if ~isnan(diff(3))
            count = count + 1;
            result(count) = diff(3);
        end
    end
end
hist(result(1: count), 50);
