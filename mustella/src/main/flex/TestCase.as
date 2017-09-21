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
import flash.utils.getQualifiedClassName;
import flash.utils.getTimer;
import flash.utils.Timer;
}
COMPILE::JS
{
    import org.apache.flex.events.EventDispatcher;
    import org.apache.flex.utils.Timer;
}
/**
 *  A Test.  A Test script comprises several of these
 *  TestCases.  Each TestCase consists of a
 *  setup, body and cleanup section which are sets
 *  of TestStep-derived classes like SetProperty,
 *  RunCode, AssertPropertyValue, etc.
 *
 *  MXML Properties (not attributes)
 *  setup
 *  body
 *  cleanup
 */
public class TestCase extends EventDispatcher
{
	/**
	 *  The history of bugs that this test case has encountered
	 */
	public var bugs:Array;

	/**
	 *  The sequence of TestSteps that comprise the test setup
	 */
	public var setup:Array;

	/**
	 *  The sequence of TestSteps that comprise the test
	 */
	public var body:Array;

	/**
	 *  The sequence of TestSteps that restore the test environment
	 */
	public var cleanup:Array;

	/**
	 *  An identifier for the test
	 */
	public var testID:String;

	/**
	 *  A description of the test 
	 */
	public var description:String;

	/**
	 *  keywords, summarizing the tests
	 */
	public var keywords:String;

	/**
	 *  frequency, an estimate of the tests's intersection with real-world
	 *  usage. 1 = most frequent usage; 2 somewhat common; 3 = unusual
	 */
	public var frequency:String;

	/**
	 *  The current set of steps (setup, body, cleanup) we are executing
	 */
	private var currentSteps:Array;

	/**
	 *  Which step we're currently executing (or waiting on an event for)
	 */
	private var currentIndex:int = 0;

	/**
	 *  Number of steps in currentSteps
	 */
	private var numSteps:int = 0;

	/**
	 *  The root of the SWF (SystemManager)
	 */
    COMPILE::SWF
	private var root:DisplayObject;

	/**
	 *  The shared timer we listen to
	 */
	private var timer:Timer;

	/**
	 *  The unit tester
	 */
	private var context:UnitTester;

	/**
	 *  Whether we need to emit a runComplete event or not
	 */
	private var needCompleteEvent:Boolean = false;

	/**
	 *  If non-zero, the time when we'll give up on waiting
	 */
	public var expirationTime:int;

	/**
	 *  the last expected Error thrown by SetProperty
	 */
	public var lastError:Error;

	/**
	 *	Called by test steps looking for a timeout indicator
	 */
	public function setExpirationTime(time:int):void
	{
		expirationTime = (time > 0) ? time + UnitTester.timeout_plus : 0;
	}

	/**
	 *  Storage for the cleanupAsserts
	 */
	private var _cleanupAsserts:Array;

	/**
	 *  Steps we have to review at the end of the body to see if
	 *  they failed or not.  These steps monitor activity like
	 *  checking for duplicate events or making sure unwanted events
	 *  don't fire.
	 */
	public function get cleanupAsserts():Array
	{
		return _cleanupAsserts;
	}

	/**
	 *  Storage for this tests's result
	 */
	private var _testResult:TestResult;

	/**
	 *  This tests's result
	 */
	public function get testResult():TestResult 
	{ 
		_testResult.testID = testID;
		return _testResult;
	}

	/**
	 * Constructor. Create the TestResult associated with this TestCase
	 */
	public function TestCase() {

		_testResult = new TestResult();
		_testResult.testID = testID;

		_cleanupAsserts = [];
	}

