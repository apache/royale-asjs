DesktopMap Example

This sample FlexJS application shows how you can integrate a 3rd party library, such as Google Maps, into the
world of FlexJS.

The ActionScript side is an AIR app that uses HTMLLoader to bring in the Google MAP JavaScript API. You could
also try to use an iFrame with a web application (there are examples of iFrame and Flex scattered around the web).

You can also cross-compile this sample into JavaScript. This is possible because there is a JavaScript version of the
ActionScript Map class. The JavaScript Map class loads the Google MAP API asynchronously and dispatches a "ready" 
event when the load and initialization of the API is complete.
    
You will need a Google API developer key. When you have it, replace --put your Google API dev token here-- with 
your developer token in the MyInitialView.mxml <basic:Map> tag.

