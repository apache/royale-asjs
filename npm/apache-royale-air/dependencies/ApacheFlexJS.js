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
var unzip = require('unzip');
var pjson = require('../package');

var constants = require('../dependencies/Constants');

var ApacheFlexJS = module.exports = Object.create(events.EventEmitter.prototype);

//FlexJS
var pathToFlexJSBinary = pjson.org_apache_royale.royale_path_binary;
var fileNameFlexJSBinary = pjson.org_apache_royale.royale_file_name;

ApacheFlexJS.handleFlexJSMirrorsResponse = function (error, response, body)
{
    if (!error && response.statusCode == 200)
    {
        var mirrors = JSON.parse(body);
        var flexJSPreferredDownloadURL = mirrors.preferred + pathToFlexJSBinary + fileNameFlexJSBinary;
        console.log('Downloading Apache FlexJS from mirror: ' + flexJSPreferredDownloadURL);
        request
            .get(flexJSPreferredDownloadURL)
            .pipe(fs.createWriteStream(constants.DOWNLOADS_FOLDER + fileNameFlexJSBinary)
                .on('close', function(){
                    console.log('Apache FlexJS download complete');
                    ApacheFlexJS.extract();
                })
        );
    }
};

ApacheFlexJS.extract = function()
{
    console.log('Extracting Apache FlexJS');
    fs.createReadStream(constants.DOWNLOADS_FOLDER + fileNameFlexJSBinary)
        .pipe(unzip.Extract({ path: constants.FLEXJS_FOLDER })
            .on('close', function(){
                console.log('Apache FlexJS extraction complete');
                ApacheFlexJS.emit('complete');
            })
    );
};

ApacheFlexJS.install = function()
{
    //to test with a nightly build or another custom URL, run the following
    //command with your custom URL
    //npm config set flexjs_custom_url http://example.com/path/to/flexjs.zip
    //example URL: http://apacheflexbuild.cloudapp.net:8080/job/flex-asjs/lastSuccessfulBuild/artifact/out/apache-flex-flexjs-0.8.0-bin.zip
    var customURL = process.env.npm_package_config_flexjs_custom_url;
    var isCustom = typeof customURL !== "undefined";
    if(isCustom)
    {
        var downloadURL = customURL;
    }
    else
    {
        downloadURL = constants.APACHE_MIRROR_RESOLVER_URL + pathToFlexJSBinary + fileNameFlexJSBinary + '?' + constants.REQUEST_JSON_PARAM;
    }
    console.log('Downloading Apache FlexJS from ' + downloadURL);
    if(isCustom)
    {
    	request
    		.get(downloadURL)
    		.pipe(fs.createWriteStream(constants.DOWNLOADS_FOLDER + fileNameFlexJSBinary)
    			.on('close', function(){
    				console.log('Apache FlexJS download complete');
    				ApacheFlexJS.extract();
    			})
        );
    }
    else
    {
        request(downloadURL, ApacheFlexJS.handleFlexJSMirrorsResponse);
    }
};