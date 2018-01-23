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
import flash.system.Capabilities;
[Mixin]
/**
* By including this mixin via CompileMustellaSwfs, we
* can set up some variables for UnitTester to use for
* an Android run.
*/
public class MobileConfig
{
	public static function init(root:DisplayObject):void
	{
		if( UnitTester.cv == null ){
			UnitTester.cv = new ConditionalValue();
		}
		UnitTester.cv.device = "mac";
		UnitTester.cv.os = "android";
		UnitTester.cv.targetOS = "android";
		UnitTester.cv.osVersion = "${os_version}";
		UnitTester.cv.deviceDensity = Util.roundDeviceDensity( flash.system.Capabilities.screenDPI );
		UnitTester.cv.screenDPI = flash.system.Capabilities.screenDPI;
		//UnitTester.cv.deviceWidth = set by MultiResult;
		//UnitTester.cv.deviceHeight = set by MultiResult;
		//UnitTester.cv.color = this is not defined yet, but there are rumours it might be.
		UnitTester.run_id = "-1";
		UnitTester.excludeFile = "ExcludeList${os}.txt";
	}
}
}
