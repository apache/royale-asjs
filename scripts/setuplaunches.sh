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
    echo "Usage: setuplaunches <absolute path to Apache Flex SDK> <absolute path to Java executable>"
    exit
fi
if [ "${argv[1]}" = "" ] 
    then
    echo "Usage: setuplaunches <absolute path to Apache Flex SDK> <absolute path to Java executable>"
    exit
fi
if [ ! -d "${argv[0]}/frameworks/" ]
    then
    echo "Error: not a valid SDK directory"
    exit
fi
if [ "$GOOG_HOME" = "" ]
    then
	echo "GOOG_HOME environment variable not set.  Set to folder (usually called library) containing closure folder from Google Closure library"
	exit
fi

BASEDIR=$(dirname $0)
FILENAME="FlexJS (Debug Build).launch"
echo "Creating FlexJS Debug Launch Configuration"
echo "<?xml version='1.0' encoding='UTF-8' standalone='no'?>" > "${argv[0]}/ide/flashbuilder/$FILENAME"
echo "<launchConfiguration type='org.eclipse.ui.externaltools.ProgramLaunchConfigurationType'>" >> "${argv[0]}/ide/flashbuilder/$FILENAME"
echo "<booleanAttribute key='org.eclipse.debug.core.appendEnvironmentVariables' value='false'/>" >> "${argv[0]}/ide/flashbuilder/$FILENAME"
echo "<listAttribute key='org.eclipse.debug.ui.favoriteGroups'>" >> "${argv[0]}/ide/flashbuilder/$FILENAME"
echo "<listEntry value='org.eclipse.ui.externaltools.launchGroup'/>" >> "${argv[0]}/ide/flashbuilder/$FILENAME"
echo "</listAttribute>" >> "${argv[0]}/ide/flashbuilder/$FILENAME"
echo "<stringAttribute key='org.eclipse.ui.externaltools.ATTR_LAUNCH_CONFIGURATION_BUILD_SCOPE' value='\${project}'/>" >> "${argv[0]}/ide/flashbuilder/$FILENAME"
echo "<stringAttribute key='org.eclipse.ui.externaltools.ATTR_LOCATION' value='${argv[1]}'/>" >> "${argv[0]}/ide/flashbuilder/$FILENAME"
echo "<stringAttribute key='org.eclipse.ui.externaltools.ATTR_TOOL_ARGUMENTS' value='-Xmx384m -Dsun.io.useCanonCaches=false -Dflexcompiler=&quot;${argv[0]}&quot; -Dflexlib=&quot;${argv[0]}/frameworks&quot; -jar &quot;${argv[0]}/lib/falcon-mxmlc.jar&quot; -compiler.mxml.children-as-data -debug -compiler.binding-value-change-event=org.apache.flex.events.ValueChangeEvent -compiler.binding-value-change-event-kind=org.apache.flex.events.ValueChangeEvent -compiler.binding-value-change-event-type=valueChange -fb &quot;\${project_loc}&quot;'/>" >> "${argv[0]}/ide/flashbuilder/$FILENAME"
echo "</launchConfiguration>"  >> "${argv[0]}/ide/flashbuilder/$FILENAME"

