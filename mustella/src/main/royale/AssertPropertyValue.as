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
import flash.events.EventDispatcher;
}

/**
*  Vector of conditionalValue objects.
**/
[DefaultProperty("conditionalValues")]

/**
 *  Instead of a property, we use an event so the MXML
 *  compiler will wrap the code in a function for us
 */
[Event(name="valueExpression", type="flash.events.Event")]

/**
 *  Tests that the value of a property is as expected
 *  MXML attributes:
 *  target
 *  propertyName
 *  value
 *  waitTarget (optional)
 *  waitEvent (optional)
 *  timeout (optional)
 */
public class AssertPropertyValue extends Assert
{
    //TODO (aharui) later
	//public var conditionalValues:Vector.<ConditionalValue> = null;

	/**
	 *  See if the property has the correct value
	 */
    COMPILE::SWF
	override protected function doStep():void
	{
		var actualTarget:Object = context.stringToObject(target);
		var multiResultResult:String = "";
		var cv:ConditionalValue = null;
		var dispatcher:EventDispatcher = this;

		if (!actualTarget)
		{
			testResult.doFail("Target " + target + " not found");
			return;
		}

		if (!(propertyName in actualTarget))
		{
			testResult.doFail ( target + "." + propertyName + " does not exist");
			return;
		}

		// Use MultiResult to determine the proper value (or valueExpression, below).
        /* TODO (aharui) later
		if(conditionalValues){
			cv = new MultiResult().chooseCV(conditionalValues);
			if(cv){
				value = cv.value;
				dispatcher = cv;
			}
		}
        */
        
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
            if (!contains(actualTarget[propertyName], errors))
                testResult.doFail(target + "." + propertyName + " " + valueToString(actualTarget[propertyName]) + " should contain " + valueToString(errors));
        } else if (valueToString(actualTarget[propertyName]) != valueToString(value))
            testResult.doFail(target + "." + propertyName + " " + valueToString(actualTarget[propertyName]) + " != " + valueToString(value));
	}

	/**
	 *  The name of the property to test
	 */
	public var propertyName:String;

	/**
	 *  The value the property should have
	 */
	public var value:*;

    public var errorArray:Array;

	/**
	 *  customize string representation
	 */
	override public function toString():String
	{
		var s:String = "AssertPropertyValue";
		if (target)
			s += ": target = " + target;
		if (propertyName)
			s += ", propertyName = " + propertyName;
		return s;
	}
}

}
