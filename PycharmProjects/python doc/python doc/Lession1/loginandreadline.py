ɖ˭x8P���af��PJ,��ō<.�mK:d쳸���|Ӿ�#W� � 6�V���� 7ڝ�=p)�7v��9lȘ%��X�3�����)������+�V�e�cc�x���1�K 8ܪ�ߪ�ǰ�� ��ӵ��z[�@�Gs&��]�]�RnL4\ü�8�7������~}��4~W��]r��-��މ�����/|�oLP�&��XlҬB_:(m�����6�g�?���k-��c��)_�^fς�PqI΋�jK+*f-�UG̆�䃷ʊC�[� Ui�3�Ho���Wq]�E�^��W��k��G����E1Aю��yU�s���4��㲺@��k]���״DF���o)"E���Z�u7�;�[�;	�}$���f�˺xeO e��}�1��G�6h�)L#��'$:7&�h��",ka�-�_��Y�^��2?�BGȄd���f�2�;N��%� '��]L5��!?n��`o�Љ��@�N����kS��)("Pls input your pass:\n")
		else:	#如果密码比对成功,则输出print
			print  "Welcome login readline.\n"
			#密码成功以后再次while循环,进行内容匹配循环
			while True: 
				sname = raw_input("Pls input your serach name:") #接收输入名字
				if len(sname) == 0:break  #如果输入的字符为空,则跳出要求从新登录
				dname = file('namelist2') #使用文件模块,然后读取文件内容到dname
				match_yes = 0   #设置初始变量,用于判度是否匹配成功,然后利用这个变量避免多行不匹配输出
				while True:  #循环,进行内容比对
					line = dname.readline()   #line的值来源于dname的每一行
					if len(line) == 0:break   #判断,如果line的值为0,则跳出比对
					if sname in line:   #输入的名字如果在line中,则打印line,并重置match_yes的值,来区分比对成功还是不成功的值.
						print "The user is: %s" % line
						match_yes = 1
				if match_yes != 1:  #判度如果match_yes 不等于1,那么将输出找不到用户
					print "No match user"
		#这里最精妙的地方是if 和 while的并行,如果if放到while内的话,将出现多个不能匹配项的输出结果,但是如果while判断以后,给出一个最终的match_yes的值,在来比对.
	else:print "Sorry, user %s not found" % input

