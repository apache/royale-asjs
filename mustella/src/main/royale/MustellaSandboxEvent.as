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

import flash.events.Event;

/**
 *  An event used as a message passed across security domain boundaries
 */
public class MustellaSandboxEvent extends Event
{
	public static const MUSTELLA_STARTED:String = "mustellaStarted";
	public static const STRING_TO_OBJECT:String = "stringToObject";
	public static const GET_BITMAP:String = "getBitmap";
	public static const GET_EFFECTS:String = "getEffects";
	public static const GET_OBJECTS_UNDER_POINT:String = "getObjectsUnderPoint";
	public static const RESET_COMPONENT:String = "resetComponent";
	public static const MOUSEXY:String = "mouseXY";
	public static const GET_FOCUS:String = "getFocus";
	public static const APP_READY:String = "appReady";

	/**
	 *  
	 */
	public function MustellaSandboxEvent(type:String)
	{
		super(type);
	}

	// the string to be parsed and turned into an object
	public var string:String;

	// the object returned.
	public var obj:Object;
}

}
