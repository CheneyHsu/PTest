#!/usr/bin/env  python
#-*- coding:utf-8 -*-
# Revision:    1.0
### END INIT INFO

"""
目录,文件对比
"""
__author__ = 'KK'


import filecmp
a="./dir1"   #定义左目录
b="./dir2"   #定义右目录
dirobj=filecmp.dircmp(a,b,['test.py'])  #目录对不忽略 test.py

#输出对比家而过数据报表,详细说明请参考 filecmp 类方法及属性信息

dirobj.report()
dirobj.report_partial_closure()
dirobj.report_full_closure()
print "left_list:"+str(dirobj.left_list)
print "right_list:"+str(dirobj.right_list)
print "common:"+str(dirobj.common)
print "left_only:"+str(dirobj.left_only)
print "right_only:"+str(dirobj.right_only)
print "common_dirs:"+str(dirobj.common_dirs)
print "common_files:"+str(dirobj.common_files)
print "common_funny:"+str(dirobj.common_funny)
print "same_files:"+str(dirobj.same_files)
print "diff_files:" +str(dirobj.diff_files)
print "funny_files:"+str(dirobj.funny_files)

"""
left,左目录
right, 右目录
left_list,左目录中得文件及目录列表
right_list, 右目录中得文件及目录表
common, 俩边文件共同存在的文件及目录
left_only,只在左侧文件和目录
right_only, 只在右侧文件和目录
common_dirs, 俩边目录都存在的子目录;
common_files,俩边目录都存在的子文件
common_funny, 俩边目录都存在的子目录(不同目录类型或os.stat()记录的错误);
same_files, 匹配相同文件
diff_files, 不匹配相同文件
funny_files, 俩边目录中都存在,但无法比较的文件
subdirs, 将 common_dirs 目录名映射到新的 dircmp 对象,格式化为字典类型
"""

