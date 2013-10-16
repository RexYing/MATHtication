function [M, iter, vert_rem] = adapative_crop( M, init_upper_direct, init_test_direct, test_direct_ind, stepsize, tol, threshold_ratio_lb )
%ADAPATIVE_CROP:  adapatively crop the mesh until principal axes (almost)
%                 evenly divide the mesh into two parts
%   Detailed explanation goes here

%%% initialize mesh & construct cube
M.V = M.V - repmat(mean(M.V, 2),1,size(M.V, 2));
vert_size_base = max(size(M.V));

adj_cube = sparse([1,3,1,2,5,7,5,6,1,2,3,4], [2,4,3,4,6,8,7,8,5,6,7,8], ones(1,12));

%%% if initial test direction projection not ideal, crop the mesh at the
%%% size of stepsize and test again
iter = 0;
postant_plane = zeros(3,5);
test_result = M.V'*init_test_direct;
pos_count = sum(test_result > 0);
neg_count = sum(test_result < 0);
Pos = M.V(:,find(test_result > 0));

figure('Unit', 'normalized', 'Position', [0.1, 0.2, 0.6, 0.6]);
set(gcf, 'ToolBar', 'none');
cameratoolbar;
cameratoolbar('SetCoordSys', 'none');
colors = eye(3);
draw(M);
hold on;
axis off;
for i=1:3
    line([0 -M.Aux.axis(1,i)], [0 -M.Aux.axis(2,i)], [0 -M.Aux.axis(3,i)], 'Color', colors(i,:));
end
draw_box_3d(M.Aux.bbox', adj_cube, gca, [0 0 0]);
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
scatter3(Pos(1,1:50:1051), Pos(2,1:50:1051), Pos(3,1:50:1051), 10, 'g', 'filled');
view(M.Aux.axis(:,3));
set(gca, 'XLim', [-12,12], 'YLim', [-12,12]);
drawnow;

disp('+++++++++++++++++++++++++++++++++++++++');
disp(['Before cropping: ']);
disp(['Test Projection Discrepancy Rate: ' num2str(abs(pos_count - neg_count)/length(test_result))]);
disp(['Vertices Remaining Rate: ' num2str(max(size(M.V))/vert_size_base)]);
disp('+++++++++++++++++++++++++++++++++++++++');
disp(' ');

test_upper_direct = init_upper_direct;
test_upper_result = M.V'*test_upper_direct;

while (((abs(pos_count - neg_count)/length(test_result))>tol) && (max(size(M.V))/vert_size_base)>threshold_ratio_lb)
    iter = iter + 1;
    disp('+++++++++++++++++++++++++++++++++++++++');
    disp(['Start cropping ' num2str(iter) '...']);
    threshold = stepsize*(max(test_upper_result)-min(test_upper_result))+min(test_upper_result);
    
    dind = find(test_upper_result < threshold);
    dvtable = 1:max(size(M.V));
    vert_shift_table = ones(size(dvtable));
    M.V(:, dind') = [];
    
    dvtable(dind') = [];
    for i=1:length(dvtable)
        progressbar(i,length(dvtable),20);
        vert_shift_table(dvtable(i)) = i;
    end
    
    dindf = [];
    for i=1:length(dind)
        dindf = [dindf;find(M.F2V(:,dind(i)))];
    end
    dindf = unique(dindf);
    M.F(:,dindf') = [];
    temp_size = size(M.F);
    temp = M.F(:);
    temp = vert_shift_table(temp);
    M.F = reshape(temp, temp_size);
    
    M.V = M.V - repmat(mean(M.V, 2),1,size(M.V, 2));
    M.F2V = computeF2V(M);
    [M.Aux.bbox, M.Aux.axis] = get_bbox_3d(M.V');
    
    clf;
    colors = eye(3);
    draw(M);
    hold on;
    axis off;
    for i=1:3
        line([0 -M.Aux.axis(1,i)], [0 -M.Aux.axis(2,i)], [0 -M.Aux.axis(3,i)], 'Color', colors(i,:));
    end
    draw_box_3d(M.Aux.bbox', adj_cube, gca, [0 0 0]);
    
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
    set(gca, 'XLim', [-12,12], 'YLim', [-12,12]);
    drawnow;
    
    if (init_upper_direct'*(-M.Aux.axis(:,3)) > 0)
        test_upper_direct = -M.Aux.axis(:,3)./norm(M.Aux.axis(:,3));
    else
        test_upper_direct = M.Aux.axis(:,3)./norm(M.Aux.axis(:,3));
    end
    test_upper_result = M.V'*test_upper_direct;
    test_direct = M.Aux.axis(:,test_direct_ind)./norm(M.Aux.axis(:,test_direct_ind));
    test_result = M.V'*test_direct;
    pos_count = sum(test_result > 0);
    neg_count = sum(test_result < 0);
    Pos = M.V(:,find(test_result > 0));
    scatter3(Pos(1,1:50:1051), Pos(2,1:50:1051), Pos(3,1:50:1051), 10, 'g', 'filled');
    disp(['Test Projection Discrepancy Rate: ' num2str(abs(pos_count - neg_count)/length(test_result))]);
    disp(['Vertices Remaining Rate: ' num2str(max(size(M.V))/vert_size_base)]);
    disp(['Cropping ' num2str(iter) ' completed.']);
    disp('+++++++++++++++++++++++++++++++++++++++');
    disp(' ');
end

vert_rem = max(size(M.V))/vert_size_base;

end

