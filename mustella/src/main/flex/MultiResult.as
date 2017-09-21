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

	import flash.display.*;
	import mx.core.FlexGlobals;
	import mx.core.mx_internal;
	
	use namespace mx_internal;
	
	[DefaultProperty("conditionalValues")]	
	public class MultiResult
	{
		private var conditionalValues:Vector.<ConditionalValue>;

		public function MultiResult(){
		}

		/**
		 *  Loop through the conditional values and process the ones which apply to our configuration.
		 *  Functionally, it should work like this:
		 *	1) Any number of mismatches will case a CV to be ignored.
		 *	2) Empty CVs will be ignored.
		 *  3) Among device matches, pick the best.
		 *  4) If no match yet, among the remaining, pick the one with the most matches.
		 *  5) If no match yet, the TestStep's is used.
		 *
		 * Called by determineResult() and CompareBitmap's execute().
  		 **/
		public function chooseCV(conditionalValues:Vector.<ConditionalValue>):ConditionalValue{
			var i:int;
			var cv:ConditionalValue;
			//var cvToUse:ConditionalValue = null;
			var cvUT:ConditionalValue = UnitTester.cv;
			
			var bestDeviceMatch:ConditionalValue = null;
			var bestNonDeviceMatch:ConditionalValue = null;
			
			var bestDeviceMatchCount:int = 0;		// # matches for the best match, among device matches
			var bestNonDeviceMatchCount:int = 0;	// # matches for the best match
			var numMatches:int = 0;
			
			// When running mobile on desktop, set some items in UnitTester's CV later
			if( cvUT.deviceWidth == -1 ){
				cvUT.deviceWidth = FlexGlobals.topLevelApplication.width;
			}

			if( cvUT.deviceHeight == -1 ){
				cvUT.deviceHeight = FlexGlobals.topLevelApplication.height;
			}

			//trace("MultiResult.chooseCV(): Actual test environment is: \n" + cvUT.toString());
			
			for(i = 0; i < conditionalValues.length; ++i){
				cv = conditionalValues[ i ];
				
				// This is an empty one; ignore it.
				if( cv.isDefault() ){
					continue;
				}
				
				numMatches = countMatches( cv, cvUT );
				//trace("numMatches="+numMatches+" with "+cv);
				
				if( numMatches <= 0 ) // -1 is a mismatch, and 0 is no matches.
					continue;	
				
				if( cv.device && cvUT.device && (cv.device == cvUT.device) ){
					
					if( numMatches > bestDeviceMatchCount ){
						bestDeviceMatchCount = numMatches;
						bestDeviceMatch = cv;
					}
				}else{
					
					if( numMatches > bestNonDeviceMatchCount ){
						bestNonDeviceMatchCount = numMatches;
						bestNonDeviceMatch = cv;
					}
				}
			}

			/**
				if( bestDeviceMatch != null )
					trace("MultiResult.chooseCV(): bestDeviceMatch:\n" + bestDeviceMatch.toString());
				else
					trace("MultiResult.chooseCV(): bestDeviceMatch: null");

				if( bestNonDeviceMatch != null )				
					trace("MultiResult.chooseCV(): bestNonDeviceMatch:\n" + bestNonDeviceMatch.toString());
				else
					trace("MultiResult.chooseCV(): bestNonDeviceMatch: null");
			**/	
				
			if( bestDeviceMatch != null )
				return bestDeviceMatch;
			else if( bestNonDeviceMatch != null )
				return bestNonDeviceMatch;
			else
				return null;
		}
		
		
		/**
		* Count the matches between two CVs.
		* If a value is unset in either, it's not a match or a mismatch.
		* Returns 0 if no matches.
		* Returns -1 immediately if a mismatch occurs.
		**/
		private function countMatches( cv1:ConditionalValue, cv2:ConditionalValue ):int{
			var ret:int = 0;
			
			// if .targetOS has been set in cv2 (which is the baseline as specified by options)
			// use that for comparison otherwise use the normal .os
			var os:String = cv2.targetOS != null ? cv2.targetOS : cv2.os;
			
			if( (cv1.os != null) && (os != null) ){
				if( cv1.os != os )
					return -1;
				else
					++ret;
			}

			if( (cv1.osVersion != null) && (cv2.osVersion != null) ){
				if( cv1.osVersion != cv2.osVersion )
					return -1;
				else
					++ret;
			}

			if( (cv1.screenDPI > -1) && (cv2.screenDPI > -1) ){
				if( cv1.screenDPI != cv2.screenDPI )
					return -1;
				else
					++ret;
			}

			if( (cv1.deviceDensity > -1) && (cv2.deviceDensity > -1) ){
				if( cv1.deviceDensity != cv2.deviceDensity )
					return -1;
				else
					++ret;
			}

			if( (cv1.deviceWidth > -1) && (cv2.deviceWidth > -1) ){
				if( cv1.deviceWidth != cv2.deviceWidth )
					return -1;
				else
					++ret;
			}

			if( (cv1.deviceHeight > -1) && (cv2.deviceHeight > -1) ){
				if( cv1.deviceHeight != cv2.deviceHeight )
					return -1;
				else
					++ret;
			}

			if( (cv1.color > -1) && (cv2.color > -1) ){
				if( cv1.color != cv2.color )
					return -1;
				else
					++ret;
			}

			if( (cv1.device != null) && (cv2.device != null) ){
				if( cv1.device != cv2.device )
					return -1;
				else
					++ret;
			}

			return ret;
		}
	}
}