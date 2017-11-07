Running the CordovaCameraExample on an Android Device

From Flash Builder or the command line, run the Royale Compiler, to build the HTML/JavaScript version of your app.
% cd ~/dev/royale-asjs/examples/CordovaCameraExample
% ant all

The ANT script will build the application and then create the Cordova template in the app/CordovaCameraExample directory.

Now install the Android platform:

% cd app/CordovaCameraExample
% cordova platform add android

Now install the plugin:

% cordova plugin add cordova-plugin-camera

Once this is complete, you can connect your Android device to your computer and run it:

EITHER (if still in the Cordova app/CordovaCameraExample directory):
% cordova run

OR (return to top-level example directory):
% cd royale-asjs/examples/royale/CordovaCameraExample
% ant run

Or run on the simulator
% cordova emulate android
