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
package org.apache.royale.html.beads
{
	import org.apache.royale.core.BeadViewBase;
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IBeadModel;
	import org.apache.royale.core.IBeadView;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.SimpleCSSStylesWithFlex;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.core.ValuesManager;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.html.Container;
	import org.apache.royale.html.Group;
	import org.apache.royale.html.List;
	import org.apache.royale.html.TextButton;
	import org.apache.royale.html.beads.GroupView;
	import org.apache.royale.html.beads.layouts.HorizontalLayout;
	import org.apache.royale.html.beads.layouts.HorizontalFlexLayout;
	import org.apache.royale.html.beads.layouts.TileLayout;
	import org.apache.royale.html.beads.models.DateChooserModel;
	import org.apache.royale.html.supportClasses.DateHeaderButton;
	import org.apache.royale.html.supportClasses.DateChooserHeader;
	import org.apache.royale.html.supportClasses.DateChooserList;
	import org.apache.royale.utils.loadBeadFromValuesManager;

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
		 *  @productversion Royale 0.0
		 */
		public function DateChooserView()
		{
			super();
		}
		
		/**
		 * 	@royaleignorecoercion org.apache.royale.html.beads.models.DateChooserModel
		 */
		override public function set strand(value:IStrand):void
		{
			super.strand = value;

			model = loadBeadFromValuesManager(IBeadModel, "iBeadModel", _strand) as DateChooserModel;

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
		 * @royaleignorecoercion org.apache.royale.core.UIBase
		 */
		private function getHost():UIBase
		{
			return _strand as UIBase;
		}
		/**
		 *  The button that causes the previous month to be displayed by the DateChooser.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
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
		 *  @productversion Royale 0.0
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
		 * @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 */
		private function createChildren():void
		{
			// HEADER BUTTONS
			
			monthButtonsContainer = new Group();
			monthButtonsContainer.addBead(new HorizontalFlexLayout());
			monthButtonsContainer.height = controlHeight;
			monthButtonsContainer.id = "dateChooserMonthButtons";
			monthButtonsContainer.style = new SimpleCSSStylesWithFlex();
			monthButtonsContainer.style.flexGrow = 0;
			COMPILE::JS {
				monthButtonsContainer.element.style["flex-grow"] = "0";
			}
			
			_prevMonthButton = new DateHeaderButton();
			_prevMonthButton.width = commonButtonWidth;
			_prevMonthButton.text = "<";
			if (_prevMonthButton.style == null) {
				_prevMonthButton.style = new SimpleCSSStylesWithFlex();
			}
			_prevMonthButton.style.flexGrow = 0;
			COMPILE::JS {
				_prevMonthButton.element.style["flex-grow"] = "0";
			}
			monthButtonsContainer.addElement(_prevMonthButton);
			
			monthLabel = new DateHeaderButton();
			monthLabel.text = "Month Here";
			if (monthLabel.style == null) {
				monthLabel.style = new SimpleCSSStylesWithFlex();
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
				_nextMonthButton.style = new SimpleCSSStylesWithFlex();
			}
			COMPILE::JS {
				_nextMonthButton.element.style["flex-grow"] = "0";
			}
			_nextMonthButton.style.flexGrow = 0;
			monthButtonsContainer.addElement(_nextMonthButton);
			
			getHost().addElement(monthButtonsContainer, false);
			
			// DAY NAMES
			
			dayNamesContainer = new DateChooserHeader();
			dayNamesContainer.id = "dateChooserDayNames";
			dayNamesContainer.className = "DateChooserHeader";
			dayNamesContainer.height = controlHeight;
			dayNamesContainer.style = new SimpleCSSStylesWithFlex();
			dayNamesContainer.style.flexGrow = 0;
			COMPILE::JS {
				dayNamesContainer.element.style["flex-grow"] = "0";
				dayNamesContainer.element.style["align-items"] = "center";
			}
			COMPILE::SWF {
				dayNamesContainer.percentWidth = 100;
			}
			getHost().addElement(dayNamesContainer, false);
			
			// DAYS
			
			daysContainer = new DateChooserList();
			daysContainer.className = "DateChooserList";
			daysContainer.id = "dateChooserList";
			daysContainer.style = new SimpleCSSStylesWithFlex();
			daysContainer.style.flexGrow = 1;
			COMPILE::JS {
				daysContainer.element.style["flex-grow"] = "1";
			}
			COMPILE::SWF {
				daysContainer.percentWidth = 100;
			}
			getHost().addElement(daysContainer, false);
			
			
			(daysContainer as IEventDispatcher).dispatchEvent( new Event("itemsCreated") );
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

			daysContainer.selectedIndex = model.getIndexForSelectedDate()
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