FILENAME="FlexJS (Release Build).launch"
echo "Creating FlexJS Release Launch Configuration"
echo "<?xml version='1.0' encoding='UTF-8' standalone='no'?>" > "${argv[0]}/ide/flashbuilder/$FILENAME"
echo "<launchConfiguration type='org.eclipse.ui.externaltools.ProgramLaunchConfigurationType'>" >> "${argv[0]}/ide/flashbuilder/$FILENAME"
echo "<booleanAttribute key='org.eclipse.debug.core.appendEnvironmentVariables' value='false'/>" >> "${argv[0]}/ide/flashbuilder/$FILENAME"
echo "<listAttribute key='org.eclipse.debug.ui.favoriteGroups'>" >> "${argv[0]}/ide/flashbuilder/$FILENAME"
echo "<listEntry value='org.eclipse.ui.externaltools.launchGroup'/>" >> "${argv[0]}/ide/flashbuilder/$FILENAME"
echo "</listAttribute>" >> "${argv[0]}/ide/flashbuilder/$FILENAME"
echo "<stringAttribute key='org.eclipse.ui.externaltools.ATTR_LAUNCH_CONFIGURATION_BUILD_SCOPE' value='\${project}'/>" >> "${argv[0]}/ide/flashbuilder/$FILENAME"
echo "<stringAttribute key='org.eclipse.ui.externaltools.ATTR_LOCATION' value='${argv[1]}'/>" >> "${argv[0]}/ide/flashbuilder/$FILENAME"
echo "<stringAttribute key='org.eclipse.ui.externaltools.ATTR_TOOL_ARGUMENTS' value='-Xmx384m -Dsun.io.useCanonCaches=false -Dflexcompiler=&quot;${argv[0]}&quot; -Dflexlib=&quot;${argv[0]}/frameworks&quot; -jar &quot;${argv[0]}/lib/falcon-mxmlc.jar&quot; -compiler.mxml.children-as-data -compiler.binding-value-change-event=org.apache.flex.events.ValueChangeEvent -compiler.binding-value-change-event-kind=org.apache.flex.events.ValueChangeEvent -compiler.binding-value-change-event-type=valueChange -fb &quot;\${project_loc}&quot;'/>" >> "${argv[0]}/ide/flashbuilder/$FILENAME"
echo "</launchConfiguration>"  >> "${argv[0]}/ide/flashbuilder/$FILENAME"

FILENAME="FlexJS (FalconJX Debug and Release Build).launch"
echo "Creating FlexJS FalconJX Launch Configuration"
echo "<?xml version='1.0' encoding='UTF-8' standalone='no'?>" > "${argv[0]}/ide/flashbuilder/$FILENAME"
echo "<launchConfiguration type='org.eclipse.ui.externaltools.ProgramLaunchConfigurationType'>" >> "${argv[0]}/ide/flashbuilder/$FILENAME"
echo "<booleanAttribute key='org.eclipse.debug.core.appendEnvironmentVariables' value='false'/>" >> "${argv[0]}/ide/flashbuilder/$FILENAME"
echo "<listAttribute key='org.eclipse.debug.ui.favoriteGroups'>" >> "${argv[0]}/ide/flashbuilder/$FILENAME"
echo "<listEntry value='org.eclipse.ui.externaltools.launchGroup'/>" >> "${argv[0]}/ide/flashbuilder/$FILENAME"
echo "</listAttribute>" >> "${argv[0]}/ide/flashbuilder/$FILENAME"
echo "<stringAttribute key='org.eclipse.ui.externaltools.ATTR_LAUNCH_CONFIGURATION_BUILD_SCOPE' value='\${project}'/>" >> "${argv[0]}/ide/flashbuilder/$FILENAME"
echo "<stringAttribute key='org.eclipse.ui.externaltools.ATTR_LOCATION' value='${argv[1]}'/>" >> "${argv[0]}/ide/flashbuilder/$FILENAME"
echo "<stringAttribute key='org.eclipse.ui.externaltools.ATTR_TOOL_ARGUMENTS' value='-Xmx384m -Dfile.encoding=UTF8 -Dsun.io.useCanonCaches=false -Dflexcompiler=&quot;${argv[0]}&quot; -Dflexlib=&quot;${argv[0]}/frameworks&quot; -jar &quot;${argv[0]}/js/lib/mxmlc.jar&quot; -compiler.mxml.children-as-data -compiler.binding-value-change-event-type=valueChange -js-output-type=FLEXJS -closure-lib=&quot;$GOOG_HOME&quot; -sdk-js-lib=&quot;${argv[0]}/js/src&quot; -fb &quot;\${project_loc}&quot;'/>" >> "${argv[0]}/ide/flashbuilder/$FILENAME"
echo "</launchConfiguration>"  >> "${argv[0]}/ide/flashbuilder/$FILENAME"

