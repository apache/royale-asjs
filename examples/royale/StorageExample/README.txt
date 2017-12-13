Storage Example

The StorageExample is designed to show you have to read and write simple, but permanent files using
the Royale Storage framework.

Permanent storage is available when the target platform is either Adobe AIR (desktop or mobile device)
or Apache Cordova (mobile devices).

Build the Example

1. Run the build (ant)

This will build both the AIR and Cordova-compatible versions. The AIR version will be in the
bin-debug directory. The Cordova-compatible versions will be in the js-debug and js-release
directories.

Running on Adobe AIR

1. Run the example (ant run).

This will launch the SWF as an AIR application. 

Running on an Android Device using Cordova

This is a somewhat complex process. The JavaScript and HTML files that were built (bin/js-debug)
need to be moved into a Cordova project. Once there, the application can be deployed to a device
or run in an emulator.

1. In a clean directory, outside of the royale-asjs directories, use the cordova command line
interface to build an empty application:

cordova create filetest org.apache.flex "FileTest"
cd filetest

2. Add in the Android platform and the Cordova File plugin:

cordova platform add android
cordova plugin add cordova-plugin-file

3. Go to the StorageExample/bin/js-debug directory and copy all of the files and directories
into the filetest/www directory:

index.html (replaces the index.html from the generated cordova app)
MyInitialView.js
StorageExample.css
StorageExample.js
externs/
library/
models/
org/


4. Open filetest/www/index.html and replace the <body> element with this:

<body onload="startup()">
  <script type="text/javascript" src="cordova.js"></script>
  <script type="text/javascript">
      function startup() {
        document.addEventListener('deviceready', this.onDeviceReady, false);
      }
      function onDeviceReady() {
         new StorageExample().start();
      }
  </script>
</body>


5. Build the Cordova app from the top filetest directory:

cordova build

6. You can run it either in an emulator on a connected device:

(emulator): cordova emulate android
(device): cordova run android

The filetest/platforms/android directory can be opened from Android Studio if you want to
use an Android IDE. If you need to make changes, do that in the filetest/www directory,
then run "cordova build" again. Android Studio will detect the change, ask you to re-sync,
and after that, you can re-redeploy the changed app to the device.
 
