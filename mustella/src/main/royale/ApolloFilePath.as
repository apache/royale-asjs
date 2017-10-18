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
package  { 

import flash.display.DisplayObject;
import flash.utils.*;
import flash.net.*;
import flash.events.*;
import flash.display.*;
import flash.desktop.NativeApplication;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.filesystem.File;

[Mixin]
/**
 * Apollo doesn't return anything useable from the loaderInfo.url: 
 * it looks like this: app-context://my.swf
 * The received url in a test, which is looks like "../Properties/baselines/my.png"
 * won't load. Apparently, the "../" is offensive. To get the fully qualified path, 
 * we need the Apollo File class.  That's what this Mixin supplies.
 * Also, Apollo like soft exits, and won't re-launch after a kill (java's destroy process). 
 * so exit by calling the window's close method. 
 */
public class ApolloFilePath 
{ 

	public static var _root:DisplayObject;

	public static function init(root:DisplayObject):void
	{
		UnitTester.isApollo = true;
		CompareBitmap.adjustPath = apolloAdjust;
		
		/// the exit method has to be gentler for apollo, too
		UnitTester.exitWhenDone = true;
		UnitTester.exit = apolloExit;
		_root=root;

	}

	
	/**
	 * gets the url from CompareBitmap; 
	 * creates fully qualified path using flash File class. 
	 */
	public static function apolloAdjust(url:String):String
	{

		var swf:String = _root.loaderInfo.url;
		var f:File = new File (swf);
		// clean it up: 
		var myPattern:RegExp = /\\/g;
		var path:String;
		
		if( UnitTester.cv.os == DeviceNames.ANDROID ){
			// AIR for Android returns empty string for nativePath (on purpose).  Use url instead.
			// See https://zerowing.corp.adobe.com/display/airlinux/Resource+Mapping.
			path = f.url;
		}else{
			path = f.nativePath;
			path = path.replace (":", "|");
		}

		path = path.replace (myPattern, "/");			

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

		if( UnitTester.cv.os == DeviceNames.ANDROID ){
			// AIR for Android needs it to start with app:/, so just return at this point.
			return path;
		}else{
			return "file:///" + path;		
		}
	}

	/**
	 * call the native window close method
	 */
	public static function apolloExit(): void 
	{ 
		/// hack around an issue that apollo seems to hang when it exits
		/// with a socket still open. Arbitrary sleep isn't attractive
		/// but we never received a response from Runner after sending 
		/// ScriptDone
		setTimeout (real_apolloExit, 1500);
	}


	public static function real_apolloExit(): void 
	{ 

		// Call the more general exit
		trace ("Doing an apollo exit");
		NativeApplication.nativeApplication.exit(1);
	}
}

}
