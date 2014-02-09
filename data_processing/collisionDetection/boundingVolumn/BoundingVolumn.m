classdef BoundingVolumn < handle
    %BOUNDINGVOLUMN Abstract class of bounding volumn for collision model
    % By default, vectors are in column form
    
    properties
        pos % position of BV
        rotMat  % Rotational matrix
        firstChild = [];
    end
    
    properties(SetAccess = private)
        
    end
    
    methods
        function leaf = isLeaf(bv)
            if (isempty(bv.firstChild))
                leaf = 1;
            else
                leaf = 0;
            end
        end
    end
    
    methods (Abstract)
        size = getSize(bv)
    end
    
    methods (Abstract, Static)
        fitToTris(bv, orient, tris, numTris)
        overlap = bvOverlap(bv, bv1, rotMat, trans)
    end
    
end

