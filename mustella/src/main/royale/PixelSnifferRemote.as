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

import mx.managers.IFocusManagerComponent;
import mx.managers.SystemManager;
import mx.core.FlexGlobals;
import mx.core.IFlexDisplayObject;
import mx.core.IMXMLObject;
import mx.core.UIComponent;
import mx.core.IVisualElementContainer;
import mx.core.mx_internal;
use namespace mx_internal;

[Mixin]
/**
 *  Displays positions and pixel colors to SnifferRemoteClient.swf
 */
public class PixelSnifferRemote
{
	public function PixelSnifferRemote()
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

		pixelcommandconnection = new LocalConnection();
		pixelcommandconnection.allowDomain("*");
		pixelcommandconnection.client = PixelSnifferRemote;
		pixelcommandconnection.connect("_PixelSnifferCommands");
	}

    // Turn on only if the SnifferRemoteClient app's checkbox
    // for this item is checked.
	private static function initHandler(event:Event):void
	{
        connection.send("_PixelSniffer", "toggleSniffersEnabled");
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
    private static var pixelcommandconnection:LocalConnection;    


	public static function enableSniffer():void
	{

		// hook UIComponent so we can see all events
		document.stage.addEventListener("mouseMove", mouseMoveHandler);
	}

	public static function disableSniffer():void
	{
        //trace("PixelSnifferRemote disabled");
        
		document.stage.removeEventListener("mouseMove", mouseMoveHandler);
	}

	private static function mouseMoveHandler(event:MouseEvent):void
	{
		var c:DisplayObject = findComponent(DisplayObject(event.target));
		var pt:Point = c.globalToLocal(new Point(event.stageX, event.stageY));
		/// we're combining these (perhaps for now) because the other side only 	
		/// really cares about event Name, not event
		appendLog(c.toString(), "[mousedata] "+ pt.toString() + " " + pixelValue(c, pt), "");
	}

	/* a heuristic for figuring out which component should be the target */
	private static function findComponent(target:DisplayObject):DisplayObject
	{
		var o:DisplayObject = target;
		while (o)
		{
			if (o is IFocusManagerComponent && IFocusManagerComponent(o).focusEnabled)
				return o;



			/* was: (before the spark -only universe)
			if (o.parent is Container)
			{
				var c:Container = o.parent as Container;
				var children:Array = c.createdComponents;
				var numChildren:int = children.length;
				for (var i:int = 0; i < numChildren; i++)
				{
					if (children[i] == o)
						return o;
				}
			}
			*/


			/// post-mobile universe
			if (o.parent is IVisualElementContainer) 
			{

				var c:IVisualElementContainer = o.parent as IVisualElementContainer;
				var numChildren:int = c.numElements;
				for (var i:int = 0; i < numChildren; i++)
				{
					if (c.getElementAt(i) == o) 
					{ 
						return o;
					}

				 }
			}
			else if (o.parent is SystemManager)
			{
				return o;
			}
			o = o.parent;
		}
		return target;
	}

	private static function pixelValue(target:DisplayObject, pt:Point):String
	{
		var stagePt:Point = target.localToGlobal(new Point(0, 0));
		var screenBits:BitmapData = new BitmapData(target.width, target.height);
		screenBits.draw(document.stage, new Matrix(1, 0, 0, 1, -stagePt.x, -stagePt.y));

		var clr:uint = screenBits.getPixel(pt.x, pt.y);
		var s:String = clr.toString(16);
		while (s.length < 6)
		{
			s = "0" + s;
		}

		return s.toUpperCase();
	}

	private static function appendLog(c:String, s:String, col:String):void
	{
//		connection.send("_PixelSniffer", "appendLog", "Pixel", c, s, col);

	    var info:Object = new Object();
	    
	    info.dataSource = "Pixel";
	    info.target = c;
	    info.eventName = s;
	    info.event = col;

        /**
        trace("PixelSniffer is sending: ");
        trace ("    info.dataSource: " + info.dataSource);
        trace ("    info.target: " + info.target);
        trace ("    info.eventName: " + info.eventName);
        trace ("    info.event: " + info.event);
	    **/
	    
	    connection.send("_PixelSniffer", "appendLog", info);

	}

}

}
