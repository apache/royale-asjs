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
rem mxmlc.bat script to launch compiler-mxmlc.jar in Windows Command Prompt.
rem On OSX, Unix, or Cygwin, use the mxmlc shell script instead.
rem

if "x%ROYALE_COMPILER_HOME%"=="x"  (set "ROYALE_COMPILER_HOME=%~dp0..\..") else echo Using Royale Compiler codebase: %ROYALE_COMPILER_HOME%

if "x%ROYALE_HOME%"=="x" (set "ROYALE_HOME=%~dp0..\..") else echo Using Royale SDK: %ROYALE_HOME%

@java -Dsun.io.useCanonCaches=false -Xms32m -Xmx512m  -Droyalelib="%ROYALE_HOME%\frameworks" -jar "%ROYALE_COMPILER_HOME%\js\lib\mxmlc.jar" -js-output-type=node +configname=node %*
