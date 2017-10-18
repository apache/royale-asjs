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
package 
{
import flash.display.DisplayObject;
import flash.events.Event;
import flash.events.FocusEvent;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.events.StatusEvent;
import flash.net.LocalConnection;

import mx.core.FlexGlobals;
import mx.core.IFlexDisplayObject;
import mx.core.IMXMLObject;
import mx.core.UIComponent;
import mx.core.mx_internal;
use namespace mx_internal;

[Mixin]
/**
 *  Traps most events and records them to SnifferRemoteClient.swf
 */
public class EventSnifferRemote
{
	public function EventSnifferRemote()
	{
	}

	public static function init(root:Object):void
	{
		document = root;
		if (document)
			document.addEventListener("applicationComplete", initHandler);
			
  		connection = new LocalConnection();
		connection.allowDomain("*");
  		connection.addEventListener(StatusEvent.STATUS, statusHandler);
  		
		commandconnection = new LocalConnection();
		commandconnection.allowDomain("*");
		commandconnection.client = EventSnifferRemote;
		commandconnection.connect("_EventSnifferCommands");
	}

    // Turn on only if the SnifferRemoteClient app's checkbox
    // for this item is checked.
	private static function initHandler(event:Event):void
	{
        connection.send("_EventSniffer", "toggleSniffersEnabled");
	}

	private static function statusHandler(event:Event):void
	{
	}

    /**
     *  @private
	 *  The document containing a reference to this object
     */
    private static var document:Object;

    /**
     *  @private
	 *  The local connection to the remote client
     */
    private static var connection:LocalConnection;
    private static var commandconnection:LocalConnection;

	public static function enableSniffer():void
	{
        //trace("EventSnifferRemote enabled");

		// hook UIComponent so we can see all events
		UIComponent.dispatchEventHook = dispatchEventHook;
		document.stage.addEventListener(MouseEvent.CLICK, uberListener, true);
		document.stage.addEventListener(MouseEvent.DOUBLE_CLICK, uberListener, true);
		document.stage.addEventListener(MouseEvent.MOUSE_DOWN, uberListener, true);
		document.stage.addEventListener(MouseEvent.MOUSE_MOVE, uberListener, true);
		document.stage.addEventListener(MouseEvent.MOUSE_OUT, uberListener, true);
		document.stage.addEventListener(MouseEvent.MOUSE_OVER, uberListener, true);
		document.stage.addEventListener(MouseEvent.MOUSE_UP, uberListener, true);
		document.stage.addEventListener(MouseEvent.MOUSE_WHEEL, uberListener, true);
		document.stage.addEventListener(MouseEvent.ROLL_OUT, uberListener, true);
		document.stage.addEventListener(MouseEvent.ROLL_OVER, uberListener, true);
		document.stage.addEventListener(KeyboardEvent.KEY_UP, uberListener, true);
		document.stage.addEventListener(KeyboardEvent.KEY_DOWN, uberListener, true);
		document.stage.addEventListener(FocusEvent.FOCUS_IN, uberListener, true);
		document.stage.addEventListener(FocusEvent.FOCUS_OUT, uberListener, true);
	}

	public static function disableSniffer():void
	{
        //trace("EventSnifferRemote disabled");
        
		// unhook UIComponent so we can see all events
		UIComponent.dispatchEventHook = null;
		document.stage.removeEventListener(MouseEvent.CLICK, uberListener, true);
		document.stage.removeEventListener(MouseEvent.DOUBLE_CLICK, uberListener, true);
		document.stage.removeEventListener(MouseEvent.MOUSE_DOWN, uberListener, true);
		document.stage.removeEventListener(MouseEvent.MOUSE_MOVE, uberListener, true);
		document.stage.removeEventListener(MouseEvent.MOUSE_OUT, uberListener, true);
		document.stage.removeEventListener(MouseEvent.MOUSE_OVER, uberListener, true);
		document.stage.removeEventListener(MouseEvent.MOUSE_UP, uberListener, true);
		document.stage.removeEventListener(MouseEvent.MOUSE_WHEEL, uberListener, true);
		document.stage.removeEventListener(MouseEvent.ROLL_OUT, uberListener, true);
		document.stage.removeEventListener(MouseEvent.ROLL_OVER, uberListener, true);
		document.stage.removeEventListener(KeyboardEvent.KEY_UP, uberListener, true);
		document.stage.removeEventListener(KeyboardEvent.KEY_DOWN, uberListener, true);
		document.stage.removeEventListener(FocusEvent.FOCUS_IN, uberListener, true);
		document.stage.removeEventListener(FocusEvent.FOCUS_OUT, uberListener, true);
	}

	private static function uberListener(event:Event):void
	{
		dispatchEventHook(event, DisplayObject(event.target));
	}

	private static function dispatchEventHook(event:Event, target:DisplayObject):void
	{
	    
		// connection.send("_EventSniffer", "appendLog", "Event", target.toString(), event.type, event.toString());
		
		// This is the appendLog method in SnifferRemoteClient which will accept this:
	    // public function appendLog(dataSource:String = null, target:String=null, eventName:String = null, event:String = null):void

	    var info:Object = new Object();
	    
	    info.dataSource = "Event";
	    info.target = target.toString();
	    info.eventName = event.type;
	    info.event = event.toString();
	    
	    connection.send("_EventSniffer", "appendLog", info);
	}
}

}
