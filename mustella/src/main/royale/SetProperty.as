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

COMPILE::SWF
{
import flash.display.DisplayObject;
}

/**
 *  Instead of a property, we use an event so the MXML
 *  compiler will wrap the code in a function for us
 */
[Event(name="valueExpression", type="flash.events.Event")]

/**
 *  The test step that sets a property to some value
 *  MXML attributes:
 *  target
 *  propertyName
 *  value
 *  waitTarget (optional)
 *  waitEvent (optional)
 *  timeout (optional);
 */
public class SetProperty extends TestStep
{
	/**
	 *  @private
	 */
    COMPILE::SWF
	override public function execute(root:Object, context:UnitTester, testCase:TestCase, testResult:TestResult):Boolean
	{
		if (waitEvent && waitTarget == null)
			waitTarget = target;
		return super.execute(root, context, testCase, testResult);
	}

	/**
	 *  Set the target's property to the specified value
	 */
    COMPILE::SWF
	override protected function doStep():void
	{
		if (expectError)
			testCase.lastError = null;

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

		try
		{
			actualTarget[propertyName] = value;
		}
		catch (e1:Error)
		{
			if (expectError)
				testCase.lastError = e1;
			else
			{
				if (!(propertyName in actualTarget))
				{
					testResult.doFail ("target does not have property " + propertyName);
					return;
				}
		
				TestOutput.logResult("Exception thrown setting property.");
				testResult.doFail (e1.getStackTrace());	
			}
		}
	}

	/**
	 *  The object to set a property on
	 */
	public var target:String;

	/**
	 *  The name of the property to set
	 */
	public var propertyName:String;

	/**
	 *  The value to set
	 */
	public var value:Object;

	/**
	 *  If we should expect an error
	 */
	public var expectError:Boolean;

	/**
	 *  customize string representation
	 */
	override public function toString():String
	{
		var s:String = "SetProperty";
		if (target)
			s += ": target = " + target;
		if (propertyName)
			s += ", propertyName = " + propertyName;
		return s;
	}
}

}
