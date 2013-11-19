@echo off
rem  Licensed to the Apache Software Foundation (ASF) under one or more

rem  contributor license agreements.  See the NOTICE file distributed with

rem  this work for additional information regarding copyright ownership.

rem  The ASF licenses this file to You under the Apache License, Version 2.0

rem  (the "License"); you may not use this file except in compliance with

rem  the License.  You may obtain a copy of the License at

rem
rem     http:\\www.apache.org\licenses\LICENSE-2.0

rem
rem  Unless required by applicable law or agreed to in writing, software

rem  distributed under the License is distributed on an "AS IS" BASIS,

rem  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

rem  See the License for the specific language governing permissions and

rem  limitations under the License.


if "%~1" == "" goto usage
goto check2

:usage
echo Usage: setuplaunches <absolute path to Apache Flex SDK> <absolute path to Java executable>
goto exit

:check2
if "%~2" == "" goto usage
if "%GOOG_HOME%" == "" goto nogoog
goto doit

:nogoog
echo GOOG_HOME environment variable not set.  Set to folder (usually called library) containing closure folder from Google Closure library
goto exit

:doit
echo %~d0%~p0
setlocal
set BASEDIR=%~d0%~p0
set FILENAME=FlexJS (Debug Build).launch
echo Creating FlexJS Debug Launch Configuration
echo ^<?xml version='1.0' encoding='UTF-8' standalone='no'?^> > "%~1\ide\flashbuilder\%FILENAME%"
echo ^<launchConfiguration type='org.eclipse.ui.externaltools.ProgramLaunchConfigurationType'^> >> "%~1\ide\flashbuilder\%FILENAME%"
echo ^<booleanAttribute key='org.eclipse.debug.core.appendEnvironmentVariables' value='false'/^> >> "%~1\ide\flashbuilder\%FILENAME%"
echo ^<listAttribute key='org.eclipse.debug.ui.favoriteGroups'^> >> "%~1\ide\flashbuilder\%FILENAME%"
echo ^<listEntry value='org.eclipse.ui.externaltools.launchGroup'/^> >> "%~1\ide\flashbuilder\%FILENAME%"
echo ^</listAttribute^> >> "%~1\ide\flashbuilder\%FILENAME%"
echo ^<stringAttribute key='org.eclipse.ui.externaltools.ATTR_LAUNCH_CONFIGURATION_BUILD_SCOPE' value='${project}'/^> >> "%~1\ide\flashbuilder\%FILENAME%"
echo ^<stringAttribute key='org.eclipse.ui.externaltools.ATTR_LOCATION' value='%~2'/^> >> "%~1\ide\flashbuilder\%FILENAME%"
echo ^<stringAttribute key='org.eclipse.ui.externaltools.ATTR_TOOL_ARGUMENTS' value='-Xmx384m -Dsun.io.useCanonCaches=false -Dflexcompiler=^&quot;%~1^&quot; -Dflexlib=^&quot;%~1\frameworks^&quot; -jar %~1\lib\falcon-mxmlc.jar -compiler.mxml.children-as-data -debug -compiler.binding-value-change-event=org.apache.flex.events.ValueChangeEvent -compiler.binding-value-change-event-kind=org.apache.flex.events.ValueChangeEvent -compiler.binding-value-change-event-type=valueChange -fb ^&quot;${project_loc}^&quot;'/^> >> "%~1\ide\flashbuilder\%FILENAME%"
echo ^</launchConfiguration^> >> "%~1\ide\flashbuilder\%FILENAME%"

