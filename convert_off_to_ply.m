function convert_off_to_ply( filename_off, filename_ply )
[V,F]=read_off(filename_off);
write_ply(V,F,filename_ply);
end

