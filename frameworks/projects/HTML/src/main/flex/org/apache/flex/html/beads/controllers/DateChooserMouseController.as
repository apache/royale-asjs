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
package org.apache.flex.html.beads.controllers
{	
	import org.apache.flex.html.beads.DateChooserView;
	import org.apache.flex.html.beads.models.DateChooserModel;
	import org.apache.flex.html.supportClasses.DateChooserButton;
	
	import org.apache.flex.core.IBeadController;
	import org.apache.flex.core.IBeadModel;
	import org.apache.flex.core.IBeadView;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
	
	/**
	 *  The DateChooserMouseController class is responsible for listening to
	 *  mouse event related to the DateChooser. Events such as selecting a date
	 *  or changing the calendar.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class DateChooserMouseController implements IBeadController
	{
		/**
		 *  constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function DateChooserMouseController()
		{
		}
		
		private var _strand:IStrand;
		
		/**
		 *  @copy org.apache.flex.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;
			
			var view:DateChooserView = value.getBeadByType(IBeadView) as DateChooserView;
			view.prevMonthButton.addEventListener("click", prevMonthClickHandler);
			view.nextMonthButton.addEventListener("click", nextMonthClickHandler);
			
			var dayButtons:Array = view.dayButtons;
			for(var i:int=0; i < dayButtons.length; i++) {
				IEventDispatcher(dayButtons[i]).addEventListener("click", dayButtonClickHandler);
			}
		}
		
		/**
		 * @private
		 */
		private function prevMonthClickHandler(event:Event):void
		{
			var model:DateChooserModel = _strand.getBeadByType(IBeadModel) as DateChooserModel;
			var month:Number = model.displayedMonth - 1;
			var year:Number  = model.displayedYear;
			if (month < 0) {
				month = 11;
				year--;
			}
			model.displayedMonth = month;
			model.displayedYear = year;
		}
		
		/**
		 * @private
		 */
		private function nextMonthClickHandler(event:Event):void
		{
			var model:DateChooserModel = _strand.getBeadByType(IBeadModel) as DateChooserModel;
			var month:Number = model.displayedMonth + 1;
			var year:Number  = model.displayedYear;
			if (month >= 12) {
				month = 0;
				year++;
			}
			model.displayedMonth = month;
			model.displayedYear = year;
		}
		
		/**
		 * @private
		 */
		private function dayButtonClickHandler(event:Event):void
		{
			var dateButton:DateChooserButton = event.target as DateChooserButton;
			if (dateButton.dayOfMonth > 0) {
				var model:DateChooserModel = _strand.getBeadByType(IBeadModel) as DateChooserModel;
				var newDate:Date = new Date(model.displayedYear,model.displayedMonth,dateButton.dayOfMonth);
				model.selectedDate = newDate;
				IEventDispatcher(_strand).dispatchEvent( new Event("change") );
			}
		}
	}
}
