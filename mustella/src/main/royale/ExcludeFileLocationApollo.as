////////////////////////////////////////////////////////////////////////////////
//
//  Licensed to the Apache Software Foundation (ASF) under one or more
//  contributor license agreements.  See the NOTICE file distributed with
//  this work for additional information regarding copyright ownership.
//  The ASF licenses this file to You under the Apache License, Version 2.0
//  (the "License"); you may not use this file except in compliance with
//  the License.  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
////////////////////////////////////////////////////////////////////////////////
package {

import flash.display.DisplayObject;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.events.Event;
import flash.system.Capabilities;
import flash.filesystem.File;

[Mixin]
/**
 *  Location of a hash table of tests not to run. 
 *  This mixin should find the excludes written to one of two locations.
 *  Browsers runs are picky about where they find the excludes, so, we serve them 
 *  up via http (in a sibling location to the tests). 
 *  The file is one test per line of the form ScriptName$TestID
 *  The location of the file is assumed to be c:/temp on windows, 
 *  or /tmp on Unix. 
 */
public class ExcludeFileLocationApollo
{

	private static var loader:URLLoader;

	private static var url:String;
	private static var mustellaTestDir:String;

	private static var frontURL:String;
	private static var domain:String;

	public static var excludeFile:String = "ExcludeList.txt";	

	/**
	 * tell UnitTester it should wait for this load to complete
	 */
	UnitTester.waitForExcludes = true;


	public static var _root:DisplayObject;


	public static var triedBrowser:Boolean = false;
	public static var triedNormal:Boolean  = false;

	// we try the http spot, in case this is a browser run
	public static function init(root:DisplayObject):void
	{

		trace ("Hello from excludes at: " + new Date());

        _root = root;
            
        // set up callback to load excludes after 
        // UnitTester has initialized.
        UnitTester.loadExcludeFile = loadExcludeFile;   
        
	}


    public static function loadExcludeFile():void
    {
        var os:String = Capabilities.os;
        
        // This seems to be a timing issue which pops up on some machines.
        if( UnitTester.cv == null ){
            UnitTester.cv = new ConditionalValue();
        }
        
        if( (UnitTester.cv.os != null) && (UnitTester.cv.os.toLowerCase() == DeviceNames.ANDROID.toLowerCase()) ){
            mustellaTestDir = "..";
            excludeFile = UnitTester.excludeFile;
            trace("Doing Android style exclude.  Checking in " + mustellaTestDir + "/" + excludeFile);
        }else if( (UnitTester.cv.os != null) && (UnitTester.cv.os.toLowerCase() == DeviceNames.IOS.toLowerCase()) ){
            mustellaTestDir = File.documentsDirectory.url;
            excludeFile = UnitTester.excludeFile;
        }else if (os.indexOf ("QNX") > -1) {
            mustellaTestDir = "..";
            excludeFile = UnitTester.excludeFile;
            trace("Doing QNX style exclude.  Checking in " + mustellaTestDir + "/" + excludeFile);
        }
        else{
            
            if (os.indexOf ("Windows") != -1) 
            {
                excludeFile = "ExcludeListWinAIR.txt";
            } else if (os.indexOf ("Mac") != -1) 
            {
                excludeFile = "ExcludeListMacAIR.txt";
            } else if (os.indexOf ("Linux") != -1) 
            {
                excludeFile = "ExcludeListLinux.txt";
            } else 
            {		
                trace ("Excludes: bad: we didn't see an OS we liked: " + os);
                excludeFile = "ExcludeListWin.txt";
            }
            
            url = _root.loaderInfo.url;
            
            if (url.indexOf("app:")!=-1) 
            {
                ApolloFilePath.init (_root);
                url = encodeURI2(ApolloFilePath.apolloAdjust(url));
                trace ("Adjusting path for AIR to: " + url);
                // url = adjustPath(url);
            }
            
            // allow application to override mustella test dir
            if (!UnitTester.mustellaTestDir)
                mustellaTestDir = url.substring (0, url.indexOf ("mustella/tests")+14);
            else
                mustellaTestDir = UnitTester.mustellaTestDir;
            
            frontURL = url.substring (0, url.indexOf (":"));
            domain = url.substring (url.indexOf (":")+3);		
            domain = domain.substring (0, domain.indexOf ("/"));
        }
        
        loadTryNormal();
        
    }

    private static function apolloAdjust(url:String):String
	{

		var swf:String = _root.loaderInfo.url;
		var f:File = new File (swf);
		// clean it up: 
		var myPattern:RegExp = /\\/g; 
		var path:String = f.nativePath;
		path = path.replace (myPattern, "/");
		path = path.replace (":", "|");
		// yank off the swfs directory, which we're in
		path = path.substr (0, path.lastIndexOf ("/")-1);
		path = path.substr (0, path.lastIndexOf ("/"));

		if (url.indexOf ("../")==0)
			url = url.substring (2);

		if (url.indexOf ("/..")==0)
		{
			url = url.substring (3);
			path = path.substr (0, path.lastIndexOf ("/"));
		}

		/// create the final url
		path = path + url;

		return "file:///" + path;
	}

	public static var adjustPath:Function = function(url:String):String { return url; };



        private static function encodeURI2(s:String):String
        {
                var pos:int = s.lastIndexOf("/");
                if (pos != -1)
                {
                        var fragment:String = s.substring(pos + 1);
                        s = s.substring(0, pos + 1);
                        fragment= encodeURIComponent(fragment);
                        s = s + fragment;
                }
                return s;
        }


	public static function loadTryBrowser():void
	{
		trace ("excludes loadTryBrowser at: " + new Date().toString());

		triedBrowser = true;

		var currentOS:String = Capabilities.os;

		var useFile:String = "http://localhost/" + excludeFile;

		trace ("try excludes from here: " + useFile);

		var req:URLRequest = new URLRequest(useFile);
		loader = new URLLoader();
		loader.addEventListener("complete", completeHandler);
		loader.addEventListener("securityError", errorHandler);
		loader.addEventListener("ioError", errorHandler);
		loader.load(req);

	}

	/// if it worked, all good
	private static function completeHandler(event:Event):void
	{
		trace ("Excludes: from web server");
		postProcessData(event);
	}


	/**
	 *  A non-browser will get its results from the /tmp location. 
 	 *  It should be a failure to get here; we try the browser case first
	 *  because it throws a nasty seciry
	 *  
	 */
	public static function errorHandler(event:Event):void
	{ 
	
		trace ("Exclude: in the web read error handler");
		if (!triedNormal) 
		{
			loadTryNormal();	

		}

	}
	public static function loadTryNormal():void
	{

		triedNormal = true;

		trace ("excludes loadTryFile " + new Date().toString());

		var currentOS:String = Capabilities.os;

		var useFile:String;

		useFile = mustellaTestDir +"/" + excludeFile;

		trace ("Exclude: try load from: " + useFile);

		var req:URLRequest = new URLRequest(useFile);
		loader = new URLLoader();
		loader.addEventListener("complete", completeHandler2);
		loader.addEventListener("ioError", errorHandler2);
		loader.addEventListener("securityError", errorHandler2);
		loader.load(req);

	}

	private static function errorHandler2(event:Event):void
	{
		trace ("Exclude: error in the exclude file load " +event);	
		if (!triedBrowser) 
		{
			loadTryBrowser();
		}

	}


	private static function completeHandler2(event:Event):void
	{
		trace ("Excludes: Reading from file system at "+mustellaTestDir );
		postProcessData(event);
	}
	private static function postProcessData(event:Event):void
	{
		var data:String = loader.data;
		// DOS end of line
		var delimiter:RegExp = new RegExp("\r\n", "g");
		data = data.replace(delimiter, ",");
		// Unix end of line
		delimiter = new RegExp("\n", "g");
		data = data.replace(delimiter, ",");

		UnitTester.excludeList = new Object();
		var items:Array = data.split(",");
		var n:int = items.length;
		for (var i:int = 0; i < n; i++)
		{
			var s:String = items[i];
			if (s.length)
				UnitTester.excludeList[s] = 1;

		}
		
		UnitTester.waitForExcludes = false;
		UnitTester.pre_startEventHandler(event);
	}
}

}
