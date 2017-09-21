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
import flash.utils.getTimer;

import mx.core.mx_internal;
use namespace mx_internal;

/**
 *  The test step that sets a property to some value
 *  MXML attributes:
 *  target
 *  timeout (optional);
 */
public class WaitForSandboxApp extends TestStep
{
	/**
	 *  @private
	 */
	override public function execute(root:DisplayObject, context:UnitTester, testCase:TestCase, testResult:TestResult):Boolean
	{
		super.execute(root, context, testCase, testResult);
		return false;
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

		UnitTester.callback = waitForApp;

		testCase.setExpirationTime(getTimer() + timeout);
	}

	private function waitForApp():void
	{

		var actualTarget:Object = context.stringToObject(target);
		if (actualTarget.bytesLoaded < actualTarget.bytesTotal)
		{
			UnitTester.callback = waitForApp;
			return;
		}

		try
		{
			var e:MustellaSandboxEvent = new MustellaSandboxEvent(MustellaSandboxEvent.APP_READY);
			actualTarget.contentHolder.contentLoaderInfo.sharedEvents.dispatchEvent(e);
			if (e.obj)
			{
				testCase.setExpirationTime(0);
				stepComplete();
			}
			else
				UnitTester.callback = waitForApp;
		}
		catch (e:Error)
		{
			UnitTester.callback = waitForApp;
		}
	}

	/**
	 *  The SWFLoader that loads the untrusted app
	 */
	public var target:String;

	/**
	 *  customize string representation
	 */
	override public function toString():String
	{
		var s:String = "WaitForSandboxApp";
		if (target)
			s += ": target = " + target;
		return s;
	}
}

}
