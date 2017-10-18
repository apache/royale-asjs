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
 *  The test step that sets a property to some value
 *  MXML attributes:
 *  target
 *  styleName
 *  value
 *  waitTarget (optional)
 *  waitEvent (optional)
 *  timeout (optional);
 */
public class SetStyle extends TestStep
{

	/**
	 *  @private
	 */
	override public function execute(root:DisplayObject, context:UnitTester, testCase:TestCase, testResult:TestResult):Boolean
	{
		if (waitEvent && waitTarget == null)
			waitTarget = target;
		return super.execute(root, context, testCase, testResult);
	}

	/**
	 *  Set the target's property to the specified value
	 */
	override protected function doStep():void
	{
		var actualTarget:Object = context.stringToObject(target);
		if (!actualTarget)
		{
			testResult.doFail("Target " + target + " not found");
			return;
		}

		try
		{
			if (hasEventListener("valueExpression"))
			{
				context.resetValue();
				dispatchEvent(new RunCodeEvent("valueExpression", root["document"], context, testCase, testResult));
				value = context.value;
				if (!context.valueChanged)
					TestOutput.logResult("WARNING: value was not set by valueExpression.  'value=' missing from expression?");
			}

		}
		catch (e:Error)
		{
			TestOutput.logResult("Exception thrown evaluating value expression.");
			testResult.doFail (e.getStackTrace());	
			return;
		}

		actualTarget.setStyle (styleName, value);
	}

	/**
	 *  The object to set a property on
	 */
	public var target:String;

	/**
	 *  The name of the property to set
	 */
	public var styleName:String;

	/**
	 *  The value to set
	 */
	public var value:Object;

	/**
	 *  customize string representation
	 */
	override public function toString():String
	{
		var s:String = "SetStyle";
		if (target)
			s += ": target = " + target;
		if (styleName)
			s += ", styleName = " + styleName;
		return s;
	}
}

}
