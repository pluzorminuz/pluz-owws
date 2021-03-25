import bpy
import decimal
D = decimal.Decimal
import math
import os
import fnmatch

THIS_BLENDFILE_DIR = bpy.path.abspath('//')

f5 = D('100000')
f4 = D('10000')
f0 = D('1')

class DataEntry:
    def __init__(self, type, pos, rolled_pos, delay, delay_raw, dmg, slot, scale):
        self.type = type
        self.pos = pos
        self.rolled_pos = rolled_pos
        self.delay = delay
        self.delay_raw = delay_raw
        self.dmg = dmg
        self.slot = slot
        self.scale = scale
    
    def __str__(self):
        print()
        print('Type:',self.type)
        print('True Pos:', self.pos)
        print('Rolled Pos:', self.rolled_pos)
        print('Attack Delay:', self.delay)
        print('Attack Delay (Raw):', self.delay_raw)
        print('Damage Received:', self.dmg)
        print('Slot:', self.slot)
        print('Scale:', self.scale)
        return ''

def find(pattern, path):
    result = []
    for root, dirs, files in os.walk(path):
        for name in files:
            if fnmatch.fnmatch(name, pattern):
                result.append(os.path.join(name))
        break # don't do recursively
    return result

def new_collection(name='New Collection', parent=None):
    # does the collection already exists?
    if name in bpy.data.collections:
        print('Collection [',name,'] already exists.',sep='')
        return bpy.data.collections[name]
    
    else:
        # if no specified parent colletion, then use the master collection
        new_coll = bpy.data.collections.new(name)
        if parent == None:

            parent_coll = bpy.context.scene.collection
            print(parent_coll)
        
        # if specified
        else:
            # try to check if the parent collection exists
            # if parent is of type string
            if isinstance(parent, str):
                if parent in bpy.data.collections:
                    parent_coll = bpy.data.collections[parent]
                else:
                    parent_coll = new_collection(parent)
            # parent is a collection
            else:
                parent_coll = parent
                
        parent_coll.children.link(new_coll)
        return new_coll

def nearest_mult_of(num,mult):
    round = D(str(num))
    round = round / D(str(mult))
    round = round.quantize(D('1'), rounding=ROUND_HALF_EVEN)
    round = round * D(str(mult))
    return round

def ow_coord_conv_decimal(string,factor):
    temp = string.split('; ')
    return (D(temp[0])/factor,-D(temp[2])/factor,D(temp[1])/factor)

def ow_coord_conv_decimal154(string,factor):
    temp = string
    temp = temp.replace('(','')
    temp = temp.replace(')','')
    temp = temp.split('; ')
    return (D(temp[0])/factor,-D(temp[2])/factor,D(temp[1])/factor)

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
    x = D(temp[0])/factor
    y = -D(temp[2])/factor
    z = D(temp[1])/factor
    x_trans = x + offset
    x_mult = x_trans / mod
    x_mult = x_mult.quantize(D(1),rounding=ROUND_FLOOR)
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

def point_cloud(coords, coll=bpy.context.scene.collection, ob_name='Point Cloud', edges=[], faces=[]):
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
    x = D(temp[0])/factor
    y = -D(temp[2])/factor
    z = D(temp[1])/factor
    x_trans = x + offset
    x_mult = x_trans / mod
    x_mult = x_mult.quantize(D('1'),rounding=ROUND_FLOOR)
    x_new = x-(x_mult * mod)
    return (x_new, y, z)

def ow_coord_conv_decimal_alf_multi(string,factor,mod):
    temp = string
    temp = temp.replace('(','')
    temp = temp.replace(')','')
    temp = temp.split(', ')
    x = D(temp[0])/factor
    y = -D(temp[2])/factor
    z = D(temp[1])/factor
    x_trans = x + (offset * D('0.5'))
    x_mult = x_trans / mod
    x_mult = x_mult.quantize(D('1'),rounding=ROUND_FLOOR)
    x_new = x-(x_mult * mod)
    return (x_new, y, z)

def ow_coord_conv_decimal_alf(string,factor):
    temp = string
    temp = temp.replace('(','')
    temp = temp.replace(')','')
    temp = temp.split(', ')
    return (D(temp[0])/factor, -D(temp[2])/factor, D(temp[1])/factor)

def ow_coord_array_conv_alf_mod(input_array,factor,offset,mod): # given an ALF parsed array of coord, convert to an array of decimals
        array = []
        for item in input_array:
            array.append(ow_coord_conv_decimal_alf_mod(item,factor,offset,mod))
        return array

def floatToDecimal(input, factor):
    return D(input) / factor

def owCoordToDecimalVec(input, factor):
    temp = input
    temp = temp.replace('(','')
    temp = temp.replace(')','')
    temp = temp.split('; ')
    return (D(temp[0])/factor, -D(temp[2])/factor, D(temp[1])/factor)

