#!/bin/sh

# @(#)zamboni        A.02.01     04/03/00                                 =*=



################################################################

# Program for Zamboni Data Collection                          #

# Note:                                                        #

# The directory containing the log files must be the current   #

# directory when this script is executed.                      #

################################################################



# Set the version

ZAM_VERSION="A.02.01     04/03/00"

USAGE="usage: zamboni.scr [-a] [+k]"



# Check if the debug flag is set

if [ -n "${ZAMDEBUG}" ]

then

  set -x

fi # End check debug



# Specify the installation workfiles

# INSTALL_DIR="."

CMD_LOG="./zamboni.log"

#LOCK="/usr/tmp/zamboni.lock"





check_os() {

  #

  # Check the operating system of the MeasureWare agent

  #



  # Check if the debug flag is set

  if [ -n "${ZAMDEBUG}" ]

  then

    set -x

  fi # End check debug



  # Log command

  echo "Retrieve the Operating System information." >>${CMD_LOG}



  # Initialize the directory vars

  LOG_DIR=

  BIN_DIR=

  PERF_DIR=



  # Get the operating system version.

  VERSION="`uname -r`" >/dev/null 2>>${CMD_LOG}



  # Get the operating system name.

  case `uname -s` in

    *HP-UX)

      SYS="HP-UX"

      echo ${VERSION} | grep "10" >/dev/null 2>&1



      # Check the status of the grep

      if [ "$?" != "0" ]

      then

        # OS is not HP-UX 10

        HPUX10="false"

        BIN_DIR="/usr/perf/bin"

        if [ "${HAVEPARM}" = "false" ]

        then

           #LOGNAME="/usr/perf/log/${SYSNAME}/logglob"

           LOGNAME="${PWD}/logglob"

        else

           LOGNAME=${PARM1}

        fi



      else # status version



        # OS is HP-UX 10

        HPUX10="true"

        LOG_DIR="/var/opt/perf"

        BIN_DIR="/opt/perf/bin"

        PERF_DIR="/opt/perf"

        PATH=${PATH}:/opt/perf/bin

        if [ "${HAVEPARM}" = "false" ]

        then

           #LOGNAME="/var/opt/perf/logglob"

           LOGNAME="${PWD}/logglob"

        else

           LOGNAME=${PARM1}

        fi



      fi # End version

    ;; # End hp-ux



    *)

      # Operating system does not support MeasureWare Netscape-Webser measurement.

      echo " >>> This integration can only be done on a system with"

      echo " >>> MeasureWare installed and will only support the HP-UX 10.x"

      echo " >>> operating system."

      echo " "





    ;; # End other

  esac # End os type



  # Log command

  echo " OS is ${SYS} ${VERSION}." >>${CMD_LOG}

  echo " "                                                >>${CMD_LOG}



} # End check_os







write_confrep() {

cat <<==EndReport== > zamconf.rep

  report "CONFHEAD <V>2.1 HPUX <S>!SYSTEM_ID <D>!DATE <T>!TIME <L>!LOGFILE <C>!COLLECTOR <*>"

  format datafile"

  headings=on

  separator=","

  DATA TYPE CONFIGURATION

   record_type

   date

   time

*

   GBL_SYSTEM_ID

   GBL_COLLECTOR

   GBL_OSNAME

   GBL_OSRELEASE

   GBL_MACHINE

   GBL_NUM_CPU

   GBL_NUM_DISK

   GBL_NUM_NETWORK

   GBL_MEM_PHYS

   GBL_MEM_AVAIL

   GBL_LOGGING_TYPES

   GBL_LOGFILE_VERSION

   GBL_MACHINE_MODEL

   GBL_OSVERSION

* End of File

==EndReport==

} # End write_globs



write_globsrep() {

cat <<==EndReport== > zamglobs.rep

*----------------------------------------------------------------------

* ZAMGLOBS.REP 3/6/00

* This is a report file used to export MWA data for use by Zamboni

*---------------------------------------------------------------------

report "GSUMHEAD  HPUX Global Summary Data for !SYSTEM_ID"

format DATAFILE

headings=on

separator=","

DATA TYPE GLOBAL

  record_type

  date

  time

  interval

  gbl_proc_sample

*

  GBL_CPU_TOTAL_UTIL

  GBL_DISK_UTIL_PEAK

  GBL_DISK_VM_READ_RATE

  GBL_DISK_VM_WRITE_RATE

*

  GBL_PRI_QUEUE

  GBL_DISK_SUBSYSTEM_QUEUE

  GBL_MEM_QUEUE

*

  GBL_CPU_SYSCALL_UTIL

  GBL_CPU_NORMAL_UTIL

  GBL_CPU_NICE_UTIL

  GBL_CPU_CSWITCH_UTIL

  GBL_CPU_INTERRUPT_UTIL

  GBL_CPU_REALTIME_UTIL

*

  GBL_DISK_LOGL_IO_RATE

  GBL_DISK_PHYS_IO_RATE

* Total of 20 GSUM metrics to this point

*

* Additional Memory metrics

*

  GBL_MEM_CACHE_HIT_PCT

  GBL_MEM_UTIL

  GBL_MEM_SYS_AND_CACHE_UTIL

  GBL_MEM_USER_UTIL

  GBL_MEM_PAGE_REQUEST_RATE

  GBL_MEM_PAGEOUT_RATE

  GBL_MEM_SWAPOUT_RATE

  GBL_MEM_ACTIVE_VIRT_UTIL

  GBL_SWAP_SPACE_UTIL

*

* Additional System Activity metrics

  GBL_SYSCALL_RATE

  GBL_ALIVE_PROC

  GBL_ACTIVE_PROC

*

* Additional Queueing metric

  GBL_NETWORK_SUBSYSTEM_QUEUE

* Total of 33 GSUM metrics to this point

*

* That's all folks!

==EndReport==

} # End write_globs



