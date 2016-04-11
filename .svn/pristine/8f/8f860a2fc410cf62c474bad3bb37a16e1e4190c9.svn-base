#coding=utf-8
#!/usr/bin/python
import re
import os
import time

import utils
def sortedDictValues3(adict):
    keys = adict.keys()
    keys.sort()
    return map(adict.get, keys)

def run():
    if utils.isLinux() == False:
        return [('ifconfig_collect os type error','this is windows')]
    #not first run
    if os.path.isfile('./oldifconfig'):
        fileold = open('./oldifconfig', 'r')
        fileold.seek(0)
        #读入上次记录的临时流量数据文件，和时间戳
        (oldtime, fileoldcontent) = fileold.read().split('#')
        fileold.close;
        netcard = {}
        tempstr = ''
        key = ''
        for strline in fileoldcontent.split('/n'):
            reobj = re.compile('^lo*.')
            if reobj.search(strline):
                break;
            reobj = re.compile('^eth*.')
            if reobj.search(strline):
                key = strline.split()[0]
            tempstr = tempstr + strline + '/n'
            netcard[key] = tempstr
        RXold = {}
        TXold = {}
        for key,value in netcard.items():
            tempsplit = value.split('/n')
            netcard[key] = ''
            for item in tempsplit:
                item = item + '<br>'
                netcard[key] = netcard[key] + item
                tempcount = 1
                for match in re.finditer("(bytes:)(.*?)( /()", item):
                    if tempcount == 1:
                        RXold[key] = match.group(2)
                        tempcount = tempcount + 1
                    elif tempcount == 2:
                        TXold[key] = match.group(2)
                        netcard[key] = netcard[key] + 'net io percent(bytes/s): 0 <br>'

        #记录当前网卡信息到临时文件中
        os.system('ifconfig > ifconfigtemp')
        file = open('./ifconfigtemp','r');
        fileold = open('./oldifconfig', 'w')
        temptimestr = str(int(time.time()));
        fileold.write(temptimestr)
        fileold.write('#')
        file.seek(0)
        fileold.write(file.read())
        fileold.close()
        returnkeys = []
        returnvalues = []
        netcard = {}
        tempcountcard = 0
        file.seek(0)
        key = ''
        for strline in file.readlines():
            reobj = re.compile('^lo*.')
            if reobj.search(strline):
                break;
            reobj = re.compile('^eth*.')
            if reobj.search(strline):
                key = strline.split()[0]
                netcard[key] = ''
            netcard[key] = netcard[key] + strline
        newnetcard = {}
        file.seek(0)
        key = ''
        for strline in file.readlines():
            reobj = re.compile('^lo*.')
            if reobj.search(strline):
                break;
            if re.search("^eth", strline):
                templist = strline.split()
                key = templist[0]
                newnetcard[key] = ''
                newnetcard[key] = templist[4] + newnetcard[key] + ' '
            if re.search("^ *inet ", strline):
                templist = strline.split()
                newnetcard[key] = templist[1][5:] + ' ' + newnetcard[key] + ' '
        for key,value in newnetcard.items():
            #记录每张网卡是否工作状态信息到临时文件
            os.system('ethtool %s > ethtooltemp'%(key))
            file = open('./ethtooltemp','r');
            tempethtooltemplist = file.read().split('/n/t')
            file.close
            if re.search("yes", tempethtooltemplist[-1]):
                templist = newnetcard[key].split()
                newnetcard[key] = templist[0] + ' runing! ' + templist[1]
            else:
                templist = newnetcard[key].split()
                if len(templist) > 1:
                    newnetcard[key] = templist[0] + ' stop! ' + templist[1]
                else:
                    newnetcard[key] =  'stop! ' + templist[0]
        file.close()
        RX = {}
        TX = {}
        for key,value in netcard.items():
            tempsplit = value.split('/n')
            netcard[key] = ''
            for item in tempsplit:
                item = item + '<br>'
                netcard[key] = netcard[key] + item
                tempcount = 1
                for match in re.finditer("(bytes:)(.*?)( /()", item):
                    if tempcount == 1:
                        RX[key] = str(int(match.group(2)) - int(RXold[key]))
                        tempcount = tempcount + 1
                    elif tempcount == 2:
                        TX[key] = str(int(match.group(2)) - int(TXold[key]))
                        divtime = float(int(time.time()) - int(oldtime))
                        if divtime == 0:
                            rate = (float(TX[key]) + float(RX[key]))
                        else:
                            rate = (float(TX[key]) + float(RX[key]))/(divtime)
                        if rate == 0:
                            newnetcard[key] = '0' + ' ' + newnetcard[key]
                        else:
                            newnetcard[key] = '%.2f'%rate + ' ' + newnetcard[key]
        return zip(['order'], ['48']) + newnetcard.items();
    else:
        os.system('ifconfig > ifconfigtemp')
        file = open('./ifconfigtemp','r');
        fileold = open('./oldifconfig', 'w')
        temptimestr = str(int(time.time()));
        fileold.write(temptimestr)
        fileold.write('#')
        file.seek(0)
        fileold.write(file.read())
        fileold.close()

        netcard = {}
        file.seek(0)
        key = ''
        for strline in file.readlines():
            reobj = re.compile('^lo*.')
            if reobj.search(strline):
                break;
            reobj = re.compile('^eth*.')
            if reobj.search(strline):
                key = strline.split()[0]
                netcard[key] = ''
            netcard[key] = netcard[key] + strline
        RX = {}
        TX = {}

        key = ''
        newnetcard = {}
        file.seek(0)
        for strline in file.readlines():
            reobj = re.compile('^lo*.')
            if reobj.search(strline):
                break;
            if re.search("^eth", strline):
                templist = strline.split()
                key = templist[0]
                newnetcard[key] = templist[4] + ' '
            if re.search("^ *inet ", strline):
                templist = strline.split()
                newnetcard[key] = newnetcard[key] + templist[1][5:] + ' '
        for key,value in newnetcard.items():
            os.system('ethtool %s > ethtooltemp'%(key))
            file = open('./ethtooltemp','r');
            tempethtooltemplist = file.read().split('/n')
            file.close
            if re.search("yes", tempethtooltemplist[-1]):
                newnetcard[key] = newnetcard[key] + 'runing!'
            else:
                newnetcard[key] = newnetcard[key] + 'stop!'
        file.close()
        for key,value in netcard.items():
            tempsplit = value.split('/n')
            netcard[key] = ''
            for item in tempsplit:
                item = item + '<br>'
                #print item
                netcard[key] = netcard[key] + item
                tempcount = 1
                for match in re.finditer("(bytes:)(.*?)( /()", item):
                    if tempcount == 1:
                        RX[key] = match.group(2)
                        tempcount = tempcount + 1
                    elif tempcount == 2:
                        TX[key] = match.group(2)
                        netcard[key] = netcard[key] + 'net io percent(bytes/s): 0 <br>'
                        newnetcard[key] = newnetcard[key] + ' ' + '0 <br>'
        return zip(['order'], ['48']) + newnetcard.items();
if __name__ == '__main__':
    print run()
