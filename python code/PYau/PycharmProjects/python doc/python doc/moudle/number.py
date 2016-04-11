import os
print(os.getcwd())
os.chdir('../')
print(os.getcwd())
print(os.path.join('/Users/Hsu/Desktop/PYTHON l/test','2.py'))
print(os.path.expanduser('~'))
print(os.path.join(os.path.expanduser('~'),'Desktop','PYTHON l','2.py'))

pathname='/Users/Hsu/Desktop/PYTHON l/test/test.py'
print(os.path.split(pathname))

(dirname,filename) = os.path.split(pathname)
print(dirname)
print(filename)


(shortname , extension) = os.path.splitext(filename)
print(shortname)
print(extension)


os.chdir('/Users/Hsu/Desktop/PYTHON l')
import glob
print(glob.glob('test/*.py'))
os.chdir('PYTHON l/')
print(glob.glob('*.py'))
print(os.getcwd())
os.chdir('/Users/Hsu/Desktop/PYTHON l/test')
metadata = os.stat('test.py')
print(metadata.st_mtime)
import time
print(time.localtime(metadata.st_mtime))

print(metadata.st_size)

print(os.getcwd())
os.chdir('/Users/Hsu/Desktop')
print(os.path.realpath('436.pdf'))


a_list = [1, 9 , 8 ,2]
print([elem * 2 for elem in a_list])
print(a_list)
a_list=[test * 2 for test in a_list]
print(a_list)


#100Î»×Ö½Ú
os.chdir('/Users/Hsu/Desktop/PYTHON l/test')
print(glob.glob('*.py'))
print([os.path.realpath(f) for f in glob.glob('*.py')])
print([f for f in glob.glob('*.py') if os.stat(f).st_size > 100 ])

print([(os.stat(f).st_size, os.path.realpath(f)) for f in glob.glob('*.py')])

metadata = [(f, os.stat(f)) for f in glob.glob('*.py')]
print(metadata[0])

metadata_dict = {f:os.stat(f) for f in glob.glob('*.py')}
print(type(metadata_dict))
print(list(metadata_dict.keys()))
print(metadata_dict['1.py'].st_size)


a_dict = {'a':1 , 'b':2 , 'c':3}
print({value:key for key,value in a_dict.items()})

a_set = set(range(10))
print(a_set)
print({x ** 2 for x in a_set})
print({x for x in a_set if x % 2 == 0})
print({2 ** x for x in range(10)})
###########################################################################