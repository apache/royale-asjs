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
var unzip = require('unzip');
var pjson = require('../package');

var constants = require('../dependencies/Constants');

var AdobeAIR = module.exports = Object.create(events.EventEmitter.prototype);

//Adobe AIR
var AdobeAIRURL = pjson.org_apache_royale.adobe_air_url;
var fileNameAdobeAIR = pjson.org_apache_royale.adobe_air_file_name;

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
        .pipe(fs.createWriteStream(constants.DOWNLOADS_FOLDER + fileNameAdobeAIR)
            .on('close', function(){
                console.log('Adobe AIR download complete');
                extract();
            })
    );
}

function extract()
{
    console.log('Extracting Adobe AIR');
    fs.createReadStream(constants.DOWNLOADS_FOLDER + fileNameAdobeAIR)
        .pipe(unzip.Extract({ path: constants.ROYALE_FOLDER })
            .on('close', function(){
                console.log('Adobe AIR extraction complete');
                AdobeAIR.emit('complete');
            })
    );
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