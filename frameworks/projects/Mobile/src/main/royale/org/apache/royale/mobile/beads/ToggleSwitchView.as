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
package org.apache.royale.mobile.beads
{	
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IBeadView;
	import org.apache.royale.core.IToggleButtonModel;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.svg.Rect;
	import org.apache.royale.graphics.SolidColor;
	import org.apache.royale.graphics.SolidColorStroke;
	import org.apache.royale.events.Event;
	
	/**
	 * The ToggleSwitchView creates the element used to display the ToggleSwitch
	 * interface.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class ToggleSwitchView implements IBeadView
	{
		/**
		 * Constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function ToggleSwitchView()
		{
			super();
		}
		
		/**
		 * @private
         * 
         *  @royalesuppresspublicvarwarning
		 */
		public var boundingBox:Rect;
		
		/**
		 * @private
         * 
         *  @royalesuppresspublicvarwarning
		 */
		public var actualSwitch:Rect;
		
		/**
		 * @private
		 */
		public function get host():IUIBase
		{
			return _strand as IUIBase;
		}
		public function set host(value:IUIBase):void
		{
			// not implemented; getter only.
		}
		
		private var _strand:IStrand;
		
		/**
		 * @private
		 */
		public function get strand():IStrand
		{
			return _strand;
		}
		public function set strand(value:IStrand):void
		{
			_strand = value;
			UIBase(_strand).addEventListener("sizeChanged", sizeChangedHandler);
			UIBase(_strand).addEventListener("widthChanged", sizeChangedHandler);
			UIBase(_strand).addEventListener("heightChanged", sizeChangedHandler);
			
			var model:IToggleButtonModel = value.getBeadByType(IToggleButtonModel) as IToggleButtonModel;
			model.addEventListener("selectedChange", toggleChangedHandler);
			
			boundingBox = new Rect();
			UIBase(host).addElement(boundingBox, false);
			
			actualSwitch = new Rect();
			UIBase(host).addElement(actualSwitch, false);
			
			layoutChromeElements();
		}
		
		/**
		 * @private
		 */
		protected function toggleChangedHandler(event:Event):void
		{
			layoutChromeElements();
		}
		
		/**
		 * @private
		 */
		protected function sizeChangedHandler(event:Event):void
		{
			layoutChromeElements();
		}
		
		/**
		 * @private
		 */
		protected function layoutChromeElements():void
		{
			sizeViewsToFitContentArea();
		}
		
		/**
		 * @private
		 */
		protected function sizeViewsToFitContentArea():void
		{
			var model:IToggleButtonModel = _strand.getBeadByType(IToggleButtonModel) as IToggleButtonModel;
			
			boundingBox.x = 0;
			boundingBox.y = 0;
			boundingBox.setWidthAndHeight(host.width, host.height, false);
			
			actualSwitch.y = 2;
			actualSwitch.setWidthAndHeight(host.width/2 - 2, host.height-4, false);
			
			var fill:SolidColor = new SolidColor();
			fill.alpha = 2.0;
			
			var switchFill:SolidColor = new SolidColor();
			switchFill.alpha = 1.0;
			switchFill.color = 0xFFFFFF;
			actualSwitch.fill = switchFill;
			
			var border:SolidColorStroke = new SolidColorStroke();
			border.alpha = 1.0;
			border.color = 0x333333;
			border.weight = 1.0;
			
			boundingBox.stroke = border;
			actualSwitch.stroke = border;
			
			if (model.selected) {
				actualSwitch.x = host.width / 2;
				fill.color = 0x00DD00;
				boundingBox.fill = fill;
			} else {
				actualSwitch.x = 2;
				fill.color = 0xFFFFFF;
				boundingBox.fill = fill;
			}

			COMPILE::SWF {
				boundingBox.drawRect(0, 0, boundingBox.width, boundingBox.height);
				actualSwitch.drawRect(0, 0, actualSwitch.width, actualSwitch.height);
			}
			COMPILE::JS {
				boundingBox.drawRect(0, 0, boundingBox.width, boundingBox.height);
				actualSwitch.drawRect(actualSwitch.x, actualSwitch.y, actualSwitch.width, actualSwitch.height);
			}
			
		}
	}
}
