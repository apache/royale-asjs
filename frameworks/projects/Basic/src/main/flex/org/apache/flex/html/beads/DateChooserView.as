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
package org.apache.flex.html.beads
{
	import org.apache.flex.core.BeadViewBase;
	import org.apache.flex.core.IBead;
	import org.apache.flex.core.IBeadModel;
	import org.apache.flex.core.IBeadView;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.core.ValuesManager;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
	import org.apache.flex.html.Container;
    import org.apache.flex.html.List;
	import org.apache.flex.html.TextButton;
    import org.apache.flex.html.beads.layouts.HorizontalLayout;
	import org.apache.flex.html.beads.layouts.TileLayout;
	import org.apache.flex.html.beads.models.DateChooserModel;
	import org.apache.flex.html.supportClasses.DateHeaderButton;
    import org.apache.flex.html.supportClasses.DateChooserHeader;
    import org.apache.flex.html.supportClasses.DateChooserList;
    
	/**
	 * The DateChooserView class is a view bead for the DateChooser. This class
	 * creates the elements for the DateChooser: the buttons to move between
	 * months, the labels for the days of the week, and the buttons for each day
	 * of the month.
	 */
	public class DateChooserView extends BeadViewBase implements IBeadView
	{
		/**
		 *  constructor
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function DateChooserView()
		{
		}
		
		override public function set strand(value:IStrand):void
		{
			super.strand = value;
			model = _strand.getBeadByType(IBeadModel) as DateChooserModel;
			if (model == null) {
				model = new (ValuesManager.valuesImpl.getValue(_strand,"iBeadModel")) as DateChooserModel;
			}
			model.addEventListener("displayedMonthChanged",handleModelChange);
			model.addEventListener("displayedYearChanged",handleModelChange);

			var host:UIBase = value as UIBase;
			host.addEventListener("widthChanged", handleSizeChange);
			host.addEventListener("heightChanged", handleSizeChange);

			createChildren();
			layoutContents();
		}

        private var model:DateChooserModel;
		private var _prevMonthButton:DateHeaderButton;
		private var _nextMonthButton:DateHeaderButton;
		private var monthLabel:DateHeaderButton;
        private var dayNamesContainer:DateChooserHeader;
        private var daysContainer:DateChooserList;
        
        private var _dayNames:Array;
        private var _days:Array;
        
		/**
		 *  The button that causes the previous month to be displayed by the DateChooser.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get prevMonthButton():DateHeaderButton
		{
			return _prevMonthButton;
		}

		/**
		 *  The button that causes the next month to be displayed by the DateChooser.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get nextMonthButton():DateHeaderButton
		{
			return _nextMonthButton;
		}

        public function get dayList():List
        {
            return daysContainer;
        }
            
		private function handleSizeChange(event:Event):void
		{
			layoutContents();
		}

		/**
		 * @private
		 */
		private function createChildren():void
		{
			_prevMonthButton = new DateHeaderButton();
			_prevMonthButton.width = 40;
			_prevMonthButton.height = 20;
			_prevMonthButton.text = "<";
			UIBase(_strand).addElement(_prevMonthButton);

			_nextMonthButton = new DateHeaderButton();
			_nextMonthButton.width = 40;
			_nextMonthButton.height = 20;
			_nextMonthButton.text = ">";
			UIBase(_strand).addElement(_nextMonthButton);

			monthLabel = new DateHeaderButton();
			monthLabel.text = "Month Here";
			monthLabel.width = 100;
			monthLabel.height = 20;
			UIBase(_strand).addElement(monthLabel);

            dayNamesContainer = new DateChooserHeader();
            UIBase(_strand).addElement(dayNamesContainer, false);
            
            daysContainer = new DateChooserList();
            UIBase(_strand).addElement(daysContainer, false);
            
            _dayNames = new Array();
            
			// the calendar has 7 columns with 6 rows, the first row are the day names
			for(var i:int=0; i < 7; i++) {
                _dayNames.push(model.dayNames[i]);
			}

			IEventDispatcher(daysContainer).dispatchEvent( new Event("itemsCreated") );

			updateCalendar();
		}

        private function layoutContents():void
        {
            var sw:Number = UIBase(_strand).width;
            var sh:Number = UIBase(_strand).height;
            
            _prevMonthButton.x = 0;
            _prevMonthButton.y = 0;
            
            _nextMonthButton.x = sw - _nextMonthButton.width;
            _nextMonthButton.y = 0;
            
            monthLabel.x = _prevMonthButton.x + _prevMonthButton.width;
            monthLabel.y = 0;
            monthLabel.width = sw - _prevMonthButton.width - _nextMonthButton.width;
            
            dayNamesContainer.x = 0;
            dayNamesContainer.y = monthLabel.y + monthLabel.height;
            dayNamesContainer.width = sw;
            dayNamesContainer.height = monthLabel.height;
            
            dayNamesContainer.dataProvider = _dayNames;
            
            daysContainer.x = 0;
            daysContainer.y = dayNamesContainer.y + dayNamesContainer.height;
            daysContainer.width = sw;
            daysContainer.height = sh - monthLabel.height - dayNamesContainer.height;
            daysContainer.dataProvider = _days;
                
            IEventDispatcher(_strand).dispatchEvent( new Event("layoutNeeded") );
            IEventDispatcher(daysContainer).dispatchEvent( new Event("layoutNeeded") );
        }

        
		/**
		 * @private
		 */
		private function updateCalendar():void
		{
			monthLabel.text = model.monthNames[model.displayedMonth] + " " +
				String(model.displayedYear);

			var firstDay:Date = new Date(model.displayedYear,model.displayedMonth,1);

            _days = new Array(42);
            
			// blank out the labels for the first firstDay.day-1 entries.
			for(var i:int=0; i < firstDay.getDay(); i++) {
                _days[i] = null;
            }

			// renumber to the last day of the month
			var dayNumber:int = 1;
			var numDays:Number = numberOfDaysInMonth(model.displayedMonth, model.displayedYear);

            for(; i < _days.length && dayNumber <= numDays; i++) {
                _days[i] = new Date(model.displayedYear, model.displayedMonth, dayNumber++);
            }

			// blank out the rest
            for(; i < _days.length; i++) {
                _days[i] = null;
            }
            daysContainer.dataProvider = _days;
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
		 */
		private function handleModelChange(event:Event):void
		{
			updateCalendar();
		}
		
	}
}
