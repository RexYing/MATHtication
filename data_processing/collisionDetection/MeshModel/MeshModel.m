classdef MeshModel < handle
    %MESHMODEL Model of mesh for collision detection
    %   Detailed explanation goes here
    
    properties
        isBuilt = false;
        verts
        faces
        numVerts
        numFaces % equivalent to number of triangles
        bvs  % BoundingVolumns
        numBvs % number of initialized BoundingVolumn objects
    end
    
    properties(SetAccess = private)
        maxInitBvs = 0;
    end
    
    methods
        function model = MeshModel(verts, faces)
            model.verts = verts;
            model.faces = faces;
            model.numVerts = length(verts);
            model.numFaces = length(faces);
            model.initBv();
        end
        
        % Initialize bounding volumns
        function initBv(model)
            % an array of BoundingVolumn objects
            tmp(2 * model.numFaces - 1) = OBB;
            model.bvs = tmp;
            % no BoundingVolumn object is initialized yet
            model.numBvs = 0;
            % Ready to build model
            buildModel(model);
        end
        
        % Build the tree model for a mesh once. There is no need to do this
        % again afterwards, even if it gets rotated and translated.
        function buildModel(model)
            model.numBvs = 1;
            % building tree of bounding volumns recursively
            success = build_recurse(model, 1, 1);
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
        function isBuilt = build_recurse(model, bvInd, firstTri)
            bv = model.getBvByIndex(bvInd);
            
            isBuilt = true;
        end
        
        % Descends the hierarchy, converting world-relative transforms to 
        % parent-relative transforms
        %
        % Before making this call, the tree hierarchy of bounding volumns 
        % should have already been built.
        %
        % R: parent rotation matrix
        % T: parent translation column vector
        function makeParentRelative(model, bvInd, R, T)
            
        end
        
        function bv = getBvByIndex(model, ind)
            % Assume that when building BV tree, indices are assessed in
            % order
            if (ind > model.maxInitBvs + 1)
                model.bvs(ind) = OBB();
                model.maxInitBvs = model.maxInitBvs + 1;
            end
            bv = model.bvs(ind);
        end
        
        function [b] = createModel(a, b)
          b = b + 1;
        end
    end
    
    methods (Static = true)
        
    end
    
end

