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
var wrench = require('wrench');
var mkdirp = require('mkdirp');
var replace = require('replace');
var pjson = require('../package');

var constants = require('../dependencies/Constants');
var duc = require('../dependencies/DownloadUncompressAndCopy');

var ApacheFalcon = module.exports = Object.create(events.EventEmitter.prototype);

//Falcon
var pathToFalconBinary = pjson.org_apache_royale.falcon_path_binary;
var fileNameFalconBinary = pjson.org_apache_royale.falcon_file_name;
var playerVersion = pjson.org_apache_royale.player_version;
var swfVersion = pjson.org_apache_royale.swf_version;

var falconCompilerLibFolder = 'falcon/compiler/lib/';
var falconLibExternalFolder = 'lib/external/';
var jsLibFolder = constants.FLEXJS_FOLDER + 'js/lib/';
var googleClosureCompilerFolder =  constants.FLEXJS_FOLDER + 'js/lib/google/closure-compiler/';

//Antlr
var antlrURL = 'http://search.maven.org/remotecontent?filepath=org/antlr/antlr-complete/3.5.2/antlr-complete-3.5.2.jar';
var localFileNameAntlr = 'antlr.jar';

var apacheCommonsURL = 'http://archive.apache.org/dist/commons/cli/binaries/';
var fileNameApacheCommons = 'commons-cli-1.2-bin.zip';
var localFileNameApacheCommons = 'commons-cli.jar';

