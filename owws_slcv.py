def strip(str):
	return str.replace('\t','').replace('\n','')

def striptab(str):
	return str.replace('\t','')

def stripendcomma(str):
	if str[-2:] == ',\n':
		str = str[:-2] + ', '
	elif str[-2:] == ')\n':
		str = str[:-2] + ') '
	return str

def merge(arr):
	if len(arr) == 1: # only one line
		#print(arr[0],end='')
		return arr[0]
	else:
		i = 0
		while i < len(arr):
			if i == 0: # first line, remove line end comma
				arr[i] = stripendcomma(arr[i]) # xxxxx,\n --> xxxxx,<space>
				arr[i] = arr[i].replace('\n','') # or xxxxx)\n --> xxxxx)
			elif i == len(arr)-1: # final line, strip tab only, keep new line
				arr[i] = striptab(arr[i]) # \t\t\txxxxx; --> #xxxxx;
			else: # middle, strip all, and check if end with comma
				arr[i] = striptab(stripendcomma(arr[i])) # \t\t\t\txxxxx,\n --> xxxxx<space>
				arr[i] = arr[i].replace('\n','') # xxxxx)\n --> xxxxx)
			i += 1
	out = ''
	for line in arr:
		out += line
	return out


def process_action(arr):
	output_lines = []
	content_lines = arr[2:-1]
	output_lines.append(arr[0])
	output_lines.append(arr[1])
	
	process = []
	total = len(content_lines)
	cur_line = 0
	while cur_line < total:
		original_line = content_lines[cur_line]
		trim = strip(original_line)

		if trim != '':
			if trim[0] == trim[-1] == '"': # comment line
				process.append(original_line)
				cur_line += 1
				continue
			else:	# if not comment, then it is code or code end line
				codeline_start_index = cur_line
				codeline_end_index = cur_line
				i = cur_line
				while True:
					if strip(content_lines[i])[-1] == ';':
						codeline_end_index = i+1
						cur_line = codeline_end_index
						break
					else:
						i += 1
						continue
				process.append(merge(content_lines[codeline_start_index:codeline_end_index]))
				continue

		else: # is empty line
			process.append(original_line)
			cur_line += 1
			continue

		cur_line += 1

	output_lines.extend(process)
	output_lines.append(arr[-1])
	return output_lines

def file_path_name(str):
	slash_indexs = find_mult(str,'/')
	if slash_indexs == None:
		slash_indexs = find_mult(str,'\\')
		if slash_indexs == None:
			return None, None, None
	period_indexs = find_mult(str,'.')
	return str[:slash_indexs[-1]+1], str[slash_indexs[-1]+1:period_indexs[-1]], str[period_indexs[-1]:]

def find_mult(str,key):
	if str == '':
		return None
	else:
		out = []
		i = 0
		while True:
			i = str.find(key,i)
			if i == -1:
				break
			else:
				out.append(i)
				i += 1
		if len(out) == 0:
			return None
		else:
			return out


	#while index 

fi = input('File:')
#fi = '/Users/admin/Documents/mergetest/linemergetest_backup.txt'

try:
	f = open(fi, 'r')
except:
	print('Error opening file!')
else:
	file_path, file_name, file_ext = file_path_name(fi)
	# print(file_path, file_name, file_ext)
	data = f.readlines()
	f.close()

	total_line_count = len(data)
	print('Raw Line Count:',total_line_count)

	cur_line = 0
	final_lines = []

	while cur_line < total_line_count:
		original_line = data[cur_line]

		trim = strip(original_line)

		if trim == 'actions': # starting action
			action_start_index = cur_line # mark starting line of actions
			action_end_index = cur_line # temporary
			i = cur_line # variable
			while True:
				i += 1
				if strip(data[i]) == '}': # end of action block
					action_end_index = i + 1
					break
			final_lines.extend(process_action(data[action_start_index:action_end_index]))
			cur_line = action_end_index # jump to not brace
			if cur_line > total_line_count:
				break
			continue
		else:
			final_lines.append(original_line)
			cur_line += 1
			continue
		cur_line += 1

	w = open(file_path+file_name+'_slcv'+file_ext,'w')
	w = open(file_path+file_name+'_slcv'+file_ext,'a')
	for line in final_lines:
	 	w.write(line)
	w.close()
	w = open(file_path+file_name+'_slcv'+file_ext,'r')
	print('Converted Line Count:',len(w.readlines()))
	w.close()



		
