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

package mx.events
{

//import flash.events.Event;
import org.apache.royale.events.Event;
import org.apache.royale.events.IRoyaleEvent;

COMPILE::SWF{
    import FlashEvent=flash.events.Event;
}

/**
 *  The SliderEvent class represents the event object passed to 
 *  the event listener for the <code>change</code>, <code>thumbDrag</code>, 
 *  <code>thumbPress</code>, and <code>thumbRelease</code> events 
 *  of the HSlider and VSlider classes.
 *
 *  @see mx.controls.HSlider
 *  @see mx.controls.VSlider
 *  @see mx.controls.sliderClasses.Slider
 *  @see mx.events.SliderEventClickTarget
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 * 
 *  @royalesuppresspublicvarwarning
 */
public class SliderEvent extends Event
{
    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    /**
     *  The <code>SliderEvent.CHANGE</code> constant defines the value of the 
     *  <code>type</code> property of the event object for a <code>change</code> event. 
     *
     *  <p>The properties of the event object have the following values:</p>
     *  <table class="innertable">
     *     <tr><th>Property</th><th>Value</th></tr>
     *     <tr><td><code>bubbles</code></td><td>false</td></tr>
     *     <tr><td><code>cancelable</code></td><td>false</td></tr>
     *     <tr><td><code>clickTarget</code></td><td>Specifies whether the slider 
     *       track or a slider thumb was pressed.</td></tr>
     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the 
     *       event listener that handles the event. For example, if you use 
     *       <code>myButton.addEventListener()</code> to register an event listener, 
     *       myButton is the value of the <code>currentTarget</code>. </td></tr>
     *     <tr><td><code>keyCode</code></td><td>If the event was triggered by a key press, 
     *       the keycode for the key.</td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
     *       it is not always the Object listening for the event. 
     *       Use the <code>currentTarget</code> property to always access the 
     *       Object listening for the event.</td></tr>
     *     <tr><td><code>thumbIndex</code></td><td>The zero-based index of the thumb
     *       whose position has changed.</td></tr>
     *     <tr><td><code>triggerEvent</code></td><td>Contains a value indicating the 
     *       type of input action. The value is an event object of type flash.events.MouseEvent
     *       or flash.events.KeyboardEvent.</td></tr>
     *     <tr><td><code>value</code></td><td>The new value of the slider.</td></tr>
     *  </table>
     *
     *  @eventType change
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static const CHANGE:String = "change";

    /**
     *  The <code>SliderEvent.THUMB_DRAG</code> constant defines the value of the 
     *  <code>type</code> property of the event object for a <code>thumbDrag</code> event. 
     *
     *  <p>The properties of the event object have the following values:</p>
     *  <table class="innertable">
     *     <tr><th>Property</th><th>Value</th></tr>
     *     <tr><td><code>bubbles</code></td><td>false</td></tr>
     *     <tr><td><code>cancelable</code></td><td>false</td></tr>
     *     <tr><td><code>clickTarget</code></td><td>Specifies whether the slider 
     *       track or a slider thumb was pressed.</td></tr>
     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the 
     *       event listener that handles the event. For example, if you use 
     *       <code>myButton.addEventListener()</code> to register an event listener, 
     *       myButton is the value of the <code>currentTarget</code>. </td></tr>
     *     <tr><td><code>keyCode</code></td><td>If the event was triggered by a key press, 
     *       the keycode for the key.</td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
     *       it is not always the Object listening for the event. 
     *       Use the <code>currentTarget</code> property to always access the 
     *       Object listening for the event.</td></tr>
     *     <tr><td><code>thumbIndex</code></td><td>The zero-based index of the thumb
     *       whose position has changed.</td></tr>
     *     <tr><td><code>triggerEvent</code></td><td>Contains a value indicating the 
     *       type of input action. The value is an event object of type flash.events.MouseEvent
     *       or flash.events.KeyboardEvent.</td></tr>
     *     <tr><td><code>value</code></td><td>The new value of the slider.</td></tr>
     *  </table>
     *
     *  @eventType thumbDrag
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static const THUMB_DRAG:String = "thumbDrag";

    /**
     *  The <code>SliderEvent.THUMB_PRESS</code> constant defines the value of the 
     *  <code>type</code> property of the event object for a <code>thumbPress</code> event. 
     *
     *  <p>The properties of the event object have the following values:</p>
     *  <table class="innertable">
     *     <tr><th>Property</th><th>Value</th></tr>
     *     <tr><td><code>bubbles</code></td><td>false</td></tr>
     *     <tr><td><code>cancelable</code></td><td>false</td></tr>
     *     <tr><td><code>clickTarget</code></td><td>Specifies whether the slider 
     *       track or a slider thumb was pressed.</td></tr>
     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the 
     *       event listener that handles the event. For example, if you use 
     *       <code>myButton.addEventListener()</code> to register an event listener, 
     *       myButton is the value of the <code>currentTarget</code>. </td></tr>
     *     <tr><td><code>keyCode</code></td><td>If the event was triggered by a key press, 
     *       the keycode for the key.</td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
     *       it is not always the Object listening for the event. 
     *       Use the <code>currentTarget</code> property to always access the 
     *       Object listening for the event.</td></tr>
     *     <tr><td><code>thumbIndex</code></td><td>The zero-based index of the thumb
     *       whose position has changed.</td></tr>
     *     <tr><td><code>triggerEvent</code></td><td>Contains a value indicating the 
     *       type of input action. The value is an event object of type flash.events.MouseEvent
     *       or flash.events.KeyboardEvent.</td></tr>
     *     <tr><td><code>value</code></td><td>The new value of the slider.</td></tr>
     *  </table>
     *
     *  @eventType thumbPress
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static const THUMB_PRESS:String = "thumbPress";

    /**
     *  The <code>SliderEvent.THUMB_RELEASE</code> constant defines the value of the 
     *  <code>type</code> property of the event object for a <code>thumbRelease</code> event. 
     *
     *  <p>The properties of the event object have the following values:</p>
     *  <table class="innertable">
     *     <tr><th>Property</th><th>Value</th></tr>
     *     <tr><td><code>bubbles</code></td><td>false</td></tr>
     *     <tr><td><code>cancelable</code></td><td>false</td></tr>
     *     <tr><td><code>clickTarget</code></td><td>Specifies whether the slider 
     *       track or a slider thumb was pressed.</td></tr>
     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the 
     *       event listener that handles the event. For example, if you use 
     *       <code>myButton.addEventListener()</code> to register an event listener, 
     *       myButton is the value of the <code>currentTarget</code>. </td></tr>
     *     <tr><td><code>keyCode</code></td><td>If the event was triggered by a key press, 
     *       the keycode for the key.</td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
     *       it is not always the Object listening for the event. 
     *       Use the <code>currentTarget</code> property to always access the 
     *       Object listening for the event.</td></tr>
     *     <tr><td><code>thumbIndex</code></td><td>The zero-based index of the thumb
     *       whose position has changed.</td></tr>
     *     <tr><td><code>triggerEvent</code></td><td>Contains a value indicating the 
     *       type of input action. The value is an event object of type flash.events.MouseEvent
     *       or flash.events.KeyboardEvent.</td></tr>
     *     <tr><td><code>value</code></td><td>The new value of the slider.</td></tr>
     *  </table>
     *
     *  @eventType thumbRelease
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static const THUMB_RELEASE:String = "thumbRelease";

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     *
     *  @param type The event type; indicates the action that caused the event.
     *
     *  @param bubbles Specifies whether the event can bubble
     *  up the display list hierarchy.
     *
     *  @param cancelable Specifies whether the behavior
     *  associated with the event can be prevented.
     *
     *  @param thumbIndex The zero-based index of the thumb
     *  whose position has changed.
     *
     *  @param value The new value of the slider.
     *
     *  @param triggerEvent The type of input action. 
     *  The value is an object of type flash.events.MouseEvent 
     *  or flash.events.KeyboardEvent.
     *
     *  @param clickTarget Whether the slider track or a slider thumb was pressed.
     *
     *  @param keyCode If the event was triggered by a key press, 
     *  the keycode for the key.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    COMPILE::JS
    public function SliderEvent(type:String, bubbles:Boolean = false,
                                cancelable:Boolean = false,
                                thumbIndex:int = -1, value:Number = NaN,
                                triggerEvent:Event = null,
                                clickTarget:String = null, keyCode:int = -1)
    {
        super(type, bubbles, cancelable);

        this.thumbIndex = thumbIndex;
        this.value = value;
        this.triggerEvent = triggerEvent;
        this.clickTarget = clickTarget;
        this.keyCode = keyCode;
    }

    /**
     *  Constructor.
     *
     *  @param type The event type; indicates the action that caused the event.
     *
     *  @param bubbles Specifies whether the event can bubble
     *  up the display list hierarchy.
     *
     *  @param cancelable Specifies whether the behavior
     *  associated with the event can be prevented.
     *
     *  @param thumbIndex The zero-based index of the thumb
     *  whose position has changed.
     *
     *  @param value The new value of the slider.
     *
     *  @param triggerEvent The type of input action.
     *  The value is an object of type flash.events.MouseEvent
     *  or flash.events.KeyboardEvent.
     *
     *  @param clickTarget Whether the slider track or a slider thumb was pressed.
     *
     *  @param keyCode If the event was triggered by a key press,
     *  the keycode for the key.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    COMPILE::SWF
    public function SliderEvent(type:String, bubbles:Boolean = false,
                                cancelable:Boolean = false,
                                thumbIndex:int = -1, value:Number = NaN,
                                triggerEvent:FlashEvent = null,
                                clickTarget:String = null, keyCode:int = -1)
    {
        super(type, bubbles, cancelable);

        this.thumbIndex = thumbIndex;
        this.value = value;
        this.triggerEvent = triggerEvent;
        this.clickTarget = clickTarget;
        this.keyCode = keyCode;
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  clickTarget
    //----------------------------------

    /**
     *  Specifies whether the slider track or a slider thumb was pressed. 
     *  This property can have one of two values: 
     *  <code>SliderEventClickTarget.THUMB</code> 
     *  or <code>SliderEventClickTarget.TRACK</code>.
     *
     *  @see mx.events.SliderEventClickTarget
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public var clickTarget:String;
    
    //----------------------------------
    //  keyCode
    //----------------------------------

    /**
     *  If the event was triggered by a key press, the keycode for the key.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public var keyCode:int;

    //----------------------------------
    //  thumbIndex
    //----------------------------------

    /**
     *  The zero-based index of the thumb whose position has changed.
     *  If there is only a single thumb, the value is 0.
     *  If there are two thumbs, the value is 0 or 1.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public var thumbIndex:int;
    
    //----------------------------------
    //  triggerEvent
    //----------------------------------

    /**
     *  Indicates the type of input action. 
     *  The value is an event object of type mx.events.MouseEvent
     *  or mx.events.KeyboardEvent.
     *
     *  @see flash.events.MouseEvent
     *  @see flash.events.KeyboardEvent
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    COMPILE::JS
    public var triggerEvent:Event;

    /**
     *  Indicates the type of input action.
     *  The value is an event object of type flash.events.MouseEvent
     *  or flash.events.KeyboardEvent.
     *
     *  @see flash.events.MouseEvent
     *  @see flash.events.KeyboardEvent
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    COMPILE::SWF
    public var triggerEvent:FlashEvent;

    //----------------------------------
    //  value
    //----------------------------------

    /**
     *  The new value of the slider.  
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public var value:Number;
    
    //--------------------------------------------------------------------------
    //
    //  Overridden methods: Event
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    override public function cloneEvent():IRoyaleEvent
    {
        return new SliderEvent(type, bubbles, cancelable, thumbIndex,
                               value, triggerEvent, clickTarget, keyCode);
    }
}

}
