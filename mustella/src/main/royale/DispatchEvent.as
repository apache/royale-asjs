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
import flash.display.DisplayObjectContainer;
import flash.display.InteractiveObject;
import flash.events.Event;
import flash.system.ApplicationDomain;
}

/**
 *  The test step that fakes an event.  Do not use for MouseEvent or KeyboardEvent
 *  MXML attributes:
 *  bubbles
 *  cancelable
 *  eventClass
 *  properties
 *  target
 *  type
 *  waitTarget (optional)
 *  waitEvent (optional)
 *  timeout (optional);
 */
public class DispatchEvent extends TestStep
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
		UnitTester.blockFocusEvents = false;

		var actualTarget:Object = context.stringToObject(target);
		if (!actualTarget)
		{
			testResult.doFail("Target " + target + " not found");
			UnitTester.blockFocusEvents = false;
			return;
		}

		var c:Class = ApplicationDomain.currentDomain.getDefinition(eventClass) as Class;
		var event:Event = new c(type, bubbles, cancelable);
		if (properties)
		{
			for (var s:String in properties)
			{
				event[s] = properties[s];
			}
		}
		try
		{
			actualTarget.dispatchEvent(event);
		}
		catch (e2:Error)
		{
			TestOutput.logResult("Exception thrown in DispatchEvent.");
			testResult.doFail (e2.getStackTrace());	
		}

		UnitTester.blockFocusEvents = true;
	}

	/**
	 *  The qualified name of the class for the event
	 *  i.e. flash.events.Event
	 */
	public var eventClass:String;

	/**
	 *  The object that receives the mouse event
	 */
	public var target:String;

	/**
	 *  The type of the event to send (mouseUp, mouseDown, etc).
	 */
	public var type:String;

	/**
	 *  The bubbles property on the Event (optional)
	 */
	public var bubbles:Boolean;

	/**
	 *  The cancelable property on the Event (optional)
	 */
	public var cancelable:Boolean;


	/**
	 *  The relatedObject property on the MouseEvent (optional)
	 */
	public var properties:Object;


	/**
	 *  customize string representation
	 */
	override public function toString():String
	{
		var s:String = "DispatchEvent: target = ";
		s += target;
		if (type)
			s += ", type = " + type;
		return s;
	}
}

}
