###################################################
# used to Collection weblogic information
# script by pythnn
# writed by dlh 
# 2012/11/15
#-------------------------------------------------
# writed by dlh
# modify import commands.getstatusoutput hostname
# 2012/12/05
###################################################



#! /usr/bin/python
if __name__ == '__main__': 

        from wlstModule import *#@UnusedWildImport

from  time import strftime,localtime
#from  commands  import getstatusoutput
from  socket import gethostname

print 'starting the script ....'
connect(sys.argv[1],sys.argv[2],sys.argv[3])


domainConfig()
JDBCSystemResources=cmo.getJDBCSystemResources()
DCServersTrees=cmo.getServers()
DCWebappsTrees=cmo.getAppDeployments()

#a,hname=getstatusoutput('hostname')
hname=gethostname().split('.')[0]
domainame=cmo.getName()
#############################################################  domain  ##################################
filename="../file/"+hname+'_'+strftime('%Y-%m-%d',localtime())+'_domain.txt'

filehandle=open(filename,'a')

if(get('ProductionModeEnabled')> 0):

        filehandle.write(cmo.getDomainVersion()+'|'+domainame+'|'+ cmo.getRootDirectory()+'|'+'ture\n')
else:
        filehandle.write(cmo.getDomainVersion()+'|'+domainame+'|'+ cmo.getRootDirectory()+'|'+'false\n')

filehandle.close()

#############################################################  Server  ##################################
filename="../file/"+hname+'_'+strftime('%Y-%m-%d',localtime())+'_server.txt'

filehandle=open(filename,'a')

for DCServersTree in DCServersTrees:
    filehandle.write(domainame+'|'+str(DCServersTree.getName())+'|'+str(DCServersTree.getListenAddress())+'|'+str(DCServersTree.getListenPort())+'|'+ str(DCServersTree.getMachine())+'|'+str(DCServersTree.getCluster())+'\n')

filehandle.close()
#############################################################  Webapp  ##################################
filename="../file/"+hname+'_'+strftime('%Y-%m-%d',localtime())+'_webapp.txt'
filetarg="../file/"+hname+'_'+strftime('%Y-%m-%d',localtime())+'_webapp_target.txt'
filehandle=open(filename,'a')
    
for DCWebappsTree in DCWebappsTrees:
    appname=DCWebappsTree.getApplicationName()
    cd ('/AppDeployments/'+appname+'/Targets')
    Targets=list(ls(returnMap='true'))
    
    filehandle.write(domainame+'|'+str(appname)+'|'+str(DCWebappsTree.getAbsoluteSourcePath())+'|'+str(DCWebappsTree.getStagingMode())+'\n')

    filetarghd=open(filetarg,'a')
    for x in Targets:
        filetarghd.write(domainame+'|'+str(appname)+'|'+str(x)+'\n')

    filetarghd.close()  

filehandle.close()

#############################################################  JDBC  ##################################    
filename="../file/"+hname+'_'+strftime('%Y-%m-%d',localtime())+'_jdbc.txt'
filetarg="../file/"+hname+'_'+strftime('%Y-%m-%d',localtime())+'_jdbc_target.txt'
filehandle=open(filename,'a')

for JDBCSystemResource in JDBCSystemResources:
    
    dataSname=JDBCSystemResource.getName()
    
    Targets=JDBCSystemResource.getTargets()
    cd('/SystemResources/'+dataSname+'/Targets')
    Targets=list(ls(returnMap='true'))
    JDBCResource=JDBCSystemResource.getJDBCResource()
    
    erverJDBCResource=JDBCResource.getJDBCConnectionPoolParams()
    
    JDBCDriverParams=JDBCResource.getJDBCDriverParams()
    JDBCDataSourceParams=JDBCResource.getJDBCDataSourceParams()
    
    JNDINamestr=str(JDBCDataSourceParams.getJNDINames())
    laba=int(JNDINamestr.index("['"))+2
    labb=int(JNDINamestr.index("']"))
    JNDIName=JNDINamestr[laba:labb]

    filehandle.write(domainame+'|'+dataSname+'|'+str(erverJDBCResource.getCapacityIncrement())+'|'+str(erverJDBCResource.getInitialCapacity())+'|'+str(erverJDBCResource.getMaxCapacity())+'|'+str(erverJDBCResource.getInactiveConnectionTimeoutSeconds())+'|'+str(erverJDBCResource.getShrinkFrequencySeconds())+'|'+str(JDBCDriverParams.getUrl())+'|'+str(JDBCDriverParams.getDriverName())+'|'+JNDIName+'\n')
    filetarghd=open(filetarg,'a')
    for x in Targets:
        filetarghd.write(domainame+'|'+dataSname+'|'+str(x)+'\n') 
    filetarghd.close()
       
filehandle.close()

#############################################################  JVM ##################################
filename="../file/"+hname+'_'+strftime('%Y-%m-%d',localtime())+'_jvm.txt'

filehandle=open(filename,'a')

domainRuntime()

allServers=domainRuntimeService.getServerRuntimes()

for tempServer in allServers:
    RTServerName=str(tempServer.getName())
    JVMRuntime=tempServer.getJVMRuntime()
    filehandle.write(domainame+'|'+RTServerName+'|'+str(JVMRuntime.getJavaVMVendor())+'|'+str(JVMRuntime.getOSName())+'|'+str(JVMRuntime.getHeapSizeMax())+'|'+str(JVMRuntime.getHeapSizeCurrent())+'\n')
    
filehandle.close()


disconnect()
