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


var request = require('request');
var fs = require('fs');
var events = require('events');
var prompt = require('prompt');
var unzip = require('unzipper');
var pjson = require('../package');

var isMac = false;
var os = require('os');
if (os.type() === 'Darwin') 
   isMac = true;

var constants = require('../dependencies/Constants');

var inExpand = false;

var AdobeAIR = module.exports = Object.create(events.EventEmitter.prototype);

//Adobe AIR
var AdobeAIRURL = pjson.org_apache_royale.adobe_air_url;
var fileNameAdobeAIR = pjson.org_apache_royale.adobe_air_file_name;
if (isMac) {
	AdobeAIRURL = pjson.org_apache_royale.adobe_air_url_mac;
    fileNameAdobeAIR = pjson.org_apache_royale.adobe_air_file_name_mac;
}

var adobeAirPromptText = "\
Apache Royale SWF support uses the Adobe AIR SDK to build Adobe AIR applications.\n\
The Adobe AIR SDK is subject to and governed by the\n\
Adobe AIR SDK License Agreement specified here:\n\
http://www.adobe.com/products/air/sdk-eula.html.\n\
This license is not compatible with the Apache v2 license.\n\
Do you want to download and install the Adobe AIR SDK?\n\
This is a required component (y/n)";

function promptForAdobeAIR()
{
    var schema = {
        properties: {
            accept: {
                description: adobeAirPromptText.grey,
                pattern: /^[YNyn\s]{1}$/,
                message: 'Please respond with either y or n'.red,
                required: true
            }
        }
    };
    prompt.start();
    prompt.get(schema, function (err, result) {
        if(result.accept.toLowerCase() == 'y')
        {
            downloadAdobeAIR();
        }
        else
        {
            console.log('Aborting installation');
            AdobeAIR.emit('abort');
        }
    });
}

function downloadAdobeAIR()
{
    var downloadURL = AdobeAIRURL + fileNameAdobeAIR;
    console.log('Downloading Adobe AIR from ' + downloadURL);
    request
        .get(downloadURL)
        .pipe(fs.createWriteStream(constants.DOWNLOADS_FOLDER + fileNameAdobeAIR, {emitClose:true})
            .on('close', function(){
                console.log('Adobe AIR download complete');
				if (!isMac)
	                extract();
				else
					expand();
            })
    );
}

function extract()
{
	if (inExpand) return;
	inExpand = true;
	var pathResolver = require('path');
	// ROYALE_FOLDER is the base of the tar.gz package which has the 3 repos as children
	// and not the royale-asjs repo
	var absPath = pathResolver.resolve(constants.ROYALE_FOLDER + "royale-asjs/");
    console.log('Extracting Adobe AIR');
    fs.createReadStream(constants.DOWNLOADS_FOLDER + fileNameAdobeAIR)
        .pipe(unzip.Extract({ path: absPath })
            .on('close', function(){
                console.log('Adobe AIR extraction complete');
                AdobeAIR.emit('complete');
            })
    );
}

 function expand()
 {
	if (inExpand) return;
	inExpand = true;
    console.log('Extracting Adobe AIR (DMG)');
	var dmg = require('dmg');
    var fse = require('fs-extra');
 
    // path must be absolute and the extension must be .dmg
    var myDmg = constants.DOWNLOADS_FOLDER + fileNameAdobeAIR; 
 
    // to open & mount the dmg
    dmg.mount(myDmg, function(err, path) {
	  if (!err) {
		var folders = fse.readdirSync(path);
		for (var i = 0; i < folders.length; i++) {
			var folderName = folders[i];
			var destFolder = constants.ROYALE_FOLDER + "royale-asjs/" + folderName;
			var srcFolder = path + "/" + folderName;
			console.log(destFolder);
			if (!fse.existsSync(destFolder)) {
				console.log("copying " + srcFolder + " -> " + destFolder);
			    fse.copySync(srcFolder, destFolder);
			}
			else {
				copyfolder(fse, srcFolder, destFolder);
			}
			
		}
        dmg.unmount(path, function(err) {});
	  }});
	  
   function copyfolder(fse, sourcePath, destPath) {
		console.log("copyfolder: " + sourcePath + " -> " + destPath);
	    var stat = fse.statSync(destPath);
		if (stat.isDirectory()) {
  	      var folders = fse.readdirSync(sourcePath);
		  for (var i = 0; i < folders.length; i++) {
			var folderName = folders[i];
			var destFolder = destPath + "/" + folderName;
			var srcFolder = sourcePath + "/" + folderName;
			console.log(destFolder);
			if (!fse.existsSync(destFolder)) {
				console.log("copying " + srcFolder + " -> " + destFolder);
			    fse.copySync(srcFolder, destFolder);
			}
			else {
				copyfolder(fse, srcFolder, destFolder);
			}			
		  }
		}
      }
   }

AdobeAIR.install = function()
{
    if(process.env.ACCEPT_ALL_ROYALE_LICENSES === 'true')
    {
        downloadAdobeAIR();
    }
    else {
        promptForAdobeAIR();
    }
};