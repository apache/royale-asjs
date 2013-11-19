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



if "%~1" == "" goto error
goto check2
:error
echo Usage: deploy.bat [absolute path to Apache Flex SDK] [absolute path to new folder]
goto end

:check2
if "%~2" == "" goto error
if "%GOOG_HOME%" == "" goto nogoog
goto checkjava

:nogoog
echo GOOG_HOME environment variable not set.  Set to folder (usually called library) containing closure folder from Google Closure library
goto end

:checkjava
if "%JAVA_HOME%" == "" goto nojava
goto copyfiles

:nojava
echo JAVA_HOME environment variable not set.  Set to folder containing bin\java.exe
goto end

:copyfiles
echo "Copying Apache Flex SDK (be patient, lots of files)..."
md %2
xcopy /s %1\*.* %2

echo %~d0%~p0
setlocal
set BASEDIR=%~d0%~p0
echo Installing FlexJS files from %BASEDIR% to %2

echo removing Flex files
del /q %2\ant\lib\*.*
del /q %2\bin\*.*
del %2\lib\asc.jar
del %2\lib\asdoc.jar
del %2\lib\batik-all-flex.jar
del %2\lib\compc.jar
del %2\lib\copylocale.jar
del %2\lib\digest.jar
del %2\lib\fcsh.jar
del %2\lib\fdb.jar
del %2\lib\flex-compiler-oem.jar
del %2\lib\fxgutils.jar
del /q %2\lib\mxmlc_*.jar
del %2\lib\optimizer.jar
del %2\lib\swcdepends.jar
del %2\lib\swfdump.jar
del %2\lib\swfutils.jar
del %2\lib\velocity-dep-1.4-flex.jar

del /q /s %2\lib\external\*.*
rd /q /s %2\lib\external
del %2\flex-sdk-description.xml
del %2\frameworks\flex-config.xml
del /q %2\frameworks\libs\automation\*.*
rd /q %2\frameworks\libs\automation
del /q %2\frameworks\libs\mobile\*.*
rd /q %2\frameworks\libs\mobile
del /q %2\frameworks\libs\mx\*.*
rem rd %2\frameworks\libs\mx  FB needs this

del /q %2\frameworks\libs\*.*





echo copying Falcon files"
xcopy /y /s "%BASEDIR%\ant\lib\*.*" %2\ant\lib

xcopy /y /s "%BASEDIR%\bin\*.*" %2\bin

md %2\bin-legacy

xcopy /y /s "%BASEDIR%\bin-legacy\*.*" %2\bin-legacy

xcopy /y /s "%BASEDIR%\lib\*.*" %2\lib


echo copying FalconJS files

md %2\js

xcopy /y /s "%BASEDIR%\js\*.*" %2\js


echo copying FlexJS files

xcopy /y /s "%BASEDIR%\frameworks\libs\*.*" %2\frameworks\libs

md %2\frameworks\as
mkdir %2\frameworks\as\src

xcopy /y /s "%BASEDIR%\frameworks\src\*.*" %2\frameworks\as\src


move %2\frameworks\as\src\basic-manifest.xml %2\frameworks

move %2\frameworks\as\src\html5-manifest.xml %2\frameworks

move %2\frameworks\as\src\flex-sdk-description.xml %2

move %2\frameworks\as\src\flex-config.xml %2\frameworks


endlocal

copy %1\bin\adl.* %2\bin
copy %1\bin\adt.* %2\bin

setuplaunches.bat %2 "%JAVA_HOME%\bin\java.exe"

:end

