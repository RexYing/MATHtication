function [ sample ] = farthest_point_downsample( verts, faces, n, landmarks )
%FARTHEST_POINT_DOWNSAMPLE Farthest point sampling scheme using fast
%marching
%   
% verts: [m-by-3] matrix representing the original set of m vertices
% n: number of sample vertices desired
% landmarks: vector containing indices of points that are already provided (optional)

sample = zeros(n, 1);
if nargin == 4
    sample(1: length(landmarks)) = landmarks;
    i = length(landmarks) + 1;
else
    sample(1) = 1;
    i = 2;
end

[D, ~, ~] = perform_fast_marching_mesh(verts, faces, sample(1: i - 1));
while i <= n
    progressbar(i, n);
    [~, sample(i)] = max(D);
    options.constraint_map = D;
    [D1, ~, ~] = perform_fast_marching_mesh(verts, faces, sample(1: i), options);
    D = min(D,D1);
    i = i + 1;
end

end

