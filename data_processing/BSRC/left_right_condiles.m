function [ verts_type ] = left_right_condiles( condile_verts, axes, verts_type )
%
% given the condile indices, separate them into 2 groups, each of which
% represents a condile.
%
% The right condile is on the right side of the symmetry plane (raw) if facing in
% the direction of the posterior-anterior axis
% For right condile, verts_type is 1; left condile, verts_type is 2
%
% directions for axes should already be fixed before the function is called
%
% For find_condiles

% Here assume the centroid of the jaw is already at the origin

% project onto the lateral axis to differentiate between two condiles
for i = 1: length(condile_verts)
    val = condile_verts(i, :) * axes(:, 2);
    if val > 0
        % right condile
        verts_type(i) = 1;
    else
        verts_type(i) = 2;
    end
end


end

