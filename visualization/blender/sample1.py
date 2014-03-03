import bpy
import mathutils
from math import sin, cos, radians
import time
import threading

def place_cursor(x, y, z):
    cursor = bpy.context.scene.cursor_location
    cursor.x = x
    cursor.y = y
    cursor.z = z
       

def orig_vert_translation():
    bpy.context.active_object.location.xyz = [0, 0, -1.86]
    bpy.context.active_object.rotation_euler = [0, 0, radians(-5.22)]

# fit without 
t_pa = -1.56
t_lat = 0
t_ver = -0.777
r_pa = -0.044
r_lat = -0.093
r_ver = -4.09

def best_fit():
    bpy.context.active_object.location.xyz = [t_pa, t_lat, t_ver]
    bpy.context.active_object.rotation_euler = [radians(r_pa), radians(r_lat), radians(r_ver)]

def lift(h):
    lift_vec = mathutils.Vector((0, 0, h))
    bpy.data.objects['lower_processed'].location += lift_vec

def stroke(k):
    bpy.context.active_object.rotation_euler = [r_pa, r_lat, r_ver + radians(k)]

#    prod_vec = Vector((random() - 0.5, random() - 0.5, random() - 0.5))
#    print("Prodding", prod_vec)
#    bpy.data.objects["Cube"].location += prod_vec

#thread = threading.Thread(name="stroke", target=stroke)
#thread.start()
#thread.join()
#best_fit()
#lift(-1)
orig_vert_translation()
step = 1
#stroke()
#place_cursor(-27.3145, -15.0857, 11.4144)
#place_cursor(-27.2714, 14.9699, 11.6102)