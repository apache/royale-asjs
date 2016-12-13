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
package org.apache.flex.html.beads.models
{	
	import org.apache.flex.core.IDateChooserModel;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.EventDispatcher;
	
	/**
	 *  The DateChooserModel is a bead class that manages the data for a DataChooser. 
	 *  This includes arrays of names for the months and days of the week as well the
	 *  currently selected date.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class DateChooserModel extends EventDispatcher implements IDateChooserModel
	{
		public function DateChooserModel()
		{
			// default displayed year and month to "today"
			var today:Date = new Date();
			displayedYear = today.getFullYear();
			displayedMonth = today.getMonth();
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
		}
		
		private var _dayNames:Array   = ["Sun","Mon","Tue","Wed","Thu","Fri","Sat"];
		private var _monthNames:Array = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"];
		private var _displayedYear:Number;
		private var _displayedMonth:Number;
		private var _firstDayOfWeek:Number = 0;
		private var _selectedDate:Date;
		
		/**
		 *  An array of strings used to name the days of the week with Sunday being the
		 *  first element of the array.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
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
		 *  @productversion FlexJS 0.0
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
		 *  @productversion FlexJS 0.0
		 */
		public function get displayedYear():Number
		{
			return _displayedYear;
		}
		public function set displayedYear(value:Number):void
		{
			if (value != _displayedYear) {
				_displayedYear = value;
				dispatchEvent( new Event("displayedYearChanged") );
			}
		}
		
		/**
		 *  The month currently displayed by the DateChooser.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get displayedMonth():Number
		{
			return _displayedMonth;
		}
		public function set displayedMonth(value:Number):void
		{
			if (_displayedMonth != value) {
				_displayedMonth = value;
				dispatchEvent( new Event("displayedMonthChanged") );
			}
		}
		
		/**
		 *  The index of the first day of the week, Sunday = 0.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
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
		
		/**
		 *  The currently selected date or null if no date has been selected.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get selectedDate():Date
		{
			return _selectedDate;
		}
		public function set selectedDate(value:Date):void
		{
			if (value != _selectedDate) {
				_selectedDate = value;
				dispatchEvent( new Event("selectedDateChanged") );
				
				if (value != null) {
					displayedMonth = value.getMonth();
					displayedYear  = value.getFullYear();
				}
			}
		}
	}
}
