function [ best_position, translate_data ] = translate( vertex, faces_l, vertex_u, faces_u, range )
%TRANSLATE Summary of this function goes here
%   Detailed explanation goes here
    best_position = zeros(1,4);
    best_position(4) = intmax('int32');
    translate_data = zeros(2*range+1, 2*range+1, 2*range+1);
    for j = -range:range
        for k = -range:range
            for l = -range:range
                trans_matrix = createTranslation3d(j, k, l);
                translated_vertex = transformPoint3d(vertex, trans_matrix);
                if check_intersect(translated_vertex, faces_l, vertex_u, faces_u) > 0
                    disp('intersect')
                    continue;
                end
                translate_data(j+range+1, k+range+1, l+range+1) = ...
                    mean(calc_dist(translated_vertex, ...
                    faces_l, vertex_u, faces_u));
                %disp(translate_data(j+range+1, k+range+1, l+range+1));
                if translate_data(j+range+1, k+range+1, l+range+1) < best_position(4)
                    best_position(1) = j;
                    best_position(2) = k;
                    best_position(3) = l;
                    best_position(4) = translate_data(j+range+1, k+range+1, l+range+1);
                end
            end
        end
    end
end

