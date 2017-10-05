@echo off

rem
rem Licensed to the Apache Software Foundation (ASF) under one or more
rem contributor license agreements.  See the NOTICE file distributed with
rem this work for additional information regarding copyright ownership.
rem The ASF licenses this file to You under the Apache License, Version 2.0
rem (the "License"); you may not use this file except in compliance with
rem the License.  You may obtain a copy of the License at
rem
rem     http://www.apache.org/licenses/LICENSE-2.0
rem
rem Unless required by applicable law or agreed to in writing, software
rem distributed under the License is distributed on an "AS IS" BASIS,
rem WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
rem See the License for the specific language governing permissions and
rem limitations under the License.
rem

rem
rem mxmlc.bat script to launch falcon-mxmlc.jar in Windows Command Prompt.
rem On OSX, Unix, or Cygwin, use the mxmlc shell script instead.
rem

if "x%FALCON_HOME%"=="x"  (set "FALCON_HOME=%~dp0..\..") else echo Using Falcon codebase: %FALCON_HOME%

if "x%FLEX_HOME%"=="x" (set "FLEX_HOME=%~dp0..\..") else echo Using Flex SDK: %FLEX_HOME%

@java -Dsun.io.useCanonCaches=false -Xms32m -Xmx512m -Dflexcompiler="%FALCON_HOME%" -Dflexlib="%FLEX_HOME%\frameworks" -jar "%FALCON_HOME%\js\lib\mxmlc.jar" -js-output-type=node +configname=node %*
