% diff = 0.05;
% stat = zeros(1, 36);
% count = 0;
% start = -0.9;
% while start <= 0.85
%     count = count + 1;
%     for i=1:size(Cmean)
%         if Cmean(i) >= start
%             stat(count) = stat(count) + 1;
%         end
%     end
%     start = start + diff;
% end

high_curvature_points = zeros(1, 262);
count = 1;
threshold = 0.05;
for i=1:size(Cmean)
    if Cmean(i) >= threshold
        high_curvature_points(count) = i;
        count = count + 1;
    end
end

% high_curvature_surfaces = zeros(1,236);
% count = 1;
% for i=1:size(high_curvature_points)
%     for j=1:size