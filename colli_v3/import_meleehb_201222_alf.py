import bpy
from decimal import *
import math
import os
import fnmatch
import mathutils

THIS_BLENDFILE_DIR = bpy.path.abspath('//')

factor5 = Decimal('100000')
factor6 = Decimal('1000000')
factor0 = Decimal('1')
offset = Decimal('2.5')
mod = Decimal('5')

def find(pattern, path):
    result = []
    for root, dirs, files in os.walk(path):
        for name in files:
            if fnmatch.fnmatch(name, pattern):
                result.append(os.path.join(name))
        break # don't do recursively
    return result

def new_collection(name='New Collection',parent=None):
    new_coll = bpy.data.collections.new(name)
    if parent == None:
        parent_coll = bpy.context.scene.collection
    else:
        try:
            parent_coll = bpy.data.collections[parent]
        except:
            parent_coll = new_collection(parent)
    parent_coll.children.link(new_coll)
    return new_coll

def nearest_mult_of(num,mult):
    round = Decimal(str(num))
    round = round / Decimal(str(mult))
    round = round.quantize(Decimal('1'), rounding=ROUND_HALF_EVEN)
    round = round * Decimal(str(mult))
    return round

def ow_coord_conv_decimal(string,factor):
    temp = string.split('; ')
    return (Decimal(temp[0])/factor,-Decimal(temp[2])/factor,Decimal(temp[1])/factor)

def ow_coord_conv_decimal154(string,factor):
    temp = string
    temp = temp.replace('(','')
    temp = temp.replace(')','')
    temp = temp.split('; ')
    return (Decimal(temp[0])/factor,-Decimal(temp[2])/factor,Decimal(temp[1])/factor)

def ow_coord_array_conv154(line,factor): # given a raw OWWS RAW array (string), convert to an array of world coords
    if line == '0':
        return []
    elif line == '[]':
        return []
    else:
        array = []
        temp = line
        temp = temp.replace('[','')
        temp = temp.replace(']','')
        temp = temp.replace(');(','):(')
        temp = temp.split(':')
        for item in temp:
            array.append(ow_coord_conv_decimal154(item,factor))
        return array

def ow_coord_conv_decimal154_mod(string,factor,offset,mod):
    temp = string
    temp = temp.replace('(','')
    temp = temp.replace(')','')
    temp = temp.split('; ')
    x = Decimal(temp[0])/factor
    y = -Decimal(temp[2])/factor
    z = Decimal(temp[1])/factor
    x_trans = x + offset
    x_mult = x_trans / mod
    x_mult = x_mult.quantize(Decimal(1),rounding=ROUND_FLOOR)
    x_new = x-(x_mult * mod)
    return (x_new, y, z)

def ow_coord_array_conv154_mod(line,factor,offset,mod): # given a raw OWWS RAW array (string), convert to an array of world coords
    if line == '0':
        return []
    elif line == '[]':
        return []
    else:
        array = []
        temp = line
        temp = temp.replace('[','')
        temp = temp.replace(']','')
        temp = temp.replace(');(','):(')
        temp = temp.split(':')
        for item in temp:
            array.append(ow_coord_conv_decimal154_mod(item,factor,offset,mod))
        return array

def ow_facdir_conv(string,factor):
    unit = ow_coord_conv_decimal(string,factor)
    return unit

def add_vector(a,b):
    return (a[0]+b[0],a[1]+b[1],a[2]+b[2])

def create_empty_dir(pos,dir,name,coll):
    o = bpy.data.objects.new(name,None)
    coll.objects.link(o)
    o.empty_display_size = 2
    o.empty_display_type = 'SINGLE_ARROW'
    o.location = pos
    o.rotation_euler = dir

def create_empty(pos,name='Empty',coll=bpy.context.scene.collection,type='PLAIN_AXES'):
    o = bpy.data.objects.new(name,None)
    coll.objects.link(o)
    o.empty_display_size = 2
    o.empty_display_type = type
    o.location = pos

