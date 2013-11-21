%% submesh - find submeshes of a mesh. 
%
% Vertices of each submesh forms a connected component.
function [verts, f] = submesh(verts, faces, weights)

%%
%
% * SYNTAX
%
%   [submeshList] = submesh(faces);
%
% * INPUT
%
% faces    faces of mesh
%
% * OUTPUT
%
% 
%
% * DESCRIPTION
%
% identify different connected components of mesh
%
% * REFERENCES
%
% * AUTHOR
%
% Rex Ying
%

f = zeros(length(faces), 3);
count = 0;
for i = 1: length(faces)
    if weights(faces(i, 1)) == 0 || weights(faces(i, 2)) == 0 || ...
            weights(faces(i, 3)) == 0
        
    else
        count = count + 1;
        f(count, :) = faces(i, :);
    end
end
f = f(1: count, :);
end