	/**
	 *  Called by the UnitTester when it is time to execute
	 *  this test case.
	 *
	 *  @param root The SystemManager
	 *  @param timer The shared Timer;
	 *  @param context the UnitTester that contains these tests
	 */
	public function runTest(root:Object, timer:Timer, context:UnitTester):Boolean
	{
		COMPILE::SWF
        {
		_testResult.beginTime = new Date().time;
		_testResult.context = context;
		this.timer = timer;
		this.timer.addEventListener("timer", timerHandler);
		this.root = root;
		this.context = context;

		if (UnitTester.hasRTE) 
		{ 
			return true;

		}

		// do a sanity test here
		if (UnitTester.verboseMode)
		{
			var needWaitEvent:Boolean = false;
			var i:int;
			if (setup)
			{
				for (i = 0; i < setup.length; i++)
				{
					if (setup[i] is ResetComponent)
						needWaitEvent = true;
					if (needWaitEvent)
					{
						if (setup[i].waitEvent)
						{
							needWaitEvent = false;
							break;
						}
					}
				}
				if (needWaitEvent)
					TestOutput.logResult("WARNING: Test " + getQualifiedClassName(context) + "." + testID + " ResetComponent used without any setup steps using a waitEvent\n");
			}
			var allAsserts:Boolean = true;
			needWaitEvent = false;
			for (i = 0; i < body.length; i++)
			{
				if (body[i] is SetProperty || body[i] is SetStyle)
					needWaitEvent = true;
				if (!(body[i] is Assert))
					allAsserts = false;
				if (allAsserts && body[i] is AssertEvent)
				{
					TestOutput.logResult("WARNING: Test " + getQualifiedClassName(context) + "." + testID + " no non-Assert steps in body before AssertEvent\n");
				}
				if (needWaitEvent)
				{
					if (body[i].waitEvent)
					{
						needWaitEvent = false;
						break;
					}
				}
			}
			if (needWaitEvent)
				TestOutput.logResult("WARNING: Test " + getQualifiedClassName(context) + "." + testID + " tests setting values without a waitEvent\n");
			
		}

		return runSetup();
        }
        COMPILE::JS
        {
            return true;
        }
	}

	/**
	 *  Execute the setup portion of the test
	 *
	 *  @param continuing If true, don't reset the counter to zero
	 *  and just continue on with the test at the currentIndex
	 */
    COMPILE::SWF
	private function runSetup(continuing:Boolean = false):Boolean
	{
		if (!testResult.hasStatus()) 
		{ 
			if (setup)
			{
				testResult.phase = TestResult.SETUP;
				currentSteps = setup;
				if (!continuing)
					currentIndex = 0;
				numSteps = setup.length;
				// return if we need to wait for something
				if (!runSteps())
					return false;

			}
		}
		return runBody();
	}

	/**
	 *  Execute the body portion of the test
	 *
	 *  @param continuing If true, don't reset the counter to zero
	 *  and just continue on with the test at the currentIndex
	 */
    COMPILE::SWF
	private function runBody(continuing:Boolean = false):Boolean
	{
		if (!testResult.hasStatus()) 
		{ 
			if (body)
			{
				testResult.phase = TestResult.BODY;
				currentSteps = body;
				if (!continuing)
					currentIndex = 0;
				numSteps = body.length;
				// return if we need to wait for something
				if (!runSteps())
					return false;

			}
		}
		return runCleanup();
	}

	/**
	 *  Execute the cleanup portion of the test
	 *
	 *  @param continuing If true, don't reset the counter to zero
	 *  and just continue on with the test at the currentIndex
	 */
    COMPILE::SWF
	private function runCleanup(continuing:Boolean = false):Boolean
	{
		if (!testResult.hasStatus()) 
		{ 
			if (cleanup)
			{
				testResult.phase = TestResult.CLEANUP;
				currentSteps = cleanup;
				if (!continuing)
					currentIndex = 0;
				numSteps = cleanup.length;
				// return if we need to wait for something
				if (!runSteps())
					return false;

			}
		}
		return runComplete();
	}

	/**
	 *  Clean up when all three phases are done.  Sends an event
	 *  to the UnitTester harness to tell it that it can run
	 *  the next test case.
	 */
    COMPILE::SWF
	private function runComplete():Boolean
	{
		var n:int = cleanupAsserts.length;
		for (var i:int = 0; i < n; i++)
		{
			var assert:Assert = cleanupAsserts[i];
			assert.cleanup();
		}

		timer.removeEventListener("timer", timerHandler);
		if (needCompleteEvent)
			dispatchEvent(new Event("runComplete"));
		return true;
	}

