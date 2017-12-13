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
import flash.display.IBitmapDrawable;
import flash.utils.*;
import flash.net.*;
import flash.events.*;
import flash.display.*;
import flash.geom.Matrix;

/**
 *  Tests that the value of a property is as expected
 *  MXML attributes:
 *  target
 *  eventName
 *  eventType
 *  waitTarget (optional)
 *  waitEvent (optional)
 *  timeout (optional)
 */
public class AssertEvent extends Assert
{

	private var eventListenerListening:Boolean = false;

	/**
	 *  Test the value of a property, log result if failure.
	 */
	override public function preview(root:DisplayObject, context:UnitTester, testCase:TestCase, testResult:TestResult):void
	{
		this.root = root;
		this.context = context;
		this.testCase = testCase;
		this.testResult = testResult;

		var actualTarget:Object = context.stringToObject(target);
		if (actualTarget)
		{
			actualTarget.addEventListener(eventName, eventListener);
			eventListenerListening = true;
			testCase.cleanupAsserts.push(this);
		}
		// we don't fail during preview, we will fail later anyway
	}

	/**
	 *  Test the value of a property, log result if failure.
	 */
	override public function execute(root:DisplayObject, context:UnitTester, testCase:TestCase, testResult:TestResult):Boolean
	{
		this.root = root;
		this.context = context;
		this.testCase = testCase;
		this.testResult = testResult;

		if (numEvents == 1 && (numExpectedEvents == 1 || numExpectedEvents == -1))
		{
			doStep();
			return true;
		}

		if ((numEvents < numExpectedEvents) || (numEvents == 0 && numExpectedEvents == -1))
		{
			var actualTarget:IEventDispatcher = context.stringToObject(target) as IEventDispatcher;
			if (!actualTarget)
			{
				testResult.doFail("target " + target + " not found");
				return true;
			}
			// if eventListener is not hooked up, make sure it is
			if (!eventListenerListening)
			{
				actualTarget.addEventListener(eventName, eventListener);
				eventListenerListening = true;
				testCase.cleanupAsserts.push(this);
			}
			// don't remove eventListener because we still want to check for extra events
			// but add this in so we can wait until we get the required number of events
			actualTarget.addEventListener(eventName, waitEventHandler);
			testCase.setExpirationTime(getTimer() + timeout);
			waitEvent = eventName;
			waitTarget = target;
			return false;
		}

		return super.execute(root, context, testCase, testResult);
	}

	/**
	 *  Test the value of a property, log result if failure.
	 */
	override protected function doStep():void
	{
		var actualTarget:Object = context.stringToObject(target);
		if (!actualTarget)
		{
			testResult.doFail("Target " + target + " not found");
			return;
		}

		context.lastEvent = lastEvent;

		if (numExpectedEvents != -1 && numEvents != numExpectedEvents)
		{
			testResult.doFail("Event " + eventName + " received " + numEvents + " times");
			return;
		}

		if (getQualifiedClassName(lastEvent).indexOf(eventClass) == -1)
			testResult.doFail("Event " + eventName + " of class " + getQualifiedClassName(lastEvent));
	}

	/**
	 *  The name of the event to watch for
	 */
	public var eventName:String;

	/**
	 *  The class of the event, e.g. mx.events.DataGridEvent
	 */
	public var eventClass:String;

	/**
	 *  Storage for numEvents
	 */
	protected var numEvents:int = 0;

	/**
	 *  Number of expected events (must be > 0), use AssertNoEvent for 0.
	 *  Set to -1 if you want to see at least one event and don't care if there's more.
	 */
	public var numExpectedEvents:int = 1;

	/**
	 *  The event object
	 */
	private var lastEvent:Event;

	/**
	 *	The event listener
	 */
	protected function eventListener(event:Event):void
	{
		testCase.setExpirationTime(0);

		lastEvent = event;
		numEvents++;

		if (numExpectedEvents != -1 && numEvents > numExpectedEvents)
		{
			testResult.doFail ("Event " + eventName + " received " + numEvents + " times");	
			return;
		}
	}

	/**
	 *  Test the value of a property, log result if failure.
	 */
	override public function cleanup():void
	{
		var actualTarget:Object = context.stringToObject(target);
		if (actualTarget)	// might be null if object was killed
			actualTarget.removeEventListener(eventName, eventListener);
	}

	/**
	 *  customize string representation
	 */
	override public function toString():String
	{
		var s:String = "AssertEvent";
		if (target)
			s += ": target = " + target;
		if (eventName)
			s += ", eventName = " + eventName;
		return s;
	}

	/**
	 *  The method that gets called back when the event we're waiting on fires
	 */
	override protected function waitEventHandler(event:Event):void
	{
		// we can rely on eventListener to update lastEvent and numEvents

		// keep waiting if there aren't enough events
		if (numExpectedEvents != -1 && numEvents < numExpectedEvents)
		{
			testCase.setExpirationTime(getTimer() + timeout);
			return;
		}

		// finish up
		waitEvent = eventName;
		waitTarget = target;
		super.waitEventHandler(event);

	}
}

}
