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

package org.apache.royale.effects
{

import org.apache.royale.core.IEffectTimer;
import org.apache.royale.core.ValuesManager;
import org.apache.royale.events.ValueEvent;
import org.apache.royale.events.Event;
import org.apache.royale.events.EventDispatcher;

[Event(name="tweenEnd", type="org.apache.royale.events.ValueEvent")]
[Event(name="tweenStart", type="org.apache.royale.events.ValueEvent")]
[Event(name="tweenUpdate", type="org.apache.royale.events.ValueEvent")]
[Event(name="effectEnd", type="org.apache.royale.events.Event")]

/**
 *  Tween is the underlying animation class for the effects in Royale.
 *
 *  The Tween class defines a tween, a property animation performed
 *  on a target object over a period of time.
 *  That animation can be a change in position, such as performed by
 *  the Move effect; a change in size, as performed by the Resize or
 *  Zoom effects; a change in visibility, as performed by the Fade or
 *  Dissolve effects; or other types of animations.
 *
 *  <p>A Tween instance accepts the <code>startValue</code>,
 *  <code>endValue</code>, and <code>duration</code> properties,
 *  and an optional easing function to define the animation.</p>
 *
 *
 *  @langversion 3.0
 *  @playerversion Flash 10.2
 *  @playerversion AIR 2.6
 *  @productversion Royale 0.0
 */
public class Tween extends Effect
{
    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    /**
     *  The <code>Tween.TWEEN_END</code> constant defines the value of the
     *  event object's <code>type</code> property for a <code>tweenEnd</code> event.
     *
     *  <p>The properties of the event object have the following values:</p>
     *  <table class="innertable">
     *     <tr><th>Property</th><th>Value</th></tr>
     *     <tr><td><code>bubbles</code></td><td>false</td></tr>
     *     <tr><td><code>cancelable</code></td><td>false</td></tr>
     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the
     *       event listener that handles the event. For example, if you use
     *       <code>myButton.addEventListener()</code> to register an event listener,
     *       myButton is the value of the <code>currentTarget</code>. </td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event;
     *       it is not always the Object listening for the event.
     *       Use the <code>currentTarget</code> property to always access the
     *       Object listening for the event.</td></tr>
     *     <tr><td><code>value</code></td><td>The value passed to the
     *       <code>onTweenEnd()</code> method.</td></tr>
     *  </table>
     *
     *  @see org.apache.royale.effects.Effect
     *  @see org.apache.royale.effects.TweenEffect
     *  @see org.apache.royale.events.EffectEvent
     *  @eventType tweenEnd
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 1.0.0
     */
    public static const TWEEN_END:String = "tweenEnd";

    /**
     *  The <code>Tween.TWEEN_START</code> constant defines the value of the
     *  event object's <code>type</code> property for a <code>tweenStart</code> event.
     *
     *  <p>The properties of the event object have the following values:</p>
     *  <table class="innertable">
     *     <tr><th>Property</th><th>Value</th></tr>
     *     <tr><td><code>bubbles</code></td><td>false</td></tr>
     *     <tr><td><code>cancelable</code></td><td>false</td></tr>
     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the
     *       event listener that handles the event. For example, if you use
     *       <code>myButton.addEventListener()</code> to register an event listener,
     *       myButton is the value of the <code>currentTarget</code>. </td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event;
     *       it is not always the Object listening for the event.
     *       Use the <code>currentTarget</code> property to always access the
     *       Object listening for the event.</td></tr>
     *     <tr><td><code>value</code></td><td>The value passed to the
     *       <code>onTweenUpdate()</code> method.</td></tr>
     *  </table>
     *
     *  @eventType tweenStart
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 1.0.0
     */
    public static const TWEEN_START:String = "tweenStart";

    /**
     *  The <code>Tween.TWEEN_UPDATE</code> constant defines the value of the
     *  event object's <code>type</code> property for a <code>tweenUpdate</code> event.
     *
     *  <p>The properties of the event object have the following values:</p>
     *  <table class="innertable">
     *     <tr><th>Property</th><th>Value</th></tr>
     *     <tr><td><code>bubbles</code></td><td>false</td></tr>
     *     <tr><td><code>cancelable</code></td><td>false</td></tr>
     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the
     *       event listener that handles the event. For example, if you use
     *       <code>myButton.addEventListener()</code> to register an event listener,
     *       myButton is the value of the <code>currentTarget</code>. </td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event;
     *       it is not always the Object listening for the event.
     *       Use the <code>currentTarget</code> property to always access the
     *       Object listening for the event.</td></tr>
     *     <tr><td><code>value</code></td><td>The value passed to the
     *       <code>onTweenUpdate()</code> method.</td></tr>
     *  </table>
     *
     *  @eventType tweenUpdate
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 1.0.0
     */
    public static const TWEEN_UPDATE:String = "tweenUpdate";


    //--------------------------------------------------------------------------
    //
    //  Class variables
    //
    //--------------------------------------------------------------------------

    /**
     *  The list of tweens that are currently playing.
     * 
     *  @royalesuppresspublicvarwarning
     */
    public static var activeTweens:Object = { };

    private static var activeCount:uint = 0;

    private static var timer:IEffectTimer;

    private static var currentID:uint = 1;

    //--------------------------------------------------------------------------
    //
    //  Class properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  currentTime
    //----------------------------------

    /**
     *  Used by effects to get the current effect time tick.
     * 
     *  @royalesuppresspublicvarwarning
     */
    public static var currentTime:Number = NaN;

    //--------------------------------------------------------------------------
    //
    //  Class methods
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     *  @royaleignorecoercion org.apache.royale.core.IEffectTimer
     */
    private static function addTween(tween:Tween):void
    {
        tween.uid = currentID++;

        activeTweens[tween.uid] = tween;
        activeCount++;

        if (!timer)
        {
            timer = ValuesManager.valuesImpl.newInstance(tween, "iEffectTimer") as IEffectTimer;
            timer.addEventListener("update", updateHandler);
        }
        currentTime = timer.start();

        tween.startTime = tween.previousUpdateTime = currentTime;
    }


    /**
     *  @private
     */
    private static function removeTween(tween:Tween):void
    {
        delete activeTweens[tween.uid];
        activeCount--;
        if (activeCount === 0) {
            timer.stop();
        }
    }

    /**
     *  @royaleignorecoercion org.apache.royale.effects.Tween
     *  @royaleignorecoercion Number
     *  @private
     */
    private static function updateHandler(event:ValueEvent):void
    {
        var oldTime:Number = currentTime;

        // the IEFfectTimer can control the current time
        // if it wants.  This can be useful for automated
        // testing.
        currentTime = event.value as Number;

        for (var uid:String in activeTweens)
        {
            var tween:Tween = Tween(activeTweens[uid]);
            tween.update();
        }
    }

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
     *  @productversion Royale 1.0.0
     */
    public function Tween()
    {
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    private var uid:uint = 0;

    /**
     *  @private
     */
    private var _doSeek:Boolean = false;

    /**
     *  @private
     */
    private var _isPlaying:Boolean = true;

    /**
     *  @private
     */
    private var _doReverse:Boolean = false;

    /**
     *  @private
     */
    private var startTime:Number;

    /**
     *  @private
     */
    private var previousUpdateTime:Number;

    /**
     *  @private
     */
    private var userEquation:Function;

    private var _endValue:Number;
    
    /**
     *  Final value of the animation.
     */
    public function get endValue():Number
    {
        return _endValue;
    }
    
    /**
     *  @private
     */
    public function set endValue(value:Number):void
    {
        _endValue = value;
    }

    private var _startValue:Number;
    
    /**
     *  Initial value of the animation.
     */
    public function get startValue():Number
    {
        return _startValue;
    }
    
    /**
     *  @private
     */
    public function set startValue(value:Number):void
    {
        _startValue = value;
    }

    /**
     *  @private
     */
    private var started:Boolean = false;

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  listener
    //----------------------------------

    /**
     *  Object that is notified at each interval of the animation.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 1.0.0
     * 
     *  @royalesuppresspublicvarwarning
     */
    public var listener:Object;

    //----------------------------------
    //  playheadTime
    //----------------------------------

    /**
     *  @private
     *  Storage for the playheadTime property.
     */
    private var _playheadTime:Number = 0;

    /**
     *  @private
     *  The current millisecond position in the tween.
     *  This value is between 0 and duration.
     *  Use the seek() method to change the position of the tween.
     */
    private function get playheadTime():Number
    {
        return _playheadTime;
    }

    //----------------------------------
    //  playReversed
    //----------------------------------

    /**
     *  @private
     *  Storage for the playReversed property.
     */
    private var _invertValues:Boolean = false;

    /**
     *  @private
     *  Starts playing reversed from start of tween.
     *  Setting this property to <code>true</code>
     *  inverts the values returned by the tween.
     *  Using reverse inverts the values and only plays
     *  for as much time that has already elapsed.
     */
    private function get playReversed():Boolean
    {
        return _invertValues;
    }

    /**
     *  @private
     */
    private function set playReversed(value:Boolean):void
    {
        _invertValues = value;
    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------


    /**
     *  Sets the easing function for the animation.
     *  The easing function is used to interpolate between
     *  the <code>startValue</code> value and the <code>endValue</code>.
     *  A trivial easing function does linear interpolation,
     *  but more sophisticated easing functions create the illusion of
     *  acceleration and deceleration, which makes the animation seem
     *  more natural.
     *
     *  <p>If no easing function is specified, an easing function based
     *  on the <code>Math.sin()</code> method is used.</p>
     *
     *  <p>The easing function follows the function signature
     *  popularized by Robert Penner.
     *  The function accepts four arguments.
     *  The first argument is the "current time",
     *  where the animation start time is 0.
     *  The second argument is a the initial value
     *  at the beginning of the animation (a Number).
     *  The third argument is the ending value
     *  minus the initial value.
     *  The fourth argument is the duration of the animation.
     *  The return value is the interpolated value for the current time
     *  (usually a value between the initial value and the ending value).</p>
     *
     *  @param easingFunction Function that implements the easing equation.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 1.0.0
     */
    public function set easingFunction(value:Function):void
    {
        userEquation = value;
    }

    /**
     *  Interrupt the tween, jump immediately to the end of the tween,
     *  and invoke the <code>onTweenEnd()</code> callback function.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 1.0.0
     */
    public function endTween():void
    {
        var event:ValueEvent = new ValueEvent(Tween.TWEEN_END);
        var value:Object = getCurrentValue(duration);

        event.value = value;

        dispatchEvent(event);

        listener.onTweenEnd(value);

        dispatchEvent(new Event(Effect.EFFECT_END));
        //reset
        started = false;
        // If tween has been added, id > 0
        // but if duration = 0, this might not be the case.
        if (uid > 0) {
            Tween.removeTween(this);
            uid = 0;
        }
    }

    /**
     *  @private
     *  Returns true if the tween has ended.
     */
    protected function update():Boolean
    {
        var tweenEnded:Boolean = false;

        // If user specified a minimum frames per second, we can't guarantee
        // that we'll be called often enough to satisfy that request.
        // However, we can avoid skipping over part of the animation.
        // If this callback arrives too late, adjust the animation startTime,
        // so that the animation starts up 'maxDelay' milliseconds
        // after its last update.
        /*
         if (intervalTime - previousUpdateTime > maxDelay)
         {
         startTime += intervalTime - previousUpdateTime - maxDelay;
         }
         */
        previousUpdateTime = currentTime;

        if (_isPlaying || _doSeek)
        {

            var elapsedTime:Number = currentTime - startTime;
            _playheadTime = elapsedTime;

            var currentValue:Object =
                    getCurrentValue(elapsedTime);

            if (elapsedTime >= duration && !_doSeek)
            {
                endTween();
                tweenEnded = true;
            }
            else
            {
                if (!started)
                {
                    var startEvent:ValueEvent = new ValueEvent(Tween.TWEEN_START);
                    dispatchEvent(startEvent);
                    started = true;
                }

                var event:ValueEvent =
                        new ValueEvent(Tween.TWEEN_UPDATE);
                event.value = currentValue;

                dispatchEvent(event);

                listener.onTweenUpdate(currentValue);
            }

            _doSeek = false;
        }
        return tweenEnded;
    }

    /**
     *  @private
     */
    /* protected */ public function getCurrentValue(currentTime:Number):Object
    {
        if (duration == 0)
        {
            return endValue;
        }

        if (_invertValues)
            currentTime = duration - currentTime;

        return userEquation(currentTime, startValue,
                endValue - startValue,
                duration);
    }

    /**
     *  @private
     */
    private function defaultEasingFunction(t:Number, b:Number,
                                           c:Number, d:Number):Number
    {
        return c / 2 * (Math.sin(Math.PI * (t / d - 0.5)) + 1) + b;
    }

    /**
     *  Stops the tween, ending it without dispatching an event or calling
     *  the Tween's endFunction or <code>onTweenEnd()</code>.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 1.0.0
     */
    public function end():void
    {
        seek(duration);
    }
    
    /**
     *  Advances the tween effect to the specified position.
     *
     *  @param playheadTime The position, in milliseconds, between 0
     *  and the value of the <code>duration</code> property.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 1.0.0
     */
    public function seek(playheadTime:Number):void
    {
        // Set value between 0 and duration
        //playheadTime = Math.min(Math.max(playheadTime, 0), duration);

        var clockTime:Number = currentTime;

        // Reset the previous update time
        previousUpdateTime = clockTime;

        // Reset the start time
        startTime = clockTime - playheadTime;

        _doSeek = true;

        update();
    }

    /**
     *  Plays the effect in reverse,
     *  starting from the current position of the effect.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 1.0.0
     */
    override public function reverse():void
    {
        if (_isPlaying)
        {
            _doReverse = false;
            seek(duration - _playheadTime);
            _invertValues = !_invertValues;
        }
        else
        {
            _doReverse = !_doReverse;
        }
    }

    /**
     *  Pauses the effect until you call the <code>resume()</code> method.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 1.0.0
     */
    override public function pause():void
    {
        _isPlaying = false;
    }

    /**
     *  Stops the tween, ending it without dispatching an event or calling
     *  the Tween's endFunction or <code>onTweenEnd()</code>.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 1.0.0
     */
    override public function play():void
    {
        if (uid == 0) {
            if (userEquation == null)
                userEquation = defaultEasingFunction;
            Tween.addTween(this);
        }
    }

    /**
     *  Stops the tween, ending it without dispatching an event or calling
     *  the Tween's endFunction or <code>onTweenEnd()</code>.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 1.0.0
     */
    override public function stop():void
    {
        if (uid !== 0) {
            Tween.removeTween(this);
            started = false;
            uid = 0;
        }
    }

    /**
     *  Resumes the effect after it has been paused
     *  by a call to the <code>pause()</code> method.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 1.0.0
     */
    override public function resume():void
    {
        _isPlaying = true;

        startTime = currentTime - _playheadTime;
        if (_doReverse)
        {
            reverse();
            _doReverse = false;
        }
    }
}

}
