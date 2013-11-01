function [ class ] = break2parts( vals )
% break 1 D array into 2 parts according to their value

class = zeros(size(vals));
[maxBreak, ind] = max(vals(2: end) - vals(1: end - 1));
% vals(ind + 1) - vals(ind) is the maximum
ind = ind + 1;


end

