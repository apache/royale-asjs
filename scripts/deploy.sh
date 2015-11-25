#!/bin/bash
################################################################################
##
##  Licensed to the Apache Software Foundation (ASF) under one or more
##  contributor license agreements.  See the NOTICE file distributed with
##  this work for additional information regarding copyright ownership.
##  The ASF licenses this file to You under the Apache License, Version 2.0
##  (the "License"); you may not use this file except in compliance with
##  the License.  You may obtain a copy of the License at
##
##      http://www.apache.org/licenses/LICENSE-2.0
##
##  Unless required by applicable law or agreed to in writing, software
##  distributed under the License is distributed on an "AS IS" BASIS,
##  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
##  See the License for the specific language governing permissions and
##  limitations under the License.
##
################################################################################

# copyFileOrDirectory from ADOBE_FLEX_SDK_DIR to IDE_SDK_DIR
#   param1 is file or directory to copy
copyFileOrDirectory()
{
    f="$1"
    
    dir=`dirname "${BASEDIR}/$f"`
	
    echo Copying $f to ${dir}
    
    if [ -f "${FLEX_SDK_DIR}/$f" ] ; then
        mkdir -p "${dir}"
        cp -p "${FLEX_SDK_DIR}/$f" "${BASEDIR}/$f"
    fi

    if [ -d "${FLEX_SDK_DIR}/$f" ] ; then
        rsync --archive --ignore-existing --force "${FLEX_SDK_DIR}/$f" "${dir}"
    fi
}

i=0
argv=()
for arg in "$@"; do
    argv[$i]="$arg"
    i=$((i + 1))
done

if [ "${argv[0]}" = "" ] 
    then
    echo "Usage: deploy.sh <path to existing Apache Flex SDK>"
    exit
fi
if [ "$GOOG_HOME" = "" ]
    then
	echo "GOOG_HOME environment variable not set.  Set to folder (usually called library) containing closure folder from Google Closure library"
	exit
fi
if [ "$JAVA_HOME" = "" ]
    then
	JAVA_HOME="/System/Library/Java/JavaVirtualMachines/1.6.0.jdk/Contents/Home"
fi

FLEX_SDK_DIR="${argv[0]}"
RELBASEDIR=$(dirname $0)
if [ "$RELBASEDIR" = "" ]
	then
	echo "Could not determine script folder.  Did you use '. deploy.sh' instead of './deploy.sh'?"
	exit
fi
BASEDIR=`cd "$RELBASEDIR"; pwd`

echo "Copying AIR and Flash SDK from ${FLEX_SDK_DIR} to ${BASEDIR}"
files=(
    "AIR SDK license.pdf" 
    "AIR SDK Readme.txt" 
    bin/adl.exe 
    bin/adt.bat 
    frameworks/libs/air
    frameworks/libs/player
    frameworks/projects/air
    include
    install/android
    lib/adt.jar 
    lib/android
    lib/aot
    lib/nai
    lib/win
    runtimes
    samples/badge
    samples/descriptor-sample.xml
    samples/icons
    templates/air
    templates/extensions)
for file in "${files[@]}" 
do
    copyFileOrDirectory "$file"
done

copyFileOrDirectory ide/flashbuilder/flashbuilder-config.xml
copyFileOrDirectory frameworks/mxml-manifest.xml
copyFileOrDirectory frameworks/spark-manifest.xml
copyFileOrDirectory frameworks/themes/Halo/halo.swc
copyFileOrDirectory frameworks/macfonts.ser
copyFileOrDirectory frameworks/winfonts.ser
cp frameworks/air-config.xml frameworks/airmobile-config.xml
mkdir frameworks/locale
mkdir frameworks/mx
mkdir frameworks/projects
mkdir frameworks/rsls


echo "Setting up Launch Configs"
./setuplaunches.sh "$BASEDIR" $JAVA_HOME/bin/java
