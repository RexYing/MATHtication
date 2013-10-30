function [ meanPoint ] = mean_pt( verts, faces )
%MEAN_PT Summary of this function goes here
%   mean point. The current implementation is average of all points

meanPoint = [0 0 0];
for i = 1: 3
    meanPoint(i) = mean(verts(:, i));
end

end