write_globdrep() {

cat <<==EndReport== > zamglobd.rep

*---------------------------------------------------------------------"

* ZAMGLOBD.REP

* This is a report file used to export MWA data for use by Zamboni

*---------------------------------------------------------------------

report "GLOBHEAD  HPUX Global Detail Data for !SYSTEM_ID"

format datafile

headings=on

separator=","

DATA TYPE GLOBAL

  record_type

  date

  time

  interval

  gbl_proc_sample

*

  GBL_CPU_SYSCALL_UTIL

  GBL_CPU_NORMAL_UTIL

  GBL_CPU_NICE_UTIL

  GBL_CPU_CSWITCH_UTIL

  GBL_CPU_INTERRUPT_UTIL

  GBL_CPU_REALTIME_UTIL

  GBL_CPU_TOTAL_UTIL

  GBL_CPU_TOTAL_TIME

*

* That's all

==EndReport==

} # End write_globsrep



write_disksrep() {

cat <<==EndReport== > zamdisks.rep

  *---------------------------------------------------------------------"

  * ZAMDISKS.REP

  * This is a report file used to export MWA data for use by LaserView

  *---------------------------------------------------------------------

  report "DSUMHEAD   HPUX Disk Summary Data for !SYSTEM_ID"

  format datafile

  headings=on

  separator=","

  DATA TYPE DISK

  layout single

  record_type

  date

  time

  interval

  *

  BYDSK_ID

  BYDSK_DEVNAME

  BYDSK_UTIL

  BYDSK_PHYS_READ_RATE 

  BYDSK_PHYS_WRITE_RATE

  BYDSK_REQUEST_QUEUE

  *

  * That's all folks!

==EndReport==

} # End write_disksrep


write_lvmrep() {

cat <<==EndReport== > zamlvm.rep

  *---------------------------------------------------------------------"

  * ZAMLVM.REP

  * This is a report file used to export MWA data for use by LaserView

  *---------------------------------------------------------------------

  report "DSUMHEAD   HPUX LVM Summary Data for !SYSTEM_ID"

  format datafile

  headings=on

  separator=","

  DATA TYPE LV
  layout single

  record_type

  date

  time

  interval

  *

  LV_READ_RATE 
  LV_LOGL_READ 
  LV_WRITE_RATE  
  LV_LOGL_WRITE 
  LV_READ_BYTE_RATE 
  LV_WRITE_BYTE_RATE 
  LV_SPACE_UTIL 
  * That's all folks!  

==EndReport==

} # End write_lvmrep



write_lansrep() {

cat <<==EndReport== > zamlans.rep

  *---------------------------------------------------------------------"

  * ZAMLANS.REP

  * This is a report file used to export MWA data for use by LaserView

  *---------------------------------------------------------------------

  report "NSUMHEAD   HPUX LAN Summary Data for !SYSTEM_ID"

  format datafile

  headings=on

  separator=","

  DATA TYPE NETIF

  layout single

  record_type

  date

  time

  interval

  *

  BYNETIF_NAME

  BYNETIF_IN_PACKET_RATE

  BYNETIF_OUT_PACKET_RATE

  BYNETIF_COLLISION_RATE

  *

* That's all folks!

==EndReport==

}



write_applsrep() {

cat <<==EndReport== > zamappls.rep

  *----------------------------------------------------------

  * ZAMAPPLS.REP  10/25/96

  *----------------------------------------------------------

  report "ASUMHEAD  Application Summary Data for !SYSTEM_ID"

  format datafile

  headings=on

  separator=","

  DATA TYPE APPLICATION

    record_type

    date

    time

    interval

    app_sample

*

    APP_NUM

    APP_NAME

    APP_CPU_TOTAL_UTIL

    APP_DISK_PHYS_IO_RATE

*

* That's all folks

==EndReport==

} # End write_applsrep



print_error() {

  #

  # Print error function.

  #



  # Check if the debug flag is set

  if [ -n "${ZAMDEBUG}" ]

  then

    set -x

  fi # End debug



  echo " "

  echo "--------------------------------------------------------------------"

  echo "| Check the logfile ${CMD_LOG} for errors, correct them and "

  echo "|"

  echo "| for error(s), correct error(s) and re-execute this installation."

  echo "--------------------------------------------------------------------"

  echo " "



} # End print_error





#######################

# Main body of script #

#######################