	/**
	 *  Go through the currentSteps, executing each one.
	 *  Returns true if no test steps required waiting.
	 *  Returns false if we have to wait for an event before
	 *  continuing.
	 */
    COMPILE::SWF
	private function runSteps():Boolean
	{
		while (currentIndex < numSteps)
		{
			// return if a step failed
			if (testResult.hasStatus()) 
				return true;
							
			/* 
			    The following lets you step each step but makes tests
			    more sensitive to which step actually sends the event.
				For example, cb.mouseDown/mouseUp, the tween starts on
				mousedown and fires its event before you step.  Another
				example is asserting with waitEvent=updateComplete.  It
				could have fired a long time before you step
			*/
			if (UnitTester.playbackControl == "pause")
			{
				UnitTester.callback = pauseHandler;
				needCompleteEvent = true;
				return false;
			}
			else if (UnitTester.playbackControl == "step")
				UnitTester.playbackControl = "pause";

			var step:TestStep = currentSteps[currentIndex];
			if (!(step is Assert))
			{
				// look at subsequent steps for Asserts and set them up early
				for (var j:int = currentIndex + 1; j < numSteps; j++)
				{
					// scan following asserts for AssertEvents and set them up early
					var nextStep:TestStep = currentSteps[j];
					if (nextStep is Assert)
					{
						Assert(nextStep).preview(root, context, this, testResult);
						// do a check to be sure folks are using AssertEventPropertyValue correctly
						if (nextStep is AssertEventPropertyValue)
						{
							// AEPV must follow an AssertEvent or another AEPV
							if (j == 0 || !(currentSteps[j-1] is AssertEvent || currentSteps[j-1] is AssertEventPropertyValue))
								TestOutput.logResult("WARNING: AssertEventPropertyValue may be missing preceding AssertEvent");
						}
						else if (nextStep is AssertError)
						{
							if (step is SetProperty)
								SetProperty(step).expectError = true;
						}
					}
					else
						break;
				}
			}
			if (UnitTester.verboseMode)
			{
				TestOutput.logResult(step.toString());
			}
			UnitTester.lastStep = step;
			UnitTester.lastStepLine = currentIndex;
			step.addEventListener("stepComplete", stepCompleteHandler);
			if (!step.execute(root, context, this, testResult))
			{
				needCompleteEvent = true;
				return false;
			}
			step.removeEventListener("stepComplete", stepCompleteHandler);
			currentIndex++;
		}
		return true;
	}

    COMPILE::SWF
	private function stepCompleteHandler(event:Event):void
	{
		var step:TestStep = currentSteps[currentIndex];
		step.removeEventListener("stepComplete", stepCompleteHandler);
		if (UnitTester.playbackControl == "play")
			UnitTester.callback = runNextSteps;
		else
		{
			currentIndex++;
			UnitTester.callback = pauseHandler;
		}
	}


	/**
	 *  Handler for timer events to see if we've waited too long
	 */
    COMPILE::SWF
	private function timerHandler(event:Event):void
	{
		if (expirationTime > 0)
			if (expirationTime < getTimer())
			{
				var step:TestStep = currentSteps[currentIndex];
				step.timeoutCallback();
			}
	}

	/**
	 *  Determines which set of steps (setup, body, cleanup) to run next
	 */
    COMPILE::SWF
	private function runNextSteps():void
	{
		currentIndex++;
		if (currentSteps == setup)
			runSetup(true);
		else if (currentSteps == body)
			runBody(true);
		else if (currentSteps == cleanup)
			runCleanup(true);
		else
			runComplete();
	}

	/**
	 *  Determines which set of steps (setup, body, cleanup) to run next
	 */
    COMPILE::SWF
	private function continueSteps():void
	{
		if (currentSteps == setup)
			runSetup(true);
		else if (currentSteps == body)
			runBody(true);
		else if (currentSteps == cleanup)
			runCleanup(true);
		else
			runComplete();
	}

	/**
	 *  Determines which set of steps (setup, body, cleanup) to run next
	 */
    COMPILE::SWF
	private function pauseHandler():void
	{
		if (UnitTester.playbackControl == "step")
			continueSteps();
		else if (UnitTester.playbackControl == "play")
			continueSteps();
		else
			UnitTester.callback = pauseHandler;
	}
}

}
