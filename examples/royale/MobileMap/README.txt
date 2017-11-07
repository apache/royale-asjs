The MobileMap example shows how you can use Royale to create a mobile app experience using both Google Maps and Cordova plugins.

The app itself is very simple: it has a label for status and a map. The application simply shows your current position in the center of the map. 

The app uses the Cordova Geolocation plugin to get the device's current location. The map is displayed using the Royale Google Maps wrapper component.

To get this example to work, you must first make sure you have all of the necessary Royale SDK and associated parts (eg, ANT, the Royale Compiler) downloaded and installed. If you have pulled this example from the examples directory of the Royale SDK, you probably have it all set up now.

You will also need Apache Cordova. You can about the Royale Cordova connection on these Wiki pages which will direct you to the page with instructions for getting Cordova onto your system:

https://cwiki.apache.org/confluence/pages/viewpage.action?pageId=62690320
https://cwiki.apache.org/confluence/pages/viewpage.action?pageId=63406558

Whichever way you want to go: using an IDE like Flash Builder or using the command line, you will still need to install the Cordova Geolocation plugin. The first thing you need to do is build the Cordova application template. 

% cd royale-asjs/examples/royale/MobileMap
% ant all

The ANT script will build the application and then create the Cordova template in the app/MobileMap directory.

Now install the Android platform:

% cd app/MobileApp
% cordova platform add android

Now install the plugin:

% cordova plugin add cordova-plugin-geolocation

Once this is complete, you can connect your Android device to your computer and run it:

EITHER (if still in the Cordova app/MobileMap directory):
% cordova run

OR (return to top-level example directory):
% cd royale-asjs/examples/royale/MobileMap
% ant run

The Cordova app will be built and deployed to the device and started. Note that according to the Cordova documentation, nothing of importance should be done until the app receives the "deviceReady" event. So while the app will display an initial map, it will not center on your current location until receiving this event.

The Google Maps API is contained in the royale-asjs/frameworks/projects/GoogleMaps directory. This API is really only usable by the JavaScript platform output of the example build (eg, royale-asjs/examples/royale/MobileMap/bin/js-debug) as there is no SWF equivalent; the ActionScript API library are just stub calls for SWF but real calls for JavaScript.

Likewise, there is an API for the Cordova Geolocation plugin located in royale-asjs/frameworks/projects/Mobile directory. You will find a geolocation.Geolocation class with stub calls for SWF and code for JavaScript.

Whenever you want to use a Cordova plugin with ActionScript and Royale, you must make an ActionScript library so the compiler knows about it. Use the Geolocation package and class as a template.

