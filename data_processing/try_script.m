wl = find_weight(verts_lower, faces_lower);
ind = find(wl==0);
fid = open('degen_verts_lower')
for i = 1: length(ind)
    fprintf(fid, '%d ', ind(i));
end
