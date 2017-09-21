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
import flash.display.IBitmapDrawable;
import flash.utils.*;
import flash.net.*;
import flash.events.*;
import flash.display.*;
import flash.geom.Matrix;

/**
 *  Tests that the value of a property is as expected
 *  MXML attributes:
 *  target
 *  eventName
 *  eventType
 *  waitTarget (optional)
 *  waitEvent (optional)
 *  timeout (optional)
 */
public class AssertNoEvent extends AssertEvent
{
	/**
	 *  Test the value of a property, log result if failure.
	 */
	override public function execute(root:DisplayObject, context:UnitTester, testCase:TestCase, testResult:TestResult):Boolean
	{
		return true;
	}

	/**
	 *	The event listener
	 */
	override protected function eventListener(event:Event):void
	{
		testCase.setExpirationTime(0);

		numEvents++;

		if (numEvents)
		{
			testResult.doFail ("Event " + eventName + " unexpectedly received " + numEvents + " times");	
			return;
		}
	}

	/**
	 *  customize string representation
	 */
	override public function toString():String
	{
		var s:String = "AssertNoEvent";
		if (target)
			s += ": target = " + target;
		if (eventName)
			s += ", eventName = " + eventName;
		return s;
	}

}

}
