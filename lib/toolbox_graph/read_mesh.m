%% read_mesh - read data from OFF, PLY, SMF or WRL file.
function [vertex, face, normal, uv, sphparam] = read_mesh(file)

%%
%
% * SYNTAX
%
%   [vertex,face] = read_mesh(filename);
%   [vertex,face] = read_mesh;      % open a dialog box
%
% * INPUT
%
% filename    Input file name
%
% * OUTPUT
%
% <html>
% <table border=0>
%   <tr><td>vertex</td>
%       <td>[N-by-3] the 3D position of the vertices.</td></tr>
%   <tr><td>face</td>
%       <td>[N-by-3] the connectivity of the mesh.</td></tr>
% </table>
% </html>
%
% * DESCRIPTION
%
% Supported file extensions are: .off, .ply, .wrl, .obj, .m, .gim.
%
% * ACKNOWLEDGEMENT
%
% Gabriel Peyre
%
% * DEPENDENCIES
%
% NONE
%
% * REFERENCES
%
% * AUTHOR
%
% Gabriel Peyre 2007
%
% Modified by Rex Ying
% It is now able to accept file as a path name containing multiple '.'
% File extension is determined by examining the string after the last '.'
%

switch file
    case {'triangle' 'square' 'square1' 'L' 'L1' 'tetra' 'oct' 'ico' 'rand'}
        [vertex,face] = compute_base_mesh(file);
        [vertex,face] = check_face_vertex(vertex,face);
        return;
end

% Ask for input file through GUI
if nargin==0
    [f, pathname] = uigetfile({'*.off;*.ply;*.wrl;*.smf;*.png;*.jpg;*.gim;*.tet','*.off,*.ply,*.wrl,*.smf,*.png,*.png,*.gim,*.tet Files'},'Pick a file');
    file = [pathname, f];
end

% Extension
ext = {'off' 'ply' 'wrl' 'smf' 'png' 'jpg' 'gim' 'tet'};
next = length(ext);

inds = strfind(file, '.');
if isempty(inds)
    % try to determine extension
    found = 0;
    for inds = 1: next
        if exist([file '.' ext{inds}], 'file')==2
            found = 1;
            file = [file '.' ext{inds}]; %#ok<AGROW>
            break;
        end
    end
    if found==0
        error('File not found with matching extension.');
    end
    inds = strfind(file,'.');
end
ext = file(inds(end) + 1: end);
name = file(1: inds(end) - 1);

switch lower(ext)
    case 'off'
        [vertex,face] = read_off(file);
    case 'ply'
        [vertex,face] = read_ply(file);
    case 'smf'
        [vertex,face] = read_smf(file);
    case 'wrl'
        [vertex,face] = read_wrl(file);
    case 'obj'
        [vertex,face,normal] = read_obj(file);
    case 'tet'
        [vertex,face] = read_tet(file);
    case 'm'
        if isfield(options, 'type')
            type = options.type;
        else
            type = 'gim';
        end
        [vertex,face,normal, uv, sphparam] = read_mfile(file, type);
    case 'gim'
        sub_sample = 1;
        [M,Normal] = load_gim(name, options);
        [vertex,face] = convert_gim2mesh(M, sub_sample);
        normal = convert_gim2mesh(Normal, sub_sample);
        
    otherwise
        error('Unknown extension.');
end

if strcmp(name, 'mannequin')
    vertex = -vertex;
end