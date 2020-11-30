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
package org.apache.royale.jewel.beads.controllers
{
    COMPILE::JS
    {
	import org.apache.royale.jewel.Button;
    }
	import org.apache.royale.core.IBeadController;
	import org.apache.royale.core.IRangeModel;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.MouseEvent;
	import org.apache.royale.events.ValueChangeEvent;
	import org.apache.royale.jewel.beads.controls.spinner.ISpinnerView;
	import org.apache.royale.utils.Timer;
	import org.apache.royale.utils.sendStrandEvent;

	/**
	 *  The SpinnerMouseController class bead handles mouse events on the
	 *  org.apache.royale.jewel.Spinner's component buttons, changing the
	 *  value of the Spinner.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.4
	 */
	public class SpinnerMouseController implements IBeadController
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function SpinnerMouseController()
		{
		}

		private var rangeModel:IRangeModel;

		private var _strand:IStrand;

		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *
		 *  @royaleignorecoercion org.apache.royale.jewel.Spinner
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 *  @royaleignorecoercion org.apache.royale.jewel.beads.controls.spinner.ISpinnerView
		 *  @royaleignorecoercion org.apache.royale.core.UIBase
		 *  @royaleignorecoercion org.apache.royale.core.IRangeModel
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;

			rangeModel = UIBase(value).model as IRangeModel;

            COMPILE::SWF
            {
			var spinnerBead:ISpinnerView = value.getBeadByType(ISpinnerView) as ISpinnerView;
			spinnerBead.decrement.addEventListener(MouseEvent.CLICK, decrementClickHandler);
			spinnerBead.decrement.addEventListener("buttonRepeat", decrementClickHandler);
			spinnerBead.increment.addEventListener(MouseEvent.CLICK, incrementClickHandler);
			spinnerBead.increment.addEventListener("buttonRepeat", incrementClickHandler);
            }

            COMPILE::JS
            {
			var view:ISpinnerView = value.getBeadByType(ISpinnerView) as ISpinnerView;

			var incrementButton:Button = view.increment;
			var decrementButton:Button = view.decrement;

			incrementButton.addEventListener(MouseEvent.CLICK, incrementClickHandler);
			incrementButton.addEventListener(MouseEvent.MOUSE_DOWN, incrementMouseDownHandler);
			incrementButton.addEventListener(MouseEvent.MOUSE_UP, incrementMouseUpHandlermouseUpHandler);
			decrementButton.addEventListener(MouseEvent.CLICK, decrementClickHandler);
			decrementButton.addEventListener(MouseEvent.MOUSE_DOWN, decrementMouseDownHandler);
			decrementButton.addEventListener(MouseEvent.MOUSE_UP, decrementMouseUpHandlermouseUpHandler);
            }
		}

		private var mouseDown:Boolean = false;

		protected var timer:Timer;
		protected var timerdelay:Number = 500;

		/**
		 * Make timer be faster as user maintain the button pressed
		 * @private
		 */
		private function increaseCadence(incOrDecFunc:Function):void
		{
			if(!mouseDown) return;
			if(timer != null && timer.running)
			{
				if (timer.delay > 150)
				{
					var newdelay:Number = timer.delay/2;
					removeTimer(incOrDecFunc);
					createTimer(incOrDecFunc, newdelay)
				}
			}
		}

		/**
		 * Create the timer each time needed depending on function to listen and delay
		 * @private
		 */
		private function createTimer(incOrDecFunc:Function, delay:Number):void
		{
			timer = new Timer(delay, 0);
			timer.addEventListener("timer", incOrDecFunc);
			timer.start();
		}
		
		/**
		 * Remove the timer each time needed depending on function to listen
		 * @private
		 */
		private function removeTimer(incOrDecFunc:Function):void
		{
			timer.removeEventListener("timer", incOrDecFunc);
			timer.stop();
			timer = null;
		}

		/**
		 * Increment mouse down handler
		 */
		private function incrementMouseDownHandler(event:MouseEvent):void
		{
			COMPILE::JS
			{
			if (event.button !== 0)
				return;
			}
			mouseDown = true;
			createTimer(incrementClickHandler, timerdelay);
		}
		/**
		 * Increment mouse up handler
		 */
		private function incrementMouseUpHandlermouseUpHandler(event:MouseEvent):void
		{
			COMPILE::JS
			{
			if (event.button !== 0)
				return;
			}
			mouseDown = false;
			removeTimer(incrementClickHandler);
		}
		/**
		 * Increment mouse click handler
		 */
		private function incrementClickHandler(event:Event):void
		{
			increaseCadence(incrementClickHandler);
			
			var oldValue:Number = rangeModel.value;
			rangeModel.value = Math.min(rangeModel.maximum, rangeModel.value + rangeModel.stepSize);
			var vce:ValueChangeEvent = ValueChangeEvent.createUpdateEvent(_strand, "value", oldValue, rangeModel.value);
			sendStrandEvent(_strand, vce);
		}

		/**
		 * Decrement mouse down handler
		 */
		private function decrementMouseDownHandler(event:MouseEvent):void
		{
			COMPILE::JS
			{
			if (event.button !== 0)
				return;
			}
			mouseDown = true;
			createTimer(decrementClickHandler, timerdelay);
		}
		/**
		 * Decrement mouse up handler
		 */
		private function decrementMouseUpHandlermouseUpHandler(event:MouseEvent):void
		{
			COMPILE::JS
			{
			if (event.button !== 0)
				return;
			}
			mouseDown = false;
			removeTimer(decrementClickHandler);
		}
		/**
		 * Decrement mouse click handler
		 */
		private function decrementClickHandler(event:Event):void
		{
			increaseCadence(decrementClickHandler);

			var oldValue:Number = rangeModel.value;
			rangeModel.value = Math.max(rangeModel.minimum, rangeModel.value - rangeModel.stepSize);
			var vce:ValueChangeEvent = ValueChangeEvent.createUpdateEvent(_strand, "value", oldValue, rangeModel.value);
			sendStrandEvent(_strand, vce);
		}
	}
}
