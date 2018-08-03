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
package org.apache.royale.jewel.beads.views
{
	import org.apache.royale.core.IBeadModel;
	import org.apache.royale.core.IBeadView;
	import org.apache.royale.core.IStrand;
	// import org.apache.royale.core.SimpleCSSStylesWithFlex;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.jewel.Group;
	import org.apache.royale.jewel.List;
	import org.apache.royale.jewel.beads.models.DateChooserModel;
	import org.apache.royale.jewel.Button;
	import org.apache.royale.jewel.supportClasses.datechooser.DateChooserHeader;
	import org.apache.royale.jewel.supportClasses.datechooser.DateChooserList;
	import org.apache.royale.utils.loadBeadFromValuesManager;
	import org.apache.royale.html.beads.GroupView;
	// import org.apache.royale.html.beads.layouts.HorizontalFlexLayout;

	/**
	 * The DateChooserView class is a view bead for the DateChooser.
     * 
     * This class creates the elements for the DateChooser: the buttons to move between
	 * months, the labels for the days of the week, and the buttons for each day
	 * of the month.
     * 
	 * @viewbead	 
	 */
	public class DateChooserView extends GroupView implements IBeadView
	{
		/**
		 *  constructor
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.3
		 */
		public function DateChooserView()
		{
			super();
		}
		
		override public function set strand(value:IStrand):void
		{
			super.strand = value;

			model = loadBeadFromValuesManager(IBeadModel, "iBeadModel", _strand) as DateChooserModel;

			model.addEventListener("firstDayOfWeekChanged", handleModelChange);
			model.addEventListener("dayNamesChanged", handleModelChange);
			model.addEventListener("displayedMonthChanged", handleModelChange);
			model.addEventListener("displayedYearChanged", handleModelChange);
			
			createChildren();
			updateDisplay();
		}
		
		private var model:DateChooserModel;
		
		private var monthButtonsContainer:Group;
		private var monthLabel:Button;
		private var dayNamesContainer:DateChooserHeader;
		
		/**
		 * @royaleignorecoercion org.apache.royale.core.UIBase
		 */
		private function getHost():UIBase
		{
			return _strand as UIBase;
		}

		private var _prevMonthButton:Button;
		/**
		 *  The button that causes the previous month to be displayed by the DateChooser.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.3
		 */
		public function get prevMonthButton():Button
		{
			return _prevMonthButton;
		}
		
		private var _nextMonthButton:Button;
		/**
		 *  The button that causes the next month to be displayed by the DateChooser.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.3
		 */
		public function get nextMonthButton():Button
		{
			return _nextMonthButton;
		}
		
		private var _dayList:DateChooserList;
		/**
		 *  The List of days to display
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.3
		 */
		public function get dayList():List
		{
			return _dayList;
		}
		
		// private const controlHeight:int = 26;
		// private const commonButtonWidth:int = 40;
		
		/**
		 * @private
		 */
		private function createChildren():void
		{
			// HEADER BUTTONS
			
			monthButtonsContainer = new Group();
			
			monthLabel = new Button();
			monthLabel.text = "Month Here";
			monthButtonsContainer.addElement(monthLabel);
			
			_prevMonthButton = new Button();
			_prevMonthButton.text = "<";
			monthButtonsContainer.addElement(_prevMonthButton);
			
			_nextMonthButton = new Button();
			_nextMonthButton.text = ">";
			monthButtonsContainer.addElement(_nextMonthButton);
			
			getHost().addElement(monthButtonsContainer, false);
			
			// DAY NAMES
			
			dayNamesContainer = new DateChooserHeader();
			//dayNamesContainer.id = "dateChooserDayNames";
			COMPILE::SWF {
			dayNamesContainer.percentWidth = 100;
			}
			
			getHost().addElement(dayNamesContainer, false);

			// DAYS
			
			_dayList = new DateChooserList();
			COMPILE::SWF {
			_dayList.percentWidth = 100;
			}
			getHost().addElement(_dayList, false);
			
			IEventDispatcher(_dayList).dispatchEvent( new Event("itemsCreated") );
			model.addEventListener("selectedDateChanged", selectionChangeHandler);

			// monthButtonsContainer.id = "dateChooserMonthButtons";
			// monthButtonsContainer.addBead(new HorizontalFlexLayout());
			// monthButtonsContainer.height = controlHeight;
			// monthButtonsContainer.style = new SimpleCSSStylesWithFlex();
			// monthButtonsContainer.style.flexGrow = 0;
			// COMPILE::JS {
			// 	monthButtonsContainer.element.style["flex-grow"] = "0";
			// }
			// _prevMonthButton.width = commonButtonWidth;
			// if (_prevMonthButton.style == null) {
			// 	_prevMonthButton.style = new SimpleCSSStylesWithFlex();
			// }
			// _prevMonthButton.style.flexGrow = 0;
			// COMPILE::JS {
			// 	_prevMonthButton.element.style["flex-grow"] = "0";
			// }
			
			// if (monthLabel.style == null) {
			// 	monthLabel.style = new SimpleCSSStylesWithFlex();
			// }
			// monthLabel.style.flexGrow = 1;
			// COMPILE::JS {
			// 	monthLabel.element.style["flex-grow"] = "1";
			// }
			
			// _nextMonthButton.width = commonButtonWidth;
			// if (_nextMonthButton.style == null) {
			// 	_nextMonthButton.style = new SimpleCSSStylesWithFlex();
			// }
			// COMPILE::JS {
			// 	_nextMonthButton.element.style["flex-grow"] = "0";
			// }
			//_nextMonthButton.style.flexGrow = 0;
			
			// dayNamesContainer.className = "DateChooserHeader";
			// dayNamesContainer.height = controlHeight;
			// dayNamesContainer.style = new SimpleCSSStylesWithFlex();
			// dayNamesContainer.style.flexGrow = 0;
			// COMPILE::JS {
			// 	dayNamesContainer.element.style["flex-grow"] = "0";
			// 	dayNamesContainer.element.style["align-items"] = "center";
			// }
			
			// _dayList.className = "DateChooserList";
			// _dayList.id = "dateChooserList";
			// _dayList.style = new SimpleCSSStylesWithFlex();
			// _dayList.style.flexGrow = 1;
			// COMPILE::JS {
			// 	_dayList.element.style["flex-grow"] = "1";
			// }
		}
		
		/**
		 * @private
		 */
		private function updateDisplay():void
		{
			monthLabel.text = model.monthNames[model.displayedMonth] + " " +
				String(model.displayedYear);

			dayNamesContainer.dataProvider = model.dayNames;

			_dayList.dataProvider = model.days;

			_dayList.selectedIndex = model.getIndexForSelectedDate();
		}

		/**
		 * @private
		 */
		private function selectionChangeHandler(event:Event):void
		{
			updateDisplay();

			getHost().dispatchEvent(new Event("selectedDateChanged"));
			getHost().dispatchEvent( new Event("change") );
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