def create_path(ob_name,coll,coords):
    curveData = bpy.data.curves.new(ob_name, type='CURVE')
    curveData.dimensions = '3D'
    curveData.resolution_u = 2
    
    polyline = curveData.splines.new('BEZIER')
    polyline.bezier_points.add(len(coords)-1)
    
    for i, coord in enumerate(coords):
        polyline.bezier_points[i].co = coord
        polyline.bezier_points[i].handle_right = coord
        polyline.bezier_points[i].handle_left = coord
    
    curveOB = bpy.data.objects.new(ob_name, curveData)
    coll.objects.link(curveOB)

def point_cloud(coords,coll=bpy.context.scene.collection,ob_name='Point Cloud', edges=[], faces=[]):
    # Create new mesh and a new object
    me = bpy.data.meshes.new(ob_name)
    ob = bpy.data.objects.new(ob_name, me)

    # Make a mesh from a list of vertices/edges/faces
    me.from_pydata(coords, edges, faces)

    # Display name and update the mesh
    #ob.show_name = True
    me.update()
    coll.objects.link(ob)
    return ob

def ow_coord_array_conv(line):
    array = []
    temp = line
    temp = temp.replace('{','')
    temp = temp.replace('}','')
    temp = temp.split('); ')
    for item in temp:
        temp1 = item
        temp1 = temp1.replace('(','')
        temp1 = temp1.replace(')','')
        array.append(ow_coord_conv_decimal(temp1,factor))
    return array

def ow_integer_array_conv(line):
    temp = line
    temp = temp.replace('{','')
    temp = temp.replace('}','')
    temp = temp.split('; ')
    array = [item for item in temp]
    return array

def ow_integer_array_conv154(line):
    if line == '0':
        return []
    elif line == '[]':
        return []
    else:
        temp = line
        temp = temp.replace('[','')
        temp = temp.replace(']','')
        temp = temp.split(';')
        array = [item for item in temp]
        return array

def ow_coord_conv_decimal_alf_mod(string,factor,offset,mod):
    temp = string
    temp = temp.replace('(','')
    temp = temp.replace(')','')
    temp = temp.split(', ')
    x = Decimal(temp[0])/factor
    y = -Decimal(temp[2])/factor
    z = Decimal(temp[1])/factor
    x_trans = x + offset
    x_mult = x_trans / mod
    x_mult = x_mult.quantize(Decimal(1),rounding=ROUND_FLOOR)
    x_new = x-(x_mult * mod)
    return (x_new, y, z)

def ow_coord_array_conv_alf_mod(input_array,factor,offset,mod): # given an ALF parsed array of coord, convert to an array of decimals
        array = []
        for item in input_array:
            array.append(ow_coord_conv_decimal_alf_mod(item,factor,offset,mod))
        return array

def ow_coord_conv_decimal_alf(string,factor):
    temp = string
    temp = temp.replace('(','')
    temp = temp.replace(')','')
    temp = temp.split(', ')
    return (Decimal(temp[0])/factor,-Decimal(temp[2])/factor,Decimal(temp[1])/factor)

this_coll = bpy.context.scene.collection

scan_index = 'wb_melee_test2'
filelist = find(scan_index + '-*.txt', THIS_BLENDFILE_DIR)

if filelist == []:
    print('No file match! Exiting...')
else:
    data = []
    for file in filelist:
        f = open(THIS_BLENDFILE_DIR + file,'r')
        data.extend(f.readlines())
        f.close()
    data = [line.replace('\n','')[11:].split(' : ') for line in data if line != '\n']
    
    for i in range(len(data)):
        data[i][0] = ow_coord_conv_decimal_alf(data[i][0],factor5) #  Attacker Final Eval * 1e6
    
    print('Raw data lines:',len(data))
    
    hit = [line[0] for line in data if line[1] == '1']
    miss = [line[0] for line in data if line[1] == '0']
    
    print('Hit count:',len(hit))
    print('Miss count:',len(miss))
    
    this_import_coll = new_collection(scan_index,'imports')
    
    #point_cloud(coords,coll=bpy.context.scene.collection,ob_name='Point Cloud', edges=[], faces=[]):
    this_hit_pc = point_cloud(hit, this_import_coll, scan_index+' Hit')
    this_miss_pc = point_cloud(miss, this_import_coll, scan_index+' Miss')
    
    