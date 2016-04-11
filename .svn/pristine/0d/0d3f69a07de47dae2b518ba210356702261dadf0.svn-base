#!/bin/bash

#########################################################################
#
# Cheney Hsu 201308018 v0.4
# 函数,主要用于移动文件生成对比数据.
#########################################################################


#引用变量文件,内部存在很多变量,定义变量集中化
source /usr/report/Variable.sh

#函数功能为移动上一次的文件为老文件,为对比做准备.
#作者 Cheney Hsu
#version 0.1
#磁盘
function DIFFMV {
 if [ -f "$TMPDIR_MOUDLE_LINUX/usr/report/diffdisk1" ]; then
          mv $TMPDIR_MOUDLE_LINUX/usr/report/diffdisk1 $TMPDIR_MOUDLE_LINUX/usr/report/diffdisk
   fi
   }
#用户
function DIFFMVUSER {
 if [ -f "$TMPDIR_MOUDLE_LINUX/usr/report/userdiff1" ]; then
          mv $TMPDIR_MOUDLE_LINUX/usr/report/userdiff1 $TMPDIR_MOUDLE_LINUX/usr/report/userdiff
   fi
   }
#网络
function DIFFMVNET {
 if [ -f "$TMPDIR_MOUDLE_LINUX/usr/report/netdiff1" ]; then
          mv $TMPDIR_MOUDLE_LINUX/usr/report/netdiff1 $TMPDIR_MOUDLE_LINUX/usr/report/netdiff
   fi
   }
#MOD
function DIFFMVMOD {
 if [ -f "$TMPDIR_MOUDLE_LINUX/usr/report/lsmoddiff1" ]; then
          mv $TMPDIR_MOUDLE_LINUX/usr/report/lsmoddiff1 $TMPDIR_MOUDLE_LINUX/usr/report/lsmoddiff
   fi
}

function DIFFINODE {
 if [ -f "$TMPDIR_MOUDLE_LINUX/usr/report/diffinode1" ]; then
          mv $TMPDIR_MOUDLE_LINUX/usr/report/diffinode1 $TMPDIR_MOUDLE_LINUX/usr/report/diffinode
   fi
   }
