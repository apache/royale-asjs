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
	import org.apache.royale.core.IBeadController;
	import org.apache.royale.core.IRangeModel;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.events.MouseEvent;
	import org.apache.royale.events.ValueChangeEvent;
	import org.apache.royale.jewel.beads.controls.spinner.ISpinnerView;
    COMPILE::JS
    {
        import org.apache.royale.jewel.Spinner;
        import org.apache.royale.jewel.Button;
        import goog.events;
        import goog.events.EventType;
    }

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
            	var spinnerBead:ISpinnerView = value.getBeadByType(ISpinnerView) as ISpinnerView;

                var incrementButton:Button = spinnerBead.increment;
                var decrementButton:Button = spinnerBead.decrement;

                goog.events.listen(incrementButton.element, goog.events.EventType.CLICK,
                    incrementClickHandler);

                goog.events.listen(decrementButton.element, goog.events.EventType.CLICK,
                    decrementClickHandler);
            }
		}

		/**
		 * @private
		 * @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 */
		private function decrementClickHandler( event:org.apache.royale.events.MouseEvent ) : void
		{
			var oldValue:Number = rangeModel.value;
			rangeModel.value = Math.max(rangeModel.minimum, rangeModel.value - rangeModel.stepSize);
			var vce:ValueChangeEvent = ValueChangeEvent.createUpdateEvent(_strand, "value", oldValue, rangeModel.value);
			IEventDispatcher(_strand).dispatchEvent(vce);
		}

		/**
		 * @private
		 * @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 */
		private function incrementClickHandler( event:org.apache.royale.events.MouseEvent ) : void
		{
			var oldValue:Number = rangeModel.value;
			rangeModel.value = Math.min(rangeModel.maximum, rangeModel.value + rangeModel.stepSize);
			var vce:ValueChangeEvent = ValueChangeEvent.createUpdateEvent(_strand, "value", oldValue, rangeModel.value);
			IEventDispatcher(_strand).dispatchEvent(vce);
		}
	}
}
