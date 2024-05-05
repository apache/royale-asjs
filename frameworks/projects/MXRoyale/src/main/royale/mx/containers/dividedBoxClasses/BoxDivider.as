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

package mx.containers.dividedBoxClasses
{

/*import flash.display.DisplayObject;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;*/

import mx.containers.DividedBox;
import mx.core.IUIComponent;

//import mx.containers.DividerState;
//import mx.core.ILayoutDirectionElement;
import mx.core.UIComponent;
import mx.core.mx_internal;
import mx.events.SandboxMouseEvent;

import mx.events.MouseEvent;
import org.apache.royale.events.Event;

use namespace mx_internal;

//--------------------------------------
//  Styles
//--------------------------------------

//include "../../styles/metadata/GapStyles.as"

/**
 *  @copy mx.containers.DividedBox#style:dividerAffordance
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Style(name="dividerAffordance", type="Number", format="Length", inherit="no")]

/**
 *  @copy mx.containers.DividedBox#style:dividerAlpha 
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Style(name="dividerAlpha", type="Number", inherit="no")]

/**
 *  @copy mx.containers.DividedBox#style:dividerColor
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Style(name="dividerColor", type="uint", format="Color", inherit="yes")]

/**
 *  @copy mx.containers.DividedBox#style:dividerThickness
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Style(name="dividerThickness", type="Number", format="Length", inherit="no")]

//--------------------------------------
//  Other metadata
//--------------------------------------

/**
 *  The BoxDivider class represents the divider between children of a DividedBox container.
 *
 *  @see mx.containers.DividedBox
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class BoxDivider extends UIComponent
{
   // include "../../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function BoxDivider()
    {
        super();
        typeNames = 'BoxDivider';
        // Register for player events.
        addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
        addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
        addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
    }


    override public function set owner(value:IUIComponent):void
    {
        super.owner = value;

        var vert:Boolean = DividedBox(owner).isVertical();
        COMPILE::JS {
            if (vert) {
                this.element.classList.remove('horizontal');
                this.element.classList.add('vertical');
            } else {
                this.element.classList.remove('vertical');
                this.element.classList.add('horizontal');
            }
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    private var knob:/*DisplayObject*/IUIComponent;
    
    /**
     *  @private
     */
    private var isMouseOver:Boolean = false;

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    override public function set x(value:Number):void
    {
        var oldValue:Number = x;
        super.x = value;
        
        if (!DividedBox(owner).isVertical())
        {
            DividedBox(owner).moveDivider(
                DividedBox(owner).getDividerIndex(this), value - oldValue);
        }
    }

    /**
     *  @private
     */
    override public function set y(value:Number):void
    {
        var oldValue:Number = y;
        super.y = value;
        
        if (DividedBox(owner).isVertical())
        {
            DividedBox(owner).moveDivider(
                DividedBox(owner).getDividerIndex(this), value - oldValue);
        }
    }

    //----------------------------------
    //  state
    //----------------------------------

    /**
     *  @private
     *  Storage for the state property.
     */
    private var _state:String = 'up';//DividerState.UP;

    /**
     *  @private
     */
    mx_internal function get state():String
    {
        return _state;
    }

    /**
     *  @private
     */
    mx_internal function set state(value:String):void
    {
        if (value != _state) {
            COMPILE::JS{
                this.element.classList.remove(_state);
            }
            _state = value;
            COMPILE::JS{
                this.element.classList.add(value);
            }
        }

        invalidateDisplayList();
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden methods
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    override protected function updateDisplayList(unscaledWidth:Number,
                                                  unscaledHeight:Number):void
    {
        // The mouse-over thickness of the divider is normally determined
        // by the dividerAffordance style, and the visible thickness is
        // normally determined by the dividerThickness style, assuming that
        // the relationship thickness <= affordance <= gap applies. But if
        // one of the other five orderings applies, here is a table of what
        // happens:
        //
        //  divider    divider    horizontalGap/  dividerWidth/  visible width/
        // Thickness  Affordance  verticalGap     dividerHeight  visible height
        //
        //    4           6             8               6              4
        //    4           8             6               6              4
        //    6           4             8               6              6
        //    6           8             4               4              4
        //    8           4             6               6              6
        //    8           6             4               4              4

        if (!(width) || !(height))
            return;

        if (!parent)
            return;
        var color:Number;
        var alpha:Number = 1.0;

        var thickness:Number = getStyle("dividerThickness");
        var gap:Number = DividedBox(owner).isVertical() ?
                DividedBox(owner).getStyle("verticalGap") :
                DividedBox(owner).getStyle("horizontalGap");


        color = getStyle("dividerColor");
        alpha = getStyle("dividerAlpha");
        COMPILE::JS {

        }


        /*if (isNaN(width) || isNaN(height))
            return;

        if (!parent)
            return;

        super.updateDisplayList(unscaledWidth, unscaledHeight);

        graphics.clear();

        graphics.beginFill(0x000000, 0);
        graphics.drawRect(0, 0, width, height);
        graphics.endFill();

        var color:Number;
        var alpha:Number = 1.0;

        var thickness:Number = getStyle("dividerThickness");

        var gap:Number = DividedBox(owner).isVertical() ?
                         DividedBox(owner).getStyle("verticalGap") :
                         DividedBox(owner).getStyle("horizontalGap");

        if (state != DividerState.DOWN)
        {
            // Draw knob, if there is enough room
            if (gap >= 6)
            {
                if (!knob)
                {
                    var knobClass:Class = Class(getStyle("dividerSkin"));
                    if (knobClass)
                        knob = new knobClass();
                    if (knob)
                    {
                        if (knob is ILayoutDirectionElement)
                            ILayoutDirectionElement(knob).layoutDirection = null;
                        addChild(knob);
                    }
                }

                if (knob)
                {
                    if (DividedBox(owner).isVertical())
                    {
                        knob.scaleX = 1.0;
                        knob.rotation = 0;
                    }
                    else
                    {
                        // Rotate the knob
                        knob.scaleX = -1.0;
                        knob.rotation = -90;
                    }

                    knob.x = Math.round((width - knob.width) / 2);
                    knob.y = Math.round((height - knob.height) / 2);
                }
            }
            return;
        }

        color = getStyle("dividerColor");
        alpha = getStyle("dividerAlpha");
        graphics.beginFill(color, alpha);

        if (DividedBox(owner).isVertical())
        {
            var visibleHeight:Number = thickness;

            if (visibleHeight > gap)
                visibleHeight = gap;

            var y:Number = (height - visibleHeight) / 2;
            graphics.drawRect(0, y, width, visibleHeight);
        }
        else
        {
            var visibleWidth:Number = thickness;

            if (visibleWidth > gap)
                visibleWidth = gap;

            var x:Number = (width - visibleWidth) / 2;
            graphics.drawRect(x, 0, visibleWidth, height);
        }

        graphics.endFill();*/
    }

    /**
     *  @private
     */
    /*override public function styleChanged(styleProp:String):void
    {
        super.styleChanged(styleProp);

        if (!styleProp ||
            styleProp == "dividerSkin" ||
            styleProp == "styleName")
        {
            if (knob)
            {
                removeChild(knob);
                knob = null;
            }
        }
    }*/

    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    private function mouseOverHandler(event:MouseEvent):void
    {
        if (event.buttonDown)
            return;
            
        isMouseOver = true;
        if (!DividedBox(owner).activeDivider)
        {
            state = 'over'/*DividerState.OVER*/;
            DividedBox(owner).changeCursor(this);
        }
    }

    /**
     *  @private
     */
    private function mouseOutHandler(event:MouseEvent):void
    {
        isMouseOver = false;
        if (!DividedBox(owner).activeDivider)
        {
            state = 'up';//DividerState.UP;
            if (parent)
                DividedBox(owner).restoreCursor();
        }
    }

    /**
     *  @private
     */
    private function mouseDownHandler(event:MouseEvent):void
    {
        // Don't set down state here. If we're doing a live drag we don't
        // want to show the proxy. If we're not doing a live drag, our
        // parent will create a drag proxy and set the state to DividerState.DOWN.
        // state = DividerState.DOWN;
        DividedBox(owner).changeCursor(this);
        DividedBox(owner).startDividerDrag(this, event);
        
     //   var sbRoot:DisplayObject = systemManager.getSandboxRoot();
     //   sbRoot.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler, true);
     //  sbRoot.addEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE, mouseUpHandler);
       /* this.topMostEventDispatcher*/ systemManager.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler, true);
    }

    /**
     *  @private
     * 
     *  @param event MouseEvent or SandboxMouseEvent.
     */
    private function mouseUpHandler(event:Event):void
    {
        // If a mouseOut was the last mouse event that occurred
        // make sure to restore the system cursor.
        if (!isMouseOver)
            DividedBox(owner).restoreCursor();

        state = 'over';//DividerState.OVER;
        DividedBox(owner).stopDividerDrag(this, event as MouseEvent);

     //   var sbRoot:DisplayObject = systemManager.getSandboxRoot();
    //    sbRoot.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler, true);
     //   sbRoot.removeEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE, mouseUpHandler);

        /*this.topMostEventDispatcher*/ systemManager.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler, true);
    }
}

}
