function [ verts ] = adjust_axes( verts, w )
%ADJUST_AXES Project into 2 dimen and adjust post-anterior and lateral
%axes.
% verts are transformed into the new axes system

axes2 = find_axes(verts(:, 1: 2))
meanpt = mean_pt(verts)
verts = verts - repmat(meanpt, length(verts), 1);
%axes2 = find_axes(verts(w ~= 0, 1: 2))
verts(:, 1: 2) = verts(:, 1: 2) * axes2;

end

