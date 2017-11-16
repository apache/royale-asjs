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

let args, createFile, dir, fs, playerHome, playerVersion, projectName,
    projectPath, projectSrcPath, royaleHome, wastcJar;



fs = require('fs');



createFile = function (file, content) {
  fs.writeFile(file, content, function(error) {
    if (error) {
      return console.log(`Error writing file ('${file}'): ` + error + '.');
    } else {
      console.log(`Created file ('${file}').`);
    }
  });
};



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

royaleHome = process.argv[1].split('/');
royaleHome.pop(); // remove 'create.js'
royaleHome.pop(); // remove 'wast'
royaleHome = royaleHome.join('/');

wastcJar = royaleHome + '/wast/lib/wastc.jar';
if (!fs.existsSync(wastcJar)) {
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

dir = args['dir'];
if (!fs.existsSync(dir)) {
  console.log(`The intended target directory ('${dir}') does not exist.`);

  process.exit();
}

projectName = args['name'];
projectPath = dir + '/' + projectName;
if (!fs.existsSync(projectPath)) {
  fs.mkdirSync(projectPath);
}

projectSrcPath = projectPath + '/src';
if (!fs.existsSync(projectSrcPath)) {
  fs.mkdirSync(projectSrcPath);
}

createFile(projectPath + '/README', `To build and run this project, use:

cd [project dir]
npm run build
`);

fs.createReadStream('resources/build.js')
.pipe(fs.createWriteStream(projectPath + '/build.js'));

fs.createReadStream('resources/install.js')
.pipe(fs.createWriteStream(projectPath + '/install.js'));

createFile(projectPath + '/package.json', `{

  "dependencies": { 
    "http-server" : "0.10.0"
  },
  
  "scripts": {
    "build": "node install.js; node build.js -wastc-jar=${wastcJar} -playerglobal-home=${playerHome} -playerglobal-version=${playerVersion} -src=src/${projectName}.as; http-server ./bin -o -a localhost -p 1337 -c-1"
  }

}
`);

createFile(projectSrcPath + '/' + projectName + '.as', `package {

  public class ${projectName} {

    public function main():void {
      trace('Hello world ;-)');
    }

  }

}`);
