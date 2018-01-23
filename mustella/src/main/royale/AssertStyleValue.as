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
import flash.events.EventDispatcher;

import mx.core.mx_internal;
use namespace mx_internal;

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
 *  target
 *  styleName
 *  value
 *  waitTarget (optional)
 *  waitEvent (optional)
 *  timeout (optional)
 */
public class AssertStyleValue extends Assert
{
	public var conditionalValues:Vector.<ConditionalValue> = null;

	/**
	 *  Test the value of a property, log result if failure.
	 */
	override protected function doStep():void
	{
		var cv:ConditionalValue = null;
		var dispatcher:EventDispatcher = this;
		var actualTarget:Object = context.stringToObject(target);
		
		if (!actualTarget)
		{
			testResult.doFail("Target " + target + " not found");
			return;
		}

		// Use MultiResult to determine the proper value (or valueExpression, below).
		if(conditionalValues){
			cv = new MultiResult().chooseCV(conditionalValues);
			if(cv){
				value = cv.value;
				dispatcher = cv;
			}
		}

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

		if (valueToString(actualTarget.getStyle(styleName)) != valueToString(value))
		{
			testResult.doFail( target + "." + styleName + " " + valueToString(actualTarget.getStyle(styleName)) + " != " + valueToString(value));
		} 
	}

	/**
	 *  The name of the property to test
	 */
	public var styleName:String;

	/**
	 *  The value the property should have
	 */
	public var value:Object;

	/**
	 *  customize string representation
	 */
	override public function toString():String
	{
		var s:String = "AssertStyleValue";
		if (target)
			s += ": target = " + target;
		if (styleName)
			s += ", styleName = " + styleName;
		return s;
	}
}

}
