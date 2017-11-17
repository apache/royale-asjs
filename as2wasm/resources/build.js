/*
 *
 *  Licensed to the Apache Software Foundation (ASF) under one or more
 *  contributor license agreements.  See the NOTICE file distributed with
 *  this work for additional information regarding copyright ownership.
 *  The ASF licenses this file to You under the Apache License, Version 2.0
 *  (the "License"); you may not use this file except in compliance with
 *  the License.  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 *
 */

'use strict';

let args, cmd, exec;



exec = require('child_process').exec;



args = {};
process.argv.slice(2).forEach(function (value) {
  let valueArray;

  valueArray = value.split('=');
  if (1 < valueArray.length) {
    let name, value;

    name = valueArray[0].substr(1);
    value = valueArray[1];

    args[name] = value;

    console.log('Set arg \'' + name + '\' to \'' + value + '\'');
  }
});

cmd = `/usr/bin/java -Xmx384m -Dsun.io.useCanonCaches=false -jar "lib/compiler/wastc.jar" -external-library-path="lib/player/playerglobal.swc" ${args['src']}`;
exec(cmd, function (error, stdout, stderr) {
  console.log(stdout);

  if (stderr && '' !== stderr) {
    console.log('stderr: ' + stderr);
  }

  if (error) {
    console.log('exec error: ' + error);
  }
});
