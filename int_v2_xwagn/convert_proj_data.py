def workshopArray(arr=[]):
    string = 'Array('
    if len(arr) == 0:
        string += ')'
        return string
    else:
        length = len(arr)
        if isinstance(arr[0], list): # if the item is a list
            string += workshopArray(arr[0])
        else:
            string += str(arr[0])
        for i in range(length-1):
            string += ', '
            if isinstance(arr[i+1], list): # ditto
                string += workshopArray(arr[i+1])
            else:
                string += str(arr[i+1])
            pass
        string += ')'
        return string

def workshopArrayHero(arr=[]):
    string = 'Array('
    if len(arr) == 0:
        string += ')'
        return string
    else:
        length = len(arr)
        if isinstance(arr[0], list): # if the item is a list
            string += workshopArray(arr[0])
        else:
            string += 'Hero('
            string += str(arr[0])
            string += ')'
        for i in range(length-1):
            string += ', '
            if isinstance(arr[i+1], list): # ditto
                string += workshopArray(arr[i+1])
            else:
                string += 'Hero('
                string += str(arr[i+1])
                string += ')'
            pass
        string += ')'
        return string

f = open('proj_data.txt','r')
data = f.readlines()
f.close()

abi = ['0','1','2','3','4']

data = [line.replace('\t','').split(',') for line in data][1:]

hero_array = [line[0] for line in data]

hero_array_uniq = []

for hero in hero_array:
    if hero not in hero_array_uniq:
        hero_array_uniq.append(hero)

# 0    1       2 3   4   5 6 7          8           9       10 11 12     13
# hero,ability,g,vel,del,t,r,cast_delay,chase_delay,default,r1,r2,cylin1,warn,
#      0            9        10-12 13
#      [proj_data], default, fx,   warn
# 0 1   2   3 4 5          6
# g,vel,del,t,r,cast_delay,chase_delay

proj_data = []

for hero in hero_array_uniq:
    candidate_list = [line for line in data if line[0] == hero]
    this_default = candidate_list[0][10]
    this_fx = candidate_list[0][11:14]
    this_warn = candidate_list[0][14]
    
    this_proj_data = []

    for this_abi in abi:
        entry = [line for line in candidate_list if line[1]==this_abi]
        if entry == []:
            this_proj_data.append([])
        else:
            this_proj_data.append(entry[0][2:10])

    proj_data.append ( [this_proj_data, this_default, this_fx, this_warn] )

print(workshopArray([workshopArrayHero(hero_array_uniq),workshopArray(proj_data)]))