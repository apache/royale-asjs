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
var fs = require('fs-extra');
var events = require('events');
var unzip = require('unzipper');
var constants = require('../dependencies/Constants');

var DownloadUncompressAndCopy = module.exports = Object.create(events.EventEmitter.prototype);

DownloadUncompressAndCopy.downloadFile = function(item)
{
	var inClose = false;
	
    console.log('Downloading: ' + item.url + item.remoteFileName);
    request
        .get(item.url + item.remoteFileName)
        .on('response', function(response){
            if(response.statusCode != 200)
            {
                console.log('Download failed with status code: ' + response.statusCode);
                DownloadUncompressAndCopy.emit('installFail');
            }
            else
            {
                response.pipe(fs.createWriteStream(constants.DOWNLOADS_FOLDER + item.remoteFileName, {emitClose:true})
                    .on('close', function(){
						if (inClose) return;
						inClose = true;
                        console.log('Finished downloading: ' + item.url + item.remoteFileName);
                        if(item.unzip)
                        {//Unzip
                            console.log('Uncompressing:  ' + constants.DOWNLOADS_FOLDER + item.remoteFileName);
                            fs.createReadStream(constants.DOWNLOADS_FOLDER + item.remoteFileName)
                                .pipe(unzip.Parse())
                                .on('entry', function (entry) {
                                    var fileName = entry.path;
                                    var type = entry.type; // 'Directory' or 'File'
                                    var size = entry.size;
                                    if (fileName === item.pathOfFileToBeCopiedFrom) {
                                        entry.pipe(fs.createWriteStream(item.pathOfFileToBeCopiedTo));
                                    } else {
                                        entry.autodrain();
                                    }
                                })
                                .on('finish', function(){
                                    console.log('Finished uncompressing: ' + constants.DOWNLOADS_FOLDER + item.remoteFileName + ' to: ' + item.destinationPath + item.destinationFileName);
                                    DownloadUncompressAndCopy.emit('installComplete');
                                })

                        }
                        else
                        {//Just copy
                            if((constants.DOWNLOADS_FOLDER + item.remoteFileName === item.destinationPath + item.destinationFileName))
                            {
                                DownloadUncompressAndCopy.emit('installComplete');
                            }
                            else
                            {
								if (!fs.existsSync(item.destinationPath)) {
									fs.ensureDirSync(item.destinationPath);
								}
                                fs.createReadStream(constants.DOWNLOADS_FOLDER + item.remoteFileName, {emitClose:true})
                                    .pipe(fs.createWriteStream(item.destinationPath + item.destinationFileName))
                                    .on('close', function(){
                                        console.log("Copied " + constants.DOWNLOADS_FOLDER + item.remoteFileName + " to " +
                                            item.destinationPath + item.destinationFileName);
                                        DownloadUncompressAndCopy.emit('installComplete');
                                    });
                            }
                        }
                    })
            );
            }
        })
};

DownloadUncompressAndCopy.install = function(item)
{
    DownloadUncompressAndCopy.downloadFile(item);
};