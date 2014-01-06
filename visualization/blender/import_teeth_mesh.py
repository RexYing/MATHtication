import os
import sys

import bpy
import bmesh
from mathutils import Vector

from io_mesh_ply import import_ply

filepath = bpy.data.filepath
root_dir = filepath[0: filepath.find('visualization') - 1]
jaw_names = ('lower_cropped-downsampled', 'upper_cropped-downsampled')

def find_center(mesh_name):
    '''
    Find the center of the mesh.
    
    @param mesh_name: identifier (string or number) of the mesh
    '''
    mesh = bpy.data.meshes[mesh_name]
    average = [0] * 3;
    for vert in mesh.vertices:
        average[0] += vert.co.x;
        average[1] += vert.co.y;
        average[2] += vert.co.z;
    average = [x / len(mesh.vertices) for x in average]
    
    
def remove_mesh(mesh_name):
    '''
    Remove mesh from bpy.data.meshes
    Make sure no objects are using this mesh
    
    @param mesh: Blender mesh object to be removed
    '''
    keys = bpy.data.objects.keys()
    if mesh_name not in keys:
        return;
    
    # clear object with the same name
    bpy.data.objects[mesh_name].user_clear();
    
    # remove on reload
    bpy.data.meshes[mesh_name].user_clear();
    
    
def load_jaw_from_ply(filename):
    filepath = bpy.data.filepath
    root_dir = filepath[0: filepath.find('visualization') - 1]
    filepath = os.path.join(root_dir, 'data', filename)
    import_ply.load_ply(filepath)

## TODO: jaw class
def load_original():
    # Move object center of the mesh to the center of its geometry
    layer = 0
    for name in jaw_names:
        print(name)
        select_layer(layer)
        load_jaw_from_ply(name + '.ply')
        # move to center
        bpy.ops.object.origin_set(
            type='GEOMETRY_ORIGIN', center='MEDIAN')
        layer += 1
    
    return (bpy.data.objects[name] for name in jaw_names);
    
    
def load_cropped():
    filepath = bpy.data.filepath
    blend_directory = filepath[0: filepath.rfind('\\')]
    upper_jaw_file = os.path.join(blend_directory, "upper_cropped.ply")
    import_ply.load_ply(upper_jaw_file)
    
'''
Set the current scene layer to the one layer specified by layer_nr
'''
def select_layer(layer_nr):  
    bpy.context.scene.layers = tuple(
        i == layer_nr for i in range(0, 20))
    
    
def draw_line(name, pt1, pt2):
    mesh = bpy.data.meshes.new(name)
    obj = bpy.data.objects.new(name, mesh)
    
    scn = bpy.context.scene
    scn.objects.link(obj)
    scn.objects.active = obj
    obj.select = True
    
    mesh.from_pydata([pt1, pt2], [(0, 1)], [])
    mesh.update()
    
def draw_axes(name, coords):
    for i in range(0, 3):
        pt1 = [20 * coords[i * 3 + j] for j in range(0, 3)];
        pt1 = tuple(pt1)
        pt2 = (-num for num in pt1)
        # naming: method + 'axis' + dimNum
        draw_line(name + 'axis' + str(i), pt1, pt2)

'''
Display axes in different layers
'''
def pca(axes_dict):
#    select_layer(2)
#    draw_axes('sample_lower_', axes_dict['sample']['lower'])
#    select_layer(3)
#    draw_axes('sample_upper_', axes_dict['sample']['upper'])
    select_layer(2)
    draw_axes('raw_lower_', axes_dict['raw']['lower'])
    select_layer(3)
    draw_axes('raw_upper_', axes_dict['raw']['upper'])
    
    select_layer(4)
    draw_axes('adacrop_lower_', axes_dict['adacrop']['lower'])
    select_layer(5)
    draw_axes('adacrop_upper_', axes_dict['adacrop']['upper'])
    
def main():
    jaws = load_original()
    
    path = os.path.join(root_dir, 'visualization', 'blender')
    sys.path.append(path)
    import read_jaw_data
    # import xml file on the jaw being analyzed
    loader = read_jaw_data.DataLoader('jaw1.xml')
    # display principle component axes
    pca(loader.load_axes());
    inds = loader.load_inds('f_upper_inds.csv')
    paint_inds(inds)

'''
mat_ind is both the material index and the value in inds array
'''
def assign_faces_color(polygons, inds, mat_ind):
    #deselect everything first
    for i in range(len(polygons)):
        polygons[i].select = False
        
    for i in range(len(inds)):
        if inds[i] == mat_ind:
            polygons[i].select = True
    bpy.context.object.active_material_index = mat_ind
    bpy.ops.object.material_slot_assign()
          
def paint_inds(inds):
    for obj in bpy.data.objects:
        obj.select = False
    obj = bpy.data.objects['upper_cropped-downsampled']
    obj.select = True
    bpy.ops.object.editmode_toggle()
    
    assign_faces_color(obj.data.polygons, inds, 1)
    assign_faces_color(obj.data.polygons, inds, 2)
        
    bpy.ops.object.editmode_toggle()
    
if __name__ == '__main__':
    #remove_mesh('lower_cropped-downsampled')
    main()
    
    
    '''
    #draw special line. TODO: automate them
    select_layer(0)
    draw_line('molar3line', (11.187, 5.251, 9.077), (-6.182, 7.334, 11.308))
    draw_line('condilesline', (20.9, 3.73, 23.2), (-9.66, 8.054, 27.454))
    '''
    