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
import flash.events.EventDispatcher;
import flash.utils.*;
import flash.net.*;
import flash.events.*;
import flash.display.*;
import flash.geom.Matrix;

import mx.core.mx_internal;
use namespace mx_internal;

/**
 *  Instead of a property, we use an event so the MXML
 *  compiler will wrap the code in a function for us
 */
[Event(name="method", type="flash.events.Event")]

/**
 *  Instead of a property, we use an event so the MXML
 *  compiler will wrap the code in a function for us
 */
[Event(name="valueExpression", type="flash.events.Event")]

/**
*  Vector of conditionalValue objects.
**/
[DefaultProperty("conditionalValues")]

/**
 *  Tests that the value of a property is as expected
 *  MXML attributes:
 *  target (not used)
 *  method
 *  value
 *  waitTarget (optional)
 *  waitEvent (optional)
 *  timeout (optional)
 */
public class AssertMethodValue extends Assert
{
	public var conditionalValues:Vector.<ConditionalValue> = null;

	/**
	 *  Test the value of a property, log result if failure.
	 */
	override protected function doStep():void
	{
		var cv:ConditionalValue = null;
		var dispatcher:EventDispatcher = this;

		context.resetValue();

		// Use MultiResult to determine the proper value (or valueExpression, below).
		if(conditionalValues){
			cv = new MultiResult().chooseCV(conditionalValues);
			if(cv){
				value = cv.value;
				dispatcher = cv;
			}
		}

		// Execute the method.
		try
		{
			dispatchEvent(new RunCodeEvent("method", root["document"], context, testCase, testResult));
		}
		catch (e:Error)
		{
			TestOutput.logResult("Exception thrown executing method.");
			testResult.doFail (e.getStackTrace());
			return;
		}
		if (!context.valueChanged)
			TestOutput.logResult("WARNING: value was not set by method.  'value=' missing from expression?");
		var methodValue:Object = context.value;

		// Execute the valueExpression.
		if (dispatcher.hasEventListener("valueExpression"))
		{
			context.resetValue();
			try
			{
				dispatcher.dispatchEvent(new RunCodeEvent("valueExpression", root["document"], context, testCase, testResult));
			}
			catch (e1:Error)
			{
				TestOutput.logResult("Exception thrown evaluating value expression.");
				testResult.doFail (e1.getStackTrace());
				return;
			}
			value = context.value;
			if (!context.valueChanged)
				TestOutput.logResult("WARNING: value was not set by valueExpression.  'value=' missing from expression?");
		}

        if (errorArray) {
            var errors:ErrorArray = new ErrorArray(errorArray);
            if (!contains(methodValue, errors))
                testResult.doFail("method returned " + valueToString(methodValue) + ", expected it contains " + valueToString(errors));
        } else if (valueToString(methodValue) != valueToString(value))
            testResult.doFail("method returned " + valueToString(methodValue) + ", expected " + valueToString(value));
	}

	/**
	 *  The value the method should return
	 */
	public var value:*;

    public var errorArray:Array;

	/**
	 *  customize string representation
	 */
	override public function toString():String
	{
		var s:String = "AssertMethodValue (method cannot be shown) ";
		return s;
	}

}

}
