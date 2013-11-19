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

i=0
argv=()
for arg in "$@"; do
    argv[$i]="$arg"
    i=$((i + 1))
done

if [ "${argv[0]}" = "" ] 
    then
    echo "Usage: deploy.sh <path to existing Apache Flex SDK> <path to new folder>"
    exit
fi
if [ "${argv[1]}" = "" ] 
    then
    echo "Usage: deploy.sh <path to existing Apache Flex SDK> <path to new folder>"
    exit
fi
if [ -d "${argv[1]}" ]
    then
    echo "Error: folder already exists"
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

echo "Copying Apache Flex SDK (be patient, lots of files)..."
mkdir -pv "${argv[1]}"
if [ ! -d "${argv[1]}" ]
    then
    echo "Error: creating destination folder '${argv[1]}'"
    exit
fi
DESTDIR=`cd "${argv[1]}"; pwd`
cp -r "${argv[0]}"/* "$DESTDIR"

BASEDIR=$(dirname $0)
echo "Installing FlexJS files from $BASEDIR to $DESTDIR"

echo "Removing Flex files"
rm -f "$DESTDIR/ant/lib"/*
rm "$DESTDIR/bin"/*
rm "$DESTDIR/lib/asc.jar"
rm "$DESTDIR/lib/asdoc.jar"
rm "$DESTDIR/lib/batik-all-flex.jar"
rm "$DESTDIR/lib/compc.jar"
rm "$DESTDIR/lib/copylocale.jar"
rm "$DESTDIR/lib/digest.jar"
rm "$DESTDIR/lib/fcsh.jar"
rm "$DESTDIR/lib/fdb.jar"
rm "$DESTDIR/lib/flex-compiler-oem.jar"
rm "$DESTDIR/lib/fxgutils.jar"
rm "$DESTDIR/lib"/mxmlc_*.jar
rm "$DESTDIR/lib/optimizer.jar"
rm "$DESTDIR/lib/swcdepends.jar"
rm "$DESTDIR/lib/swfdump.jar"
rm "$DESTDIR/lib/swfutils.jar"
rm "$DESTDIR/lib/velocity-dep-1.4-flex.jar"
rm -r "$DESTDIR/lib/external"/*
rmdir "$DESTDIR/lib/external"
rm "$DESTDIR/flex-sdk-description.xml"
rm "$DESTDIR/frameworks/flex-config.xml"
rm "$DESTDIR/frameworks/libs/automation"/*
rmdir "$DESTDIR/frameworks/libs/automation"
rm "$DESTDIR/frameworks/libs/mobile"/*
rmdir "$DESTDIR/frameworks/libs/mobile"
rm "$DESTDIR/frameworks/libs/mx"/*
# rmdir "$DESTDIR/frameworks/libs/mx"  FB needs this
rm "$DESTDIR/frameworks/libs"/*

echo "Copying Falcon files"
mkdir -p "$DESTDIR/ant/lib"
cp -r "$BASEDIR/ant/lib"/* "$DESTDIR/ant/lib"
cp -r "$BASEDIR/bin"/* "$DESTDIR/bin"
mkdir "$DESTDIR/bin-legacy"
cp -r "$BASEDIR/bin-legacy"/* "$DESTDIR/bin-legacy"
cp -r "$BASEDIR/lib"/* "$DESTDIR/lib"

echo "Copying FalconJS files"
mkdir "$DESTDIR/js"
cp -r "$BASEDIR/js"/* "$DESTDIR/js"

echo "Copying FlexJS files"
cp -r "$BASEDIR/frameworks/libs"/* "$DESTDIR/frameworks/libs"
mkdir "$DESTDIR/frameworks/as"
mkdir "$DESTDIR/frameworks/as/src"
cp -r "$BASEDIR/frameworks/src"/* "$DESTDIR/frameworks/as/src"

mv "$DESTDIR/frameworks/as/src/basic-manifest.xml" "$DESTDIR/frameworks"
mv "$DESTDIR/frameworks/as/src/html5-manifest.xml" "$DESTDIR/frameworks"
mv "$DESTDIR/frameworks/as/src/flex-sdk-description.xml" "$DESTDIR"
mv "$DESTDIR/frameworks/as/src/flex-config.xml" "$DESTDIR/frameworks"

# needed for AIR apps
cp "${argv[0]}/bin/adl" "$DESTDIR/bin"
cp "${argv[0]}/bin/adt" "$DESTDIR/bin"

./setuplaunches.sh "$DESTDIR" $JAVA_HOME/bin/java
