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
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;
import flash.utils.getTimer;

/**
 *  The abstract base class for all steps in a test case.  TestStep
 *  cannot be used directly, instead its subclasses must be used
 *  such as SetProperty, RunCode, Assert, etc.
 */
public class TestStep extends EventDispatcher
{
	/**
	 *  Called by the TestCase when it is time to start this step
	 *  The default implementation checks for a wait event and
	 *  returns true if there isn't one and false if there is.
	 */
	public function execute(root:DisplayObject, context:UnitTester, testCase:TestCase, testResult:TestResult):Boolean
	{
		var tryLater:Boolean = false;

		this.root = root;
		this.context = context;
		this.testCase = testCase;
		this.testResult = testResult;

		if (waitEvent)
		{
			var actualTarget:IEventDispatcher = context.stringToObject(waitTarget) as IEventDispatcher;
			if (!(actualTarget is DisplayObject))
				if ("element" in actualTarget)
					actualTarget = actualTarget["element"];
			if (!actualTarget)
			{
				// its ok if the target isn't here yet, it may be created during this step
				tryLater = true;
			}
			else
			{
                UnitTester.waitEvent = waitEvent;
				actualTarget.addEventListener(waitEvent, waitEventHandler);
				testCase.setExpirationTime(getTimer() + timeout);
			}
		}

		if (!UnitTester.hasRTE)
			doStep();

		// if test failed, don't bother waiting, just bail
		if (testResult.hasStatus() || UnitTester.hasRTE)
		{
			if (UnitTester.hasRTE)
			{ 
				testResult.result = 1;
				testResult.message = UnitTester.RTEMsg;
				dispatchEvent(new Event("runComplete"));
				return true;	
			}

			if (waitEvent)
			{
                UnitTester.waitEvent = null;
				actualTarget = context.stringToObject(waitTarget) as IEventDispatcher;
				if (!(actualTarget is DisplayObject))
					if ("element" in actualTarget)
						actualTarget = actualTarget["element"];
				actualTarget.removeEventListener(waitEvent, waitEventHandler);
				testCase.setExpirationTime(0);
			}
			return true;
		}

		if (tryLater && waitEvent)
		{
			actualTarget = context.stringToObject(waitTarget) as IEventDispatcher;
			if (!(actualTarget is DisplayObject))
			    if ("element" in actualTarget)
				    actualTarget = actualTarget["element"];
			if (!actualTarget)
			{
				testResult.doFail("Target " + waitTarget + " not found");
				return true;
			}
            UnitTester.waitEvent = waitEvent;
			actualTarget.addEventListener(waitEvent, waitEventHandler);
			testCase.setExpirationTime(getTimer() + timeout);
		}

		return (waitEvent == null);
	}

	/**
	 *  The name of the object to listen for an event we're waiting on
	 */
	public var waitTarget:String;

	/**
	 *  The name of the event to listen for on the waitTarget
	 */
	public var waitEvent:String;

	/**
	 *  The number of milliseconds to wait before giving up
	 */
	public var timeout:int = 3000;

	/**
	 *  The TestResult for this TestCase
	 */
	protected var testResult:TestResult;

	/**
	 *  The TestCase that this step belongs to
	 */
	protected var testCase:TestCase;

	/**
	 *  The UnitTester that this step belongs to
	 */
	protected var context:UnitTester;

	/**
	 *  The root for the SWF
	 */
	protected var root:DisplayObject;

	/**
	 *  The method that gets called when it is time to perform the work in the step.
	 */
	protected function doStep():void
	{
	}

	/**
	 *  The method that gets called back when the event we're waiting on fires
	 */
	protected function waitEventHandler(event:Event):void
	{
		stepComplete();
	}

	/**
	 *  The method that gets called when it is time to clean up the step.
	 */
	protected function stepComplete():void
	{
		if (waitEvent)
		{
            UnitTester.waitEvent = null;
			var actualTarget:IEventDispatcher = context.stringToObject(waitTarget) as IEventDispatcher;
			if (!(actualTarget is DisplayObject))
			    if ("element" in actualTarget)
				    actualTarget = actualTarget["element"];
			if (actualTarget)	// can be null if object killed during step
				actualTarget.removeEventListener(waitEvent, waitEventHandler);
			testCase.setExpirationTime(0);
		}
		dispatchEvent(new Event("stepComplete"));
	}

	/**
	 *  Called by the test case if you time out
	 */
	public function timeoutCallback():void
	{
		testResult.doFail("Timeout waiting for " + waitEvent + " from " + waitTarget);
		stepComplete();
	}

}

}
