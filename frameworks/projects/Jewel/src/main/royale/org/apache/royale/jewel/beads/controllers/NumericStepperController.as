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
	import org.apache.royale.core.Bead;
	import org.apache.royale.core.IBeadController;
	import org.apache.royale.core.IRangeModel;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.ValueChangeEvent;
	import org.apache.royale.jewel.Spinner;
	import org.apache.royale.jewel.TextInput;
	import org.apache.royale.jewel.beads.views.NumericStepperView;
	import org.apache.royale.utils.sendStrandEvent;

	/**
	 *  The NumericStepperController class is responsible for listening to
	 *  mouse event related to NumericStepper.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.10.0
	 */
	public class NumericStepperController extends Bead implements IBeadController
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.10.0
		 */
		public function NumericStepperController()
		{
		}

		private var view:NumericStepperView;
		private var input:TextInput;
		private var spinner:Spinner;

		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.10.0
         *  @royaleignorecoercion org.apache.royale.jewel.beads.views.NumericStepperView
		 */
		override public function set strand(value:IStrand):void
		{
			super.strand = value;
			
			view = _strand.getBeadByType(NumericStepperView) as NumericStepperView;
			if (view) {
				finishSetup();
			} else {
				listenOnStrand("viewChanged", finishSetup);
			}
		}

		/**
         *  @private
		 */
		protected function finishSetup(event:Event = null):void
		{
			input = view.input;
			spinner = view.spinner;

			// listen for changes to the text input field which will reset the
			// value. ideally, we should either set the input to accept only
			// numeric values or, barring that, reject non-numeric entries. we
			// cannot do that right now however.
			input.addEventListener(Event.CHANGE, inputChangeHandler);
			
			// listen for change events on the spinner so the value can be updated as
			// as resizing the component
			spinner.addEventListener("valueChange", spinnerValueChanged);
			
			// listen for changes and update the UI accordingly
			listenOnStrand("valueChange", modelChangeHandler);
			listenOnStrand("minimumChange", modelChangeHandler);
			listenOnStrand("maximumChange", modelChangeHandler);
			listenOnStrand("stepSizeChange", modelChangeHandler);
			listenOnStrand("snapIntervalChange", modelChangeHandler);
		}

		/**
		 * @private
		 * @royaleignorecoercion org.apache.royale.core.UIBase
		 * @royaleignorecoercion org.apache.royale.core.IRangeModel
		 */
		private function modelChangeHandler(event:Event):void
		{
			input.text = String(IRangeModel(UIBase(_strand).model).value);
		}
		
		/**
		 * @private
		 */
		private function inputChangeHandler(event:Event):void
		{
			var newValue:Number = Number(input.text);

			if( !isNaN(newValue) ) {
				var oldValue:Number = spinner.value;
				spinner.value = newValue;
				if (oldValue != spinner.value) {
					var newEvent:ValueChangeEvent = ValueChangeEvent.createUpdateEvent(_strand, "value", oldValue, spinner.value);
					sendStrandEvent(_strand, newEvent);
				}
			}
			else {
				input.text = String(spinner.value);
			}
		}

		/**
		 * @private
		 */
		private function spinnerValueChanged(event:ValueChangeEvent):void
		{
			input.text = "" + spinner.value;
			
			var newEvent:ValueChangeEvent = ValueChangeEvent.createUpdateEvent(_strand, "value", event.oldValue, event.newValue);
			sendStrandEvent(_strand, newEvent);
		}
	}
}
