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
package org.apache.royale.html.beads.controllers
{
	import org.apache.royale.core.IBeadController;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.events.MouseEvent;
	import org.apache.royale.html.ImageButton;
	import org.apache.royale.html.beads.RangeStepperView;
	import org.apache.royale.html.beads.models.RangeModel;

	/**
	 *  The RangeStepperMouseController bead feeds mouse events to the RangeStepper and its
	 *  components. 
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class RangeStepperMouseController implements IBeadController
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function RangeStepperMouseController()
		{
		}

		private var _strand:IStrand;

		private var _incrButton:ImageButton;
		private var _decrButton:ImageButton;

		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;

			var stepperView:RangeStepperView = _strand.getBeadByType(RangeStepperView) as RangeStepperView;

			_incrButton = stepperView.incrementButton;
			_incrButton.addEventListener(MouseEvent.CLICK, handleIncrClick);

			_decrButton = stepperView.decrementButton;
			_decrButton.addEventListener(MouseEvent.CLICK, handleDecrClick);
		}

		private function handleIncrClick(event:MouseEvent):void
		{
			var model:RangeModel = (_strand as UIBase).model as RangeModel;
			var nextValue:Number = model.value + 1;
			if (nextValue >= model.maximum) nextValue = model.maximum;
			model.value = nextValue;
		}

		private function handleDecrClick(event:MouseEvent):void
		{
			var model:RangeModel = (_strand as UIBase).model as RangeModel;
			var nextValue:Number = model.value - 1;
			if (nextValue < model.minimum) nextValue = model.minimum;
			model.value = nextValue;
		}
	}
}
