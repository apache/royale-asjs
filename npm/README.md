The **Apache Royale** NPM packages are distributed under the Apache-Royale NPM organization: https://www.npmjs.com/org/apache-royale

**There are two packages available:**

1.  `@apache-royale/royale-js` [https://www.npmjs.com/package/@apache-royale/royale-js]
2.  `@apache-royale/royale-js-swf` [https://www.npmjs.com/package/@apache-royale/royale-js-swf]

The package: `@apache-royale/royale-js` supports only the JS/HTML output.  
The package: `@apache-royale/royale-js-swf` supports both JS/HTML and SWF/AIR output.  

##For End Users

**Manual installs**

To install these packages, users need to run the following commands:

```
npm install @apache-royale/royale-js -g
npm install @apache-royale/royale-js-swf -g
```

**Automated installs**

Set the environment variable: `ACCEPT_ALL_ROYALE_LICENSES=true` to accept all the licenses prompted 
by the npm installer script.  This lets you use the installer in a automated environment without 
interactive prompts. 

##For Release Managers

To setup the publish scripts, first run:

```
cd release-scripts
npm install
```

To publish the packages to NPM, run:

```
node publish.js --type=js-only --pathToTarball=path-to-tgz-file --username=npm-username --password=npm-password
node publish.js --type=js-swf --pathToTarball=path-to-tgz-file --username=npm-username --password=npm-password
```

For example:
```
node publish.js --type=js-only --pathToTarball="C:\p\os\flexroot\royale\royale-asjs\out\binaries\apache-royale-0.9.0-bin-js.tar.gz" --username=apache-royale-owner --password=shared_in_private
node publish.js --type=js-swf --pathToTarball="C:\p\os\flexroot\royale\royale-asjs\out\binaries\apache-royale-0.9.0-bin-js-swf.tar.gz" --username=apache-royale-owner --password=shared_in_private
```