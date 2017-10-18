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
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.StatusEvent;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.net.LocalConnection;
import flash.utils.getQualifiedClassName;

import mx.managers.IFocusManagerComponent;
import mx.managers.SystemManager;
import mx.core.FlexGlobals;
import mx.core.IFlexDisplayObject;
import mx.core.IMXMLObject;
import mx.core.UIComponent;
// import mx.core.Container;
import mx.utils.ObjectUtil;

import mx.core.mx_internal;
use namespace mx_internal;

[Mixin]
/**
 *  Displays object properties and values to SnifferRemoteClient
 */
public class ObjectSnifferRemote
{
	public function ObjectSnifferRemote()
	{
	}

	public static function init(root:Object):void
	{

		_root = document = root;
		if (document)
			document.addEventListener("applicationComplete", initHandler);
		connection = new LocalConnection();
		connection.allowDomain("*");
		connection.addEventListener(StatusEvent.STATUS, statusHandler);

		commandconnection = new LocalConnection();
		commandconnection.allowDomain("*");
		commandconnection.client = ObjectSnifferRemote;
		commandconnection.connect("_ObjectSnifferCommands");
	}

	private static function initHandler(event:Event):void
	{
		//enableSniffer();
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

	private static var snifferEnabled:Boolean = true;

	public static function enableSniffer():void
	{
		snifferEnabled = true;
	}

	public static function disableSniffer():void
	{
		snifferEnabled = false;
	}

	private static function appendLog(s:String):void
	{
		//connection.send("_ObjectSniffer", "appendLog", "Object", s);

	    var info:Object = new Object();
	    
        info.dataSource = "Object";
        info.target = s;
        info.eventName = "";
        info.event = "";

        /**        
        trace("ObjectSniffer is sending: ");
        trace ("    info.dataSource: " + info.dataSource);
        trace ("    info.target: " + info.target);
        trace ("    info.eventName: " + info.eventName);
        trace ("    info.event: " + info.event);
        **/
        
        connection.send("_ObjectSniffer", "appendLog", info);
	}

	public static function dumpObject(s:String):void
	{
		if (!snifferEnabled)
			return;

		var obj:* = stringToObject(s);
		if (obj === null)
		{
			appendLog(s + " = null");
		}
		else if (obj === undefined)
		{
			appendLog(s + " = undefined");
		}
		else if (obj is String)
		{
			appendLog(s + " = " + obj);
		}
		else if (obj is Boolean)
		{
			appendLog(s + " = " + obj.toString());
		}
		else if (obj is uint)
		{
			appendLog(s + " = " + obj.toString(10) + " (0x" + obj.toString(16).toUpperCase() + ")");
		}
		else if (obj is Number)
		{
			appendLog(s + " = " + obj.toString());
		}
		else if (obj is XML || obj is XMLList)
		{
			if (obj is XMLList && obj.length() == 1)
				appendLog(s + " = " + obj.toString());
			else if (obj is XMLList && obj.length() == 0)
				appendLog(s + " not found");
			else
				appendLog(s + " = " + obj.toXMLString());
		}
		else if (obj is Array)
		{
			appendLog(s + " = Array");
		}
		else appendLog(s + " = " + getQualifiedClassName(obj));
	}

	public static function listProperties(s:String):void
	{
		document.document.callLater(listProperties_cb, [s]);
	}

	public static function listProperties_cb(s:String):void
	{
		if (!snifferEnabled)
			return;

		var n:int;
		var i:int;

		var obj:* = stringToObject(s);
		if (obj === null)
		{
			appendLog(s + " is null, has no properties");
		}
		else if (obj === undefined)
		{
			appendLog(s + " is undefined, has no properties");
		}
		else if (obj is String)
		{
			appendLog(s + " is String, has no properties");
		}
		else if (obj is uint)
		{
			appendLog(s + " is uint, has no properties");
		}
		else if (obj is uint)
		{
			appendLog(s + " is int, has no properties");
		}
		else if (obj is Number)
		{
			appendLog(s + " is Number, has no properties");
		}
		else if (obj is XML)
		{
			appendLog(s);
			appendLog("  attributes:");
			var attrs:XMLList = obj.attributes();
			n = attrs.length();
			for (i = 0; i < n; i++)
			{
				appendLog("    " + attrs[i].name());
			}
			var children:XMLList = obj.children();
			n = children.length();
			var namesTable:Object = {};
			for (i = 0; i < n; i++)
			{
				namesTable[children[i].name()] = 1;
			}
			appendLog("  children:");
			for (var p:String in namesTable)
				appendLog("    " + p);
		}
		else if (obj is Array)
		{
			appendLog(s + " is Array of length " + obj.length);
		}
		else 
		{
			var info:Object = ObjectUtil.getClassInfo(obj, null, { includeReadOnly: true, includeTransient: true, uris: ["", "mx_internal"] } );
			appendLog(s + " = " + info.name);
			n = info.properties.length;
			for (i = 0; i < n; i++)
				appendLog("  " + info.properties[i]);
		}

	}

	/**
	 *  direct copy of UnitTester's stringToObject, except that it doesn't handle "script"
	 *  take an expression, find the object.
	 *  handles mx_internal:propName
	 *  a.b.c
	 *  getChildAt()
	 */
	public static function stringToObject(s:*):*
	{
		if (s == null || s == "")
			return _root["document"];

		try
		{
			var propName:* = s;
			if (s.indexOf("mx_internal:") == 0)
				propName = new QName("mx_internal", s.substring(12));
			if (s.indexOf("getChildAt(") == 0 && s.indexOf(".") == -1)
			{
				s = s.substring(11);
				s = s.substring(0, s.indexOf(")"));
				return _root["document"].getChildAt(parseInt(s));
			}
			return _root["document"][propName];
		}
		catch (e:Error)
		{
			// maybe it is a class
			var dot:int;
			var cc:int = s.indexOf("::");
			var className:String = s;
			var obj:Object = _root["document"];
			if (cc > 0)
			{
				dot = s.indexOf(".", cc);
				if (dot >= 0)
				{
					className = s.substring(0, dot);
					s = s.substring(dot + 1);
				}
				else
					s = "";
			}
			else
				dot = s.indexOf(".");

			try
			{
				obj = _root["info"]().currentDomain.getDefinition(className);		
			}
			catch (e:Error)
			{
				if (dot == -1)
					return undefined;
			}
			if (dot == -1)
				return obj;

			var list:Array = s.split(".");
			while (list.length)
			{
				try 
				{
					s = list.shift();
					if (s.indexOf("mx_internal:") == 0)
						s = new QName(mx_internal, s.substring(12));
					if (s is String && s.indexOf("getChildAt(") == 0)
					{
						s = s.substring(11);
						s = s.substring(0, s.indexOf(")"));
						obj = obj.getChildAt(parseInt(s));
					}
					else
						obj = obj[s];
				}
				catch (e:Error)
				{
					return undefined;
				}
			}
			return obj;
		}
		return null;
	}

}

}
