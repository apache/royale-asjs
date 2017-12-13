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

import mx.core.mx_internal;
use namespace mx_internal;

/**
 *  Instead of a property, we use an event so the MXML
 *  compiler will wrap the code in a function for us
 */
[Event(name="valueExpression", type="flash.events.Event")]

/**
 *  Tests that the value of a property is as expected
 *  MXML attributes:
 *  value
 *  waitTarget (optional)
 *  waitEvent (optional)
 *  timeout (optional)
 */
public class AssertError extends Assert
{
	/**
	 *  See if the property has the correct value
	 */
	override protected function doStep():void
	{
		if (hasEventListener("valueExpression"))
		{
			context.resetValue();
			try
			{
				dispatchEvent(new RunCodeEvent("valueExpression", root["document"], context, testCase, testResult));
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
			if (!contains(testCase.lastError, errors))
				testResult.doFail("Expected Error contains " + valueToString(errors) + ", got " + valueToString(testCase.lastError));
        } else if (valueToString(testCase.lastError) != valueToString(value))
            testResult.doFail("Expected Error " + valueToString(value) + ", got " + valueToString(testCase.lastError));
	}

	/**
	 *  The value the property should have.
	 */
	public var value:*;

    public var errorArray:Array;

	/**
	 *  customize string representation
	 */
	override public function toString():String
	{
		var s:String = "AssertError";
		return s;
	}
}

}
