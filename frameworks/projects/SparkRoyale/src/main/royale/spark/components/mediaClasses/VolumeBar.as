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

package spark.components.mediaClasses
{


import org.apache.royale.html.Slider;
//import flash.display.DisplayObject;
//import org.apache.royale.events.Event;
//import org.apache.royale.events.FocusEvent;
//import org.apache.royale.events.KeyboardEvent;
//import org.apache.royale.events.MouseEvent;
//import org.apache.royale.geom.Point;
//import flash.ui.Keyboard;
//import flash.ui.Mouse;
//
//import mx.collections.IList;
//import mx.core.IUIComponent;
import mx.core.UIComponent;
//import mx.core.mx_internal;
//import mx.events.CollectionEvent;
//import mx.events.FlexEvent;
//import mx.managers.LayoutManager;
//
//import spark.components.VSlider;
//import spark.components.supportClasses.ButtonBase;
//import spark.components.supportClasses.DropDownController;
//import spark.components.supportClasses.ListBase;
//import spark.events.DropDownEvent;
//import spark.utils.LabelUtil;

use namespace mx_internal;

//--------------------------------------
//  Events
//--------------------------------------

/**
 *  Dispatched when the volume drop-down slider is dismissed for any reason, 
 *  such as when the user:
 *  <ul>
 *      <li>Selects an item in the drop-down slider</li>
 *      <li>Clicks outside of the drop-down slider</li>
 *  </ul>
 *
 *  @eventType spark.events.DropDownEvent.CLOSE
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
[Event(name="close", type="spark.events.DropDownEvent")]

/**
 *  Dispatched when the user mouses over the drop-down slider 
 *  to display it. It is also dispatched if the user
 *  uses the keyboard and types Ctrl-Down to open the drop-down slider.
 *
 *  @eventType spark.events.DropDownEvent.OPEN
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
[Event(name="open", type="spark.events.DropDownEvent")]

/**
 *  Dispatched when the user mutes or unmutes the volume.
 *
 *  @eventType mx.events.FlexEvent.MUTED_CHANGE
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
[Event(name="mutedChange", type="mx.events.FlexEvent")]

//--------------------------------------
//  Styles
//--------------------------------------
    
/**
 *  The delay, in milliseconds, before opening the volume slider 
 *  after the user moves the mouse over the volume icon in 
 *  the VideoDisplay control.
 *  
 *  @default 200
 * 
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
[Style(name="rollOverOpenDelay", type="Number", inherit="no")]

//--------------------------------------
//  SkinStates
//--------------------------------------

/**
 *  Open state of the drop-down slider.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
[SkinState("open")]

/**
 *  The VolumeBar class defines a drop-down slider to control 
 *  the volume of the VideoDisplay control.  
 *  By default, the drop-down slider opens when the user moves the mouse
 *  over the volume icon of the VideoDisplay control. 
 *  The <code>rollOverOpenDelay</code> style defines a delay of 200 milliseconds 
 *  before opening the drop-down slider.  
 *
 *  @see spark.components.VideoDisplay
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
public class VolumeBar extends Slider
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
     *  @productversion Flex 4
     */
    public function VolumeBar()
    {
        super();
        
        //dropDownController = new DropDownController();
        
        // add change listener so we know when the user has interacted 
        // with the volume bar to change the value so we can automatically 
        // unmute the volume when the user does that.
        //addEventListener(Event.CHANGE, changeHandler);
    }
    
    //--------------------------------------------------------------------------
    //
    //  Skin Parts
    //
    //--------------------------------------------------------------------------    
    
    /**
     *  A skin part that defines the mute/unmute button.  
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    [SkinPart(required="false")]
    //public var muteButton:MuteButton;
    public var muteButton:UIComponent;
    
    
    /**
     *  A skin part that defines the drop-down area of the volume drop-down slider. 
     *  When the volume slider drop down is open, 
     *  clicking anywhere outside of the <code>dropDown</code> skin part
     *  closes the drop-down slider. 
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    [SkinPart(required="false")]
    public var dropDown:DisplayObject;
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  dropDownController
    //----------------------------------
    
    //private var _dropDownController:DropDownController;    
    
    /**
     *  Instance of the DropDownController class that handles all of the mouse, keyboard 
     *  and focus user interactions.  
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    //protected function get dropDownController():DropDownController
    //{
        //return _dropDownController;
    //}
    
    /**
     *  @private
     */
    //protected function set dropDownController(value:DropDownController):void
    //{
        //if (_dropDownController == value)
            //return;
            //
        //_dropDownController = value;
            //
        //_dropDownController.addEventListener(DropDownEvent.OPEN, dropDownController_openHandler);
        //_dropDownController.addEventListener(DropDownEvent.CLOSE, dropDownController_closeHandler);
            //
        //_dropDownController.rollOverOpenDelay = getStyle("rollOverOpenDelay");
            //
        //if (muteButton)
            //_dropDownController.openButton = muteButton;
        //if (dropDown)
            //_dropDownController.dropDown = dropDown;    
    //}
    
    //----------------------------------
    //  isDropDownOpen
    //----------------------------------
    
    /**
     *  @copy spark.components.supportClasses.DropDownController#isOpen
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get isDropDownOpen():Boolean
    {
        //if (dropDownController)
            //return dropDownController.isOpen;
        //else
            //return false;
	return false;
    }
    
    //----------------------------------
    //  muted
    //----------------------------------
    
    /**
     *  @private
     */
    private var _muted:Boolean = false;
    
    [Bindable("mutedChange")]
    
    /**
     *  Contains <code>true</code> if the volume of the video is muted, 
     *  and <code>false</code> if not.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get muted():Boolean
    {
        //return _muted;
	return false;
    }
    
    /**
     *  @private
     */
    public function set muted(value:Boolean):void
    {
        //if (_muted == value)
            //return;
        //
        //_muted = value;
        //
        //// invalidateDisplayList() because we take in to account value and muted when 
        //// determining where to draw the thumb on the track.
        //invalidateDisplayList();
        //
        //if (muteButton)
            //muteButton.muted = value;
        //
        //dispatchEvent(new FlexEvent(FlexEvent.MUTED_CHANGE));
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  baselinePosition
    //----------------------------------
    
    /**
     *  @private
     */
    //override public function get baselinePosition():Number
    public function get baselinePosition():Number
    {
        //return getBaselinePositionForPart(muteButton);
        return NaN;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Overridden Methods
    //
    //--------------------------------------------------------------------------   
    
    /**
     *  @private
     *  Overridden to handle the muted case where the value's not actually changed, 
     *  but we want it to show up as 0.
     */
    //override protected function updateSkinDisplayList():void
    //{
        //if (!thumb || !track)
            //return;
    //
        //var thumbRange:Number = track.getLayoutBoundsHeight() - thumb.getLayoutBoundsHeight();
        //var range:Number = maximum - minimum;
        //
        //// calculate new thumb position.
        //var thumbPosTrackY:Number;
        //
        //// if muted, it's 0.  otherwise, calculate it normally
        //// TODO (rfrishbe): should probably use setValue(0) and listen for CHANGE on the VideoPlayer 
        //// instead of VALUE_COMMIT.
        //if (!muted)
            //thumbPosTrackY = (range > 0) ? thumbRange - (((pendingValue - minimum) / range) * thumbRange) : 0;
        //else
            //thumbPosTrackY = thumbRange;
        //
        //// convert to parent's coordinates.
        //var thumbPos:Point = track.localToGlobal(new Point(0, thumbPosTrackY));
        //var thumbPosParentY:Number = thumb.parent.globalToLocal(thumbPos).y;
        //
        //thumb.setLayoutBoundsPosition(thumb.getLayoutBoundsX(), Math.round(thumbPosParentY));
    //}
    
    /**
     *  @private
     */
    //override public function styleChanged(styleProp:String):void
    public function styleChanged(styleProp:String):void
    {
        //super.styleChanged(styleProp);
        //var allStyles:Boolean = (styleProp == null || styleProp == "styleName");
         //
        //if (allStyles || styleProp == "rollOverOpenDelay")
        //{
            //if (dropDownController)
                //dropDownController.rollOverOpenDelay = getStyle("rollOverOpenDelay");
        //}
    }
     
         
    /**
     *  @private
     */
    //override protected function setValue(value:Number):void
    //{
        //super.setValue(value);
        //
        //if (muteButton)
            //muteButton.volume = value;
    //}
    
        /**
      *  @private
      */ 
    //override protected function getCurrentSkinState():String
    //{
        //return !enabled ? "disabled" : dropDownController.isOpen ? "open" : "normal";
    //}   
       
    /**
     *  @private
     */ 
    //override protected function partAdded(partName:String, instance:Object):void
    //{
        //super.partAdded(partName, instance);
 //
        //if (instance == muteButton)
        //{
            //if (dropDownController)
                //dropDownController.openButton = muteButton;
            //
            //muteButton.addEventListener(FlexEvent.MUTED_CHANGE, muteButton_mutedChangeHandler);
            //muteButton.volume = value;
            //muteButton.muted = muted;
        //}
        //else if (instance == dropDown && dropDownController)
        //{
            //dropDownController.dropDown = dropDown;
        //}
    //}
    
    /**
     *  @private
     */
    //override protected function partRemoved(partName:String, instance:Object):void
    //{
        //if (instance == muteButton)
        //{
            //muteButton.removeEventListener(FlexEvent.MUTED_CHANGE, muteButton_mutedChangeHandler);
        //}
        //else if (instance == dropDownController)
        //{
            //if (instance == muteButton)
                //dropDownController.openButton = null;
        //
            //if (instance == dropDown)
                //dropDownController.dropDown = null;
        //}
         //
        //super.partRemoved(partName, instance);
    //}
    
    /**
     *  @private
     *  On focus, pop open the drop down and validate everything so 
     *  we can draw focus on one of the drop-down parts (the thumb)
     */
    //override public function setFocus():void
    override public function setFocus():void
    {
        //openDropDown();
        //LayoutManager.getInstance().validateNow();
        //super.setFocus();
    }
    
    /**
     *  @private
     */
    //override protected function focusOutHandler(event:FocusEvent):void
    //{
        //dropDownController.processFocusOut(event);
//
        //super.focusOutHandler(event);
    //}
    
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------   

    /**
     *  Opens the drop-down slider. 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */ 
    public function openDropDown():void
    {
        //dropDownController.openDropDown();
    }
    
     /**
     *  Closes the drop-down slider. 
     * 
     *  @param commit Set to <code>true</code> if the component should commit the value
     *  from the drop-down slider. 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function closeDropDown(commit:Boolean):void
    {
        //dropDownController.closeDropDown(commit);
    }
    
    //--------------------------------------------------------------------------
    //
    //  Event handling
    //
    //--------------------------------------------------------------------------
    
    /**
     *  Event handler for the <code>dropDownController</code> 
     *  <code>DropDownEvent.OPEN</code> event. Updates the skin's state and 
     *  ensures that the selectedItem is visible. 
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    mx_internal function dropDownController_openHandler(event:DropDownEvent):void
    {
        invalidateSkinState();
        
        dispatchEvent(event);
    }
    
    /**
     *  Event handler for the <code>dropDownController</code> 
     *  <code>DropDownEvent.CLOSE</code> event. Updates the skin's state.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    //mx_internal function dropDownController_closeHandler(event:DropDownEvent):void
    //{
        //invalidateSkinState();
        //
        //// In this implementation, the volume is always changed immediately, 
        //// so no need to handle the case when 
        //// commit==false and event.preventDefault() is called on this DropDownEvent
        //
        //dispatchEvent(event);
    //}
    
    /**
     *  @private
     *  When the value is changed via a user-interaction, we will 
     *  automatically unmute the volume
     */
    //private function changeHandler(event:Event):void
    //{
        //// when the value is set, this volume bar unmutes the 
        //// video player automatically
        //if (muted)
            //muted = false;
    //}
    
    /**
     *  @private
     *  When the mute button changes the muted value, we need to change 
     *  our own.
     */
    //private function muteButton_mutedChangeHandler(event:FlexEvent):void
    //{
        //muted = muteButton.muted;
    //}

}
}
