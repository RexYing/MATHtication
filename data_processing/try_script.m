wl = find_weight(verts_lower, faces_lower);
ind = find(wl==0);
fid = fopen('degen_verts_lower');
for i = 1: length(ind)
    fprintf(fid, '%d ', ind(i));
end

%% Test adaptive cropping

init_upper_dir = Mo.Aux.axis(3, :)';
init_test_dir = Mo.Aux.axis(1, :)';
test_dir_ind = 1;
stepsize = 0.1;
tol = 0.01;
threshold_ratio_lb = 0.3;
[M, iter, vert_rem] = adapative_crop(Mo, init_upper_dir, init_test_dir, test_dir_ind, stepsize, tol, threshold_ratio_lb );