var falconDependencies = [
    {
        url:'http://search.maven.org/remotecontent?filepath=org/antlr/antlr-complete/3.5.2/',
        remoteFileName:'antlr-complete-3.5.2.jar',
        destinationPath:constants.FLEXJS_FOLDER + falconLibExternalFolder,
        destinationFileName:'antlr.jar',
        unzip:false
    },
    {
        url:'http://archive.apache.org/dist/commons/cli/binaries/',
        remoteFileName:'commons-cli-1.2-bin.zip',
        destinationPath:constants.DOWNLOADS_FOLDER,
        destinationFileName:'',
        pathOfFileToBeCopiedFrom:'commons-cli-1.2/commons-cli-1.2.jar',
        pathOfFileToBeCopiedTo:constants.FLEXJS_FOLDER + falconLibExternalFolder + 'commons-cli.jar',
        unzip:true
    },
    {
        url:'http://archive.apache.org/dist/commons/io/binaries/',
        remoteFileName:'commons-io-2.4-bin.zip',
        destinationPath:constants.DOWNLOADS_FOLDER,
        destinationFileName:'',
        pathOfFileToBeCopiedFrom:'commons-io-2.4/commons-io-2.4.jar',
        pathOfFileToBeCopiedTo:constants.FLEXJS_FOLDER + falconLibExternalFolder + 'commons-io.jar',
        unzip:true
    },
    {
        url:'http://archive.apache.org/dist/commons/lang/binaries/',
        remoteFileName:'commons-lang-2.6-bin.zip',
        destinationPath:constants.DOWNLOADS_FOLDER,
        destinationFileName:'commons-lang-2.6-bin.zip',
        pathOfFileToBeCopiedFrom:'commons-lang-2.6/commons-lang-2.6.jar',
        pathOfFileToBeCopiedTo:constants.FLEXJS_FOLDER + falconLibExternalFolder + 'commons-lang-2.6.jar',
        unzip:true
    },
    {
        url:'http://search.maven.org/remotecontent?filepath=com/google/guava/guava/20.0/',
        remoteFileName:'guava-20.0.jar',
        destinationPath:constants.FLEXJS_FOLDER + falconLibExternalFolder,
        destinationFileName:'guava.jar',
        unzip:false
    },
    {
        url:'http://search.maven.org/remotecontent?filepath=net/sourceforge/jburg/jburg/1.10.2/',
        remoteFileName:'jburg-1.10.2.jar',
        destinationPath:constants.FLEXJS_FOLDER + falconLibExternalFolder,
        destinationFileName:'jburg.jar',
        unzip:false
    },
    {
        url:'http://jflex.de/',
        remoteFileName:'jflex-1.6.0.zip',
        destinationPath:constants.DOWNLOADS_FOLDER,
        destinationFileName:'',
        pathOfFileToBeCopiedFrom:'jflex-1.6.0/lib/jflex-1.6.0.jar',
        pathOfFileToBeCopiedTo:constants.FLEXJS_FOLDER + falconLibExternalFolder + 'jflex.jar',
        unzip:true
    },
    {
        url:'http://www.java2s.com/Code/JarDownload/lzma/',
        remoteFileName:'lzma-9.20.jar.zip',
        destinationPath:constants.DOWNLOADS_FOLDER + 'lzma/',
        destinationFileName:'lzma-9.20.jar.zip',
        pathOfFileToBeCopiedFrom:'lzma-9.20.jar',
        pathOfFileToBeCopiedTo:constants.FLEXJS_FOLDER + falconLibExternalFolder + 'lzma-sdk.jar',
        unzip:true
    },
    {
        url:'http://search.maven.org/remotecontent?filepath=org/apache/flex/flex-tool-api/1.0.0/',
        remoteFileName:'flex-tool-api-1.0.0.jar',
        destinationPath:constants.FLEXJS_FOLDER + falconLibExternalFolder,
        destinationFileName:'flex-tool-api.jar',
        unzip:false
    },
    {
        url:'http://search.maven.org/remotecontent?filepath=args4j/args4j/2.0.28/',
        remoteFileName:'args4j-2.0.28.jar',
        destinationPath:jsLibFolder,
        destinationFileName:'args4j.jar',
        unzip:false
    },
    {
        url:'http://dl.google.com/closure-compiler/',
        remoteFileName:'compiler-20161201.zip',
        destinationPath:constants.DOWNLOADS_FOLDER,
        destinationFileName:'compiler-20161201.zip',
        pathOfFileToBeCopiedFrom:'closure-compiler-v20161201.jar',
        pathOfFileToBeCopiedTo:googleClosureCompilerFolder + 'compiler.jar',
        unzip:true
    },
    {
        url:'http://archive.apache.org/dist/commons/io/binaries/',
        remoteFileName:'commons-io-2.4-bin.zip',
        destinationPath:constants.DOWNLOADS_FOLDER,
        destinationFileName:'commons-io-2.4-bin.zip',
        pathOfFileToBeCopiedFrom:'commons-io-2.4/commons-io-2.4.jar',
        pathOfFileToBeCopiedTo:jsLibFolder + 'commons-io.jar',
        unzip:true
    },
    {
        url:'http://search.maven.org/remotecontent?filepath=com/google/guava/guava/20.0/',
        remoteFileName:'guava-20.0.jar',
        destinationPath:jsLibFolder,
        destinationFileName:'guava.jar',
        unzip:false
    },
    {
        url:'http://search.maven.org/remotecontent?filepath=org/codeartisans/org.json/20131017/',
        remoteFileName:'org.json-20131017.jar',
        destinationPath:jsLibFolder,
        destinationFileName:'org.json.jar',
        unzip:false
    },
    {
        url:'http://search.maven.org/remotecontent?filepath=org/apache/flex/flex-tool-api/1.0.0/',
        remoteFileName:'flex-tool-api-1.0.0.jar',
        destinationPath:jsLibFolder,
        destinationFileName:'flex-tool-api.jar',
        unzip:false
    }
];

ApacheFalcon.handleFalconMirrorsResponse = function (error, response, body)
{
    if (!error && response.statusCode == 200)
    {
        var mirrors = JSON.parse(body);
        var falconPreferredDownloadURL = mirrors.preferred + pathToFalconBinary + fileNameFalconBinary;
        console.log('Downloading Apache Flex Falcon Compiler from mirror: ' + falconPreferredDownloadURL);
        request
            .get(falconPreferredDownloadURL)
            .pipe(fs.createWriteStream(constants.DOWNLOADS_FOLDER + fileNameFalconBinary)
                .on('finish', function(){
                    console.log('Apache Flex Falcon Compiler download complete');
                    ApacheFalcon.extract();
                })
        );
    }
};

