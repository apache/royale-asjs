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
	COMPILE::JS
	{
		import org.apache.royale.html.Spinner;
		import org.apache.royale.html.supportClasses.SpinnerButton;
		import goog.events;
		import goog.events.EventType;
	}
	import org.apache.royale.core.IBeadController;
	import org.apache.royale.core.IRangeModel;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.events.MouseEvent;
	import org.apache.royale.events.ValueChangeEvent;
	import org.apache.royale.html.TextButton;
	import org.apache.royale.html.beads.ISpinnerView;
  import org.apache.royale.utils.sendStrandEvent;
	import org.apache.royale.core.Bead;

	/**
	 *  The SpinnerMouseController class bead handles mouse events on the
	 *  org.apache.royale.html.Spinner's component buttons, changing the
	 *  value of the Spinner.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9
	 */
	public class SpinnerMouseController extends Bead implements IBeadController
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		public function SpinnerMouseController()
		{
		}

		private var rangeModel:IRangeModel;

		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *
		 *  @royaleignorecoercion org.apache.royale.html.Spinner
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 *  @royaleignorecoercion org.apache.royale.html.beads.ISpinnerView
		 *  @royaleignorecoercion org.apache.royale.core.UIBase
		 *  @royaleignorecoercion org.apache.royale.core.IRangeModel
		 */
		override public function set strand(value:IStrand):void
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

				var incrementButton:SpinnerButton = spinnerBead.increment;
				var decrementButton:SpinnerButton = spinnerBead.decrement;

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
			sendStrandEvent(_strand,vce);
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
			sendStrandEvent(_strand,vce);
		}
	}
}
