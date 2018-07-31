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
package {

import mx.core.ILayoutElement;
import mx.events.PropertyChangeEvent;
import mx.formatters.NumberBase;

import spark.components.supportClasses.GroupBase;
import spark.layouts.HorizontalLayout;

public class HBaselineLayout extends HorizontalLayout
{
	public function HBaselineLayout()
	{
		super();
	}

	//----------------------------------
	//  globalBaseline
	//----------------------------------
	
	[Inspectable(category="General")]

	private var _globalBaseline:Number = NaN;
	public function get globalBaseline():Number
	{
		return _globalBaseline;
	}

	public function set globalBaseline(value:Number):void
	{
		_globalBaseline = value;
		var target:GroupBase = this.target;
		if (target)
		{
			target.invalidateSize();
			target.invalidateDisplayList();
		}
	}

	//----------------------------------
	//  actualBaseline
	//----------------------------------
	
	private var _actualBaseline:Number;
	
	[Bindable("propertyChange")]
	[Inspectable(category="General")]
	
	public function get actualBaseline():Number
	{
		return _actualBaseline;
	}
	
	private function setActualBaseline(value:Number):void
	{
		if (value == _actualBaseline)
			return;

		var oldValue:Number = _actualBaseline;
		_actualBaseline = value;
		dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "actualBaseline", oldValue, value));
	}
	
	//----------------------------------
	//  verticalAlign
	//----------------------------------
	
	[Inspectable(category="General", enumeration="top,bottom,middle,justify,contentJustify,baseline", defaultValue="top")]
	override public function get verticalAlign():String
	{
		return super.verticalAlign;		
	}

	/**
	 *  @private 
	 */
	override public function measure():void
	{
		super.measure();
		
		var target:GroupBase = this.target;
		if (!target || verticalAlign != "baseline")
			return;
		
		measureBaseline(true /*usePreferredSize*/);
		if (!isNaN(_globalBaseline))
			measuredBaselineTop = _globalBaseline;
		
		// The measured height is the sum of the space above and below the baseline
		if (isNaN(paddingTop))
			measuredBaselineTop += paddingTop;
		if (isNaN(paddingBottom))
			measuredBaselineBottom += paddingBottom;
		target.measuredHeight = Math.round(measuredBaselineTop + measuredBaselineBottom);
	}
	
	/**
	 *  @private 
	 */
	override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
	{
		super.updateDisplayList(unscaledWidth, unscaledHeight);
		
		var target:GroupBase = this.target;
		if (!target || verticalAlign != "baseline")
			return;

		measureBaseline(false /*usePreferredSize*/);
		if (!isNaN(_globalBaseline))
			measuredBaselineTop = _globalBaseline;

		if (isNaN(paddingTop))
			measuredBaselineTop += paddingTop;
		
		// Adjust the position of the elements
		var contentHeight:Number = 0;
		var count:int = target.numElements;
		for (var i:int = 0; i < count; i++)
		{
			var element:ILayoutElement = target.getElementAt(i);
			if (!element || !element.includeInLayout)
				continue;
			
			var elementBaseline:Number = element.baseline as Number;
			if (isNaN(elementBaseline))
				elementBaseline = 0;

			var baselinePosition:Number = element.baselinePosition;
			var y:Number = measuredBaselineTop + (elementBaseline - baselinePosition);
			element.setLayoutBoundsPosition(element.getLayoutBoundsX(), y);
			contentHeight = Math.max(contentHeight, element.getLayoutBoundsHeight() + y);
		}

		// Adjust the content height
		if (isNaN(paddingBottom))
			contentHeight += paddingBottom;
		target.setContentSize(target.contentWidth, contentHeight);
		
		// Update the baseline
		setActualBaseline(measuredBaselineTop);
	}

	private var measuredBaselineTop:Number = 0;			// How much space is needed above the baseline to fit all the elements
	private var measuredBaselineBottom:Number = 0;		// How much space is needed below the baseline to fit all the elements
	
	/**
	 *  @private 
	 */
	private function measureBaseline(usePreferredSize:Boolean):void
	{
		var elementBaseline:Number = 0; 			// The current element's explicit baseline constraint
		var elementBaselineTop:Number = 0;			// The portiono of the current element that's above the baseline
		var elementBaselineBottom:Number = 0;		// The portion of the current element that's below the baseline

		measuredBaselineTop = 0;
		measuredBaselineBottom = 0;

		var count:int = target.numElements;
		for (var i:int = 0; i < count; i++)
		{
			var element:ILayoutElement = target.getElementAt(i);
			if (!element || !element.includeInLayout)
				continue;
			
			var elementHeight:Number = usePreferredSize ? element.getPreferredBoundsHeight() :
														  element.getLayoutBoundsHeight();
			elementBaseline = element.baseline as Number;
			if (isNaN(elementBaseline))
				elementBaseline = 0;
			
			var baselinePosition:Number = element.baselinePosition;
			
			elementBaselineTop = baselinePosition - elementBaseline;
			elementBaselineBottom = elementHeight - elementBaselineTop;
			
			measuredBaselineTop = Math.max(elementBaselineTop, measuredBaselineTop);
			measuredBaselineBottom = Math.max(elementBaselineBottom, measuredBaselineBottom);
		}
	}
}
}