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
import flash.utils.*;

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
 *  target (ignored)
 *  propertyName
 *  value
 *  waitTarget (optional)
 *  waitEvent (optional)
 *  timeout (optional)
 */
public class AssertEventPropertyValue extends Assert
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

		var val:Object;
		if (!context.lastEvent)
		{
			testResult.doFail ("No event fired prior to this step");
			return;
		}
		if (!(propertyName in context.lastEvent))
		{
			testResult.doFail ("Event does not have property " + propertyName);
			return;
		}
		val = context.lastEvent[propertyName];

		if (valueToString(val) != valueToString(value))
		{
			testResult.doFail ( getQualifiedClassName(context.lastEvent) + "." + propertyName + " " + valueToString(val)  + " != " + valueToString(value));
		} 
	}

	/**
	 *  The name of the property to test
	 */
	public var propertyName:String;

	/**
	 *  The value the property should have
	 */
	public var value:Object;

	/**
	 *  customize string representation
	 */
	override public function toString():String
	{
		var s:String = "AssertEventPropertyValue";
		if (target)
			s += ": target = " + target;
		if (propertyName)
			s += ", propertyName = " + propertyName;
		return s;
	}
}

}
