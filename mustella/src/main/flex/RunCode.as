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
}

/**
 *  Instead of a property, we use an event so the MXML
 *  compiler will wrap the code in a function for us
 */
[Event(name="code", type="flash.events.Event")]

/**
 *  A test step that runs an arbitrary set of actionscript
 *  MXML attributes
 *  code (a sequence of actionscript)
 */
public class RunCode extends TestStep
{
	/** 
	 *  Execute the code by passing it an event.
	 */
    COMPILE::SWF
	override protected function doStep():void
	{
		UnitTester.blockFocusEvents = false;
		try
		{
			dispatchEvent(new RunCodeEvent("code", root["document"], context, testCase, testResult));
		}
		catch (e1:Error)
		{
			TestOutput.logResult("Exception thrown in RunCode.");
			testResult.doFail (e1.getStackTrace());	
			UnitTester.blockFocusEvents = true;
			return;
		}
		UnitTester.blockFocusEvents = true;
	}

	/*
	public var code:Function; // Event metadata takes care of this
	*/

	/**
	 *  customize string representation
	 */
    COMPILE::SWF
	override public function toString():String
	{
		var s:String = "RunCode: (code attribute cannot be shown)";
		return s;
	}
}

}
