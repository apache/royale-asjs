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

var fs = require('fs');
var path = require('path');
var mkdirp = require('mkdirp');
var eol = require('eol');
var constants = require('./Constants');
var adobeair = require('./AdobeAIR');
var flashplayerglobal = require('./FlashPlayerGlobal');
var flatUI = require('./FlatUI');

var installSteps = [
    createDownloadsDirectory,
    installFlatUI,
    installFlashPlayerGlobal,
    installAdobeAIR,
    updateScriptEOL,
    updateScriptPermissions
    ];
var currentStep = 0;

function start()
{
    installSteps[0].call();
}

function updateScriptEOL()
{
    try
    {
        var dirPath = path.join(__dirname, '..', '..', '..', 'js', 'bin');
        var files = fs.readdirSync(dirPath);
        do
        {
            var filePath = files.shift();
            filePath = path.resolve(dirPath, filePath);
            var data = fs.readFileSync(filePath, {encoding: 'utf8'});
            if(path.extname(filePath) === '.bat')
            {
                //windows scripts
                data = eol.crlf(data);
            }
            else
            {
                //mac, linux, or cygwin scripts
                data = eol.lf(data);
            }
            fs.writeFileSync(filePath, data, {encoding: 'utf8', mode: 0x755});
        }
        while(files.length > 0)
    }
    catch(e)
    {
        handleAbort();
        return;
    }
    handleInstallStepComplete();
}

function updateScriptPermissions()
{
    var mode = parseInt('755', 8);
    try
    {
        var dirPath = path.join(__dirname, '..', '..', '..', 'js', 'bin');
        var files = fs.readdirSync(dirPath);
        do
        {
            var filePath = files.shift();
            filePath = path.resolve(dirPath, filePath);
            if(path.extname(filePath) !== '.bat')
            {
                //mac, linux, or cygwin scripts
                fs.chmodSync(filePath, mode);
            }
        }
        while(files.length > 0)
    }
    catch(e)
    {
        handleAbort();
        return;
    }
    handleInstallStepComplete();
}

function createDownloadsDirectory()
{
    //Create downloads directory if it does not exist already
    try
    {
        mkdirp(constants.DOWNLOADS_FOLDER);
    }
    catch(e)
    {
        if ( e.code != 'EEXIST' ) throw e;
    }
    handleInstallStepComplete();
}

function handleInstallStepComplete(event)
{
    currentStep += 1;
    if(currentStep >= installSteps.length)
    {
        allDownloadsComplete();
    }
    else
    {
        if(installSteps[currentStep] != undefined)
        {
            installSteps[currentStep].call();
        }
    }
}

function installFlashPlayerGlobal()
{
    flashplayerglobal.once('complete', handleInstallStepComplete);
    flashplayerglobal.once('abort', handleAbort);
    flashplayerglobal.install();
}

function installAdobeAIR(event)
{
    adobeair.once('complete', handleInstallStepComplete);
    adobeair.once('abort', handleAbort);
    adobeair.install();
}

function installFlatUI(event)
{
    flatUI.once('complete', handleInstallStepComplete);
    flatUI.install();
}

function allDownloadsComplete()
{
    console.log('Installation complete!');
}

function handleAbort()
{
    process.exit(1);
}

start();