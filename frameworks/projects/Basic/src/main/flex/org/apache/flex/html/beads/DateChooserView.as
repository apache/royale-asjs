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
	import org.apache.flex.core.SimpleCSSStyles;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.core.ValuesManager;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
	import org.apache.flex.html.Container;
	import org.apache.flex.html.Group;
	import org.apache.flex.html.List;
	import org.apache.flex.html.TextButton;
	import org.apache.flex.html.beads.GroupView;
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
	 *  @viewbead	 
	 */
	public class DateChooserView extends GroupView implements IBeadView
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
			super();
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
			
			createChildren();
			updateDisplay();
		}
		
		private var model:DateChooserModel;
		
		private var _prevMonthButton:DateHeaderButton;
		private var _nextMonthButton:DateHeaderButton;
		private var monthLabel:DateHeaderButton;
		private var monthButtonsContainer:Group;
		private var dayNamesContainer:DateChooserHeader;
		private var daysContainer:DateChooserList;
		
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
		
		private const controlHeight:int = 26;
		private const commonButtonWidth:int = 40;
		
		/**
		 * @private
		 */
		private function createChildren():void
		{
			// HEADER BUTTONS
			
			monthButtonsContainer = new Group();
			monthButtonsContainer.height = controlHeight;
			monthButtonsContainer.id = "dateChooserMonthButtons";
			monthButtonsContainer.className = "DateChooserMonthButtons";
			monthButtonsContainer.style = new SimpleCSSStyles();
			monthButtonsContainer.style.flexGrow = 0;
			COMPILE::JS {
				monthButtonsContainer.element.style["flex-grow"] = "0";
			}
			
			_prevMonthButton = new DateHeaderButton();
			_prevMonthButton.width = commonButtonWidth;
			_prevMonthButton.text = "<";
			if (_prevMonthButton.style == null) {
				_prevMonthButton.style = new SimpleCSSStyles();
			}
			_prevMonthButton.style.flexGrow = 0;
			COMPILE::JS {
				_prevMonthButton.element.style["flex-grow"] = "0";
			}
			monthButtonsContainer.addElement(_prevMonthButton);
			
			monthLabel = new DateHeaderButton();
			monthLabel.text = "Month Here";
			if (monthLabel.style == null) {
				monthLabel.style = new SimpleCSSStyles();
			}
			monthLabel.style.flexGrow = 1;
			COMPILE::JS {
				monthLabel.element.style["flex-grow"] = "1";
			}
			monthButtonsContainer.addElement(monthLabel);
			
			_nextMonthButton = new DateHeaderButton();
			_nextMonthButton.width = commonButtonWidth;
			_nextMonthButton.text = ">";
			if (_nextMonthButton.style == null) {
				_nextMonthButton.style = new SimpleCSSStyles();
			}
			COMPILE::JS {
				_nextMonthButton.element.style["flex-grow"] = "0";
			}
			_nextMonthButton.style.flexGrow = 0;
			monthButtonsContainer.addElement(_nextMonthButton);
			
			UIBase(_strand).addElement(monthButtonsContainer, false);
			
			// DAY NAMES
			
			dayNamesContainer = new DateChooserHeader();
			dayNamesContainer.id = "dateChooserDayNames";
			dayNamesContainer.className = "DateChooserHeader";
			dayNamesContainer.height = controlHeight;
			dayNamesContainer.style = new SimpleCSSStyles();
			dayNamesContainer.style.flexGrow = 0;
			COMPILE::JS {
				dayNamesContainer.element.style["flex-grow"] = "0";
				dayNamesContainer.element.style["align-items"] = "center";
			}
			COMPILE::SWF {
				dayNamesContainer.percentWidth = 100;
			}
			UIBase(_strand).addElement(dayNamesContainer, false);
			
			// DAYS
			
			daysContainer = new DateChooserList();
			daysContainer.className = "DateChooserList";
			daysContainer.id = "dateChooserList";
			daysContainer.style = new SimpleCSSStyles();
			daysContainer.style.flexGrow = 1;
			COMPILE::JS {
				daysContainer.element.style["flex-grow"] = "1";
			}
			COMPILE::SWF {
				daysContainer.percentWidth = 100;
			}
			UIBase(_strand).addElement(daysContainer, false);
			
			
			IEventDispatcher(daysContainer).dispatchEvent( new Event("itemsCreated") );
			model.addEventListener("selectedDateChanged", selectionChangeHandler);
		}
		
		/**
		 * @private
		 */
		private function updateDisplay():void
		{
			monthLabel.text = model.monthNames[model.displayedMonth] + " " +
				String(model.displayedYear);
			
			dayNamesContainer.dataProvider = model.dayNames;
			
			daysContainer.dataProvider = model.days;
		}
		
		/**
		 * @private
		 */
		private function selectionChangeHandler(event:Event):void
		{
			updateDisplay();
			
			var index:Number = model.getIndexForSelectedDate();
			daysContainer.selectedIndex = index;
		}
		
		/**
		 * @private
		 */
		private function handleModelChange(event:Event):void
		{
			updateDisplay();
		}
	}
}