def owConv_arrayOfFloat(input, factor):
    if input == '0':
        return []
    elif input == '[]':
        return []
    else:
        temp = input
        temp = temp.replace('[','')
        temp = temp.replace(']','')
        temp = temp.split(';')
        return [floatToDecimal(item, factor) for item in temp]

def owConv_arrayOfVectors(input, factor):
    if input == '0':
        return []
    elif input == '[]':
        return []
    else:
        temp = input
        temp = temp.replace('[','')
        temp = temp.replace(']','')
        temp = temp.replace(');(','):(')
        temp = temp.split(':')
        return [owCoordToDecimalVec(item, factor) for item in temp]

def floatToInt(input):
    return D(int(input))

def owConv_arrayOfInt(input):
    if input == '0':
        return []
    elif input == '[]':
        return []
    else:
        temp = input
        temp = temp.replace('[','')
        temp = temp.replace(']','')
        temp = temp.split(';')
        return [floatToInt(item) for item in temp]

def scalarMultVec(scalar, vec):
    return (scalar*vec[0], scalar*vec[1], scalar*vec[2])
    

this_coll = bpy.context.scene.collection

#scan_index = 'doomfistuppercut_2a'
scan_index = 'extremeres'
offset = D('2.5')
mod = D('5')
filelist = find(scan_index + '.owhb2', THIS_BLENDFILE_DIR)

if filelist == []:
    print('No file match! Exiting...')
else:
    acc_file_len = 0
    data = []
    for file in filelist:
        f = open(THIS_BLENDFILE_DIR + file,'r')
        data.extend(f.readlines()[2:])
        f.close()
        print(file,len(data)-acc_file_len)
        acc_file_len = len(data)
    del acc_file_len
    
    data = [line.split(',') for line in data]

    # [0] timestamp
    # [1] variable target
    # [2] 0: l_hit_store                array of (float * f5)
    # [3] 1: r_hit_store                array of (float * f5)
    # [4] 2: thisscan_resolution_copy   (float * f5)
    # [5] 3: thisslice_x_copy           vector of (float * f5)
    # [6] 4: thisslice_y_bounds_copy    array of 2 int's
    # [7] 5: scan_y_batchsize           int
    # [8] 6: scan_axis                  array of 3 vectors * f0
    # [9] 7: thisscan_extract_axis      1 vector * f0
    # [10] 8: thisscan_limits_int       array of 4 int's
    # [19] 17: loop_i
    # [20] 18: thisscan_limits_raw
    # [21] 19: thisscan_resolution
    # [22] 20: scan_origin
    # [23] 21: thisscan_batch_y_start
    # [24] 22: thisscan_cur_x
    # [25] 23: thisscan_cur_y
    # [26] 24: thisslice_x

    print(data[0][8])

    for i in range(len(data)):
        data[i][2] = owConv_arrayOfFloat(data[i][2], f5)
        data[i][3] = owConv_arrayOfFloat(data[i][3], f5)
        data[i][4] = floatToDecimal(data[i][4], f5)
        data[i][5] = owCoordToDecimalVec(data[i][5], f5)
        data[i][6] = owConv_arrayOfInt(data[i][6])
        data[i][7] = floatToInt(data[i][7])
        data[i][8] = owConv_arrayOfVectors(data[i][8], f0)
        data[i][9] = owCoordToDecimalVec(data[i][9], f0)
        data[i][10] = owConv_arrayOfInt(data[i][10])
    
    # to reconstruct the ray cast hit point
    # x + y + z
    # x = thisslice_x_copy (line[5])
    # y = thisslice_y_bounds_copy[0] * loop_i * resolution (line[6] * i * line[4])
    # z = thisscan_extract_axis * line[2][i]/[3][i] (line[9] * [line[2][i])
    
    this_hb_data = []
    
    for line in data:
        this_x = line[5]
        thisline_resolution = line[4]
        thisline_extract_axis = line[9]
        thisline_y_axis = line[8][1]
        thisline_starting_y = line[6][0]
        
        i = D('0')
        
        for number in line[2]: # l hit store
            this_y = scalarMultVec(thisline_resolution * (thisline_starting_y + i), thisline_y_axis)
            this_z = scalarMultVec(number, thisline_extract_axis)
            i += D('1')
            
            this_hb_data.append( add_vector(this_x, add_vector(this_y,this_z)) )
            
        i = D('0')
        
        for number in line[3]: # r hit store
            this_y = scalarMultVec(thisline_resolution * (thisline_starting_y + i), thisline_y_axis)
            this_z = scalarMultVec(number, thisline_extract_axis)
            i += D('1')
            
            this_hb_data.append( add_vector(this_x, add_vector(this_y,this_z)) )
    
    hit_pc = point_cloud(this_hb_data, this_coll, ob_name=scan_index+' Raw')