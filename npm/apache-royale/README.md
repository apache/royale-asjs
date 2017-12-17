Apache FlexJS
=============

Apache FlexJS is a next-generation Flex SDK that has the goal of allowing 
applications developed in MXML and ActionScript to not only run in the 
Flash/AIR runtimes, but also to run natively in the browser without Flash, 
on mobile devices as a PhoneGap/Cordova application, and in embedded JS 
environments such as Chromium Embedded Framework. FlexJS has the potential 
to allow your MXML and ActionScript code to run in even more places than 
Flash currently does. 

For detailed information about Apache Flex please visit the 
[FlexJS Wiki](https://s.apache.org/flexjs)

For detailed information about Apache Flex please visit the
[Apache Flex Website](http://flex.apache.org/)

Installation
==================================

Install the Apache FlexJS NPM Module globally

    npm install flexjs -g

(There are a couple of prompts you need to answer before installation starts)
	
Usage
==================================	

After global installation, the following compiler tools will be available for you 
to use: `mxmlc`, `compc`, `asjsc`, `asjscompc`, `asnodec`, and `externc`.

Usage: 

	mxmlc <path to main .mxml file>
	asjsc <path to main .as file>

Examples
==================================	

There are several examples that ship with the FlexJS npm module. They are located in:
Windows:

	C:\Users\<username>\AppData\Roaming\npm\node_modules\flexjs\examples\

Mac:

	/usr/local/lib/node_modules/flexjs/examples/ 

You can compile them with FlexJS like this:

MXMLC (Targets apps built for the FlexJS SDK, which creates a SWF file as well as 
HTML5/JavaScript output)

Windows:

	mxmlc C:\Users\<username>\AppData\Roaming\npm\node_modules\flexjs\examples\flexjs\ChartExample\src\main\flex\ChartExample.mxml

Mac:

	mxmlc /usr/local/lib/node_modules/flexjs/examples/flexjs/ChartExample/src/main/flex/ChartExample.mxml

ASJSC (Write ActionScript3 targeting HTML5/SVG DOM without requiring JavaScript):

Windows:

	asjsc C:\Users\<username>\AppData\Roaming\npm\node_modules\flexjs\examples\native\USStatesMap\src\main\flex\USStatesMap.as

Mac:

	asjsc /usr/local/lib/node_modules/flexjs/examples/native/USStatesMap/src/main/flex/USStatesMap.as

You may need to copy the examples to a writeable folder because the compilation
will generate an output folder in the example folders.

Note
=================================
    
Note: Apache Flex™, Flex, FlexJS and Apache™ are trademarks of The Apache Software Foundation.
The Apache Flex SDK product page is located here: http://flex.apache.org

Adobe Flash, Adobe AIR, and Adobe PhoneGap are either registered trademarks or trademarks 
of Adobe Systems Incorporated in the United States and/or other countries and are used by 
permission from Adobe.