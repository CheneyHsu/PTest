#f = open('contact_list.txt','r+')
with open('contact_list.txt',"r+") as f:
        #old = f.read()
        f.seek(4)
        f.write("=======")