if [ $# = 0 ]

then

   HAVEPARM="false"

else

   HAVEPARM="true"

   PARM1=$1

fi



appls=on       # application info is exported if appls=on

keepreps=off   # the report files are not deleted if keepreps=on



while getopts :ak arguments

do

  case $arguments in

     a) appls=off;;

    +k) keepreps=on;;

    \?) print "$OPTARG is not a valid switch"

        print "$USAGE";;

  esac

done

#print "appls = $appls; keepreps = $keepreps"



SYSNAME=`uname -n`



# Remove the command logfile

rm -f ${CMD_LOG} >/dev/null 2>&1



echo " "

echo "------------------------------------------"

echo "MeasureWare -> Zamboni Data Export        "

echo "------------------------------------------"

echo " "



# Log the start of the command

echo "-------------------------------------------"       >>${CMD_LOG}

echo "MeasureWare -> Zamboni Data Export         "       >>${CMD_LOG}

echo " `date`  "                                         >>${CMD_LOG}

echo "-------------------------------------------"       >>${CMD_LOG}

echo " "                                                 >>${CMD_LOG}

echo "Script file version ${ZAM_VERSION}"                >>${CMD_LOG}



# Check the OS

#check_os

# The check_os call has been temporarily commented out

# The following variables assignments will not work on 

# a HPUX 9.0 system. It should work for 10.x and 11.x

# systems.

    HPUX10="true"

    LOG_DIR="/var/opt/perf"

    BIN_DIR="/opt/perf/bin"

    PERF_DIR="/opt/perf"

    PATH=${PATH}:/opt/perf/bin

    LOGNAME="${PWD}/logglob"



echo "Exporting data from  ${LOGNAME}"



if [ ! -r ${LOGNAME} ]

then

   echo "${LOGNAME} was not found "

   #echo "This script file must be in the same directory"

   #echo "as the MeasureWare logfiles"

   echo " "

   echo "${LOGNAME} was not found " >>${CMD_LOG}

   #echo "No logfiles found in the current directory: $PWD " >>${CMD_LOG}

   echo " " >>${CMD_LOG}

   exit 1

fi



# Write the report files

echo "Writing report files"

echo "Writing report files" >>${CMD_LOG}

write_confrep

write_globsrep

write_globdrep

write_lansrep

write_applsrep

write_disksrep

write_lvmrep



#write_extcommand



# Execute extract

echo "Exporting with ${BIN_DIR}/extract"

echo "Exporting with ${BIN_DIR}/extract" >>${CMD_LOG}



echo "Exporting data from logfiles in $PWD"

echo "Exporting data from logfiles in $PWD" >>${CMD_LOG}

echo " "

echo " " >>${CMD_LOG}

echo "Exporting configuration information"

echo "Exporting configuration information" >>${CMD_LOG}

${BIN_DIR}/extract -b last-6 -c -r zamconf.rep -l $PWD/logglob -f zamdata.csv,purge  -xp >/dev/null 2>&1

#

echo "Exporting global summary data"

echo "Exporting global summary data" >>${CMD_LOG}

${BIN_DIR}/extract -b last-6 -G -r zamglobs.rep -l $PWD/logglob -f zamdata.csv,append -xp >/dev/null 2>&1

#

echo "Exporting global detail data"

echo "Exporting global detail data"  >>${CMD_LOG}

${BIN_DIR}/extract -b last-6 -g -r zamglobd.rep -l $PWD/logglob -f zamdata.csv,append -xp >/dev/null 2>&1

#

echo "Exporting global network data"

echo "Exporting global network data" >>${CMD_LOG}

${BIN_DIR}/extract -b last-6 -N -r zamlans.rep  -l $PWD/logglob -f zamdata.csv,append -xp >/dev/null 2>&1

#

if [ "$appls" = "on" ]

then

  echo "Exporting global application data"

  echo "Exporting global application data"  >>${CMD_LOG}

  ${BIN_DIR}/extract -b last-6 -A -r zamappls.rep -l $PWD/logglob -f zamdata.csv,append -xp >/dev/null 2>&1

else

  echo "Skipping application data"

  echo "Skipping application data"  >>${CMD_LOG}

fi

#

echo "Exporting global disk data"

echo "Exporting global disk data"   >>${CMD_LOG}

${BIN_DIR}/extract -b last-6 -D -r zamdisks.rep -l $PWD/logglob -f zamdata.csv,append -xp >/dev/null 2>&1

#
#

echo "Exporting global LVM data"

echo "Exporting global LVM data"   >>${CMD_LOG}

${BIN_DIR}/extract -b last-6 -Z -r zamlvm.rep -l $PWD/logglob -f zamdata.csv,append -xp >/dev/null 2>&1

#

echo " "

echo " " >>${CMD_LOG}

#



if [ "$keepreps" = "off" ]

then

   rm *.rep

   echo "Report files (zam*.rep) removed"

   echo "Report files (zam*.rep) removed" >>${CMD_LOG}

else

   echo "Report files (zam*.rep) not removed"

   echo "Report files (zam*.rep) not removed" >>${CMD_LOG}

fi



echo "Exporting completed"

echo "Exporting completed" >>${CMD_LOG}

# End of Program 






