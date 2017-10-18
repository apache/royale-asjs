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
import flash.utils.getTimer;

import mx.core.mx_internal;
use namespace mx_internal;

/**
 *  Instead of a property, we use an event so the MXML
 *  compiler will wrap the code in a function for us
 */
[Event(name="condition", type="flash.events.Event")]

/**
 *  Vector of conditionalValue objects.
 */
[DefaultProperty("conditionalValues")]

/**
 *  WaitForCondition - waits for a condition to become true before continuing.
 * 
 *  MXML attributes:
 *  target (not used)
 *  condition
 *  timeout (optional)
 */
public class WaitForCondition extends TestStep
{
    public var conditionalValues:Vector.<ConditionalValue> = null;

    /**
     *  The value the method should return
     */
    public var value:Boolean;
    
    private var dispatcher:EventDispatcher;
    
	/**
	 *  Test the value of a property, log result if failure.
	 */
	override public function execute(root:DisplayObject, context:UnitTester, testCase:TestCase, testResult:TestResult):Boolean
	{
        super.execute(root, context, testCase, testResult);

        var cv:ConditionalValue = null;
        
        context.resetValue();
        dispatcher = this;
        
        // Use MultiResult to determine the proper value (or valueExpression, below).
        if(conditionalValues){
            cv = new MultiResult().chooseCV(conditionalValues);
            if(cv){
                value = cv.value;
                dispatcher = cv;
            }
        }

        if (checkCondition())
		{
			testCase.setExpirationTime(getTimer() + timeout);
			return false;
		} 
		else 
		{
			testCase.setExpirationTime(0);
			stepComplete();
			return true;
		}

	}

	/**
	 *  customize string representation
	 */
	override public function toString():String
	{
		var s:String = "WaitForCondition (condition cannot be shown) ";
		return s;
	}

    /**
     *  Called by the test case if you time out
     */
    override public function timeoutCallback():void
    {
        testResult.doFail("Timeout waiting for condition: (condition cannot be shown) " );
        stepComplete();
    }

    /**
     *  Evaluate the condition.
     *  
     *  @return The value of the condition, true or false.
     */
    private function checkCondition():Boolean
    {
        // Execute the method.
        try
        {
            dispatchEvent(new RunCodeEvent("condition", root["document"], context, testCase, testResult));
        }
        catch (e:Error)
        {
            TestOutput.logResult("Exception thrown executing method.");
            testResult.doFail (e.getStackTrace());
            return false;
        }

        if (!context.valueChanged)
            TestOutput.logResult("WARNING: value was not set by method.  'value=' missing from expression?");

        var methodValue:Object = context.value;
        
        if (!methodValue)
        {
            UnitTester.callback = checkCondition;
            return true;
        }
        else
        {
            testCase.setExpirationTime(0);
            stepComplete();                
            return false;
        }

    }
    
}
}
