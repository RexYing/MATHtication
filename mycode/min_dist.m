function min = min_dist(point, point_set)
%MIN_DIST Summary of this function goes here
%   Detailed explanation goes here
portion = 100;

    min = bitmax;
    for j = 1 : idivide(int32(size(point_set, 1)), portion, 'floor')
        current = point_set(j*portion,:);
        dist = 0;
        for k = 1:3
            dist = dist + (point(k)-current(k))^2;
        end
        dist = sqrt(dist);
        if min > dist
            min = dist;
        end
    end

end