FILENAME="FlexJS (COMPC).launch"
echo "Creating FlexJS COMPC Launch Configuration"
echo "<?xml version='1.0' encoding='UTF-8' standalone='no'?>" > "${argv[0]}/ide/flashbuilder/$FILENAME"
echo "<launchConfiguration type='org.eclipse.ui.externaltools.ProgramLaunchConfigurationType'>" >> "${argv[0]}/ide/flashbuilder/$FILENAME"
echo "<booleanAttribute key='org.eclipse.debug.core.appendEnvironmentVariables' value='false'/>" >> "${argv[0]}/ide/flashbuilder/$FILENAME"
echo "<listAttribute key='org.eclipse.debug.ui.favoriteGroups'>" >> "${argv[0]}/ide/flashbuilder/$FILENAME"
echo "<listEntry value='org.eclipse.ui.externaltools.launchGroup'/>" >> "${argv[0]}/ide/flashbuilder/$FILENAME"
echo "</listAttribute>" >> "${argv[0]}/ide/flashbuilder/$FILENAME"
echo "<stringAttribute key='org.eclipse.ui.externaltools.ATTR_LAUNCH_CONFIGURATION_BUILD_SCOPE' value='\${project}'/>" >> "${argv[0]}/ide/flashbuilder/$FILENAME"
echo "<stringAttribute key='org.eclipse.ui.externaltools.ATTR_LOCATION' value='${argv[1]}'/>" >> "${argv[0]}/ide/flashbuilder/$FILENAME"
echo "<stringAttribute key='org.eclipse.ui.externaltools.ATTR_TOOL_ARGUMENTS' value='-Xmx384m -Dsun.io.useCanonCaches=false -Dflexcompiler=&quot;${argv[0]}&quot; -Dflexlib=&quot;${argv[0]}/frameworks&quot; -jar &quot;${argv[0]}/lib/falcon-compc.jar&quot; -debug -compiler.mxml.children-as-data -compiler.binding-value-change-event=org.apache.flex.events.ValueChangeEvent -compiler.binding-value-change-event-kind=org.apache.flex.events.ValueChangeEvent -compiler.binding-value-change-event-type=valueChange -fb &quot;\${project_loc}&quot;' />" >> "${argv[0]}/ide/flashbuilder/$FILENAME"
echo "</launchConfiguration>"  >> "${argv[0]}/ide/flashbuilder/$FILENAME"

FILENAME="FlexJS (JS COMPC).launch"
echo "Creating FlexJS JS COMPC Launch Configuration"
echo "<?xml version='1.0' encoding='UTF-8' standalone='no'?>" > "${argv[0]}/ide/flashbuilder/$FILENAME"
echo "<launchConfiguration type='org.eclipse.ui.externaltools.ProgramLaunchConfigurationType'>" >> "${argv[0]}/ide/flashbuilder/$FILENAME"
echo "<booleanAttribute key='org.eclipse.debug.core.appendEnvironmentVariables' value='false'/>" >> "${argv[0]}/ide/flashbuilder/$FILENAME"
echo "<listAttribute key='org.eclipse.debug.ui.favoriteGroups'>" >> "${argv[0]}/ide/flashbuilder/$FILENAME"
echo "<listEntry value='org.eclipse.ui.externaltools.launchGroup'/>" >> "${argv[0]}/ide/flashbuilder/$FILENAME"
echo "</listAttribute>" >> "${argv[0]}/ide/flashbuilder/$FILENAME"
echo "<stringAttribute key='org.eclipse.ui.externaltools.ATTR_LAUNCH_CONFIGURATION_BUILD_SCOPE' value='\${project}'/>" >> "${argv[0]}/ide/flashbuilder/$FILENAME"
echo "<stringAttribute key='org.eclipse.ui.externaltools.ATTR_LOCATION' value='${argv[1]}'/>" >> "${argv[0]}/ide/flashbuilder/$FILENAME"
echo "<stringAttribute key='org.eclipse.ui.externaltools.ATTR_TOOL_ARGUMENTS' value='-Xmx384m -Dfile.encoding=UTF8 -Dsun.io.useCanonCaches=false -Dflexcompiler=&quot;${argv[0]}&quot; -Dflexlib=&quot;${argv[0]}/frameworks&quot; -jar &quot;${argv[0]}/js/lib/compc.jar&quot; -compiler.mxml.children-as-data -compiler.binding-value-change-event-type=valueChange -js-output-type=FLEXJS -closure-lib=$GOOG_HOME -sdk-js-lib=${argv[0]}/js/src -fb &quot;\${project_loc}&quot;' />" >> "${argv[0]}/ide/flashbuilder/$FILENAME"
echo "</launchConfiguration>"  >> "${argv[0]}/ide/flashbuilder/$FILENAME"
