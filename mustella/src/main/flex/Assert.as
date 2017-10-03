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
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;
import flash.utils.getTimer;
}

import org.apache.flex.utils.ObjectUtil;

/**
 *  The base class for all Asserts that the test
 *  has succeeded or not.
 *  All asserts should be derived from this class because
 *  the timing of the wait events is different than that for
 *  other TestSteps.  See AssertPropertyValue for an example.
 *
 *  Asserts don't execute their steps until after the
 *  waitEvent has been received (if there is one) whereas
 *  non-Asserts execute their steps and then wait for the
 *  waitEvent.
 */
public class Assert extends TestStep
{
	// list of properties we don't examine in determining equivalence
	private static var excludeList:Array = [
						"stage",
						"systemManager",
						"parent",
						"owner",
						"target",
						"currentTarget"
			];

	/**
	 *  Called by the test case in case you need to set up before execute()
	 */
	public function preview(root:Object, context:UnitTester, testCase:TestCase, testResult:TestResult):void
	{
		this.root = root;
		this.context = context;
		this.testCase = testCase;
		this.testResult = testResult;

		if (waitEvent)
		{
			if (waitTarget == null)
				waitTarget = target;
			var actualTarget:Object = context.stringToObject(waitTarget);
			// it is ok for us to not have an actualTarget during preview
			// someone may be waiting for the object to be created.
			if (actualTarget)
				actualTarget.addEventListener(waitEvent, eventListener);
		}
	}

	/**
	 *  All subclasses should override this method
	 */
    COMPILE::SWF
	override public function execute(root:Object, context:UnitTester, testCase:TestCase, testResult:TestResult):Boolean
	{
		this.root = root;
		this.context = context;
		this.testCase = testCase;
		this.testResult = testResult;

		if (waitEvent)
		{
			if (waitTarget == null)
				waitTarget = target;

			var actualTarget:IEventDispatcher = context.stringToObject(waitTarget) as IEventDispatcher;
			if (!actualTarget)
			{
				testResult.doFail("waitTarget " + waitTarget + " not found");
				return true;
			}
			actualTarget.removeEventListener(waitEvent, eventListener);
			if (numEvents == 0)
			{
				actualTarget.addEventListener(waitEvent, waitEventHandler);
				testCase.setExpirationTime(getTimer() + timeout);
				return false;
			}
		}

		doStep();
		return true;
	}

	/**
	 *  Storage for numEvents
	 */
	private var numEvents:int = 0;

	/**
	 *  The name of the object to test.
	 */
	public var target:String;

	/**
	 *  The method that gets called back when the event we're waiting on fires
	 */
    COMPILE::SWF
	override protected function waitEventHandler(event:Event):void
	{
		doStep();
		super.waitEventHandler(event);
	}

	/**
	 *	The event listener
	 */
	private function eventListener(event:Event):void
	{
		testCase.setExpirationTime(0);

		numEvents++;
	}

	/**
	 *  Called by the test case in case you need to clean up after execute()
	 */
	public function cleanup():void
	{
	}

	/**
	 *  convert everything to strings (like null)
	 */
	protected function valueToString(value:*):String
	{
		if (value == null)
			return "null";
		var s:String;

		if (value is Number)
		{
			if ((value is int) || (value is uint))
				s = value.toString();
			else
				s = value.toFixed(6);
		}
		else
			s = value.toString();

		if (s == "[object Object]")
			s = ObjectUtil._toString(value);
		return s;
	}

    protected function contains(value:*, expectedError:ErrorArray):Boolean {
        if (expectedError && expectedError.parts && expectedError.parts.length)
            for (var i:uint = 0; i < expectedError.parts.length; i++) {
                if (valueToString(value).indexOf(valueToString(expectedError.parts[i])) == -1)
                    return false;
            }

        return true;
    }
}

}
