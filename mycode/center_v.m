function [ center ] = center_v( v )
%CENTER_OF_MASS Summary of this function goes here
%   Detailed explanation goes here
center = zeros(1,3);
for i=1:3
    center(i) = mean(v(:,i));
end

end

