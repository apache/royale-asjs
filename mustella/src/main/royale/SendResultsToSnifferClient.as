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
import flash.net.*;
import flash.events.StatusEvent;
import flash.events.Event;

[Mixin]
/**
 *  A "marker" class that causes test scripts to write out
 *  bitmaps to the urls instead of reading and comparing
 *  so that baselines/reference-points can be created for
 *  future comparing.
 */
public class SendResultsToSnifferClient
{

	/**
	 *  Mixin callback that gets everything ready to go.
	 *  The UnitTester waits for an event before starting
	 */
	public static function init(root:DisplayObject):void
	{
		TestOutput.getInstance().addEventListener ("result", snifferSender);

		/// other required:
  		connection = new LocalConnection();
		connection.allowDomain("*");
  		connection.addEventListener(StatusEvent.STATUS, statusHandler);
	}

 	private static function statusHandler(event:Event):void
	{
	}

   /**
     *  @private
	 *  The local connection to the remote client
     */
    private static var connection:LocalConnection;

	/**
  	 * the way out for the result data
	 */
	public static function snifferSender (event:Event):void 
	{ 

		var s:String = (event as MustellaLogEvent).msg;

//		connection.send("_EventSniffer", "appendLog", "Mustella_Output", "Mustella_Output", s, "");

	    var info:Object = new Object();
	    
	    info.dataSource = "Mustella_Output";
	    info.target = "Mustella_Output";
	    info.eventName = s;
	    info.event = "";
	    
	    connection.send("_EventSniffer", "appendLog", info);

	}


}
}
