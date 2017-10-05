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
import flash.geom.Point;
import flash.net.LocalConnection;
import flash.utils.describeType;
import flash.utils.getQualifiedClassName;

import mx.core.IDeferredInstantiationUIComponent;
import mx.core.IUIComponent;
import mx.managers.SystemManager;

import mx.core.mx_internal;
use namespace mx_internal;

[Mixin]
/**
 *  Tries to show location and target path of mouse
 */
public class MouseSnifferRemote
{
	public function MouseSnifferRemote()
	{
	}

	public static function init(root:Object):void
	{
		document = root;
  		connection = new LocalConnection();
		connection.allowDomain("*");
  		connection.addEventListener(StatusEvent.STATUS, statusHandler);

        // Turn on only if the SnifferRemoteClient app's checkbox
        // for this item is checked.
        connection.send("_MouseSniffer", "toggleSniffersEnabled");

		mousecommandconnection = new LocalConnection();
		mousecommandconnection.allowDomain("*");
		mousecommandconnection.client = MouseSnifferRemote;
		mousecommandconnection.connect("_MouseSnifferCommands");
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
    private static var mousecommandconnection:LocalConnection;

	public static function enableSniffer():void
	{
        //trace("MouseSnifferRemote enabled");	    

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
	}

	public static function disableSniffer():void
	{
        //trace("MouseSnifferRemote disabled");	    
        
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
	}

	public static var propLists:Object = new Object();

	private static function uberListener(event:MouseEvent):void
	{
		var target:String = findPath(event.target);
		var pt:Point = new Point(event.stageX, event.stageY);
		var obj:Object = document.document;
		var s:String = target;
		var dot:int = s.indexOf(".");
  	    var info:Object = new Object();

		if (dot != -1)
		{
			var pieces:Array = s.split(".");
			for (var i:int = 0; i < pieces.length; i++)
			{
				s = pieces[i];
				if (s != null && s.indexOf("getChildAt(") == 0)
				{
					s = s.substring(11);
					s = s.substring(0, s.length - 1);
					obj = obj.getChildAt(parseInt(s));
				}
				else
				{
					if (obj!=null && s != null && s in obj)
						obj = obj[s];
					else
					{
						// couldn't find the piece so document chain is broken.
						// Containers as item renderers break this
						target = "";
						for (var j:int = 0; j < i; j++)
						{
							target += pieces[j];
							if (j < i - 1)
								target += "."
						}
						break;
					}
				}
			}
		}
		else if (s.length && s.indexOf(" ") == -1)
			obj = obj[s];

		if (obj != null)
			pt = obj.globalToLocal(pt);

		if (target == null || target == ""){
			//connection.send("_MouseSniffer", "appendLog", "Mouse", "stage: " + pt.x + "," + pt.y + "  stage: " + event.stageX + "," + event.stageY);

    	    info.dataSource = "Mouse";
    	    info.target = "stage: " + pt.x + "," + pt.y + "  stage: " + event.stageX + "," + event.stageY;
    	    info.eventName = "";
    	    info.event = "";

    	    connection.send("_MouseSniffer", "appendLog", info);
			
		}else{
			//connection.send("_MouseSniffer", "appendLog", "Mouse", target + " " + pt.x + "," + pt.y + "   stage: " + event.stageX + "," + event.stageY);
    	    info.dataSource = "Mouse";
    	    info.target = target + " " + pt.x + "," + pt.y + "   stage: " + event.stageX + "," + event.stageY;
    	    info.eventName = "";
    	    info.event = "";

    	    connection.send("_MouseSniffer", "appendLog", info);

		}
	}

	private static function findPath(target:Object, name:String = ""):String
	{
		var s:String = target.toString();
		var dot:int = s.indexOf(".");
		if (dot == -1)
		{
			if (target == document.document || target.parent == document.document)
				return name;
		}

		while (target)
		{
			if (target is IDeferredInstantiationUIComponent)
			{
				var targetName:String = target.id;
				// id of component in document
				if (target.id && target.id in target.document)
				{
					if (target.document[target.id] is Array)
					{
						var arr:Array = target.document[target.id];
						for (var i:int = 0; i < arr.length; i++)
						{
							if (arr[i] == target)
							{
								targetName += "." + i;
								break;
							}
						}
					}

					name = (name == "") ? targetName : targetName + "." + name;
					return findPath(target.document, name);
				}
				// MXML component has id in parent document
				if (target.id && target.document == target)
				{
					name = (name == "") ? target.id : target.id + "." + name;
					return findPath(target.parent.document, name);
				}
			}
			if (target.parent == document.document)
				break;

			if (target.parent is SystemManager)
			{
				// must be a popup
				if (target is IUIComponent)
				{
					s = findPropertyInOwner(target)
					if (s)
					{
						name = (name == "") ? s : s + "." + name;
						target = target.owner;
						continue;
					}
				}

				var index:int = document.document.systemManager.rawChildren.getChildIndex(target as DisplayObject);
				s = "systemManager.rawChildren.getChildAt(" + index + ")";
				name = (name == "") ? s : s + "." + name;
				return name;
			}
			target = target.parent;
		}
		return "no component with id under mouse";

	}

	private static function findPropertyInOwner(target:Object):String
	{
		var owner:Object = target.owner;
		var className:String = getQualifiedClassName(owner);
		var propList:XMLList = propLists[className];
		if (!propList)
		{
			var dt:XML = describeType(owner);
			propList = dt..accessor.(@type != "Number" && @type != "String" && @type != "int" && @type != "Boolean"
					&& @type != "Array" && @type != "Object" && @type != "Class" && @access != "writeonly") +
					dt..variable.(@type != "Number" && @type != "String" && @type != "int" && @type != "Boolean"
					&& @type != "Array" && @type != "Object" && @type != "Class");
			propLists[className] = propList;
		}
		var n:int = propList.length();
		for (var i:int = 0; i < n; i++)
		{
			var propName:String = propList[i].@name.toString();
			if (owner[propName] == target)
				return propName;
		}
		return null;
	}


}

}
