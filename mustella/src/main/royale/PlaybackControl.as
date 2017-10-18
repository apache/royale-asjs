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
import flash.events.Event;
import flash.events.StatusEvent;

[Mixin]
/**
 *  A "marker" class that causes test scripts to write out
 *  bitmaps to the urls instead of reading and comparing
 *  so that baselines/reference-points can be created for
 *  future comparing.
 */
public class PlaybackControl
{

	/**
	 *  Mixin callback that gets everything ready to go.
	 *  The UnitTester waits for an event before starting
	 */
	public static function init(root:DisplayObject):void
	{
		connection = new LocalConnection();
		connection.allowDomain("*");
		connection.addEventListener(StatusEvent.STATUS, statusHandler);

		commandconnection = new LocalConnection();
		connection.allowDomain("*");
		commandconnection.client = PlaybackControl;
		commandconnection.connect("_PlaybackCommands");

		connection.send("_PlaybackSniffer", "getPausedState");
	
	}

	private static function statusHandler(event:Event):void
	{

	}

    /**
     *  @private
	 *  The document containing a reference to this object
     */
    private static var document:Object;
	private static var _root:Object;

    /**
     *  @private
	 *  The local connection to the remote client
     */
    private static var connection:LocalConnection;
    private static var commandconnection:LocalConnection;


	public static function pause():void
	{
		UnitTester.playbackControl = "pause";
	}

	public static function playback():void
	{
		UnitTester.playbackControl = "play";
	}

	public static function step():void
	{
		UnitTester.playbackControl = "step";
	}

}
}
