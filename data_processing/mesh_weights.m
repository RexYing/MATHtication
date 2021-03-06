function [ weights ] = mesh_weights( verts, faces )
% find the weights of each vertex in a mesh
% The weight of a vertex is the sum of all areas of triangles which contain
% the vertex divided by 3.

weights = zeros(length(verts), 1);
areas = zeros(length(faces), 1);
for i = 1: length(faces)
    face = faces(i, :);
    % Cross product
    x = verts(face(1), :);
    y = verts(face(2), :);
    z = verts(face(3), :);
    ons = [1 1 1];
    areas(i) = 0.5 * sqrt(det([x; y; ons])^2 + ...
        det([y; z; ons])^2 + det([z; x; ons])^2);
    
    % add to the weights of the triangle's vertices
    for j = 1: 3
        weights(face(j)) = weights(face(j)) + areas(i);
    end
end
% convert to column vector, divide by 3 (vertex area)
weights = weights(:) / 3;

end

