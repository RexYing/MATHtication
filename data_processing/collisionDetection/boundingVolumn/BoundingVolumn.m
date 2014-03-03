classdef BoundingVolumn < handle
    %BOUNDINGVOLUMN Abstract class of bounding volumn for collision model
    % By default, vectors are in column form
    
    properties
        pos % position of BV
        rotMat  % Rotational matrix
        % index of first child BV. For a leaf BV, firstChild stores the
        % negative of the index of the only triangle/face the bv contains.
        firstChild = [];
    end
    
    properties(SetAccess = private)
        
    end
    
    methods
        function leaf = isLeaf(bv)
            if (bv.firstChild < 0)
                leaf = 1;
            else
                leaf = 0;
            end
        end
    end
    
    methods (Abstract)
        size = getSize(bv)
        fitToTris(bv, orient, tris, numTris)
    end
    
    methods (Abstract, Static)
        overlap = bvOverlap(bv, bv1, rotMat, trans)
    end
    
end

