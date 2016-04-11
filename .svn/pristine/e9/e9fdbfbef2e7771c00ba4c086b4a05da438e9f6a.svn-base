#!/usr/bin/env  python
#-*- coding:utf-8 -*-
# Revision:    1.0
### END INIT INFO


"""
-   包含在第一个序列行中,但不包含在第二个序列行中
+   包含在第二个序列行中,但不包含在第一个序列行中
''  俩个序列行一致
'?'  标准俩个序列行存在增量差异
'^'  标识出俩个学历航存在差异字符
"""

__author__ = 'KK'

import difflib

text1="""
this modlue provides classes and funcitons for comparing sequences.
including HTML and context and unified diffs.
difflib document v7.4
add string
"""
text1_lines=text1.splitlines()

text2="""
this module provides classes and cunftions for Comparing sequences.
including HTML and contexzt and unified diffs.
difflib covument v7.5"""

text2_lines=text2.splitlines()
d =difflib.Differ()
diff = d.compare(text1_lines,text2_lines)
print '\n'.join(list(diff))

d = difflib.HtmlDiff()
print d.make_file(text1_lines,text2_lines)

