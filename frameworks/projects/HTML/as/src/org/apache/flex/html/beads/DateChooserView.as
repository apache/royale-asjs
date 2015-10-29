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
	import org.apache.flex.html.beads.models.DateChooserModel;
	import org.apache.flex.html.supportClasses.DateChooserButton;
	
    import org.apache.flex.core.BeadViewBase;
	import org.apache.flex.core.IBeadModel;
	import org.apache.flex.core.IBeadView;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.core.ValuesManager;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
	import org.apache.flex.html.beads.layouts.TileLayout;
	import org.apache.flex.html.Container;
	import org.apache.flex.html.TextButton;
	
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
		
		/**
		 *  @copy org.apache.flex.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		override public function set strand(value:IStrand):void
		{
			super.strand = value;
			
			// make sure there is a model.
			model = _strand.getBeadByType(IBeadModel) as DateChooserModel;
			if (model == null) {
				model = new (ValuesManager.valuesImpl.getValue(_strand,"iBeadModel")) as DateChooserModel;
			}
			model.addEventListener("displayedMonthChanged",handleModelChange);
			model.addEventListener("displayedYearChanged",handleModelChange);
			
			createChildren();
		}
		
		private var _prevMonthButton:TextButton;
		private var _nextMonthButton:TextButton;
		private var _dayButtons:Array;
		private var monthLabel:TextButton;
		private var dayContainer:Container;
		
		private var model:DateChooserModel;
		
		/**
		 *  The button that causes the previous month to be displayed by the DateChooser.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get prevMonthButton():TextButton
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
		public function get nextMonthButton():TextButton
		{
			return _nextMonthButton;
		}
		
		/**
		 * The array of DateChooserButton instances that represent each day of the month.
		 */
		public function get dayButtons():Array
		{
			return _dayButtons;
		}
		
		/**
		 * @private
		 */
		private function createChildren():void
		{
			_prevMonthButton = new TextButton();
			_prevMonthButton.width = 40;
			_prevMonthButton.height = 20;
			_prevMonthButton.x = 0;
			_prevMonthButton.y = 0;
			_prevMonthButton.text = "<";
			UIBase(_strand).addElement(_prevMonthButton);
			
			_nextMonthButton = new TextButton();
			_nextMonthButton.width = 40;
			_nextMonthButton.height = 20;
			_nextMonthButton.x = UIBase(_strand).width - _nextMonthButton.width;
			_nextMonthButton.y = 0;
			_nextMonthButton.text = ">";
			UIBase(_strand).addElement(_nextMonthButton);
			
			monthLabel = new TextButton();
			monthLabel.text = "Month Here";
			monthLabel.width = 100;
			monthLabel.height = 20;
			monthLabel.x = (UIBase(_strand).width - monthLabel.width)/2;
			monthLabel.y = 0;
			UIBase(_strand).addElement(monthLabel);
			
			dayContainer = new Container();
			var tileLayout:TileLayout = new TileLayout();
			dayContainer.addBead(tileLayout);
            UIBase(_strand).addElement(dayContainer, false);
            
			tileLayout.numColumns = 7;
			dayContainer.x = 0;
			dayContainer.y = monthLabel.y + monthLabel.height + 5;
			
			var sw:Number = UIBase(_strand).width;
			var sh:Number = UIBase(_strand).height;
			//trace("Strand's width x height is "+sw+" x "+sh);
			dayContainer.width = sw;
			dayContainer.height = sh - (monthLabel.height+5);
			
			// the calendar has 7 columns with 6 rows, the first row are the day names
			for(var i:int=0; i < 7; i++) {
				var dayName:DateChooserButton = new DateChooserButton();
				dayName.text = model.dayNames[i];
				dayName.dayOfMonth = 0;
				dayContainer.addElement(dayName, false);
			}
			
			_dayButtons = new Array();
			
			for(i=0; i < 42; i++) {
				var date:DateChooserButton = new DateChooserButton();
				date.text = String(i+1);
				dayContainer.addElement(date, false);
				dayButtons.push(date);
			}
			
			IEventDispatcher(dayContainer).dispatchEvent( new Event("itemsCreated") );			
			IEventDispatcher(_strand).dispatchEvent( new Event("layoutNeeded") );			
			IEventDispatcher(dayContainer).dispatchEvent( new Event("layoutNeeded") );
			
			updateCalendar();
		}
		
		/**
		 * @private
		 */
		private function updateCalendar():void
		{
			monthLabel.text = model.monthNames[model.displayedMonth] + " " +
				String(model.displayedYear);
			
			var firstDay:Date = new Date(model.displayedYear,model.displayedMonth,1);
			
			// blank out the labels for the first firstDay.day-1 entries.
			for(var i:int=0; i < firstDay.getDay(); i++) {
				var dateButton:DateChooserButton = dayButtons[i] as DateChooserButton;
				dateButton.dayOfMonth = -1;
				dateButton.text = "";
			}
			
			// renumber to the last day of the month
			var dayNumber:int = 1;
			var numDays:Number = numberOfDaysInMonth(model.displayedMonth, model.displayedYear);
			
			for(; i < dayButtons.length && dayNumber <= numDays; i++) {
				dateButton = dayButtons[i] as DateChooserButton;
				dateButton.dayOfMonth = dayNumber;
				dateButton.text = String(dayNumber++);
			}
			
			// blank out the rest
			for(; i < dayButtons.length; i++) {
				dateButton = dayButtons[i] as DateChooserButton;
				dateButton.dayOfMonth = -1;
				dateButton.text = "";
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
		 */
		private function handleModelChange(event:Event):void
		{
			updateCalendar();
		}
	}
}
