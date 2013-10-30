function [ score ] = calc_score( obj1, obj2, R, T )
%CALC_SCORE Summary of this function goes here
% Calculate the score of current configuration based on rotation R and
% translation T

intersectFaces = pqp_intersect(obj1,obj2, R, T, 1);
if isEmpty(intersectFaces)
    score = pqp_distance(obj1, obj2,eye(3),[100 0 0]');
else
    score = -length(intersectFaces);

end

