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
import flash.external.ExternalInterface;

import mx.core.mx_internal;
use namespace mx_internal;

/**
 *  Instead of a property, we use an event so the MXML
 *  compiler will wrap the code in a function for us
 */
[Event(name="valueExpression", type="flash.events.Event")]

/**
 *  Tests that the value of a property is as expected
 *  MXML attributes:
 *  title
 *  waitTarget (optional)
 *  waitEvent (optional)
 *  timeout (optional)
 */
public class AssertTitle extends Assert
{
	/**
	 *  See if the property has the correct value
	 */
	override protected function doStep():void
	{
		var actualTitle:String = ExternalInterface.call("BrowserHistory.getTitle");
		if (valueToString(actualTitle) != valueToString(title))
		{
			testResult.doFail ( "Expected " + valueToString(title) + ", got " + valueToString(actualTitle));
		} 
	}

	/**
	 *  The value the url should have
	 */
	public var title:String;

	/**
	 *  customize string representation
	 */
	override public function toString():String
	{
		var s:String = "AssertTitle";
		return s;
	}
}

}
