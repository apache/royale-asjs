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

var pjson = require('./package.json');
var request = require('request');
var fs = require('fs');

var royaleDownloadURL = pjson.org_apache_royale.royale_binary_url;
var royaleFileName = pjson.org_apache_royale.royale_binary_file_name;

downloadApacheRoyale();

function downloadApacheRoyale() {
    request
        .get(royaleDownloadURL + royaleFileName)
        .pipe(fs.createWriteStream(royaleFileName)
            .on('close', function(){
                console.log('Apache Royale download complete');
            })
        );
}