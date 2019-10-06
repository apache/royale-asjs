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

package mx.charts.effects.effectClasses
{

import mx.charts.chartClasses.Series;
import mx.effects.Tween;
import mx.effects.effectClasses.TweenEffectInstance;
import mx.events.TweenEvent;

/**
 *  The SeriesEffectInstance class implements the base instance class
 *  for the chart series effects.
 *
 *  @see mx.charts.effects.SeriesEffect
 *
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 * 
 *  @royalesuppresspublicvarwarning
 */  
public class SeriesEffectInstance extends TweenEffectInstance
{
//    include "../../../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Class methods
    //
    //--------------------------------------------------------------------------

	/**
	 *  @private
	 */
	private static function LinearEase(t:Number, b:Number,
									   c:Number, d:Number):Number
	{
		return b + c * t / d;
	}

	/**
	 *  @private
	 */
	private static function sinEase(t:Number, b:Number,
								    c:Number, d:Number):Number
	{
		return b + c * (1 - Math.cos(Math.PI * t / d)) / 2;
	}

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

	/**
	 *  Constructor.
	 *
	 *  @param target The target of the effect.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function SeriesEffectInstance(target:Object = null)
	{
		targetSeries = Series(target);						
		
		super(target);
	}
	
    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

	/**
	 *  @private
	 */
	private var easingFunctionHolder:Function;

	/**
	 *  @private
	 */
	private var _elementDuration:Number;
	
	/**
	 *  @private
	 */
	private var _elementCount:Number;	
	
	/**
	 *  @private
	 */
	private var _playHeads:Array /* of Number */;
	
	/**
	 *  @private
	 */
	private var _forward:Boolean = true;
	
	
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

	/**
	 *  The series targeted by this instance.  
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	protected var targetSeries:Series;

	/**
	 *  The current position of each chart item being managed by this effect. This is an array of values between 0 and 1 indicating how far the effect should render each item in the series between its 
	 *	starting and ending values. These values are calculated based on the duration, number of elements, element offset, minimum element duration, and easing function.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	protected var interpolationValues:Array /* of Number */;

 	//----------------------------------
	//  elementOffset
	//----------------------------------

	[Inspectable]

	/**
	 *  Specifies the amount of time, in milliseconds, that Flex delays
	 *  the start of the effect on each element in the series.
	 *
	 *  <p>Set <code>elementOffset</code> to <code>0</code>
	 *  to affect all elements of the series at the same time.
	 *  They start the effect at the same time and end it at the same time.</p>
	 *
	 *  <p>Set <code>elementOffset</code> to a positive integer
	 *  (such as <code>30</code>) to stagger the effect on each element
	 *  by that amount of time.
	 *  For example, with a slide effect, the first element slides in
	 *  immediately, then the next element begins 30 milliseconds later,
	 *  and so on.
	 *  The amount of time for the effect to execute is the same
	 *  for each element, but the overall duration of the effect is longer.</p>
	 *
	 *  <p>Set <code>elementOffset</code> to a negative value
	 *  to have the effect begin from the last element
	 *  and move backwards through the list.</p>
	 *
	 *  <p>The default is <code>20</code>.</p>
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public var elementOffset:Number = 20;
	
 	//----------------------------------
	//  minimumElementDuration
	//----------------------------------

	[Inspectable]

	/**
	 *  Specifies the amount of time, in milliseconds,
	 *  that an individual element should take to complete the effect.
	 *
	 *  <p>Charts with a variable number of data points in the series
	 *  cannot reliably create smooth effects
	 *  with only the <code>duration</code> property.
	 *  For example, an effect with a <code>duration</code>
	 *  of <code>1000</code> and an <code>elementOffset</code>
	 *  of <code>100</code> takes 900 milliseconds per element
	 *  to complete an effect if you have two elements in the series.
	 *  This is because the start of each effect is offset by 100
	 *  and each effect finishes in 1000 milliseconds.</p>
	 * 
	 *  <p>If there are four elements in the series,
	 *  each element takes 700 milliseconds to complete
	 *  (the last effect starts 300 milliseconds after the first
	 *  and must be completed within 1000 milliseconds).
	 *  With 10 elements, each element has only 100 milliseconds</p>
	 *  to complete the effect.
	 *
	 *  <p>The <code>minimumElementDuration</code> value
	 *  sets a minimal duration for each element.
	 *  No element of the series takes less than this amount of time
	 *  (in milliseconds) to execute the effect,
	 *  regardless of the number of elements in the series
	 *  and the value of the <code>duration</code> property.
	 *  As a result, it is possible for an effect to take longer
	 *  than a specified <code>duration</code>
	 *  if at least two of the following three properties are specified:
	 *  <code>duration</code>, <code>offset</code>,
	 *  and <code>minimumElementDuration</code>.</p>
	 *  
	 *  <p>The default is <code>0</code>.</p>
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public var minimumElementDuration:Number = 0;
	
 	//----------------------------------
	//  offset
	//----------------------------------

	[Inspectable]

	/**
	 *  Specifies the amount of time, in milliseconds,
	 *  that Flex delays the effect.
	 *
	 *  <p>Use this property to stagger effects on multiple series.</p>
	 *
	 *  <p>The default is <code>0</code>.</p>
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public var offset:Number = 0;
	
 	//----------------------------------
	//  type
	//----------------------------------

	[Inspectable(environment="none")]

	/**
	 *  The type of transition this effect is being used for. Some series effects define different behavior based on whether they are being used during the show or hide portion of 
	 *	a chart transition.  The SeriesSlide effect, for example, slides elements from their position off screen when type is set to <code>hide</code>, and on screen when set to <code>show</code>.  This property
	 *	is set automatically by the chart, based on whether the effect is assigned to the ShowDataEffect or HideDataEffect style.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public var type:String = "show";

    //--------------------------------------------------------------------------
    //
    //  Overridden methods
    //
    //--------------------------------------------------------------------------

	/**
	 *  @private
	 */
	override public function onTweenUpdate(value:Object):void 
	{
		var curVal:Number = Number(value);
		
		var n:int = _elementCount;
		var i:int;
		var playHead:Number;
		
		if (_forward)
		{
			for (i = 0; i < n; i++)
			{
				if (_playHeads[i] != 1)
				{
					playHead = (curVal - offset - i * elementOffset) /
							   _elementDuration;
					
					if (playHead > 1) 
						interpolationValues[i] = 1;
					else if (playHead >= 0)
						interpolationValues[i] = easingFunctionHolder(playHead, 0, 1, 1);
					else
						interpolationValues[i] = 0;

					_playHeads[i] = playHead;
				}
			}		
		}
		else
		{
			for (i = 0; i < n; i++)
			{
				if (_playHeads[i] != 1)
				{
					playHead =
						(curVal - offset - (n - 1 - i) * elementOffset)  /
						_elementDuration;

					if (playHead > 1) 
						interpolationValues[i] = 1;
					else if (playHead >= 0)
						interpolationValues[i] = easingFunctionHolder(playHead, 0, 1, 1);
					else
						interpolationValues[i] = 0;

					_playHeads[i] = playHead;
				}
			}
		}
	
	}

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

	/**
	 *  Initializes the tweening calculations and sets up the <code>interpolationValues</code> Array for the number of items equal to the <code>elementCount</code> property. Derived classes should call this function in their <code>play()</code> method.
	 *  @param elementCount The number of elements to generate interpolation values for.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	protected function beginTween(elementCount:int):void
	{
		easingFunctionHolder = findEasingEquation(target,easingFunction);

		_elementCount = elementCount;

		if (elementOffset < 0)
		{
			_forward = false;
			elementOffset *= -1;
		}

		if (elementCount > 0)
		{
			if (!isNaN(duration))
			{
				_elementDuration =
					duration - Math.abs(elementOffset) * (elementCount - 1);
			}

			if (isNaN(duration) || _elementDuration < minimumElementDuration)
			{
				_elementDuration = minimumElementDuration;
				duration = Math.abs(elementOffset) * (elementCount - 1) +
						   _elementDuration;
			}
			
			duration += offset;
		}
		
		elementOffset /= duration;
		_elementDuration /= duration;
		offset /= duration;
				
		interpolationValues = [];
		_playHeads = [];
		
		tween = new Tween(this,0,1,duration);
		tween.addEventListener(TweenEvent.TWEEN_START, tweenEventHandler);
		tween.addEventListener(TweenEvent.TWEEN_UPDATE, tweenEventHandler);
		tween.addEventListener(TweenEvent.TWEEN_END, tweenEventHandler);		
		tween.easingFunction = LinearEase;
	}
	
	/**
	 *  @private
	 */
	private function findEasingEquation(targetObj:Object,
										easing:Object):Function
	{
		// If we're passed a function pointer, we have no work to do.
		if (easing == null)
			return sinEase;

		if (easing is Function)
			return (easing as Function);

		// Otherwise, assume we're passed a string (the name of an
		// easing function).  Search up the containment hierarchy for
		// a definition of that function.
		while (targetObj != null)
		{
			var easingFunc:Object = targetObj[easing];

			if (easingFunc != null && easingFunc is Function)
				return (easingFunc as Function);

			targetObj = targetObj.parent;
		}

		return sinEase;
	}	
	
	
	//--------------------------------------------------------------------
	//
	// Event Handlers
	//
	//--------------------------------------------------------------------
	private function tweenEventHandler(event:TweenEvent):void
	{
		dispatchEvent(event);
	}

}

}