set FILENAME=FlexJS (Release Build).launch
echo Creating FlexJS Release Launch Configuration
echo ^<?xml version='1.0' encoding='UTF-8' standalone='no'?^> > "%~1\ide\flashbuilder\%FILENAME%"
echo ^<launchConfiguration type='org.eclipse.ui.externaltools.ProgramLaunchConfigurationType'^> >> "%~1\ide\flashbuilder\%FILENAME%"
echo ^<booleanAttribute key='org.eclipse.debug.core.appendEnvironmentVariables' value='false'/^> >> "%~1\ide\flashbuilder\%FILENAME%"
echo ^<listAttribute key='org.eclipse.debug.ui.favoriteGroups'^> >> "%~1\ide\flashbuilder\%FILENAME%"
echo ^<listEntry value='org.eclipse.ui.externaltools.launchGroup'/^> >> "%~1\ide\flashbuilder\%FILENAME%"
echo ^</listAttribute^> >> "%~1\ide\flashbuilder\%FILENAME%"
echo ^<stringAttribute key='org.eclipse.ui.externaltools.ATTR_LAUNCH_CONFIGURATION_BUILD_SCOPE' value='${project}'/^> >> "%~1\ide\flashbuilder\%FILENAME%"
echo ^<stringAttribute key='org.eclipse.ui.externaltools.ATTR_LOCATION' value='%~2'/^> >> "%~1\ide\flashbuilder\%FILENAME%"
echo ^<stringAttribute key='org.eclipse.ui.externaltools.ATTR_TOOL_ARGUMENTS' value='-Xmx384m -Dsun.io.useCanonCaches=false -Dflexcompiler=^&quot;%~1^&quot; -Dflexlib=^&quot;%~1\frameworks^&quot; -jar %~1\lib\falcon-mxmlc.jar -compiler.mxml.children-as-data -compiler.binding-value-change-event=org.apache.flex.events.ValueChangeEvent -compiler.binding-value-change-event-kind=org.apache.flex.events.ValueChangeEvent -compiler.binding-value-change-event-type=valueChange -fb ^&quot;${project_loc}^&quot;'/^> >> "%~1\ide\flashbuilder\%FILENAME%"
echo ^</launchConfiguration^> >> "%~1\ide\flashbuilder\%FILENAME%"

set FILENAME=FlexJS (FalconJX Debug and Release Build).launch
echo Creating FlexJS FalconJX Launch Configuration
echo ^<?xml version='1.0' encoding='UTF-8' standalone='no'?^> > "%~1\ide\flashbuilder\%FILENAME%"
echo ^<launchConfiguration type='org.eclipse.ui.externaltools.ProgramLaunchConfigurationType'^> >> "%~1\ide\flashbuilder\%FILENAME%"
echo ^<booleanAttribute key='org.eclipse.debug.core.appendEnvironmentVariables' value='false'/^> >> "%~1\ide\flashbuilder\%FILENAME%"
echo ^<listAttribute key='org.eclipse.debug.ui.favoriteGroups'^> >> "%~1\ide\flashbuilder\%FILENAME%"
echo ^<listEntry value='org.eclipse.ui.externaltools.launchGroup'/^> >> "%~1\ide\flashbuilder\%FILENAME%"
echo ^</listAttribute^> >> "%~1\ide\flashbuilder\%FILENAME%"
echo ^<stringAttribute key='org.eclipse.ui.externaltools.ATTR_LAUNCH_CONFIGURATION_BUILD_SCOPE' value='${project}'/^> >> "%~1\ide\flashbuilder\%FILENAME%"
echo ^<stringAttribute key='org.eclipse.ui.externaltools.ATTR_LOCATION' value='%~2'/^> >> "%~1\ide\flashbuilder\%FILENAME%"
echo ^<stringAttribute key='org.eclipse.ui.externaltools.ATTR_TOOL_ARGUMENTS' value='-Xmx384m -Dfile.encoding=UTF8 -Dsun.io.useCanonCaches=false -Dflexcompiler=^&quot;%~1^&quot; -Dflexlib=^&quot;%~1\frameworks^&quot; -jar %~1\js\lib\mxmlc.jar -compiler.mxml.children-as-data -compiler.binding-value-change-event-type=valueChange -js-output-type=FLEXJS -closure-lib=%GOOG_HOME% -sdk-js-lib=%~1\js\src -fb ^&quot;${project_loc}^&quot;'/^> >> "%~1\ide\flashbuilder\%FILENAME%"
echo ^</launchConfiguration^> >> "%~1\ide\flashbuilder\%FILENAME%"

