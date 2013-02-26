diff = 0.05;
stat = zeros(1, 36);
count = 0;
start = -0.9;
while start <= 0.85
    count = count + 1;
    for i=1:size(Cmean)
        if Cmean(i) >= start
            stat(count) = stat(count) + 1;
        end
    end
    start = start + diff;
end