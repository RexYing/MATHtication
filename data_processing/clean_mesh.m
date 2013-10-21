function [ vertices, faces ] = clean_mesh( vertices, faces )
%%
%
% * SYNTAX
%
%   [ vertices, faces ] = clean_mesh(vertices, faces);
%
% * INPUT
%
% vertices and faces of the mesh
%
% * OUTPUT
%
% vertices    [N-by-3] matrix of cleaned vertices
% faces       [N-by-3] matrix of cleaned faces
%
% * DESCRIPTION
%
% Delete isolated vertices: those that are not part of a face, as well as
% isolated faces.
%
% * DEPENDENCIES
%
% find_weight
% mesh2sparse
%
% * REFERENCES
%
% * AUTHOR
%
% Rex Ying
%

%% identify isolated vertices
weights = mesh_weights(vertices, faces);

% vertices to be deleted
vertsToDel = (weights == 0);


%% remove isolated edges/faces/regions
% those connected components with number of vertices less than threshold are
% removed.
% 
threshold = 3; 
[nComp, C] = graphconncomp(mesh2sparse(faces), 'weak', true);
compSizes = zeros(nComp, 1);
% store element (index of vertices) of each component up to threshold
% number of elements.
compElems = zeros(nComp, threshold);
for iVert = 1: length(C)
    compSizes(C(iVert)) = compSizes(C(iVert)) + 1;
    size = compSizes(C(iVert));
    if size <= threshold
        compElems(C(iVert), size) = iVert;
    end
end

% If the number of vertices in a component is less than threshold, delete
% this connected component.
for iComp = 1: length(compSizes)
    if compSizes(iComp) <= threshold
        del_comp(iComp);
    end
end

function del_comp(comp)
    % mark the vertices in the components so they will be deleted in the
    % next section
    for i = 1: compSizes(comp)
        vertsToDel(compElems(comp, i)) = 1;
    end
end

%% Delete all marked vertices and update faces
vertices = vertices(vertsToDel == 0, :);

% delete faces that contain verts to be deleted (from small components)
iFace = 1;
while iFace <= length(faces)
    isDel = false;
    for j = 1: 3
        if (vertsToDel(faces(iFace, j)) == 1)
            isDel = true;
            break;
        end
    end
    if isDel
        faces(iFace, :) = [];
    else
        iFace = iFace + 1;
    end
end

newInds = zeros(length(weights), 1);

indDec = 0;
for iVert = 1: length(newInds)
    if vertsToDel(iVert) == 1
        newInds(iVert) = -1;
        indDec = indDec + 1;
        continue;
    else
        newInds(iVert) = iVert - indDec;
    end
end

% update faces
for iFace = 1: length(faces)
    for j = 1: 3
        faces(iFace, j) = newInds(faces(iFace, j));
    end
end

end
        

% -------------------------------
% Date : Oct 18, 2013
% Rex Ying
% Duke University
% ------------------------------
