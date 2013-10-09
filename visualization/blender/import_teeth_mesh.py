import os
import bpy
import bmesh
from mathutils import Vector
from io_mesh_ply import import_ply

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
    
def remove_mesh(mesh):
    '''
    Remove mesh from bpy.data.meshes
    Make sure no objects are using this mesh
    
    @param mesh: Blender mesh object to be removed
    '''
    mesh.user_clear();
    bpy.data.meshes.remove(mesh)
    # clear object with the same name
    name = mesh.name;
    
def load_jaw_from_ply(filename):
    filepath = bpy.data.filepath
    root_dir = filepath[0: filepath.find('visualization') - 1]
    filepath = os.path.join(root_dir, 'data', filename)
    import_ply.load_ply(filepath)

def load_original():
    lower_jaw_name = 'lower_cropped-downsampled'
    upper_jaw_name = 'upper_cropped-downsampled'
    # Move object center of the mesh to the center of its geometry
    load_jaw_from_ply(lower_jaw_name + '.ply')
    bpy.ops.object.origin_set(type='GEOMETRY_ORIGIN', center='MEDIAN')
    lower_jaw_object = bpy.data.objects[lower_jaw_name]
    
def load_cropped():
    filepath = bpy.data.filepath
    blend_directory = filepath[0: filepath.rfind('\\')]
    upper_jaw_file = os.path.join(blend_directory, "upper_cropped.ply")

    import_ply.load_ply(upper_jaw_file)
    
def draw_line(x, y, z):
    mesh = bpy.data.meshes.new('axis1')

    bm = bmesh.new()

    origin = Vector((0, 0, 0))
    v = Vector((x, y, z))
    bm.verts.new(origin)
    bm.verts.new(v)
    bm.edges.new([bm.verts[0], bm.verts[1]])

    bm.to_mesh(mesh)
    mesh.update()
    
    from bpy_extras import object_utils
    object_utils.object_data_add(context, mesh, operator=self)
    
def main():
    load_original()
    
    
    
if __name__ == '__main__':
    for mesh in bpy.data.meshes:
        remove_mesh(mesh)
    #main()
    draw_line(0.2216 * 100, 0.3302 * 100, 0.9175 * 100)