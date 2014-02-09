classdef RSS < BoundingVolumn
    %RSS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
        % side lengths of triangle
        % 1-by-2
        sideLen
        r % radius of sphere summed with rectangle to form RSS
    end
    
    methods
        function size = getSize(bv)
            size = sqrt(bv.sideLen .* bv.sideLen) + 2 * bv.r;
        end
        
    end
    
    % dist = bvDist(bv, rotMat, trans, bv1)
    
end

