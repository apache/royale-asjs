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
import flash.system.ApplicationDomain;
import flash.utils.getTimer;

import mx.core.mx_internal;
use namespace mx_internal;

/**
 *  The test step that sets a property to some value
 *  MXML attributes:
 *  timeout (optional)
 */
public class WaitForEffectsToEnd extends TestStep
{
	private static var effectsInEffect:QName = new QName(mx_internal, "effectsInEffect");
	private static var activeTweens:QName = new QName(mx_internal, "activeTweens");

	/**
	 *  @private
	 */
	override public function execute(root:DisplayObject, context:UnitTester, testCase:TestCase, testResult:TestResult):Boolean
	{
		super.execute(root, context, testCase, testResult);

		var appDom:ApplicationDomain = root["topLevelSystemManager"]["info"]().currentDomain;
		if (!appDom)
			appDom = ApplicationDomain.currentDomain;

		var effects:Boolean = false;

		var effectMgr:Class = Class(appDom.getDefinition("mx.effects.EffectManager"));
		if (effectMgr)
		{
			effects = effectMgr[effectsInEffect]();
		}
		if (!effects)
		{
			effectMgr = Class(appDom.getDefinition("mx.effects.Tween"));
			if (effectMgr)
			{
				effects = effectMgr[activeTweens].length > 0;
			}
		}
		if (!effects)
			effects = UnitTester.getSandboxedEffects();

		if (effects)
		{
			UnitTester.callback = checkEffects;
			testCase.setExpirationTime(getTimer() + timeout);
		}
		return !effects;
	}

	/**
	 *  Set the target's property to the specified value
	 */
	private function checkEffects():void
	{
		var effects:Boolean = false;

		var appDom:ApplicationDomain = root["topLevelSystemManager"]["info"]().currentDomain;
		if (!appDom)
			appDom = ApplicationDomain.currentDomain;

		var effectMgr:Class = Class(appDom.getDefinition("mx.effects.EffectManager"));
		if (effectMgr)
		{
			effects = effectMgr[effectsInEffect]();
		}
		if (!effects)
		{
			effectMgr = Class(appDom.getDefinition("mx.effects.Tween"));
			if (effectMgr)
			{
				effects = effectMgr[activeTweens].length > 0;
			}
		}
		if (!effects)
			effects = UnitTester.getSandboxedEffects();

		if (effects)
		{
			UnitTester.callback = checkEffects;
			testCase.setExpirationTime(getTimer() + timeout);
		}
		else
		{
			testCase.setExpirationTime(0);
			stepComplete();
		}

	}

	/**
	 *  customize string representation
	 */
	override public function toString():String
	{
		var s:String = "WaitForEffectsToEnd";
		return s;
	}
}

}