ApacheFalcon.extract = function()
{
    console.log('Extracting Apache Flex Falcon Compiler');
    fs.createReadStream(constants.DOWNLOADS_FOLDER + fileNameFalconBinary)
        .pipe(unzip.Extract({ path: constants.DOWNLOADS_FOLDER + 'falcon'})
            .on('finish', function(){
                console.log('Apache Flex Falcon Compiler extraction complete');
                ApacheFalcon.prepareForFalconDependencies();
            })
    );
};

ApacheFalcon.prepareForFalconDependencies = function()
{
    //Create lib directory if it does not exist already
    try
    {
        fs.mkdirSync(constants.DOWNLOADS_FOLDER + falconCompilerLibFolder);
    }
    catch(e)
    {
        if ( e.code != 'EEXIST' ) throw e;
    }
    try
    {
        fs.mkdirSync(googleClosureCompilerFolder);
    }
    catch(e)
    {
        if ( e.code != 'EEXIST' ) throw e;
    }

    try
    {
        mkdirp(constants.FLEXJS_FOLDER + 'js/bin');
    }
    catch(e)
    {
        if ( e.code != 'EEXIST' ) throw e;
    }

    try
    {
        mkdirp(constants.FLEXJS_FOLDER + 'js/lib');
    }
    catch(e)
    {
        if ( e.code != 'EEXIST' ) throw e;
    }

    try
    {
        mkdirp(constants.FLEXJS_FOLDER + 'js/libs');
    }
    catch(e)
    {
        if ( e.code != 'EEXIST' ) throw e;
    }

    try
    {
        mkdirp(constants.FLEXJS_FOLDER + 'flex-typedefs');
    }
    catch(e)
    {
        if ( e.code != 'EEXIST' ) throw e;
    }

    //Create downloads directory if it does not exist already
    try
    {
        mkdirp(constants.FLEXJS_FOLDER + 'bin');
    }
    catch(e)
    {
        if ( e.code != 'EEXIST' ) throw e;
    }

    try
    {
        mkdirp(constants.FLEXJS_FOLDER + 'lib/external');
    }
    catch(e)
    {
        if ( e.code != 'EEXIST' ) throw e;
    }

    ApacheFalcon.downloadDependencies();
};

var currentStep = -1;

ApacheFalcon.downloadDependencies = function()
{
    ApacheFalcon.downloadNextDependency();
};

ApacheFalcon.downloadNextDependency = function()
{
    currentStep += 1;

    if(currentStep >= falconDependencies.length)
    {
        ApacheFalcon.dependenciesComplete();
    }
    else
    {
        duc.once("installFail", handleDependencyInstallFail);
        duc.once("installComplete", handleDependencyInstallComplete);
        duc.install(falconDependencies[currentStep]);
    }
};

function handleDependencyInstallFail(event)
{
    ApacheFalcon.emit('abort');
}

function handleDependencyInstallComplete(event)
{
    ApacheFalcon.downloadNextDependency();
}

ApacheFalcon.dependenciesComplete = function()
{
    ApacheFalcon.copyFiles();
    ApacheFalcon.fixConfigFiles();
    ApacheFalcon.falconInstallComplete();
};

ApacheFalcon.copyFiles = function()
{
    console.log('Copying lib and bin directories');

    var mergedirs = require('merge-dirs');

    //Bin
    mergedirs.default(constants.DOWNLOADS_FOLDER + 'falcon/compiler/src/assembly/scripts',
        constants.FLEXJS_FOLDER + 'bin',
        'overwrite');

    //copyfiles.jx copy FalconJX files into SDK
    mergedirs.default(constants.DOWNLOADS_FOLDER + 'falcon/js/lib',
        constants.FLEXJS_FOLDER + 'js/lib',
        'overwrite');
    mergedirs.default(constants.DOWNLOADS_FOLDER + 'falcon/js/libs',
        constants.FLEXJS_FOLDER + 'js/libs',
        'overwrite');

    mergedirs.default(constants.DOWNLOADS_FOLDER + 'falcon/flex-typedefs',
        constants.FLEXJS_FOLDER + 'flex-typedefs',
        'overwrite');

    mergedirs.default(constants.DOWNLOADS_FOLDER + 'falcon/compiler/lib',
        constants.FLEXJS_FOLDER + 'lib',
        'overwrite');

    /*
    mergedirs.default(constants.DOWNLOADS_FOLDER + 'falcon/compiler/lib',
        constants.FLEXJS_FOLDER + 'lib/external',
        'overwrite');
	*/

/*    fs.createReadStream(constants.DOWNLOADS_FOLDER + 'falcon/compiler/generated/dist/sdk/lib/' + 'falcon-mxmlc.jar')
        .pipe(fs.createWriteStream(jsLibFolder + 'mxmlc.jar'));

    fs.createReadStream(constants.DOWNLOADS_FOLDER + 'falcon/compiler/generated/dist/sdk/lib/' + 'falcon-mxmlc.jar')
        .pipe(fs.createWriteStream(constants.FLEXJS_FOLDER + 'lib/' + 'mxmlc.jar'));*/

// Ant TODO:FIXME

};

