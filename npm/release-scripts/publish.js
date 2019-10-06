////////////////////////////////////////////////////////////////////////////////
//
//  Licensed to the Apache Software Foundation (ASF) under one or more
//  contributor license agreements.  See the NOTICE file distributed with
//  this work for additional information regarding copyright ownership.
//  The ASF licenses this file to You under the Apache License, Version 2.0
//  (the "License"); you may not use this file except in compliance with
//  the License.  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
////////////////////////////////////////////////////////////////////////////////

var npm = require('npm');
var fs = require('fs');
var args = require('yargs').argv;

var username = args.username;
var password = args.password;
var pathToTarball = args.pathToTarball;
var type = args.type;
var npmURL = 'https://registry.npmjs.org';
var tag = args.tag || 'latest';
var auth = {username: username, password:password, email: 'dev@royale.apache.org', tag: tag};
var addUserParams = {auth:auth};

if (!username) {
    throw new Error('Username is required as an argument --username');
}
if (!password) {
    throw new Error('Password is required as an argument --password');
}
if (!pathToTarball) {
    throw new Error('Path to tarball is required as an argument --pathToTarball');
}
if (!type) {
    throw new Error('Type is required as an argument --type');
}

try {
	var RegClient = require('npm-registry-client');
	var client = new RegClient();
	client.adduser(npmURL, addUserParams, function(error) {
		    if (error)
			    throw new Error(error);
	});
	/*
    npm.load(null,function(loadError) {
        if (loadError) {
            throw new Error(loadError);
        }

        npm.registry.adduser(npmURL, addUserParams, function(addUserError) {
            if (addUserError) {
                throw new Error(addUserError);
            }
        });
	*/
    var metadata;
    if(type == 'js-only') {
        metadata = require('../js-only/package.json') ;
    }
    else if(type == 'js-swf') {
        metadata = require('../js-swf/package.json') ;
    }
    var body = fs.createReadStream(pathToTarball);
    var publishParams = {metadata: metadata, access: 'public', body: body, auth: auth};

    console.log('Publishing to NPM: ' + metadata.name + ' version: ' + metadata.version + '...');

    client.publish(npmURL, publishParams, function(publishError) {
            if (publishError) {
                throw new Error(publishError);
            }
            console.log('Successfully published: ' + metadata.name + ' version: ' + metadata.version);
        });

/*    });
	*/

}
catch (error) {
	if (metadata)
	    console.log('Failed to publish to npm ' +  metadata.name + ' version: ' + metadata.version + '\n error: ' + error);
	else
		console.log('Failed to adduser ' + '\n error: ' + error);
}
