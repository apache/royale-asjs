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
package org.apache.royale.html.beads.layouts
{
	import org.apache.royale.core.IBeadLayout;
	import org.apache.royale.core.IRangeModel;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.html.beads.ISliderView;
	
	/**
	 * Use the HorizontalSliderLayout with a Slider to orient the Slider
	 * horizontally.
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9
	 */
	public class HorizontalSliderLayout implements IBeadLayout
	{
		/**
		 * Constructor
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		public function HorizontalSliderLayout()
		{
		}
		
		private var _strand:IStrand;
		
		/**
		 * @see org.apache.royale.core.IStrand
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;
			
			host.addEventListener("layoutNeeded", performLayout);
			
			host.addEventListener("widthChanged",performLayout);
			host.addEventListener("heightChanged",performLayout);
		}
		
		/**
		 * @private
		 */
		private function performLayout(event:Event):void
		{
			layout();
		}
		
		/**
		 * @private
		 */
		public function get host():UIBase
		{
			return _strand as UIBase;
		}
		
		/**
		 * Performs the layout (size and positioning) of the elements of the slider.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		public function layout():Boolean
		{
			var viewBead:ISliderView = host.view as ISliderView;
			if (viewBead == null) {
				return false;
			}
			
			var useWidth:Number = host.width;
			if (isNaN(useWidth)) {
				useWidth = 100;
			}
			var useHeight:Number = host.height;
			if (isNaN(useHeight)) {
				useHeight = 25;
			}
			var square:Number = Math.min(useWidth, useHeight);
			var trackHeight:Number = useHeight / 3;
			
			var thumb:IUIBase = viewBead.thumb as IUIBase;
			thumb.width = square;
			thumb.height = square;
			
			var track:IUIBase = viewBead.track as IUIBase;
			track.x = square/2;
			track.y = trackHeight; // 1/3 of the totalHeight
			track.width = useWidth - square;
			track.height = trackHeight;
			
			// determine the thumb position from the model information
			var model:IRangeModel = host.model as IRangeModel;
			var value:Number = model.value;
			if (value < model.minimum) value = model.minimum;
			if (value > model.maximum) value = model.maximum;
			var p:Number = (value-model.minimum)/(model.maximum-model.minimum);
			var xloc:Number = p * (useWidth - square);
			thumb.x = xloc;
			thumb.y = 0;
			
			return true;
		}
	}
}