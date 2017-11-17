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

let args, copyFile, createDirectory, createFile, dir, fs, projectName,
    projectPath, projectSrcPath, royaleHome, tgtDir;



fs = require('fs');



copyFile = function (file, srcDir, tgtDir) {
  fs.createReadStream(srcDir + file).pipe(fs.createWriteStream(tgtDir + file));
};

createDirectory = function (path) {
  if (!fs.existsSync(path)) {
    fs.mkdirSync(path);
  }
};

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
royaleHome.pop(); // remove 'as2wasm'
royaleHome = royaleHome.join('/') + '/';

dir = args['dir'];
if (!fs.existsSync(dir)) {
  console.log(`The intended target directory ('${dir}') does not exist.`);

  process.exit();
}

projectName = args['name'];
projectPath = dir + '/' + projectName + '/';
createDirectory(projectPath);

createDirectory(projectPath + 'lib/');

tgtDir = projectPath + 'lib/compiler/';
createDirectory(tgtDir);
copyFile('wastc.jar', royaleHome + 'as2wasm/lib/', tgtDir);
copyFile('compiler.jar', royaleHome + 'as2wasm/lib/', tgtDir);

tgtDir = projectPath + 'lib/compiler/external/';
createDirectory(tgtDir);
copyFile('antlr-LICENSE.html', royaleHome + 'as2wasm/lib/external/', tgtDir);
copyFile('antlr.jar', royaleHome + 'as2wasm/lib/external/', tgtDir);
copyFile('commons-cli.jar', royaleHome + 'as2wasm/lib/external/', tgtDir);
copyFile('commons-io.jar', royaleHome + 'as2wasm/lib/external/', tgtDir);
copyFile('flex-tool-api-LICENSE.html', royaleHome + 'as2wasm/lib/external/', tgtDir);
copyFile('flex-tool-api.jar', royaleHome + 'as2wasm/lib/external/', tgtDir);
copyFile('guava-LICENSE.html', royaleHome + 'as2wasm/lib/external/', tgtDir);
copyFile('guava.jar', royaleHome + 'as2wasm/lib/external/', tgtDir);
copyFile('lzma-sdk-LICENSE.html', royaleHome + 'as2wasm/lib/external/', tgtDir);
copyFile('lzma-sdk.jar', royaleHome + 'as2wasm/lib/external/', tgtDir);

tgtDir = projectPath + 'lib/player/';
createDirectory(tgtDir);
copyFile('playerglobal.swc', royaleHome + 'as2wasm/lib/player/', tgtDir);

copyFile('build.js', royaleHome + 'as2wasm/resources/', projectPath);
copyFile('install.js', royaleHome + 'as2wasm/resources/', projectPath);

createFile(projectPath + 'README', `To build and run this project, use:

cd [project dir]
npm run build
`);

createFile(projectPath + 'package.json', `{

  "dependencies": { 
    "http-server" : "0.10.0"
  },
  
  "scripts": {
    "build": "node install.js; node build.js -src=src/${projectName}.as; http-server ./bin -o -a localhost -p 1337 -c-1"
  }

}
`);

projectSrcPath = projectPath + 'src/';
createDirectory(projectSrcPath);
createFile(projectSrcPath + projectName + '.as', `package {

  public class ${projectName} {

    public function main():void {
      trace('Hello world ;-)');
    }

  }

}`);
