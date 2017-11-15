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

let args, cmd, exec, fs, playerHome, playerVersion, royaleHome, wastc;



exec = require('child_process').exec;
fs = require('fs');



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

royaleHome = args['royale-home'];
if (!royaleHome || '' === royaleHome) {
  royaleHome = process.env.ROYALE_HOME;
  if (!royaleHome || '' === royaleHome) {
    console.log('ROYALE_HOME is not defined. Create an environment variable (ROYALE_HOME) and point it to the skd dir, or use \'npm run build -- -royale-home=[sdk dir]\'.');

    process.exit();
  }
}
console.log('ROYALE_HOME is ' + royaleHome);

wastc = royaleHome + '/wast/lib/wastc.jar';
if (!fs.existsSync(wastc)) {
  console.log('Transpiler \'wastc\' not found. This sdk appears not to be an sdk that is compatible with this project.');

  process.exit();
}

playerHome = args['playerglobal-home'];
if (!playerHome || '' === playerHome) {
  playerHome = process.env.PLAYERGLOBAL_HOME;
  if (!playerHome || '' === playerHome) {
    console.log('PLAYERGLOBAL_HOME is not defined. Create an environment variable (PLAYERGLOBAL_HOME) and point it to the skd dir, or use \'npm run build -- -playerglobal-home=[playerglobal dir]\'.');

    process.exit();
  }
}
console.log('PLAYERGLOBAL_HOME is ' + playerHome);

playerVersion = args['player-version'];
if (!playerVersion || '' === playerVersion) {
  playerVersion = process.env.PLAYERGLOBAL_VERSION;
}
if (!playerVersion || '' === playerVersion) {
  playerVersion = '11.1';

  console.log('PLAYERGLOBAL_VERSION was undefined. It is now set to \'11.1\'. To override this default, create an environment variable (PLAYERGLOBAL_VERSION) and set it to required version, or use \'npm run build -- -player-version=[version]\'.');
} else {
  console.log('PLAYERGLOBAL_VERSION is ' + playerVersion + '.');
}

if (!fs.existsSync(playerHome + '/' + playerVersion + '/playerglobal.swc')) {
  console.log('\'playerglobal.swc\' could not be found. Make sure you have set PLAYERGLOBAL_HOME to a correctly downloaded and stored playerglobal.swc');

  process.exit();
}

cmd = `/usr/bin/java -Xmx384m -Dsun.io.useCanonCaches=false -jar "${wastc}" -external-library-path="${playerHome}/${playerVersion}/playerglobal.swc" ${args['src']}`;

exec(cmd, function (error, stdout, stderr) {
  console.log(stdout);

  if (stderr && '' !== stderr) {
    console.log('stderr: ' + stderr);
  }

  if (error) {
    console.log('exec error: ' + error);
  }
});
