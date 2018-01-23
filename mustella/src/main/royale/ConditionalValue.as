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
package
{
COMPILE::SWF
{
	import flash.events.*;
}
COMPILE::JS
{
    import org.apache.royale.events.EventDispatcher;
}

	[Event(name="valueExpression", type="RunCodeEvent")]	
	public class ConditionalValue extends EventDispatcher
	{
		// Asserts such as AssertPropertyValue use value=...
		public var value:Object = null;
		
		// CompareBitmap uses url=...
		public var url:String = null;
		
		
		/**
		* These are possibilities for the environment.
		* Use Inspectable so that test authoring is a little easier.
		* For details: https://zerowing.corp.adobe.com/display/flexmobile/Multiple+Device%2C+DPI%2C+OS+Support
		**/
		
		[Inspectable(enumeration="win,mac,android,iphone,ios,qnx")]
		public var os:String = null;

		[Inspectable(enumeration="android22,android23,android234,android31,iphone421,iphone50,ios4,ios5,ios6")]
		public var osVersion:String = null;
		
		/**
		 * The targetOS is either null or set in the UnitTester's cv as the value to match
		 * against the os properties from <ConditionalValue> elements present in the test
		 * cases. See MultiResult.chooseCV()
		 */
		[Inspectable(enumeration="android,ios")]
		public var targetOS:String = null;

		// General, "marketing number" pixel density
		[Inspectable(enumeration="120,160,240,320,480,640")]
		public var deviceDensity:Number = -1;

		// Exact pixel density reported by AIR's Capabilities.screenDPI
		public var screenDPI:Number = -1;

		// Exact
		public var deviceWidth:Number = -1;

		// Exact
		public var deviceHeight:Number = -1;

		[Inspectable(enumeration="16,32")]
		public var color:Number = -1;

		[Inspectable(enumeration="air,desire,droid,droid2,droidPro,droidX,evo,incredible,iPad,iPad2,iPodTouch3GS,iPodTouch4G,nexusOne,playbook,xoom")]
		public var device:String = null;

		/**
		* These are used to make file name legible to humans and allow
		* parsing of them.
		**/
		public static const SCREENDPI_SUFFIX:String = "scrDPI";
		public static const DENSITY_SUFFIX:String = "ppi";
		public static const WIDTH_SUFFIX:String = "w";
		public static const HEIGHT_SUFFIX:String = "h";
		public static const COLOR_SUFFIX:String = "bit";
		public static const PNG_SUFFIX:String = ".png";
		public static const DELIMITER1:String = "@"; // between testID and settings
		public static const DELIMITER2:String = "_"; // between settings
		
		/**
		* Constructor
		**/
		public function ConditionalValue(){}

		/**
		* Returns true if all items are at default values (e.g. the default, catch-all CV).
		**/
		public function isDefault():Boolean{
			return ((os == null) &&
					(osVersion == null) &&
					(screenDPI == -1) &&
					(deviceDensity == -1) &&
					(deviceWidth == -1) &&
					(deviceHeight == -1) &&
					(color == -1) &&
					(device == null) &&
					(targetOS == null)
				);
		}

		/**
		* Uses the properties which are set to create a file name for a baseline image.
		**/
		public function createFilename(testID:String):String{
			var ret:String = null;
			var consistent:Boolean = false;
			var testCV:ConditionalValue = new ConditionalValue();
			
			ret = testID + DELIMITER1;

			if( os != null ) {
				ret += os + DELIMITER2;
			}
			
/*			if( targetOS != null ) {
				ret += targetOS + DELIMITER2;
			}*/

			if( osVersion != null ){
				ret += osVersion + DELIMITER2;
			}

			if( screenDPI > -1 ){
				ret += screenDPI.toString() + SCREENDPI_SUFFIX + DELIMITER2;
			}

			if( deviceDensity > -1 ){
				ret += deviceDensity.toString() + DENSITY_SUFFIX + DELIMITER2;
			}
			
			if( deviceWidth > -1 ){
				ret += deviceWidth.toString() + WIDTH_SUFFIX + DELIMITER2;
			}
			
			if( deviceHeight > -1 ){
				ret += deviceHeight.toString() + HEIGHT_SUFFIX + DELIMITER2;
			}
			
			if( color > -1 ){
				ret += color.toString() + COLOR_SUFFIX + DELIMITER2;
			}
			
			if( device != null ){
				ret += device;
			}else{
				// Remove last DELIMITER2.
				if( ret.lastIndexOf(DELIMITER2) == ret.length - 1 ){
					ret = ret.substr(0, ret.length - 1);
				}
			}
			
			ret += PNG_SUFFIX;
			
			trace("ConditionalValue ret="+ret+"; screenDPI="+screenDPI+"; density="+deviceDensity);
			
			// Be sure we'll be able to parse what we wrote when we read it later.
			if( testCV.parseFilename( ret ) ){
				consistent = (testCV.os == os &&
							 testCV.osVersion == osVersion &&
							 testCV.screenDPI == screenDPI &&
							 testCV.deviceDensity == deviceDensity &&
							 testCV.deviceWidth == deviceWidth &&
							 testCV.deviceHeight == deviceHeight &&
							 testCV.color == color &&
							 testCV.device == device );
			}
			
			if( consistent ){
				return ret;
			}else{
				trace("ConditionalValue inconsistency:");
				trace("\twhat\ttestCV\tactualCV");
				trace("\tos\t" + testCV.os + "\t" + os);
				trace("\tosVersion\t" + testCV.osVersion + "\t" + osVersion);
				trace("\tscreenDPI\t" + testCV.screenDPI + "\t" + screenDPI);
				trace("\tdeviceDensity\t" + testCV.deviceDensity + "\t" + deviceDensity);
				trace("\tdeviceWidth\t" + testCV.deviceWidth + "\t" + deviceWidth);
				trace("\tdeviceHeight\t" + testCV.deviceHeight + "\t" + deviceHeight);
				trace("\tcolor\t" + testCV.color + "\t" + color);
				trace("\tdevice\t" + testCV.device + "\t" + device);
				
				return null;
			}
		}
		
		/** 
		* Populate values from a filename.
		**/
		public function parseFilename(filename:String):Boolean{
            /* TODO (aharui) later
            COMPILE::SWF
            {
			var tokens:Array = null;
			var curToken:String = null;
			var tokenDone:Boolean = false;
			var i:int = 0;
			var j:int = 0;
			
			
			if( filename != null ){
				// Remove the extension.
				if( filename.indexOf( PNG_SUFFIX ) > -1 ){
					filename = filename.substring( 0, filename.indexOf( PNG_SUFFIX ) );
				}
				
				if( (filename != null) && (StringUtil.trim( filename ) != "") ){
					tokens = filename.split( DELIMITER1 );
				}
				
				// tokens[0] is the test case, and tokens[1] is the data.
				tokens = tokens[1].split( DELIMITER2 );

				if( (tokens != null) && (tokens.length > 0) ){
					for( i = 0; i < tokens.length; ++i ){
						curToken = tokens[ i ];
						tokenDone = false;
						
						// Look for os.
						for( j = 0; j < DeviceNames.OS_VALUES.length; ++j ){
							if( curToken == DeviceNames.OS_VALUES[ j ] ){
								os = curToken;
								targetOS = curToken;
								tokenDone = true;
								break;
							}
						}
						
						if( !tokenDone ){
							// Look for os version.
							for( j = 0; j < DeviceNames.OS_VERSION_VALUES.length; ++j ){
								if( curToken == DeviceNames.OS_VERSION_VALUES[ j ] ){
									osVersion = curToken;
									tokenDone = true;
									break;
								}
							}
						}

						if( !tokenDone ){
							// Look for screenDPI
							if( curToken.indexOf( SCREENDPI_SUFFIX ) > -1 ){
								curToken = curToken.substring( 0, curToken.indexOf( SCREENDPI_SUFFIX ) );
								if( (curToken != null) && (StringUtil.trim( curToken ) != "") ){
									screenDPI = new Number( curToken );
									tokenDone = true;
								}
							}
						}

						if( !tokenDone ){
							// Look for density.
							if( curToken.indexOf( DENSITY_SUFFIX ) > -1 ){
								curToken = curToken.substring( 0, curToken.indexOf( DENSITY_SUFFIX ) );
								if( (curToken != null) && (StringUtil.trim( curToken ) != "") ){
									deviceDensity = new Number( curToken );
									tokenDone = true;
								}
							}
						}

						if( !tokenDone ){
							// Look for width.
							if( curToken.indexOf( WIDTH_SUFFIX ) > -1 ){
								curToken = curToken.substring( 0, curToken.indexOf( WIDTH_SUFFIX ) );
								if( (curToken != null) && (StringUtil.trim( curToken ) != "") ){
									deviceWidth = new Number( curToken );
									tokenDone = true;
								}
							}
						}

						if( !tokenDone ){
							// Look for height.
							if( curToken.indexOf( HEIGHT_SUFFIX ) > -1 ){
								curToken = curToken.substring( 0, curToken.indexOf( HEIGHT_SUFFIX ) );
								if( (curToken != null) && (StringUtil.trim( curToken ) != "") ){
									deviceHeight = new Number( curToken );
									tokenDone = true;
								}
							}
						}

						if( !tokenDone ){
							// Look for color.
							if( curToken.indexOf( COLOR_SUFFIX ) > -1 ){
								curToken = curToken.substring( 0, curToken.indexOf( COLOR_SUFFIX ) );
								if( (curToken != null) && (StringUtil.trim( curToken ) != "") ){
									color = new Number( curToken );
									tokenDone = true;
								}
							}
						}

						if( !tokenDone ){
							// Look for device.
							for( j = 0; j < DeviceNames.DEVICE_VALUES.length; ++j ){
								if( curToken == DeviceNames.DEVICE_VALUES[ j ] ){
									device = curToken;
									tokenDone = true;
									break;
								}
							}
						}
						
						if( !tokenDone ){
							trace("trouble with token: " + curToken);
						}
					}
				}
			}
			
			// If anything went wrong, tokenDone will be false.
			return tokenDone;
            }
            COMPILE::JS
            {
            */
                return false;
		}

		/**
		* Return a list of the properties.
		**/
        COMPILE::SWF
		override public function toString():String{
			var ret:String;
			
			ret = "\tvalue=" + String(value);
			ret += "\n\turl=" + url;
			ret += "\n\tos=" + os;
			ret += "\n\ttargetOS=" + targetOS;
			ret += "\n\tosVersion=" + osVersion;
			ret += "\n\tscreenDPI=" + screenDPI;
			ret += "\n\tdeviceDensity=" + deviceDensity;
			ret += "\n\tdeviceWidth=" + deviceWidth;
			ret += "\n\tdeviceHeight=" + deviceHeight;
			ret += "\n\tcolor=" + color;
			ret += "\n\tdevice=" + device;
			
			return ret;
		}
	
	}
}
