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

package spark.components.supportClasses
{
/* import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;

import mx.core.InteractionMode;
import mx.core.mx_internal;
import mx.events.FlexEvent;
import spark.components.IItemRenderer;

import spark.components.ResizeMode;

use namespace mx_internal;  */

import org.apache.royale.core.IItemRenderer;
import spark.components.DataRenderer;
/**
 *  The ItemRenderer class is the base class for Spark item renderers.
 *
 *  <p>Item renderers support optional view states. 
 *  You typically use view states in MXML item renderers to control 
 *  the appearance of a data item based on user interaction with the item. 
 *  The ItemRenderer class supports all views states so that you can use 
 *  those item renderers with list-based classes.</p>
 *
 *  <p>Flex defines the following view states that you can support 
 *  in your item renderers: </p>
 *  <ul>
 *    <li>normal - The data item has no user interaction.</li>
 *    <li>hovered - The mouse is over the data item.</li>
 *    <li>selected - The data item is selected.</li>
 *    <li>dragging - The data item is being dragged.</li>
 *    <li>normalAndShowCaret - The data item is in the normal state, 
 *      and it has focus in the item list. </li>
 *    <li>hoveredAndShowCaret - The data item is in the hovered state, 
 *      and it has focus in the item list.</li>
 *    <li>selectedAndShowCaret - The data item is in the normal state, 
 *      and it has focus in the item list.</li>
 *  </ul>
 *
 *  <p>When the user interacts with a control in a way that changes 
 *  the view state of the item renderer, Flex first determines if the 
 *  renderer defines that view state. 
 *  If the item renderer supports the view state, Flex sets the item renderer 
 *  to use that view state. 
 *  If the item renderer does not supports the view state, Flex does nothing.</p>
 * 
 *  @mxml
 *
 *  <p>The <code>&lt;s:ItemRenderer&gt;</code> tag inherits all of the tag 
 *  attributes of its superclass and adds the following tag attributes:</p>
 *
 *  <pre>
 *  &lt;s:ItemRenderer
 *    <strong>Properties</strong>
 *    autoDrawBackground="true"
 *    selected="false"
 *    showsCaret="false"
 *  /&gt;
 *  </pre>
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */
public class ItemRenderer extends DataRenderer implements IItemRenderer
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    
    /**
     *  Constructor.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    public function ItemRenderer()
    {
        super();
        
        // Initially state is dirty
      /*   rendererStateIsDirty = true;
        
        interactionStateDetector = new InteractionStateDetector(this);
        interactionStateDetector.addEventListener(Event.CHANGE, interactionStateDetector_changeHandler); */
    }
    
    //--------------------------------------------------------------------------
    //
    //  Private Properties
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     *  Helper class to help determine when we are in the hovered or down states
     */
   // private var interactionStateDetector:InteractionStateDetector;
    
    /**
     *  @private
     *  Whether the renderer's state is invalid or not.
     */
   // private var rendererStateIsDirty:Boolean = false;
    
    /**
     *  @private
     *  A flag associated with rendererStateIsDirty, determining if 
     *  this renderer should play any associated transitions 
     *  in the next validation pass.  This is different from the mx_internal
     *  playTransitions flag, which is set externally by List and DataGroup. 
     */
   // private var playTransitionsOnNextRendererState:Boolean = false;
    
    /**
     *  @private
     *  A flag determining if this renderer should play any 
     *  associated transitions when a state change occurs. 
     */
  //  mx_internal var playTransitions:Boolean = true; 
    
    //--------------------------------------------------------------------------
    //
    //  Public Properties 
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  autoDrawBackground
    //----------------------------------
    
    /**
     *  @private
     *  storage for the autoDrawBackground property 
     */ 
    private var _autoDrawBackground:Boolean = true;
    
    /**
     *  Specifies whether the item renderer draws the 
     *  background of the data item during user interaction.
     *  Interactions include moving the mouse over the item, 
     *  selecting the item, and moving the caret of the item.
     * 
     *  <p>If <code>true</code>, the background for 
     *  the item renderer is automatically drawn, and it 
     *  depends on the styles that are set (<code>contentBackgroundColor</code>, 
     *  <code>alternatingItemColor</code>, <code>rollOverColor</code>, 
     *  <code>downColor</code>, <code>selectionColor</code>) 
     *  and the state that the item renderer is in.</p>
     *
     *  <p>If <code>false</code>, the item render draws no backgrounds.
     *  Your custom item renderer is responsible for displaying the 
     *  background colors for all user interactions.</p>
     * 
     *  @default true
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    public function get autoDrawBackground():Boolean
    {
        return _autoDrawBackground;
    }
    
    /**
     *  @private
     */
    public function set autoDrawBackground(value:Boolean):void
    {
        //if (_autoDrawBackground == value)
            //return;
        //
        //_autoDrawBackground = value;
        //
        //if (_autoDrawBackground)
        //{
            //redrawRequested = true;
            //super.$invalidateDisplayList();
        //}
    }
    
    //----------------------------------
    //  down
    //----------------------------------
    /**
     *  @private
     *  storage for the down property 
     */    
    private var _down:Boolean = false;
    
    /**
     *  Set to <code>true</code> when the user is pressing down on an item renderer.
     *
     *  @default false
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */    
    public function get down():Boolean
    {
        return _down;
    }
    
    /**
     *  @private
     */    
    public function set down(value:Boolean):void
    {
        if (value != _down)
        {
            _down = value;
            /*
            invalidateRendererState();
            if (autoDrawBackground)
            {
                redrawRequested = true;
                super.$invalidateDisplayList();
            }
            */
        }
    }
    
    //----------------------------------
    //  hovered
    //----------------------------------
    /**
     *  @private
     *  storage for the hovered property 
     */    
    private var _hovered:Boolean = false;
    
    /**
     *  Set to <code>true</code> when the user is hovered over the item renderer.
     *
     *  @default false
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */    
    public function get hovered():Boolean
    {
        return _hovered;
    }
    
    /**
     *  @private
     */    
    public function set hovered(value:Boolean):void
    {
        if (value != _hovered)
        {
            _hovered = value;
            /*
            invalidateRendererState();
            if (autoDrawBackground)
            {
                redrawRequested = true;
                super.$invalidateDisplayList();
            }
            */
        }
    }
    
    //----------------------------------
    //  hoverable
    //----------------------------------
    /**
     *  @private
     *  storage for the hovered property 
     */    
    private var _hoverable:Boolean = false;
    
    /**
     *  Set to <code>true</code> when the user is hovered over the item renderer.
     *
     *  @default false
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */    
    public function get hoverable():Boolean
    {
        return _hoverable;
    }
    
    /**
     *  @private
     */    
    public function set hoverable(value:Boolean):void
    {
        if (value != _hoverable)
        {
            _hoverable = value;
            /*
            invalidateRendererState();
            if (autoDrawBackground)
            {
            redrawRequested = true;
            super.$invalidateDisplayList();
            }
            */
        }
    }
    
    //----------------------------------
    //  itemIndex
    //----------------------------------
    
    /**
     *  @private
     *  storage for the itemIndex property 
     */    
    private var _itemIndex:int;
    
  /*@todo review this:  [Bindable("itemIndexChanged")] */
    
    /**
     *  @inheritDoc 
     *
     *  @default 0
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */    
    public function get itemIndex():int
    {
        return _itemIndex;
    }
    
    /**
     *  @private
     */    
    public function set itemIndex(value:int):void
    {
        if (value == _itemIndex)
            return;
        
        _itemIndex = value;
   //@todo does this need to dispatch  "itemIndexChanged" to support Bindable ?
        //if (autoDrawBackground)
        //{
            //redrawRequested = true;
            //super.$invalidateDisplayList();
        //}
        //
        //dispatchEvent(new Event("itemIndexChanged"));
    }
    
    //----------------------------------
    //  index
    //----------------------------------
    
    /**
     *  @private
     *  storage for the index property 
    private var _index:int;
     */    
    
    //[Bindable("itemIndexChanged")]
    
    /**
     *  @inheritDoc 
     *
     *  @default 0
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
    public function get index():int
    {
        return _index;
    }
     */    
    
    /**
     *  @private
    public function set index(value:int):void
    {
        if (value == _index)
        return;
        
        _index = value;

        if (autoDrawBackground)
        {
            redrawRequested = true;
            super.$invalidateDisplayList();
        }
        
        dispatchEvent(new Event("itemIndexChanged"));
    }
        */
    
    //----------------------------------
    //  labelDisplay
    //----------------------------------
    
    /**
     *  Optional item renderer label component. 
     *  This component is used to determine the value of the 
     *  <code>baselinePosition</code> property in the host component of 
     *  the item renderer. 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    /* [Bindable]     
    public var labelDisplay:TextBase; */
    
    //----------------------------------
    //  showsCaret
    //----------------------------------

    /**
     *  @private
     *  Storage for the showsCaret property 
     */
    //private var _showsCaret:Boolean = false;

    /**
     *  @inheritDoc 
     *
     *  @default false  
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */    
    /* public function get showsCaret():Boolean
    {
        return _showsCaret;
    } */
    
    /**
     *  @private
     */    
    /* public function set showsCaret(value:Boolean):void
    {
        if (value == _showsCaret)
            return;

        _showsCaret = value;
        invalidateRendererState();
        if (autoDrawBackground)
        {
            redrawRequested = true;
            super.$invalidateDisplayList();
        }
    } */
    
    //----------------------------------
    //  selected
    //----------------------------------
    /**
     *  @private
     *  storage for the selected property 
     */    
    private var _selected:Boolean = false;
    
    /**
     *  @inheritDoc 
     *
     *  @default false
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */    
    public function get selected():Boolean
    {
        return _selected;
    }
    
    /**
     *  @private
     */    
    public function set selected(value:Boolean):void
    {
        if (value != _selected)
        {
            _selected = value;
            /*
            invalidateRendererState();
            if (autoDrawBackground)
            {
                redrawRequested = true;
                super.$invalidateDisplayList();
            }
            */
        }
    }
    
    //----------------------------------
    //  selected
    //----------------------------------
    /**
     *  @private
     *  storage for the selected property 
     */    
    private var _selectable:Boolean = false;
    
    /**
     *  @inheritDoc 
     *
     *  @default false
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */    
    public function get selectable():Boolean
    {
        return _selectable;
    }
    
    /**
     *  @private
     */    
    public function set selectable(value:Boolean):void
    {
        if (value != _selectable)
        {
            _selectable = value;
            /*
            invalidateRendererState();
            if (autoDrawBackground)
            {
            redrawRequested = true;
            super.$invalidateDisplayList();
            }
            */
        }
    }

    //----------------------------------
    //  dragging
    //----------------------------------
    
    /**
     *  @private
     *  Storage for the dragging property. 
     */
    private var _dragging:Boolean = false;

    /**
     *  @inheritDoc  
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    // not implemented
    public function get dragging():Boolean
    {
        return _dragging;
    }

    /**
     *  @private  
     */
    // not implemented
    public function set dragging(value:Boolean):void
    {
        if (value != _dragging)
        {
            _dragging = value;
            //invalidateRendererState();
        }
    }
    
    // not implemented
    public function get label():String {return "label"} 

    // not implemented
    public function set label(value:String):void {}

    //----------------------------------
    //  label
    //----------------------------------
    
    /**
     *  @private 
     *  Storage var for label
     */ 
   /*  private var _label:String = "";
    
    [Bindable("labelChanged")] */
    
    /**
     *  @inheritDoc 
     *
     *  @default ""    
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    /* public function get label():String
    {
        return _label;
    } */
    
    /**
     *  @private
     */ 
    /* public function set label(value:String):void
    {
        if (value == _label)
            return;
        
        _label = value;
            
        // Push the label down into the labelDisplay,
        // if it exists
        if (labelDisplay)
            labelDisplay.text = _label;
        
        dispatchEvent(new Event("labelChanged"));
    } */
    
    //--------------------------------------------------------------------------
    //
    //  Overridden Properties - UIComponent 
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  baselinePosition
    //----------------------------------

    /**
     *  @private
     */
    /* override public function get baselinePosition():Number
    {
        if (!validateBaselinePosition() || !labelDisplay)
            return super.baselinePosition;

        var labelPosition:Point = globalToLocal(labelDisplay.parent.localToGlobal(
            new Point(labelDisplay.x, labelDisplay.y)));
            
        return labelPosition.y + labelDisplay.baselinePosition;
    } */
    
    //--------------------------------------------------------------------------
    //
    //  Methods - ItemRenderer State Support 
    //
    //--------------------------------------------------------------------------

    /**
     *  Returns the name of the state to be applied to the renderer. For example, a
     *  very basic List item renderer would return the String "normal", "hovered", 
     *  or "selected" to specify the renderer's state.
     *  If dealing with touch interactions (or mouse interactions where selection
     *  is ignored), "down" and "downAndSelected" are also important states.
     * 
     *  <p>A subclass of ItemRenderer must override this method to return a value 
     *  if the behavior desired differs from the default behavior.</p>
     * 
     *  <p>In Royale 0.9.4, the 3 main states were "normal", "hovered", and "selected".
     *  In Royale 0.9.4, "down" and "downAndSelected" have been added.</p>
     * 
     *  <p>The full set of states supported (in order of precedence) are: 
     *    <ul>
     *      <li>dragging</li>
     *      <li>downAndSelected</li>
     *      <li>selectedAndShowsCaret</li>
     *      <li>hoveredAndShowsCaret</li>
     *      <li>normalAndShowsCaret</li>
     *      <li>down</li>
     *      <li>selected</li>
     *      <li>hovered</li>
     *      <li>normal</li>
     *    </ul>
     *  </p>
     * 
     *  @return A String specifying the name of the state to apply to the renderer. 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    protected function getCurrentRendererState():String // not implemented
    {
        // this code is pretty confusing without multi-dimensional states, but it's
        // defined in order of precedence.
        
        //if (dragging && hasState("dragging"))
            //return "dragging";
        //
        //if (selected && down && hasState("downAndSelected"))
            //return "downAndSelected";
        //
        //if (selected && showsCaret && hasState("selectedAndShowsCaret"))
            //return "selectedAndShowsCaret";
        //
        //if (hovered && showsCaret && hasState("hoveredAndShowsCaret"))
            //return "hoveredAndShowsCaret";
        //
        //if (showsCaret && hasState("normalAndShowsCaret"))
            //return "normalAndShowsCaret"; 
          //
        //if (down && hasState("down"))
            //return "down";
        //
        //if (selected && hasState("selected"))
            //return "selected";
        //
        //if (hovered && hasState("hovered"))
            //return "hovered";
        //
        //if (hasState("normal"))    
            //return "normal";
        
        // If none of the above states are defined in the item renderer,
        // we return currentState, so we don't change the state just 
        // in case the developer put the item renderer into its 
        // own custom state.
        return currentState;
    }
    
    /**
     *  Marks the renderer's state as invalid so that the new state is set
     *  during a later screen update.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.1
     *  @playerversion AIR 2.5
     *  @productversion Royale 0.9.4
     */
    /* protected function invalidateRendererState():void
    {
        playTransitionsOnNextRendererState = (playTransitionsOnNextRendererState || playTransitions);
        
        if (rendererStateIsDirty)
            return; // State is already invalidated
        
        rendererStateIsDirty = true;
        invalidateProperties();
    } */
    
    //--------------------------------------------------------------------------
    //
    //  Overridden Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     */ 
    /* override protected function commitProperties():void
    {
        // need to run this code before calling super.commitProperites
        // because the super.commitProperties can handle state change on 
        // rare occassion (during initialization)
        if (rendererStateIsDirty)
        {
            setCurrentState(getCurrentRendererState(), playTransitionsOnNextRendererState); 
            playTransitionsOnNextRendererState = false;
            rendererStateIsDirty = false;
        }
        
        super.commitProperties();
    } */
    
    /**
     *  @private
     */ 
    /* override public function styleChanged(styleName:String):void
    {
        var allStyles:Boolean = styleName == null || styleName == "styleName";
        
        super.styleChanged(styleName);
        
        if (autoDrawBackground && (allStyles || styleName == "alternatingItemColors" || 
            styleName == "contentBackgroundColor" || styleName == "rollOverColor" || 
            styleName == "downColor" || styleName == "selectionColor"))
        {
            redrawRequested = true;
            super.$invalidateDisplayList();
        }
    } */
    
    /**
     *  @private
     */
    /* override mx_internal function drawBackground():void
    {
        // if autoDrawBackground is set to true, we always 
        // draw a background and don't need to worry about mouseEnabledWhereTransparent.
        // However, if it's false, then we should just let super.drawBackground()
        // do its job.
        if (!autoDrawBackground)
        {
            super.drawBackground();
            return;
        }
        
        // TODO (rfrishbe): Would be good to remove this duplicate code with the 
        // super.drawBackground() version
        var w:Number = (resizeMode == ResizeMode.SCALE) ? measuredWidth : unscaledWidth;
        var h:Number = (resizeMode == ResizeMode.SCALE) ? measuredHeight : unscaledHeight;
        
        if (isNaN(w) || isNaN(h))
            return;
        
        graphics.clear();
        
        var backgroundColor:uint;
        var drawBackground:Boolean = true;
        var downColor:* = getStyle("downColor");
        
        if (down && downColor !== undefined)
            backgroundColor = downColor;
        else if (selected)
            backgroundColor = getStyle("selectionColor");
        else if (hovered)
            backgroundColor = getStyle("rollOverColor");
        else
        {
            var alternatingColors:Array;
            var alternatingColorsStyle:Object = getStyle("alternatingItemColors");
            
            if (alternatingColorsStyle)
                alternatingColors = (alternatingColorsStyle is Array) ? (alternatingColorsStyle as Array) : [alternatingColorsStyle];
           
            if (alternatingColors && alternatingColors.length > 0)
            {
                // translate these colors into uints
                styleManager.getColorNames(alternatingColors);
                
                backgroundColor = alternatingColors[itemIndex % alternatingColors.length];
            }            
            else
            {
                // don't draw background if it is the contentBackgroundColor. The
                // list skin handles the background drawing for us.
                drawBackground = false;
            }
        }
        
        graphics.beginFill(backgroundColor, drawBackground ? 1 : 0);
        
        if (showsCaret)
        {
            graphics.lineStyle(1, getStyle("selectionColor"));
            graphics.drawRect(0.5, 0.5, w-1, h-1);
        }
        else 
        {
            graphics.lineStyle();
            graphics.drawRect(0, 0, w, h);
        }
            
        graphics.endFill();
    } */
    
    //--------------------------------------------------------------------------
    //
    //  Event handling
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     */
    /* private function interactionStateDetector_changeHandler(event:Event):void
    {
        playTransitions = interactionStateDetector.playTransitions;
        down = (interactionStateDetector.state == InteractionState.DOWN);
        hovered = (interactionStateDetector.state == InteractionState.OVER);
        playTransitions = true;
    } */

}
}
