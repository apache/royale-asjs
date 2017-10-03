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


/**
 *  Configurations of environments where tests are run
 *  are mapped to IDs.
 *  
 *  This can't be database stuff because we don't know
 *  some of this info. until we are actually running.
 *
 *  Most tests will only differ with deviceDensity and OS, with a few differing by screenDPI.
 *  We aren't embedding in this release, so the same deviceDensity basesline will differ across
 *  OSs.  But that will probably change in Ultra, which is why the DPI is used in the config ID.
 *
 *  The color depth is just theoretical, and the osVersion has not been needed.
 *
 *  DEVICES:
 *  
 *  Device            deviceDensity    os        screenDPI    widthxheight    color    osVersion
 *  win               160              win       160          320x455         -        -
 *  Playbook          160              qnx       170          1024x600        -        -
 *  win               240              win       240          480x762         -        -
 *  Droid 2:          240              android   240          480x854         -        -
 *  Droid X:          240              android   240          480x816         -        -
 *  Nexus One:        240              android   240          480x762         -        -
 *  Desire:           240              android   240          480x762         -        -
 *  Nexus S:          240              android   240          480x762         -        -
 *  win               320              win       320          640x960         -        -
 *  iPodTouch4G:      320              ios       326          640x960         -        -
 *
 */

import mx.core.FlexGlobals;

public class TargetConfigurations
{
	//TODO add some larger screens?
	public static var configs:Array = [
		{ configID: "160_01", deviceDensity: 160, os: DeviceNames.WIN, screenDPI: 160, deviceWidth: 320, deviceHeight: 455, color: null, osVersion: null},
		{ configID: "160_02", deviceDensity: 160, os: DeviceNames.MAC, screenDPI: 160, deviceWidth: 320, deviceHeight: 455, color: null, osVersion: null},		
		{ configID: "160_03", deviceDensity: 160, os: DeviceNames.QNX, screenDPI: 170, deviceWidth: 1024, deviceHeight: 600, color: null, osVersion: null},
		{ configID: "240_01", deviceDensity: 240, os: DeviceNames.WIN, screenDPI: 240, deviceWidth: 480, deviceHeight: 762, color: null, osVersion: null},
		{ configID: "240_02", deviceDensity: 240, os: DeviceNames.MAC, screenDPI: 240, deviceWidth: 480, deviceHeight: 762, color: null, osVersion: null},		
		{ configID: "240_03", deviceDensity: 240, os: DeviceNames.ANDROID, screenDPI: 240, deviceWidth: 480, deviceHeight: 816, color: null, osVersion: null},
		{ configID: "240_04", deviceDensity: 240, os: DeviceNames.ANDROID, screenDPI: 240, deviceWidth: 480, deviceHeight: 854, color: null, osVersion: null},
		{ configID: "240_05", deviceDensity: 240, os: DeviceNames.ANDROID, screenDPI: 240, deviceWidth: 480, deviceHeight: 762, color: null, osVersion: null},
		{ configID: "320_01", deviceDensity: 320, os: DeviceNames.WIN, screenDPI: 320, deviceWidth: 640, deviceHeight: 960, color: null, osVersion: null},
		{ configID: "320_02", deviceDensity: 320, os: DeviceNames.MAC, screenDPI: 320, deviceWidth: 640, deviceHeight: 960, color: null, osVersion: null},		
		{ configID: "320_03", deviceDensity: 320, os: DeviceNames.IOS, screenDPI: 326, deviceWidth: 640, deviceHeight: 960, color: null, osVersion: null},
		{ configID: "480_01", deviceDensity: 480, os: DeviceNames.ANDROID, screenDPI: 441, deviceWidth: 1080, deviceHeight: 1920, color: null, osVersion: null}
	];
	
	/**
	 * Returns the config ID which best matches the given ConditionalValue.
	 * This config ID will get added to baselines.  e.g. MyGroovyTest_160_01.png
	 **/
	public static function getTargetConfigID( cv:ConditionalValue ):String{
		var i:int = 0;

		if( cv == null ){
			return null;
		}
		
		// Get these when a test is actually running.
		if( cv.deviceWidth == -1 ){
			cv.deviceWidth = FlexGlobals.topLevelApplication.width;
		}
	
		if( cv.deviceHeight == -1 ){
			cv.deviceHeight = FlexGlobals.topLevelApplication.height;
		}
		
		for( i = 0; i < configs.length; ++i ){
			if( cv.deviceDensity == configs[ i ].deviceDensity &&
			    cv.os == configs[ i ].os &&
			    cv.screenDPI == configs[ i ].screenDPI &&
			    cv.deviceWidth == configs[ i ].deviceWidth &&
			    cv.deviceHeight == configs[ i ].deviceHeight
			    ){
				return configs[ i ].configID;
			}else{
				//trace( "*********This did not match:**********" );
				//trace( "deviceDensity: " + configs[ i ].deviceDensity + "!=" + cv.deviceDensity );
				//trace( "os: " + configs[ i ].os + "!=" + cv.os );
				//trace( "screenDPI: " + configs[ i ].screenDPI + "!=" + cv.screenDPI );
				//trace( "deviceWidth: " + configs[ i ].deviceWidth + "!=" + cv.deviceWidth );
				//trace( "deviceHeight: " + configs[ i ].deviceHeight + "!=" + cv.deviceHeight );				
			}
		}
		
		// No matches.
		return null;

	}
} // end TargetConfigurations class
} // end package
