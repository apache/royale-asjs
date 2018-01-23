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

[Mixin]
/**
 *  A "marker" class that causes test scripts to write out
 *  bitmaps to the urls if the comparison fails.
 */
public class SaveBitmapFailuresDistServer
{

	/**
	 *  Mixin callback 
	 */
	public static function init(root:DisplayObject):void
	{
		CompareBitmap.fileSuffix = ".bad.png";
		UnitTester.bitmapServerPrefix = "http://localhost:8700/baselines/baseline.jsp?filename=";
		UnitTester.serverCopy = "http://flexqa01/FlexFiles/Uploader.upbmp?";

		if (UnitTester.isVettingRun)
			UnitTester.bitmapServerPrefix = "http://localhost:9995/baselines/baseline.jsp?filename=";
	}


	public static function urlAssemble (type:String, testDir:String, testFile:String, testCase:String, run_id:String):String 
	{

		testDir=encodeURIComponent(testDir);
		testFile = encodeURIComponent(testFile);
		testCase = encodeURIComponent(testCase);

		var back:String = "type=" + type + "&testFile="+ testDir + testFile + "&testCase=" + testCase + "&runid=" + run_id;

		return UnitTester.serverCopy + back;



	}

}

}
