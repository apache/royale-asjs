Running the CordovaCameraExample on an Android Device

From Flash Builder or the command line, run the FlexJS cross compiler, FalconJX, to build the HTML/JavaScript version of your app.
% cd ~/dev/flex-asjs/examples/CordovaCameraExample
% ant

Go to your mobile development directory:
%cd ~/mobile

Copy into this directory, the cordova-build.xml ANT script:
% cp ~/dev/flex-asjs/cordova-build.xml

Create the Cordova project for your FlexJS application:
% ant -f cordova-build.xml -DPROJECT_NAME=CordovaCameraExample -DTARGET_DIR=. -DPROJECT_DIR=/Users/home/dev/flex-asjs/examples/CordovaCameraExample/

Load the Cordova camera plugin:
cd CordovaCameraExample
% cordova plugin add org.apache.cordova.camera

Modify the www/index.html file to include the cordova.js source (place this line with the other <script> elements):
<script type="text/javascript" charset="utf-8" src="cordova.js"></script>

Run your app on your connected device:
% cordova run