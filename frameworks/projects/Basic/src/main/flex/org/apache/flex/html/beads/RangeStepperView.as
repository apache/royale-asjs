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
package org.apache.royale.html.beads
{
	import org.apache.royale.core.BeadViewBase;
	import org.apache.royale.core.IBeadView;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.svg.Rect;
	import org.apache.royale.graphics.SolidColorStroke;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.html.ImageButton;
	import org.apache.royale.html.Label;
	import org.apache.royale.html.beads.models.RangeModelExtended;

	/**
	 *  The RangeStepperView bead creates the visual elements of the RangeStepper. This
	 *  includes an increment button, a decrement button, and label to display the value.
	 *  
	 *  @viewbead
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class RangeStepperView extends BeadViewBase implements IBeadView
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function RangeStepperView()
		{
			super();
		}

		private var _label:Label;
		private var _incrementButton:ImageButton;
		private var _decrementButton:ImageButton;
		private var _labelBox:Rect;

		/**
		 *  Increment control.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get incrementButton():ImageButton
		{
			return _incrementButton;
		}

		/**
		 *  Decrement control.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get decrementButton():ImageButton
		{
			return _decrementButton;
		}

		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		override public function set strand(value:IStrand):void
		{
			super.strand = value;
			_strand = value;

			var host:UIBase = _strand as UIBase;

			_labelBox = new Rect();
			_labelBox.stroke = new SolidColorStroke();
			(_labelBox.stroke as SolidColorStroke).color = 0x000000;
			(_labelBox.stroke as SolidColorStroke).weight = 1.0;

			_incrementButton = new ImageButton();
			_incrementButton.src = "assets/up-arrow.png";

			_decrementButton = new ImageButton();
			_decrementButton.src = "assets/down-arrow.png";

			IEventDispatcher(value).addEventListener("widthChanged",sizeChangeHandler);
			IEventDispatcher(value).addEventListener("heightChanged",sizeChangeHandler);

			_label = new Label();

			host.addElement(_labelBox);
			host.addElement(_incrementButton);
			host.addElement(_decrementButton);
			host.addElement(_label);

			var model:RangeModelExtended = host.model as RangeModelExtended;
			model.addEventListener("valueChange", handleValueChange);

			sizeChangeHandler(null);
		}

		private function sizeChangeHandler(event:Event):void
		{
			var host:UIBase = _strand as UIBase;

			_incrementButton.x = 0;
			_incrementButton.y = 0;
			_incrementButton.setWidthAndHeight(host.width, 20);

			_label.x = 0;
			_label.y = _incrementButton.height + 2;
			_label.setWidthAndHeight(host.width, host.height-40, true);

			_labelBox.x = _label.x;
			_labelBox.y = _label.y - 2;
			_labelBox.drawRect(0, 0, _label.width - 1, _label.height);

			_decrementButton.x = 0;
			_decrementButton.y = host.height - 20;
			_decrementButton.setWidthAndHeight(host.width, 20);
		}

		private function handleValueChange(event:Event):void
		{
			var model:RangeModelExtended = (_strand as UIBase).model as RangeModelExtended;
			_label.text = model.getLabelForIndex(model.value);
		}
	}
}