set FILENAME=FlexJS (COMPC).launch
echo Creating FlexJS COMPC Configuration
echo ^<?xml version='1.0' encoding='UTF-8' standalone='no'?^> > "%~1\ide\flashbuilder\%FILENAME%"
echo ^<launchConfiguration type='org.eclipse.ui.externaltools.ProgramLaunchConfigurationType'^> >> "%~1\ide\flashbuilder\%FILENAME%"
echo ^<booleanAttribute key='org.eclipse.debug.core.appendEnvironmentVariables' value='false'/^> >> "%~1\ide\flashbuilder\%FILENAME%"
echo ^<listAttribute key='org.eclipse.debug.ui.favoriteGroups'^> >> "%~1\ide\flashbuilder\%FILENAME%"
echo ^<listEntry value='org.eclipse.ui.externaltools.launchGroup'/^> >> "%~1\ide\flashbuilder\%FILENAME%"
echo ^</listAttribute^> >> "%~1\ide\flashbuilder\%FILENAME%"
echo ^<stringAttribute key='org.eclipse.ui.externaltools.ATTR_LAUNCH_CONFIGURATION_BUILD_SCOPE' value='${project}'/^> >> "%~1\ide\flashbuilder\%FILENAME%"
echo ^<stringAttribute key='org.eclipse.ui.externaltools.ATTR_LOCATION' value='%~2'/^> >> "%~1\ide\flashbuilder\%FILENAME%"
echo ^<stringAttribute key='org.eclipse.ui.externaltools.ATTR_TOOL_ARGUMENTS' value='-Xmx384m -Dsun.io.useCanonCaches=false -Dflexcompiler=^&quot;%~1^&quot; -Dflexlib=^&quot;%~1\frameworks^&quot; -jar %~1\lib\falcon-compc.jar -compiler.mxml.children-as-data -debug -compiler.binding-value-change-event=org.apache.flex.events.ValueChangeEvent -compiler.binding-value-change-event-kind=org.apache.flex.events.ValueChangeEvent -compiler.binding-value-change-event-type=valueChange -fb ^&quot;${project_loc}^&quot;'/^> >> "%~1\ide\flashbuilder\%FILENAME%"
echo ^</launchConfiguration^> >> "%~1\ide\flashbuilder\%FILENAME%"

set FILENAME=FlexJS (JS COMPC).launch
echo Creating FlexJS JS COMPC Launch Configuration
echo ^<?xml version='1.0' encoding='UTF-8' standalone='no'?^> > "%~1\ide\flashbuilder\%FILENAME%"
echo ^<launchConfiguration type='org.eclipse.ui.externaltools.ProgramLaunchConfigurationType'^> >> "%~1\ide\flashbuilder\%FILENAME%"
echo ^<booleanAttribute key='org.eclipse.debug.core.appendEnvironmentVariables' value='false'/^> >> "%~1\ide\flashbuilder\%FILENAME%"
echo ^<listAttribute key='org.eclipse.debug.ui.favoriteGroups'^> >> "%~1\ide\flashbuilder\%FILENAME%"
echo ^<listEntry value='org.eclipse.ui.externaltools.launchGroup'/^> >> "%~1\ide\flashbuilder\%FILENAME%"
echo ^</listAttribute^> >> "%~1\ide\flashbuilder\%FILENAME%"
echo ^<stringAttribute key='org.eclipse.ui.externaltools.ATTR_LAUNCH_CONFIGURATION_BUILD_SCOPE' value='${project}'/^> >> "%~1\ide\flashbuilder\%FILENAME%"
echo ^<stringAttribute key='org.eclipse.ui.externaltools.ATTR_LOCATION' value='%~2'/^> >> "%~1\ide\flashbuilder\%FILENAME%"
echo ^<stringAttribute key='org.eclipse.ui.externaltools.ATTR_TOOL_ARGUMENTS' value='-Xmx384m -Dfile.encoding=UTF8 -Dsun.io.useCanonCaches=false -Dflexcompiler=^&quot;%~1^&quot; -Dflexlib=^&quot;%~1\frameworks^&quot; -jar %~1\js\lib\mxmlc.jar -compiler.mxml.children-as-data -compiler.binding-value-change-event-type=valueChange -js-output-type=FLEXJS -closure-lib=%GOOG_HOME% -sdk-js-lib=%~1\js\src -fb ^&quot;${project_loc}^&quot;'/^> >> "%~1\ide\flashbuilder\%FILENAME%"
echo ^</launchConfiguration^> >> "%~1\ide\flashbuilder\%FILENAME%"

endlocal
:exit

