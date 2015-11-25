@echo off
REM ################################################################################
REM ##
REM ##  Licensed to the Apache Software Foundation (ASF) under one or more
REM ##  contributor license agreements.  See the NOTICE file distributed with
REM ##  this work for additional information regarding copyright ownership.
REM ##  The ASF licenses this file to You under the Apache License, Version 2.0
REM ##  (the "License"); you may not use this file except in compliance with
REM ##  the License.  You may obtain a copy of the License at
REM ##
REM ##      http://www.apache.org/licenses/LICENSE-2.0
REM ##
REM ##  Unless required by applicable law or agreed to in writing, software
REM ##  distributed under the License is distributed on an "AS IS" BASIS,
REM ##  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
REM ##  See the License for the specific language governing permissions and
REM ##  limitations under the License.
REM ##
REM ################################################################################


if "%~1" == "" goto error
goto check2
:error
echo Usage: deploy.bat [absolute path to Apache Flex SDK]
goto end

:check2
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
echo %~d0%~p0
setlocal
set IDE_SDK_DIR=%~d0%~p0
if "%IDE_SDK_DIR:~-1%"=="\" SET IDE_SDK_DIR=%IDE_SDK_DIR:~0,-1%
set FLEX_SDK_DIR=%~1

REM
REM     Copy all the AIR SDK files to the IDE SDK.
REM     Copy files first, then directories with (/s).
REM
:copyAdobeAIRSDK
echo Copying the AIR SDK files from %FLEX_SDK_DIR% to %IDE_SDK_DIR%
mkdir %IDE_SDK_DIR%\samples

for %%G in (
    "AIR SDK license.pdf"
    "AIR SDK Readme.txt"
    bin\adl.exe
    bin\adt.bat
    lib\adt.jar
    samples\descriptor-sample.xml) do (
    
    if exist %FLEX_SDK_DIR%\%%G (
        copy /y %FLEX_SDK_DIR%\%%G %IDE_SDK_DIR%\%%G
    )
)

for %%G in (
    frameworks\libs\air
    frameworks\projects\air
    include
    install\android
    lib\android
    lib\aot
    lib\nai
    lib\win
    runtimes\air\android
    runtimes\air\mac
    runtimes\air\win
    runtimes\air-captive\mac
    runtimes\air-captive\win
    samples\badge
    samples\icons
    templates\air
    templates\extensions) do (
    
    if exist %FLEX_SDK_DIR%\%%G (
        REM    Make the directory so it won't prompt for file or directory.
        if not exist %IDE_SDK_DIR%\%%G mkdir %IDE_SDK_DIR%\%%G
        xcopy /q /y /e /i /c /r %FLEX_SDK_DIR%\%%G %IDE_SDK_DIR%\%%G
        if %errorlevel% NEQ 0 GOTO end
    )
)


mkdir %IDE_SDK_DIR%\frameworks\libs\player
xcopy /q /y /e /i /c /r %FLEX_SDK_DIR%\frameworks\libs\player %IDE_SDK_DIR%\frameworks\libs\player
mkdir %IDE_SDK_DIR%\ide
mkdir %IDE_SDK_DIR%\ide\flashbuilder
copy /y %FLEX_SDK_DIR%\ide\flashbuilder\flashbuilder-config.xml %IDE_SDK_DIR%\ide\flashbuilder\
copy /y %FLEX_SDK_DIR%\frameworks\mxml-manifest.xml %IDE_SDK_DIR%\frameworks
copy /y %FLEX_SDK_DIR%\frameworks\spark-manifest.xml %IDE_SDK_DIR%\frameworks
mkdir %IDE_SDK_DIR%\frameworks\themes
mkdir %IDE_SDK_DIR%\frameworks\themes\Halo
copy /y %FLEX_SDK_DIR%\frameworks\themes\Halo\halo.swc %IDE_SDK_DIR%\frameworks\themes\Halo
copy /y %FLEX_SDK_DIR%\frameworks\macfonts.ser %IDE_SDK_DIR%\frameworks
copy /y %FLEX_SDK_DIR%\frameworks\localFonts.ser %IDE_SDK_DIR%\frameworks
copy /y %FLEX_SDK_DIR%\frameworks\macfonts.ser %IDE_SDK_DIR%\frameworks
copy /y %IDE_SDK_DIR%\frameworks\air-config.xml %IDE_SDK_DIR%\frameworks\airmobile-config.xml
mkdir %IDE_SDK_DIR%\frameworks\locale
mkdir %IDE_SDK_DIR%\frameworks\mx
mkdir %IDE_SDK_DIR%\frameworks\projects
mkdir %IDE_SDK_DIR%\frameworks\rsls

echo Setting up Launch Configs
setuplaunches.bat %IDE_SDK_DIR% "%JAVA_HOME%\bin\java.exe"

:end

