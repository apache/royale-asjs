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
import mx.core.UIComponent;
import mx.effects.EffectManager;

/**
 *  A test step that runs an arbitrary set of actionscript
 *  MXML attributes
 *  code (a sequence of actionscript)
 */
public class ChangeState extends TestStep
{
	public var changeTarget:String;
	public var toState:String;
	
	public function ChangeState():void
	{
		waitEvent = "currentStateChange";
		super();
	}
	
	/** 
	 *  Execute the code by passing it an event.
	 */
	override protected function doStep():void
	{
		var actualTarget:UIComponent;
		
		UnitTester.blockFocusEvents = false;
		
		actualTarget = context.stringToObject(this.changeTarget) as UIComponent;
		
		try
		{
			if((toState) && (actualTarget))
			{
				if(actualTarget.currentState != toState)
				{
					EffectManager.suspendEventHandling();
					actualTarget.currentState = this.toState;
					EffectManager.resumeEventHandling();
				}
				else
				{
					this.stepComplete();
				}
			} 
			
		}
		catch (e1:Error)
		{
			TestOutput.logResult("Exception thrown in ChangeState.");
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
	override public function toString():String
	{
		var s:String = "RunCode: (code attribute cannot be shown)";
		return s;
	}
}

}
