function [ res ] = collide_recurse( res, bvR, bvT, meshModel1, bvInd1, meshModel2, bvInd2, findAll )
%COLLIDE_RECURSE recursively find collision pairs
%   When two bounding boxes do not intersect each other, no need to check
%   their subtree pairs
res.nBvTests = res.nBvTests + 1;

bv1 = meshModel1.bvs(bvInd1);
bv2 = meshModel2.bvs(bvInd2);
%if OBB.bvOverlap(bv1, bv2, bvR, bvT) == 0
if obb_overlap(bv1, bv2, bvR, bvT) == 0
    return;
end

isLeaf1 = (bv1.firstChild < 0);
isLeaf2 = (bv2.firstChild < 0);
% both are leaf: test triangle overlap
if isLeaf1 && isLeaf2 == 1
    res.nTriTests = res.nTriTests + 1;
    % transform points in b2 to b1
    face1 = meshModel1.faces(-bv1.firstChild, :);
    verts1 = meshModel1.verts(face1, :);
    face2 = meshModel2.faces(-bv2.firstChild, :);
    verts2 = meshModel2.verts(face2, :);
    verts2 = res.R * verts2' + repmat(res.T, 1, 3);
    verts2 = verts2';
    if (tri_overlap(verts1, verts2) ~= 0)
        res.pairs(res.nPairs + 1, :) = [-bv1.firstChild, -bv2.firstChild];
        res.nPairs = res.nPairs + 1;
    end
    return;
end

% visit children
size1 = bv1.size;
size2 = bv2.size;

if (isLeaf2 == 1) || ((isLeaf1 == 0) && (size1 > size2))
    % split the first bv
    c1 = bv1.firstChild;
    c2 = c1 + 1;
    
    % bounding volumn child of bv1
    bvc1 = meshModel1.bvs(c1);
    Rc = bvc1.rotMat' * bvR;
    temp = bvT - bvc1.pos;
    Tc = bvc1.rotMat' * temp;
    res = collide_recurse(res, Rc, Tc, meshModel1, c1, meshModel2, bvInd2, findAll);
    
    if (findAll == 0) && (res.nPairs > 0)
        return;
    end
    
    bvc2 = meshModel1.bvs(c2);
    Rc = bvc2.rotMat' * bvR;
    Tc = bvc2.rotMat' * (bvT - bvc2.pos);
    res = collide_recurse(res, Rc, Tc, meshModel1, c2, meshModel2, bvInd2, findAll);
else
    c1 = bv2.firstChild;
    c2 = c1 + 1;
    
    % child of bv2
    bvc1 = meshModel2.bvs(c1);
    % rotMat here does not need transpose
    Rc = bvR * bvc1.rotMat;
    Tc = bvR * bvc1.pos + bvT;
    res = collide_recurse(res, Rc, Tc, meshModel1, bvInd1, meshModel2, c1, findAll);
    
    if (findAll == 0) && (res.nPairs > 0)
        return;
    end
    
    bvc2 = meshModel2.bvs(c2);
    Rc = bvR * bvc2.rotMat;
    Tc = bvR * bvc2.pos + bvT;
    res = collide_recurse(res, Rc, Tc, meshModel1, bvInd1, meshModel2, c2, findAll);
    
end

end

