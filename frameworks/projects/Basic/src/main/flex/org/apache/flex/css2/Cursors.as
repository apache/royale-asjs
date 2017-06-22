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
package org.apache.flex.css2
{
    import org.apache.flex.core.IUIBase;
    import org.apache.flex.events.MouseEvent;
    
    COMPILE::SWF
    {
        import flash.display.DisplayObject;
        import flash.geom.Point;
        import flash.ui.Mouse;
        import flash.ui.MouseCursor;
    }
    COMPILE::JS
    {
        import org.apache.flex.core.WrappedHTMLElement;
    }

    /**
     *  The Label class implements the basic control for labeling
     *  other controls.
     *
     *  @toplevel
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
    public class Cursors
	{
        public static const AUTO:String = "auto";
        
        COMPILE::SWF
        public static const DEFAULT:String = "arrow";
        COMPILE::JS
        public static const DEFAULT:String = "default";
        
        COMPILE::SWF
        public static const POINTER:String = "button";
        COMPILE::JS
        public static const POINTER:String = "pointer";
        
        COMPILE::SWF
        public static const MOVE:String = "hand";
        COMPILE::JS
        public static const MOVE:String = "move";
        
        COMPILE::SWF
        public static const TEXT:String = "ibeam";
        COMPILE::JS
        public static const TEXT:String = "text";
        
        /**
         *  Constructor.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function Cursors()
		{
			super();
		}

        /**
         *  The name of the cursor
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public static function getCursor(obj:IUIBase):String
		{
            COMPILE::SWF
            {
                var cursorData:CursorData =  obj.getBeadByType(CursorData) as CursorData;
                if (cursorData)
                    return cursorData.cursor;
                return Mouse.cursor;
            }
            COMPILE::JS
            {
                return obj.element.style.cursor;
            }
		}

        /**
         *  @private
         */
		public static function setCursor(obj:IUIBase, cursor:String):void
		{
            COMPILE::SWF
            {
                var cursorData:CursorData =  obj.getBeadByType(CursorData) as CursorData;
                if (!cursorData)
                {
                    cursorData = new CursorData();
                    obj.addBead(cursorData);
                    obj.addEventListener(MouseEvent.MOUSE_OVER, overHandler);
                    obj.addEventListener(MouseEvent.MOUSE_OUT, outHandler);
                }
                cursorData.cursor = cursor;
                
                var displayObject:DisplayObject = obj as DisplayObject;
                var pt:Point = new Point(displayObject.mouseX, displayObject.mouseY);
                pt = displayObject.localToGlobal(pt);
                
                var o:Array = displayObject.stage.getObjectsUnderPoint(pt);
                for each (var s:DisplayObject in o) 
                {
                    var iui:IUIBase = s as IUIBase;
                    if (!iui)
                        iui = s.parent as IUIBase;
                    if (!iui && s.parent)
                        iui = s.parent.parent as IUIBase;
                    if (iui)
                    {
                        var actualCursor:String = getCursor(iui);
                        if (actualCursor)
                        {
                            Mouse.cursor = actualCursor;
                            return;
                        }
                    }
                }
            }
            COMPILE::JS
            {
                obj.element.style.cursor = cursor;
            }

		}


        /**
         *  @private
         */
        COMPILE::SWF
        public static function overHandler(event:MouseEvent):void
        {
            var o:Array = event.target.stage.getObjectsUnderPoint(new Point(event.stageX, event.stageY));
            for each (var s:DisplayObject in o) 
            {
                var iui:IUIBase = s as IUIBase;
                if (!iui)
                    iui = s.parent as IUIBase;
                if (!iui && s.parent)
                    iui = s.parent.parent as IUIBase;
                if (iui)
                if (iui)
                {
                    var cursor:String = getCursor(iui);
                    if (cursor)
                    {
                        Mouse.cursor = cursor;
                        return;
                    }
                }
            }
        }

        /**
         *  @private
         */
        COMPILE::SWF
        public static function outHandler(event:MouseEvent):void
        {
            if (event.relatedObject)
            {
                var o:Array = event.relatedObject.stage.getObjectsUnderPoint(new Point(event.stageX, event.stageY));
                for each (var s:DisplayObject in o) 
                {
                    var iui:IUIBase = s as IUIBase;
                    if (!iui)
                        iui = s.parent as IUIBase;
                    if (!iui && s.parent)
                        iui = s.parent.parent as IUIBase;
                    if (iui)
                    {
                        var cursor:String = getCursor(iui);
                        if (cursor)
                        {
                            Mouse.cursor = cursor;
                            return;
                        }
                    }
                }
            }
            Mouse.cursor = MouseCursor.AUTO;
        }
        
	}
}

import org.apache.flex.core.IBead;
import org.apache.flex.core.IStrand;

class CursorData implements IBead
{
    public var cursor:String;

    public function set strand(value:IStrand):void
    {
        
    }
}