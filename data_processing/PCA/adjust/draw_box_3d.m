function [] = draw_box_3d( verts, adj, h, color )

%DRAW_BOX_3D: draw a 3d box with specified vertices
%verts:       Nx3 matrix, N = number of points
%adj:         NxN adjacency matrix

dim = size(verts,2);

if(dim~=3)
    error('This function only extract bouding box for point cloud in 3d.');
end

axes(h);
for i=1:size(adj,1)
    for j=1:size(adj,2)
        if(adj(i,j) == 1)
            line([verts(i,1), verts(j,1)], [verts(i,2), verts(j,2)], [verts(i,3), verts(j,3)], 'Color', color);
        end
    end
end



end

