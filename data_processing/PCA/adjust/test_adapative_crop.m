%% preparation
path(pathdef);
path('./toolbox/', path);
clear all;
close all;

%% set parameters in this section
mesh_name = 'upper_cropped-downsampled_teeth';
%%% for 'upper_cropped-downsampled_teeth', use test_direct_ind = 1 and
%%% upper_direct = '+';
%%% for 'lower_cropped-downsampled_teeth', use test_direct_ind = 2 and
%%% upper_direct = '-'.
test_direct_ind = 1; % used to detect unbalanced distribution of points
upper_direct = '+';
%%% amount to be cropped in each step
stepsize = 0.2;
%%% error bound for unbalanced distribution of points
tol = 0.01;
%%% when (number of remaining vertices)/(number of initial vertices) drops
%%% below this threshold, terminate the iterations
threshold_ratio_lb = 0.3;

%% define an adjacency matrix for plotting bounding box
adj_cube = sparse([1,3,1,2,5,7,5,6,1,2,3,4], [2,4,3,4,6,8,7,8,5,6,7,8], ones(1,12));

%% extract initial information (parts of input parameters)
[M.V, M.F] = read_off(['./data/' mesh_name '.off']);
M.V = M.V - repmat(mean(M.V, 2),1,size(M.V, 2));
M.F2V = computeF2V(M);
Mo = M;
%%% function "get_bbox_3d" extract the bounding box by PCA
[M.Aux.bbox, M.Aux.axis] = get_bbox_3d(M.V');
switch upper_direct
    case '+'
        init_upper_direct = M.Aux.axis(:,3)./norm(M.Aux.axis(:,3));
    case '-'
        init_upper_direct = -M.Aux.axis(:,3)./norm(M.Aux.axis(:,3));
end
init_test_direct = M.Aux.axis(:,test_direct_ind)./norm(M.Aux.axis(:,test_direct_ind));

%% run adapative cropping
[M,iter,rem] = adapative_crop( M, init_upper_direct, init_test_direct, test_direct_ind, stepsize, tol, threshold_ratio_lb );

%% write the result to off file if needed
% write_off(['./data/' mesh_name '_cropped_iter' num2str(iter) '_stepsize' num2str(stepsize) '.off'], M.V', M.F');

%% visualize result
figure('Unit', 'normalized', 'Position', [0.3, 0.3, 0.6, 0.6]);
set(gcf, 'ToolBar', 'none');
cameratoolbar;
cameratoolbar('SetCoordSys', 'none');
colors = eye(3);
draw(Mo);
hold on;
axis off;
for i=1:3
    line([0 -M.Aux.axis(1,i)], [0 -M.Aux.axis(2,i)], [0 -M.Aux.axis(3,i)], 'Color', colors(i,:));
end
switch test_direct_ind
    case 1
        postant_plane(:,1) = mean(M.Aux.bbox(:,[1 5]),2);
        postant_plane(:,1) = postant_plane(:,1) - 4*M.Aux.axis(:,3);
        postant_plane(:,2) = mean(M.Aux.bbox(:,[6 2]),2);
        postant_plane(:,2) = postant_plane(:,2) + 4*M.Aux.axis(:,3);
        postant_plane(:,3) = mean(M.Aux.bbox(:,[3 8]),2);
        postant_plane(:,3) = postant_plane(:,3) + 4*M.Aux.axis(:,3);
        postant_plane(:,4) = mean(M.Aux.bbox(:,[4 7]),2);
        postant_plane(:,4) = postant_plane(:,4) - 4*M.Aux.axis(:,3);
        postant_plane(:,5) = postant_plane(:,1);
    case 2
        postant_plane(:,1) = mean(M.Aux.bbox(:,[1 3]),2);
        postant_plane(:,1) = postant_plane(:,1) - 4*M.Aux.axis(:,3);
        postant_plane(:,2) = mean(M.Aux.bbox(:,[2 4]),2);
        postant_plane(:,2) = postant_plane(:,2) + 4*M.Aux.axis(:,3);
        postant_plane(:,3) = mean(M.Aux.bbox(:,[6 8]),2);
        postant_plane(:,3) = postant_plane(:,3) + 4*M.Aux.axis(:,3);
        postant_plane(:,4) = mean(M.Aux.bbox(:,[5 7]),2);
        postant_plane(:,4) = postant_plane(:,4) - 4*M.Aux.axis(:,3);
        postant_plane(:,5) = postant_plane(:,1);
end
patch('vertices', postant_plane', 'faces', [1 2 3 4 5], 'FaceColor', 'b', 'EdgeColor', 'r', 'FaceAlpha', 0.3);
view(M.Aux.axis(:,3));
set(gca, 'XLim', [-14,14], 'YLim', [-14,14]);
drawnow;

%% save the result to a .mat file if preferred
Mo.Aux.bbox = M.Aux.bbox;
Mo.Aux.axis = M.Aux.axis;
save(['./data/' mesh_name '_apaxis.mat'], 'Mo');

