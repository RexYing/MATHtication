classdef MeshModel < handle
    %MESHMODEL Model of mesh for collision detection
    %   Detailed explanation goes here
    
    properties
        isBuilt = false;
        verts % numVerts-by-3
        faces % numFaces-by-3
        centroids % numFaces-by-3 centroids of faces
        numVerts
        numFaces % equivalent to number of triangles
        bvs  % BoundingVolumns
        numBvs % number of initialized BoundingVolumn objects
    end
    
    properties(SetAccess = private)
        
    end
    
    methods
        function model = MeshModel(verts, faces)
            model.verts = verts;
            model.faces = faces;
            model.numVerts = size(verts, 1);
            model.numFaces = size(faces, 1);
            % calculate centroids
            cent = zeros(model.numFaces, 3);
            for i = 1: model.numFaces
                cent(i, :) = mean(verts(faces(i, :), :));
            end
            model.centroids = cent;
            model.initBv();
        end
        
        % Initialize bounding volumns
        function initBv(model)
            % an array of BoundingVolumn objects
            %tmp(2 * model.numFaces - 1) = OBB;
            for iBv = 2 * model.numFaces - 1: -1: 1
                tmp(iBv) = OBB;
            end
            model.bvs = tmp;
            % no BoundingVolumn object is initialized yet
            model.numBvs = 0;
            % Ready to build model
            buildModel(model);
        end
        
        % Build the tree model for a mesh once. There is no need to do this
        % again afterwards, even if it gets rotated and translated.
        function buildModel(model)
            % 2: the index of the first child of the first bounding volumn
            model.numBvs = 2;
            % building tree of bounding volumns recursively
            success = buildRecurse(model, 1, 1: model.numFaces);
            if (~success)
                disp('Failed when building MeshModel recursively');
                return;
            end
            
            % change BV orientations from world-relative to parent-relative
            model.makeParentRelative(1, eye(3), [0; 0; 0]);
            model.isBuilt = true;
        end
        
        % Fits m->child(bn) to the num_tris triangles starting at first_tri
        % Then, if num_tris is greater than one, partitions the tris into two
        % sets, and recursively builds two children of m->child(bn)
        %
        % faceInds: 1-by-N, denoting indices of faces that are in a bv
        % The vertex indices for first triangle are faces(faceInds(1), :)
        function isBuilt = buildRecurse(model, bvInd, faceInds)
            bv = model.bvs(bvInd);
%             if (mod(bvInd, 1000) == 0)
%                 disp(bvInd)
%             end
            face = model.faces(faceInds, :);
            bvVerts = model.verts(face, :);
            % axes/rotation matrix in decreasing order
            C = cov(bvVerts);
            [axes, D] = eig(C);
            %[~, ind] = max(diag(D));
            [~, inds] = sort(diag(D), 'descend');
            axes = axes(:, inds);
            % the axis that has the most variance
            splittingAxis = axes(:, 1);
            
            bv.fitToTris(axes, bvVerts);
            if (length(faceInds) == 1)
                % base case:
                % a leaf bv: index a triangle/face distinguished by a negative 
                % sign, instead of bv index
                bv.firstChild = -faceInds(1);
            else
                % index a bounding volumn
                bv.firstChild = model.numBvs;
                model.numBvs = model.numBvs + 2;

                meanpt = mean_pt(bvVerts)';
                % project centroid onto the splitting axis
                coord = dot(splittingAxis, meanpt);
                [numFirstHalf, faceInds] = model.split_tris(faceInds, splittingAxis, coord);

                % recursion - 2 children bvs
                buildRecurse(model, model.bvs(bvInd).firstChild, ...
                    faceInds(1: numFirstHalf - 1) );
                buildRecurse(model, model.bvs(bvInd).firstChild + 1, ...
                    faceInds(numFirstHalf: end) );
            end
            isBuilt = true;
        end
        
        % Given a list of triangles, a splitting axis, and a coordinate (centroid) on
        % that axis, partition the triangles into two groups according to
        % where their centroids fall on the axis (under axial projection).
        % Returns the number of tris in the first half
        %
        % splittingAxis: 3-by-1 column vector
        %
        % faceInds is modified in the process: some are swapped depending
        % on whether they are supposed to be in the first sub-bv or second
        % sub-bv.
        function [numFirstHalf, faceInds] = split_tris(model, faceInds, splittingAxis, coord)
            % index of faceInds at which group 2 ends (EXCLUSIVE)
            % will be returned in the end as numFirstHalf
            group1End = 1;
            % group2End: index of faceInds at which group 2 ends 
            % group2End is exclusive at the beginning of each loop but 
            % inclusive at the end of each loop
            projs = model.centroids(faceInds, :) * splittingAxis;
            for group2End = 1: length(faceInds)
                proj = projs(group2End);
                
                if (proj <= coord)
                    % supposed to be in group 1. swap with first half
                    faceInds([group1End, group2End]) = faceInds([group2End, group1End]);
                    group1End = group1End + 1;
                end
            end
            % split arbitrarily if one of the groups is empty
            if (group1End == 1) || (group1End == length(faceInds) + 1)
                group1End = round(length(faceInds) / 2) + 1; % +1: exclusive
            end
            numFirstHalf = group1End;
        end
        
        % Descends the hierarchy, converting world-relative transforms to 
        % parent-relative transforms, in terms of rotation and translation.
        %
        % Before making this call, the tree hierarchy of bounding volumns 
        % should have already been built.
        %
        % R: parent rotation matrix
        % T: parent translation column vector
        function makeParentRelative(model, bvInd, R, T)
            bv = model.bvs(bvInd);
            if bv.isLeaf == 0
                % make children parent-relative
                model.makeParentRelative(bv.firstChild, bv.rotMat, bv.pos);
                model.makeParentRelative(bv.firstChild + 1, bv.rotMat, bv.pos);
            end
            
            % make itself parent relative
            bv.rotMat = R' * bv.rotMat;
            bv.pos = R' * (bv.pos - T);
        end
        
    end
    
    methods (Static = true)
        
    end
    
end

