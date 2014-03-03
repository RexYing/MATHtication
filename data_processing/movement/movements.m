%% prep
close all;

%transform = eulerAnglesToRotation3d[()
[vertsLower, faces_lower] = load_mesh('lower_fit.ply');

% left 1, right 2; see find_condyles.m
uCondyle1 = vertsUpper(vertsTypeUpper == 1, :);
uCondyle2 = vertsUpper(vertsTypeUpper == 2, :);

uCondyleCenter1 = mean_pt(uCondyle1);
uCondyleCenter2 = mean_pt(uCondyle2);
lCondyleCenter1 = mean_pt(lCondyle1);
lCondyleCenter2 = mean_pt(lCondyle2);

%%

vertsLower1 = vertsLower - repmat([0 0 1], length(vertsLower), 1);
hold off;

%% rotate around condyles
% angle each step in degrees
angleStep = pi/18;
orig = uCondyleCenter1;
dir = [0 0 1];
transMat = createRotation3dLineAngle([orig dir], angleStep);
for i = 1: 1
    vertsLower1 = transformPoint3d(vertsLower1, transMat);    
end

%% rotate
close(1);
