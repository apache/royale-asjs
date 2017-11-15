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

let args, createFile, dir, fs, projectName, projectPath, projectSrcPath, royaleHome;



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

createFile(projectPath + '/package.json', `{
  "dependencies": { 
    "http-server" : "0.10.0"
  },
  
  "scripts": {
    "build": "npm install; node build.js -royale-home=${royaleHome} -src=src/${projectName}.as; http-server bin/ -s -o -p3546"
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
