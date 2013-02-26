function [ dists, dists_l, dists_u ] = calc_dist( vertex_l, faces_l, vertex_u, faces_u )
%SMALLEST_DIST Summary of this function goes here
%   Detailed explanation goes here
% choose 1/10 of the points
graph = struct('v', {}, 'f', {});
repmat(graph, 2, 1);
graph(1).v = length(vertex_l(:, 1));
graph(1).f = length(faces_l(:, 1));
graph(2).v = length(vertex_u(:, 1));
graph(2).f = length(faces_u(:, 1));

portion = 100;

dists_l = zeros(1, idivide(int32(graph(1).v), portion, 'floor'));
for j = 1: idivide(int32(graph(1).v), portion, 'floor')
    dists_l(j) = min_dist(vertex_l(j*portion,:), vertex_u);
end
% dists_u = zeros(1, graph(2).v);
% for j = 1:graph(2).v
%     dists_u(j) = min_dist(vertex_u(j,:), vertex_l);
% end
% dists = [dists_l dists_u];
dists = dists_l;

end
