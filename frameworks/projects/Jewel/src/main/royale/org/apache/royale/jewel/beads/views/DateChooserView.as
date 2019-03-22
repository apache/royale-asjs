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
	import org.apache.royale.collections.ArrayList;
	import org.apache.royale.core.ClassFactory;
	import org.apache.royale.core.IBeadModel;
	import org.apache.royale.core.IBeadView;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.html.beads.GroupView;
	import org.apache.royale.jewel.Button;
	import org.apache.royale.jewel.beads.models.DateChooserModel;
	import org.apache.royale.jewel.beads.views.TableView;
	import org.apache.royale.jewel.itemRenderers.DateItemRenderer;
	import org.apache.royale.jewel.supportClasses.datechooser.DateChooserTable;
	import org.apache.royale.jewel.supportClasses.table.TableColumn;
	import org.apache.royale.jewel.supportClasses.table.TableHeaderCell;
	import org.apache.royale.jewel.supportClasses.table.TableRow;
	import org.apache.royale.utils.loadBeadFromValuesManager;
	// import org.apache.royale.jewel.beads.controllers.TableCellSelectionMouseController;
	// import org.apache.royale.jewel.beads.controllers.DateChooserTableCellSelectionMouseController;

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
		 *  @productversion Royale 0.9.4
		 */
		public function DateChooserView()
		{
			super();
		}
		
		override public function set strand(value:IStrand):void
		{
			super.strand = value;

			model = loadBeadFromValuesManager(IBeadModel, "iBeadModel", _strand) as DateChooserModel;

			model.addEventListener("viewStateChanged", handleModelChange);//viewStateModelChange);

			model.addEventListener("firstDayOfWeekChanged", handleModelChange);
			model.addEventListener("dayNamesChanged", handleModelChange);
			model.addEventListener("displayedMonthChanged", handleModelChange);
			model.addEventListener("displayedYearChanged", handleModelChange);
			
			createChildren();
			updateDisplay();
		}
		
		private var model:DateChooserModel;
		
		/**
		 * @royaleignorecoercion org.apache.royale.core.UIBase
		 */
		private function getHost():UIBase
		{
			return _strand as UIBase;
		}

		private var _viewSelector:Button;
		/**
		 *  The button to display month and year
		 *  and select from a list of years
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function get viewSelector():Button
		{
			return _viewSelector;
		}

		private var _previousButton:Button;
		/**
		 *  The button that causes the previous month or year to be displayed by the DateChooser.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function get previousButton():Button
		{
			return _previousButton;
		}
		
		private var _nextButton:Button;
		/**
		 *  The button that causes the next month or year to be displayed by the DateChooser.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function get nextButton():Button
		{
			return _nextButton;
		}
		
		private var _table:DateChooserTable;
		/**
		 *  The DateChooserTable of days or years to display
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function get table():DateChooserTable
		{
			return _table;
		}
		
		/**
		 * @private
		 */
		private function createChildren():void
		{
			// HEADER BUTTONS
			_viewSelector = new Button();
			_viewSelector.className = "viewSelector";
			
			_previousButton = new Button();
			_previousButton.text = "<";
			_previousButton.className = "previousButton";
			
			_nextButton = new Button();
			_nextButton.text = ">";
			_nextButton.className = "nextButton";

			_table = new DateChooserTable();
			COMPILE::SWF {
			_table.percentWidth = 100;
			}
			getHost().addElement(_table, false);
			// var controller:TableCellSelectionMouseController = _table.getBeadByType(IBeadController) as TableCellSelectionMouseController;
			// _table.removeBead(controller);
			// _table.addBead(new DateChooserTableCellSelectionMouseController());
			
			IEventDispatcher(_table).dispatchEvent( new Event("itemsCreated") );
			model.addEventListener("selectedDateChanged", selectionChangeHandler);

			createButtonsRow();
		}

		private var buttonsRow:TableRow;
		private var viewSelectorTableHeaderCell:TableHeaderCell;

		private function createButtonsRow():void
		{
			var view:TableView = _table.getBeadByType(IBeadView) as TableView;
			buttonsRow = new TableRow();

			var tableHeader:TableHeaderCell = new TableHeaderCell();
			tableHeader.className = "buttonsRow";
			tableHeader.addElement(_viewSelector);
			tableHeader.expandColumns = 5;
			buttonsRow.addElement(tableHeader);
			viewSelectorTableHeaderCell = tableHeader; // to change colspan at a later time

			tableHeader= new TableHeaderCell();
			tableHeader.className = "buttonsRow";
			tableHeader.addElement(_previousButton);
			buttonsRow.addElement(tableHeader);
			
			tableHeader= new TableHeaderCell();
			tableHeader.className = "buttonsRow";
			tableHeader.addElement(_nextButton);
			buttonsRow.addElement(tableHeader);
		}
		
		// cycle days array for offsetting when change firstDayOfWeek
		private function cycleArray(array:Array, index:Number, n:Number):Number 
		{
			return ((index + n) % array.length + array.length) % array.length;
		}

		/**
		 * @private
		 */
		private function updateDisplay():void
		{
			viewSelectorDisplay();

			createColumns(); // do this only if change view state from 0 to 1-2 or viceversa
			
			daysDisplay();
			
			fillTable();
			
			selectCurrentDate();
		}

		private function viewSelectorDisplay():void
		{
			if(model.viewState == 0)
			{
				// display "FEB 2019"
				_viewSelector.text = model.monthNames[model.displayedMonth] + " " + String(model.displayedYear);
				viewSelectorTableHeaderCell.expandColumns = 5;
			} else if(model.viewState == 1)
			{
				// display "2016-2039"
				_viewSelector.text = String(model.displayedYear - 10) + "-" + String(model.displayedYear + 10);
				viewSelectorTableHeaderCell.expandColumns = 2;
			} else
			{
				// display "2017"
				_viewSelector.text = String(model.displayedYear);
				viewSelectorTableHeaderCell.expandColumns = 2;
			}
		}

		private var columns:Array;
		private var refreshColumns:Boolean;
		public const NUM_COLS_DAYS:int = 7;
		public const NUM_COLS_YEARS_OR_MONTHS:int = 4;

		/**
		 * Create 7 columns for calendar view (viewState = 0)
		 * or 4 columns for years or months view (viewState = 1 or 2)
		 */
		public function createColumns():void
		{
			var numCols:int = model.viewState == 0 ? NUM_COLS_DAYS : NUM_COLS_YEARS_OR_MONTHS;
			if(!refreshColumns)
			{
				columns = [];
				var dateItemRenderer:ClassFactory = new ClassFactory(DateItemRenderer);
				for (var i:int = 0; i < numCols; i++)
				{
					var column:TableColumn = new TableColumn();
					column.dataField = "d"+i;
					column.align = "center";
					column.itemRenderer = dateItemRenderer;
					columns.push(column);
				}
				//refreshColumns = true;
			}
		}

		/**
		 *  Only display days if viewState is calendar view (== 0)
		 */
		private function daysDisplay():void
		{
			var index:int, column:TableColumn;
			if(model.viewState == 0)
			{
				for(index = 0; index < NUM_COLS_DAYS; index++)
				{
					column = columns[index];
					column.columnLabelAlign = "center";
					column.label = model.dayNames[cycleArray(model.dayNames, index, model.firstDayOfWeek)];
				}
				_table.columns = columns;
			} else
			{ // viewState == 1 or 2
				for(index = 0; index < NUM_COLS_YEARS_OR_MONTHS; index++)
				{
					column = columns[index];
					// column.columnLabelAlign = "center";
					column.label = null; // all column labels == null means hide header
				}
				_table.columns = columns;
			}
		}

		/**
		 *  Only display days if viewState is calendar view (== 0)
		 */
		private function fillTable():void
		{
			var i:int, j:int;
			if(model.viewState == 0)
			{
				// fill table content with all current month days
				var currrentMonth:Array = [];
				var dayIndex:int = 0;
				for(i = 0; i < model.days.length/NUM_COLS_DAYS; i++)
				{
					currrentMonth[i] = {};
					for(j = 0; j < columns.length; j++)
					{
						currrentMonth[i]["d"+j] = model.days[dayIndex];
						dayIndex++;
					}
				}
				_table.dataProvider = new ArrayList(currrentMonth);
			} else if(model.viewState == 1) {
				trace("model.years",model.years);
				var currrentYearGroup:Array = [];
				var yearIndex:int = 0;
				for(i = 0; i < model.years.length/NUM_COLS_YEARS_OR_MONTHS; i++)
				{
					currrentYearGroup[i] = {};
					for(j = 0; j < columns.length; j++)
					{
						trace(yearIndex, model.years[yearIndex]);
						currrentYearGroup[i]["d"+j] = model.years[yearIndex];
						yearIndex++;
					}
				}
				_table.dataProvider = new ArrayList(currrentYearGroup);
			} else {
				var currrentYear:Array = [];
				var monthIndex:int = 0;
				for(i = 0; i < model.months.length/NUM_COLS_YEARS_OR_MONTHS; i++)
				{
					trace("model.months",model.months);
					currrentYear[i] = {};
					for(j = 0; j < columns.length; j++)
					{
						trace(monthIndex, model.months[monthIndex]);
						currrentYear[i]["d"+j] = model.months[monthIndex];
						monthIndex++;
					}
				}
				_table.dataProvider = new ArrayList(currrentYear);
			}

			// first row with nav buttons
			var view:TableView = _table.getBeadByType(IBeadView) as TableView;
			view.thead.addElementAt(buttonsRow, 0, false);
		}

		private function selectCurrentDate():void
		{
			if(model.viewState == 0)
			{
				_table.selectedIndex = model.getIndexForSelectedDate();
			} else if(model.viewState == 1) {
				
			} else {

			}	
		}

		/**
		 * @private
		 */
		private function selectionChangeHandler(event:Event):void
		{
			updateDisplay();

			getHost().dispatchEvent(new Event("selectedDateChanged"));
			getHost().dispatchEvent(new Event(Event.CHANGE));
		}

		/**
		 * @private
		 */
		private function handleModelChange(event:Event):void
		{
			updateDisplay();
		}
		
		/**
		 * @private
		 */
		// private function viewStateModelChange(event:Event):void
		// {
		// 	changeDisplay();
		// }

		/**
		 * @private
		 */
		// private function changeDisplay():void
		// {

		// }
	}
}
