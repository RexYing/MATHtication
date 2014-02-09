classdef OBB < BoundingVolumn
    %OBB Oriented bounding box
    %   Detailed explanation goes here
    
    properties
        
        % half dimension of OBB
        % 3-by-1
        halfDim 
    end
    
    methods
        function size = getSize(bv)
            size = bv.halfDim .* bv.halfDim;
        end
    end
    
    methods (Static)
        
        function fitToTris(bv, orient, verts)
            bv.rotMat = orient;
            verts = verts * bv.rotMat;
            
            % for OBB
            minCoords = min(verts).';
            maxCoords = max(verts).';
            meanPt = (minCoords + maxCoords) / 2;
            % columns of rotMat form an orthonormal basis
            % rotMat * meanPt = (meanPt * inv(rotMat)).'
            % So it converts back to global basis (corresponding to identity matrix)
            bv.pos = bv.rotMat * meanPt;
            bv.halfDim = (maxCoords - minCoords) / 2;
        end
        
        
        % override
        % check overlap of bounding box
        % return 1 if there is overlap; 0 otherwise
        function overlap = bvOverlap(bv1, bv2, rotMat, trans)
            if obbDisjoint(rotMat, trans, bv1.halfDim, bv2.halfDim) == 0
                overlap = 1;
            else
                overlap = 0;
            end
        end
        
        
        % Test if the OBBs are disjoint
        %
        % This is a test between two boxes, obb1, obb2.  It is assumed that
        % the coordinate system is aligned and centered on obb1.  The 3x3
        % matrix rotMat specifies obb2's orientation with respect to obb1.
        % Specifically, the columns of rotMat are the basis vectors of
        % box B.  The center of obb2 is located at the vector trans.  The
        % dimensions of obb2 are given in the array dim2.  The orientation and
        % placement of obb1, in this coordinate system, are the identity matrix
        % and zero vector, respectively, so they need not be specified.  The
        % dimensions of obb1 are given in array dim1.
        %
        % trans: 3-by-1
        % dim1: 3-by-1
        % dim2: 3-by-1
        % status: none-zero value indicates that they are disjoint
        function status = obbDisjoint(rotMat, trans, dim1, dim2)
            A = abs(rotMat);
            
            % if any of these tests are one-sided, then the polyhedra are disjoint
            
            % 2 vectors in the bounding box (3 + 3 tests)
            for i = 1: 3
                if (abs(trans(i)) > dim1(i) + dot(dim2, A(i, :)) )
                    status = i;
                    return;
                end
            end
            
            for i = 1: 3
                t = abs(dot(trans, rotMat(:, i)) );
                if (t > dim2(i) + dot(dim1, A(:, i)) )
                    status = i + 3;
                    return;
                end
            end
            
            % 1 vector in each bounding box (3 * 3 tests)
            % Let the edges of obb1 be p1, p2, p3;
            % edges of obb2 be q1, q2, q3
            
            % p1 cross q1
            t = abs(trans(3) * rotMat(2, 1) - trans(2) * rotMat(3, 1));
            if (t > dim1(2) * A(3, 1) + dim1(3) * A(2, 1) ...
                    + dim2(2) * A(1, 3) + dim2(3) * A(1, 2) )
                status = 7;
                return;
            end
            
            % p1 cross q2
            t = abs(trans(3) * rotMat(2, 2) - trans(2) * rotMat(3, 2));
            if (t > dim1(2) * A(3, 2) + dim1(3) * A(2, 2) ...
                    + dim2(1) * A(1, 3) + dim2(3) * A(1, 1) )
                status = 8;
                return;
            end
            
            % p1 cross q3
            t = abs(trans(3) * rotMat(2, 3) - trans(2) * rotMat(3, 3));
            if (t > dim1(2) * A(3, 3) + dim1(3) * A(2, 3) ...
                    + dim2(1) * A(1, 2) + dim2(2) * A(1, 1) )
                status = 9;
                return;
            end
            
            % p2 cross q1
            t = abs(trans(1) * rotMat(3, 1) - trans(3) * rotMat(1, 1));
            if (t > dim1(1) * A(3, 1) + dim1(3) * A(1, 1) ...
                    + dim2(2) * A(2, 3) + dim2(3) * A(2, 2) )
                status = 10;
                return;
            end
            
            % p2 cross q2
            t = abs(trans(1) * rotMat(3, 2) - trans(3) * rotMat(1, 2));
            if (t > dim1(1) * A(3, 2) - dim1(3) * A(1, 2) ...
                   + dim2(1) * A(2, 3) - dim2(3) * A(2, 1) )
               status = 11;
               return;
            end
            
            % p2 cross q3
            t = abs(trans(1) * rotMat(3, 3) - trans(3) * rotMat(1, 3));
            if (t > dim1(1) * A(3, 3) + dim1(3) * A(1, 3) ...
                    + dim2(1) * A(2, 2) + dim2(2) * A(2, 1) )
                status = 12;
                return;
            end
            
            % p3 cross q1
            t = abs(trans(2) * rotMat(1, 1) - trans(1) * rotMat(2, 1));
            if (t > dim1(1) * A(2, 1) + dim1(2) * A(1, 1) ...
                    + dim2(2) * A(3, 3) + dim2(3) * A(3, 2) )
                status = 13;
                return;
            end
            
            % p3 cross q2
            t = abs(trans(2) * rotMat(1, 2) - trans(1) * rotMat(2, 2));
            if (t > dim1(1) * A(2, 2) + dim1(2) * A(1, 2) ...
                    + dim2(1) * A(3, 3) + dim2(3) * A(3, 1) )
                status = 14;
                return;
            end
            
            % p3 cross q3
            t = abs(trans(2) * rotMat(1, 3) - trans(1) * rotMat(2, 3));
            if (t > dim1(1) * A(2, 3) + dim1(2) * A(1, 3) ...
                    + dim2(1) * A(3, 2) + dim2(2) * A(3, 1) )
                status = 15;
                return;
            end
            % overlapping
            status = 0;
        end
    end
    
end

