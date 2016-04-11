with open('contact_list.txt',"r+") as f:
        old = f.readlines()
        for line in old:
                #print line,
		#exit()
                if 'LiuYu' in line:
                	print line,
			#exit()
			write(f.readline())
                        f.seek(3)
                        f.write("LiuXiang\n")
                        print line
