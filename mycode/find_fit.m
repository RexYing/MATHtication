function [ best_position, position_list, list_size ] = find_fit( v1, f1, v2, f2 )
%TRANSFORM Summary of this function goes here
%   Detailed explanation goes here
min_angle = -pi/90;
max_angle = pi/90;
number = 3; % number of points in the range [min_angle, max_angle]

best_position = zeros(1,7);
best_position(1) = intmax('int32');
total_size = 4*4*6*(number^3) + 1;
position_list = zeros(total_size, 7);

list_count = 0;
obj_upper = pqp_createmodel(v2', f2');
obj_lower = pqp_createmodel(v1', f1');
center = center_v(v1);
temp_pos = zeros(1, 7);
for x = linspace(-1, 1, 3)
    temp_pos(2) = x;
    for y = linspace(-1, 1, 3)
        temp_pos(3) = y;
        for z = linspace(-3, 0.3, 3) %transform lower jaw
            temp_pos(4) = z;
            translation = [x y z]';
            for i = linspace(min_angle, max_angle, number)
                temp_pos(5) = i;
                for j = linspace(min_angle, max_angle, number)
                    temp_pos(6) = j;
                    for k = linspace(min_angle, max_angle, number)
                        temp_pos(7) = k;
                        trans_mat = rotate_mesh(center, i, j, k, v1, 0);
                        rotation = trans_mat(1:3, 1:3);
                        % this function: rotate first and then translate
                        %temp_pos(1) = pqp_distance(obj_lower,obj_upper,rotation,translation);
                        intersect = pqp_intersect(obj_lower,obj_upper,rotation,translation,0);
                        if ~isempty(intersect)
                            continue;
                        end
                        
                        trans_mat(1,4) = x;
                        trans_mat(2,4) = y;
                        trans_mat(3,4) = z;
                        translated_vertex = transformPoint3d(v1, trans_mat);
                        dists = calc_dist(translated_vertex, f1, v2, f2);
                        temp_pos(1) = mean(dists);
                        disp(temp_pos(1));
                        list_count = list_count + 1;
                        position_list(list_count, :) = temp_pos;
                        if temp_pos(1) ~= 0 && temp_pos(1) < best_position(1)
                            best_position = temp_pos;
                        end
                    end
                end
            end
        end
    end
end
list_size = list_count;
pqp_deletemodel(obj_upper);
pqp_deletemodel(obj_lower);
end

