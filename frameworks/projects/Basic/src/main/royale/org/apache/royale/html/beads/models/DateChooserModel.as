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
package org.apache.royale.html.beads.models
{	
	import org.apache.royale.core.IDateChooserModelWithChangeCheck;
	import org.apache.royale.events.Event;
	import org.apache.royale.core.DispatcherBead;
	
	/**
	 *  The DateChooserModel is a bead class that manages the data for a DataChooser. 
	 *  This includes arrays of names for the months and days of the week as well the
	 *  currently selected date.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class DateChooserModel extends DispatcherBead implements IDateChooserModelWithChangeCheck
	{
		public function DateChooserModel()
		{
			// default displayed year and month to "today"
//			var today:Date = new Date();
//			displayedYear = today.getFullYear();
//			displayedMonth = today.getMonth();
		}
		
		private var _dayNames:Array   = ["Sun","Mon","Tue","Wed","Thu","Fri","Sat"];
		private var _monthNames:Array = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"];
		private var _days:Array;
		private var _displayedYear:Number;
		private var _displayedMonth:Number;
		private var _firstDayOfWeek:Number = 0;
		private var _selectedDate:Date;
		private var _disableChangeCheck:Boolean;
		
		/**
		 *  An array of strings used to name the days of the week with Sunday being the
		 *  first element of the array.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get dayNames():Array
		{
			return _dayNames;
		}
		public function set dayNames(value:Array):void
		{
			_dayNames = value;
			dispatchEvent( new Event("dayNamesChanged") );
		}
		
		/**
		 *  An array of strings used to name the months of the year with January being
		 *  the first element of the array.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get monthNames():Array
		{
			return _monthNames;
		}
		public function set monthNames(value:Array):void
		{
			_monthNames = value;
			dispatchEvent( new Event("monthNames") );
		}
		
		/**
		 *  The year currently displayed by the DateChooser.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get displayedYear():Number
		{
			return _displayedYear;
		}
		public function set displayedYear(value:Number):void
		{
			if (value != _displayedYear) {
				_displayedYear = value;
				updateCalendar();
				dispatchEvent( new Event("displayedYearChanged") );
			}
		}
		
		/**
		 *  The month currently displayed by the DateChooser.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get displayedMonth():Number
		{
			return _displayedMonth;
		}
		public function set displayedMonth(value:Number):void
		{
			if (_displayedMonth != value) {
				_displayedMonth = value;
				updateCalendar();
				dispatchEvent( new Event("displayedMonthChanged") );
			}
		}
		
		/**
		 *  The index of the first day of the week, Sunday = 0.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get firstDayOfWeek():Number
		{
			return _firstDayOfWeek;
		}
		public function set firstDayOfWeek(value:Number):void
		{
			if (value != _firstDayOfWeek) {
				_firstDayOfWeek = value;
				dispatchEvent( new Event("firstDayOfWeekChanged") );
			}
		}

		public function get days():Array
		{
			return _days;
		}
		public function set days(value:Array):void
		{
			if (value != _days) {
				_days = value;
				dispatchEvent( new Event("daysChanged") );
			}
		}

		/**
		 *  The currently selected date or null if no date has been selected.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get selectedDate():Date
		{
			return _selectedDate;
		}
		public function set selectedDate(value:Date):void
		{
			COMPILE::JS
			{
				// in JS, date compare does not compare values, only if same instance
				if (!disableChangeCheck && value != null && _selectedDate != null && value.getTime() == _selectedDate.getTime())
					return;
			}
			if (value != _selectedDate) {
				_selectedDate = value;
		
				if (value != null) {
					var needsUpdate:Boolean = false;
					if (value.getMonth() != _displayedMonth) {
						needsUpdate = true;
						_displayedMonth = value.getMonth();
					}
					if (value.getFullYear() != _displayedYear) {
						needsUpdate = true;
						_displayedYear  = value.getFullYear();
					}
					if (needsUpdate) updateCalendar();
				}
				
				dispatchEvent( new Event("selectedDateChanged") );
			}
			else if (disableChangeCheck)
				dispatchEvent( new Event("selectedDateChanged") );
		}
		
		/**
		 *  The currently selected date or null if no date has been selected.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get disableChangeCheck():Boolean
		{
			return _disableChangeCheck;
		}
		public function set disableChangeCheck(value:Boolean):void
		{
			_disableChangeCheck = value;
		}
		
		// Utilities
        
        
		/**
		 * @private
		 */
		private function updateCalendar():void
		{       
			var firstDay:Date = new Date(displayedYear,displayedMonth,1);
			_days = new Array(42);
				
			// skip to the first day and renumber to the last day of the month
			var i:int = firstDay.getDay();
			var dayNumber:int = 1;
			var numDays:Number = numberOfDaysInMonth(displayedMonth, displayedYear);
				
			while(dayNumber <= numDays) {
				_days[i++] = new Date(displayedYear, displayedMonth, dayNumber++);
			}
				
		}
        
		/**
		 * @private
		 */
		private function numberOfDaysInMonth(month:Number, year:Number):Number
		{
			var n:int;
			
			if (month == 1) // Feb
			{
				if (((year % 4 == 0) && (year % 100 != 0)) || (year % 400 == 0)) // leap year
					n = 29;
				else
					n = 28;
			}
					
			else if (month == 3 || month == 5 || month == 8 || month == 10)
				n = 30;
					
			else
				n = 31;
			
			return n;
		}
        
		/**
		 * @private
		 *  @royaleignorecoercion Date
		 */
		public function getIndexForSelectedDate():Number
		{
			if (!_selectedDate) return -1;

			var str:String = _selectedDate.toDateString();

			for(var i:int=0; i < _days.length; i++) {
					var test:Date = _days[i] as Date;

					if (test && test.toDateString() == str)
					return i;

			}
			return -1;
		}
	}
}
