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

COMPILE::SWF{
	import flash.net.*;
	import flash.events.Event;
}


[Mixin]
/**
 *  A class that sets a flag that tells SendFormattedResultsToLog
 *  to not log the scriptComplete because we don't need it for
 *  basicTests and it can cause security violations if the port
 *  is not available.
 */
public class DontSendScriptComplete
{

	/**
	 *  Mixin callback that gets everything ready to go.
	 *  The UnitTester waits for an event before starting
	 */
	public static function init(root:Object):void
	{
		UnitTester.noScriptComplete = true;
	}


}
}