ApacheFalcon.fixConfigFiles = function()
{

    console.log('Updating Config files');

    fs.createReadStream(constants.FLEXJS_FOLDER + 'frameworks/flex-config-template.xml')
        .pipe(fs.createWriteStream(constants.FLEXJS_FOLDER + 'frameworks/flex-config.xml'))
        .on('close', function(){
            replace({
                regex: "@playerversion@",
                replacement: playerVersion,
                paths: [constants.FLEXJS_FOLDER + 'frameworks/flex-config.xml'],
                recursive: false,
                silent: false
            });

            replace({
                regex: "@swfversion@",
                replacement: swfVersion,
                paths: [constants.FLEXJS_FOLDER + 'frameworks/flex-config.xml'],
                recursive: false,
                silent: false
            });

            replace({
                regex: "{playerglobalHome}",
                replacement: "libs/player",
                paths: [constants.FLEXJS_FOLDER + 'frameworks/flex-config.xml'],
                recursive: false,
                silent: false
            });
        });

    fs.createReadStream(constants.FLEXJS_FOLDER + 'frameworks/air-config-template.xml')
        .pipe(fs.createWriteStream(constants.FLEXJS_FOLDER + 'frameworks/air-config.xml'))
        .on('close', function(){
            replace({
                regex: "@playerversion@",
                replacement: playerVersion,
                paths: [constants.FLEXJS_FOLDER + 'frameworks/air-config.xml'],
                recursive: false,
                silent: false
            });

            replace({
                regex: "@swfversion@",
                replacement: swfVersion,
                paths: [constants.FLEXJS_FOLDER + 'frameworks/air-config.xml'],
                recursive: false,
                silent: false
            });

            replace({
                regex: "{airHome}/frameworks/libs",
                replacement: "libs",
                paths: [constants.FLEXJS_FOLDER + 'frameworks/air-config.xml'],
                recursive: false,
                silent: false
            });
        });

};

ApacheFalcon.falconInstallComplete = function()
{
    ApacheFalcon.emit('complete');
};

ApacheFalcon.install = function()
{
    //to test with a nightly build or another custom URL, run the following
    //command with your custom URL
    //npm config set falcon_custom_url http://example.com/path/to/falcon.zip
    //example URL: http://apacheflexbuild.cloudapp.net:8080/job/flex-falcon/lastSuccessfulBuild/artifact/out/apache-flex-falconjx-0.8.0-bin.zip
    var customURL = process.env.npm_package_config_falcon_custom_url;
    var isCustom = typeof customURL !== "undefined";
    if(isCustom)
    {
        var downloadURL = customURL;
    }
    else
    {
        downloadURL = constants.APACHE_MIRROR_RESOLVER_URL + pathToFalconBinary + fileNameFalconBinary + '?' + constants.REQUEST_JSON_PARAM;
    }
    console.log('Downloading Apache Flex "Falcon" Compiler from ' + downloadURL);
    if(isCustom)
    {
    	request
    		.get(downloadURL)
    		.pipe(fs.createWriteStream(constants.DOWNLOADS_FOLDER + fileNameFalconBinary)
    			.on('finish', function(){
    				console.log('Apache Flex Falcon Compiler download complete');
    				ApacheFalcon.extract();
    			})
    	);
    }
    else
    {
        request(downloadURL, ApacheFalcon.handleFalconMirrorsResponse);
    }
};