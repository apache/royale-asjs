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
 *  The test step that sets the browser to a specific URL
 *  MXML attributes:
 *  url
 *  waitTarget (optional)
 *  waitEvent (optional)
 *  timeout (optional);
 */
public class SetURL extends TestStep
{

	/**
	 *  Set the target's property to the specified value
	 */
	override protected function doStep():void
	{
		var count:int = 0;
		if (url.indexOf("BACK") == 0)
		{
			if (url.length > 4)
				count = parseInt(url.substring(4));

			if (count > 0)
				ExternalInterface.call("goForwardOrBackInHistory", -count);
			else
				ExternalInterface.call("backButton");

		}
		else if (url.indexOf("FORWARD") == 0)
		{
			if (url.length > 7)
				count = parseInt(url.substring(7));

			if (count > 0)
				ExternalInterface.call("goForwardOrBackInHistory", count);
			else
				ExternalInterface.call("forwardButton");

		}
		else
		{
			ExternalInterface.call("setURL", url);
		}
	}

	/**
	 *  The url to navigate to.  Can also be "BACK" or "FORWARD"
	 */
	public var url:String;

	/**
	 *  customize string representation
	 */
	override public function toString():String
	{
		var s:String = "SetURL";
		if (url)
			s += ", url = " + url;
		return s;
	}
}

}
