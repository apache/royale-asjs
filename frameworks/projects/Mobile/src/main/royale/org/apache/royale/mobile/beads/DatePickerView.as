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
	//import flash.events.Event;

	import org.apache.royale.core.BeadViewBase;
	import org.apache.royale.core.IBeadView;
	import org.apache.royale.core.IDateChooserModel;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;

	import org.apache.royale.html.beads.models.RangeModelExtended;
	import org.apache.royale.html.RangeStepper;
	import org.apache.royale.html.beads.RangeStepperView;

	/**
	 *  The DatePickerView bead creates the visual elements of the DatePicker. This
	 *  is a set of three RangeSteppers (one each for month, day, and year). 
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class DatePickerView extends BeadViewBase implements IBeadView
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function DatePickerView()
		{
			super();
		}

		private var _monthStepper:RangeStepper;
		private var _dayStepper:RangeStepper;
		private var _yearStepper:RangeStepper;

		private function monthValue(model:RangeModelExtended, index:Number):String
		{
			var dayModel:IDateChooserModel = _strand.getBeadByType(IDateChooserModel) as IDateChooserModel;
			return String(dayModel.monthNames[index]);
		}

		private function dayValue(model:RangeModelExtended, index:Number):String
		{
			return String(index);
		}

		private function yearValue(model:RangeModelExtended, index:Number):String
		{
			return String(index);
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
			var model:IDateChooserModel = _strand.getBeadByType(IDateChooserModel) as IDateChooserModel;
			var today:Date = model.selectedDate;

			var third:int = int(host.width/3.0)

			_monthStepper = new RangeStepper();
			_monthStepper.className = host.className+"_Month";
			_monthStepper.addBead(new RangeModelExtended());
			_monthStepper.addBead(new RangeStepperView());
			(_monthStepper.model as RangeModelExtended).labelFunction = monthValue;
			(_monthStepper.model as RangeModelExtended).minimum = 0;
			(_monthStepper.model as RangeModelExtended).maximum = 11;
			(_monthStepper.model as RangeModelExtended).value = today.getMonth();
			_monthStepper.setWidthAndHeight(third,host.height);
			host.addElement(_monthStepper);

			_dayStepper = new RangeStepper();
			_dayStepper.className = host.className+"_Day";
			_dayStepper.addBead(new RangeModelExtended());
			_dayStepper.addBead(new RangeStepperView());
			(_dayStepper.model as RangeModelExtended).labelFunction = dayValue;
			(_dayStepper.model as RangeModelExtended).minimum = 1;
			(_dayStepper.model as RangeModelExtended).maximum = 31;
			(_dayStepper.model as RangeModelExtended).value = today.getDate();
			_dayStepper.setWidthAndHeight(third,host.height);
			host.addElement(_dayStepper);

			_yearStepper = new RangeStepper();
			_yearStepper.className = host.className+"_Year";
			_yearStepper.addBead(new RangeModelExtended());
			_yearStepper.addBead(new RangeStepperView());
			(_yearStepper.model as RangeModelExtended).labelFunction = yearValue;
			(_yearStepper.model as RangeModelExtended).minimum = 1970;
			(_yearStepper.model as RangeModelExtended).maximum = 2025;
			(_yearStepper.model as RangeModelExtended).value = today.getFullYear();
			_yearStepper.setWidthAndHeight(third,host.height);
			host.addElement(_yearStepper);

			setupListeners(true);

			sizeChangeHandler(null);
		}

		private function setupListeners(state:Boolean):void
		{
			if (state) {
				(_monthStepper.model as IEventDispatcher).addEventListener("valueChange", handleStepperChange);
				(_dayStepper.model as IEventDispatcher).addEventListener("valueChange", handleStepperChange);
				(_yearStepper.model as IEventDispatcher).addEventListener("valueChange", handleStepperChange);
			}
			else {
				(_monthStepper.model as IEventDispatcher).removeEventListener("valueChange", handleStepperChange);
				(_dayStepper.model as IEventDispatcher).removeEventListener("valueChange", handleStepperChange);
				(_yearStepper.model as IEventDispatcher).removeEventListener("valueChange", handleStepperChange);
			}
		}

		private function sizeChangeHandler(event:Event):void
		{
			_monthStepper.x = 0;
			_monthStepper.y = 0;

			_dayStepper.x = _monthStepper.width - 1;
			_dayStepper.y = 0;

			_yearStepper.x = _monthStepper.width + _dayStepper.width - 2;
			_yearStepper.y = 0;
		}

		private function handleStepperChange(event:Event):void
		{
			var model:IDateChooserModel = _strand.getBeadByType(IDateChooserModel) as IDateChooserModel;

			var newMonth:Number = _monthStepper.value;
			var newDay:Number = _dayStepper.value;
			var newYear:Number = _yearStepper.value;

			var newDate:Date = new Date(newYear, newMonth, newDay);
			var oldDate:Date = model.selectedDate;

			if (newDate.getFullYear() != newYear || newDate.getDate() != newDay || newDate.getMonth() != newMonth) {
				setupListeners(false);
				_monthStepper.value = oldDate.getMonth();
				_dayStepper.value = oldDate.getDate();
				_yearStepper.value = oldDate.getFullYear();
				setupListeners(true);
			}
			else {
				model.selectedDate = newDate;
			}
		}
	}
}
