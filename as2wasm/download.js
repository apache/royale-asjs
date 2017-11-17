'use strict';

const promptText = '\n\
\n\
Apache FlexJS SDK uses the Adobe Flash Player\'s playerglobal.swc to build\n\
Adobe Flash applications. The playerglobal.swc file is subject to and governed\n\
by the Adobe Flex SDK License Agreement specified here:\n\
\n\
http://www.adobe.com/products/eulas/pdfs/adobe_flex_software_development_kit-combined-20110916_0930.pdf\n\
\n\
By downloading, modifying, distributing, using and/or accessing the\n\
playerglobal.swc fileyou agree to the terms and conditions of the applicable\n\
end user license agreement.\n\
\n\
In addition to the Adobe license terms, you also agree to be bound by the\n\
third-party terms specified here:\n\
\n\
http://www.adobe.com/products/eula/third_party/.\n\
\n\
Adobe recommends that you review these third-party terms. This license is not\n\
compatible with the Apache v2 license.\n\
\n\
Adobe Flash Player\'s playerglobal.swc is a required component.\n\
\n\
Do you want to download and install the playerglobal.swc? (y/n)';

let fs, fileData, prompt, request, schema;



fs = require('fs');
prompt = require('prompt');
request = require('request');



fileData = {
  fileName: 'playerglobal',
  fileExtension: '.swc',
  url: 'http://download.macromedia.com/get/flashplayer/updaters',
  version: '25'
};


schema = {
  properties: {
    accept: {
      description: promptText.cyan,
      pattern: /^[YNyn\s]$/,
      message: 'Please respond with either y or n'.red,
      required: true
    }
  }
};

prompt.start();
prompt.get(schema, function (err, result) {
  if('y' === result.accept.toLowerCase()) {
    let url;

    url = `${fileData.url}/${fileData.version}/${fileData.fileName}${fileData.version}_0${fileData.fileExtension}`;

    console.log(`Downloading: ${url}`);

    request
    .get(url)
    .on('response', function (response) {
      if(200 !== response.statusCode) {
        console.log(`Download failed with status code: ${response.statusCode}`);
      } else {
        let destination = `lib/player/${fileData.version}.0/`;

        if (!fs.existsSync('lib')) {
          fs.mkdirSync('lib');
        }
        if (!fs.existsSync('lib/player')) {
          fs.mkdirSync('lib/player');
        }
        if (!fs.existsSync(destination)) {
          fs.mkdirSync(destination);
        }

        response.pipe(fs.createWriteStream(`${destination}${fileData.fileName}${fileData.fileExtension}`)
        .on('close', function(){
          console.log(`Finished downloading: ${destination}${fileData.fileName}${fileData.fileExtension}`);
        })
        );
      }
    });
  } else {
    console.log('Aborting installation');
  }
});
