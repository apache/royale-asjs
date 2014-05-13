DesktopMap Example

This sample FlexJS application shows how you can integrate a 3rd party library, such as Google Maps, into the
world of FlexJS.

The ActionScript side is an AIR app that uses HTMLLoader to bring in the Google MAP JavaScript API. You could
also try to use an iFrame with a web application (there are examples of iFrame and Flex scattered around the web).

You can also cross-compile this sample into JavaScript. This is possible because there is a JavaScript version of the
ActionScript Map class. When you generate the JavaScript code, an index.html file is created. You must add the following
<script> lines to that index.html file in order to make the JavaScript version work (the ActionScript version of the Map
class dynamically creates the <script> include statements):

    <script type="text/javascript"
      src="https://maps.googleapis.com/maps/api/js?key={your-key-here}&sensor=false">
    </script>
    
You will need a Google API developer key. When you have it, replace {your-key-here} with your real key.

