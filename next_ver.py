def next_ver(input):
	j = input
	j.sort() # sorts normally by alphabetical order
	j.sort(key=len) # sorts by descending length
	i = [file[6:] for file in j][-1].lower()
	k = [ord(s)-97 for s in i]
	k.reverse()
	index = 0
	while(True):
		if index >= len(k):
			k.append(-1)
		k[index] += 1
		if k[index] > 25:
			k[index] %= 26
			index += 1
			continue
		break
	k.reverse()
	return j[0]+''.join([chr(s+97) for s in k])

if __name__ == '__main__':
	filelist = ['210202','210202a','210202z','210202aa','210202az','210202']
	print(next_ver(filelist))

