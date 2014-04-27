#!/bin/bash

# Title: Things Extract Script for GeekTool
# Author: Alex Wasserman
# Description: Extracts the currents items from Things database, stores in a temp file. Outputs tmp file if Things DB is locked in use.

# Things SQL Library
export SQL_LIBRARY="ThingsLibrary.db"
export LIB_DIR="/Users/khrome/Library/Containers/com.culturedcode.things/Data/Library/Application Support/Cultured Code/Things"
export THINGS_DB=${LIB_DIR}/${SQL_LIBRARY}

# Temp files
export TMP_FILE="/tmp/things_geeklet_tmp"
export OUTPUT_FILE="/tmp/things_geeklet_output"

# EDIT THIS TO CHANGE SQL USED
# export SQL="select ZTITLE from ZTHING where ZTRASHED=0 and ZSTATUS=0 and ZSTART=1 and ZFOCUSLEVEL1 !=2 order by ZDUEDATE;"
#export SQL="select '1', 'TODAY' AS "TYPE", ZTITLE from ZTHING where ZTRASHED=0 AND ZSTATUS=0 AND ZFOCUSLEVEL IS NULL AND ZSCHEDULER=1 AND ZSTART=1
#UNION
#select '2', 'NEXT' AS "TYPE",  ZTITLE from ZTHING where ZTRASHED=0 AND ZSTATUS=0 AND ZFOCUSLEVEL IS NULL AND ZSCHEDULER IS NULL AND ZSTART=1
#UNION
#select '3', 'SCHEDULED' AS "TYPE",  ZTITLE from ZTHING where ZTRASHED=0 AND ZSTATUS=0 AND ZFOCUSLEVEL IS NULL AND ZSCHEDULER=1 AND ZSTART=2
#UNION
#select '4', 'SOMEDAY' AS "TYPE",  ZTITLE from ZTHING where ZTRASHED=0 AND ZSTATUS=0 AND ZFOCUSLEVEL IS NULL AND ZSCHEDULER IS NULL AND ZSTART=2"

export SQL="select '1', 'TODAY' AS "TYPE", a.ZTITLE,  b.ZTITLE as "PROJECT" from ZTHING as a, ZTHING as b where a.ZPROJECT=b.Z_PK AND a.ZTRASHED=0 AND b.ZTRASHED=0 AND a.ZSTATUS=0  AND a.ZFOCUSLEVEL IS NULL AND a.ZSCHEDULER=1 AND a.ZSTART=1
UNION
select '2', 'NEXT' AS "TYPE", a.ZTITLE,  b.ZTITLE as "PROJECT" from ZTHING as a, ZTHING as b where a.ZPROJECT=b.Z_PK AND a.ZTRASHED=0 AND b.ZTRASHED=0 AND a.ZSTATUS=0  AND a.ZFOCUSLEVEL IS NULL AND a.ZSCHEDULER IS NULL AND a.ZSTART=1
UNION
select '3', 'SCHEDULED' AS "TYPE", a.ZTITLE,  b.ZTITLE as "PROJECT" from ZTHING as a, ZTHING as b where a.ZPROJECT=b.Z_PK AND a.ZTRASHED=0 AND b.ZTRASHED=0 AND a.ZSTATUS=0  AND a.ZFOCUSLEVEL IS NULL AND a.ZSCHEDULER=1 AND a.ZSTART=2
UNION
select '4', 'SOMEDAY' AS "TYPE", a.ZTITLE,  b.ZTITLE as "PROJECT" from ZTHING as a, ZTHING as b where a.ZPROJECT=b.Z_PK AND a.ZTRASHED=0 AND b.ZTRASHED=0 AND a.ZSTATUS=0  AND a.ZFOCUSLEVEL IS NULL AND a.ZSCHEDULER IS NULL AND a.ZSTART=2"


# Debug statements
# echo "Using Library: " $SQL_LIBRARY
# echo "From: " $LIB_DIR

# Check is Things DB exists, or exit
if [ -f "${THINGS_DB}" ]
	then :
	else
	echo "Database file doesn't exist: " "${THINGS_DB}"
	echo "Existing now"
	exit 125
fi

# Run our query, and store it in a temp file
sqlite3 -csv "${LIB_DIR}"/"${SQL_LIBRARY}" "$SQL" > $TMP_FILE 2>&1

# If the database is locked, output prior data, otherwise process tmp file to output file, then show it.
if [ `grep -c "Error: database is locked" $TMP_FILE` -eq 1 ]
	then
	echo "** CACHED **"
	cat $OUTPUT_FILE 
	else
	grep . $TMP_FILE | sort -n | awk -F, '{ print $3 " - " $4 " - " ($2 == "NEXT"?"\033[33m"$2"\033[0m":($2 == "TODAY"?"\033[31m"$2"\033[0m":$2)) }' | sed s/\"//g > $OUTPUT_FILE
	cat $OUTPUT_FILE
fi

exit 0




