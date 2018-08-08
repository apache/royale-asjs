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
	import org.apache.royale.jewel.supportClasses.table.TableRow;
	import org.apache.royale.jewel.supportClasses.table.TableHeaderCell;
	import org.apache.royale.jewel.supportClasses.table.TableColumn;
	import org.apache.royale.utils.loadBeadFromValuesManager;

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
		
		/**
		 * @royaleignorecoercion org.apache.royale.core.UIBase
		 */
		private function getHost():UIBase
		{
			return _strand as UIBase;
		}

		private var _monthLabel:Button;
		/**
		 *  The button to display month and year
		 *  and select from a list of years
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.3
		 */
		public function get monthLabel():Button
		{
			return _monthLabel;
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
		
		private var _daysTable:DateChooserTable;
		/**
		 *  The DateChooserTable of days to display
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.3
		 */
		public function get daysTable():DateChooserTable
		{
			return _daysTable;
		}
		
		/**
		 * @private
		 */
		private function createChildren():void
		{
			// HEADER BUTTONS
			_monthLabel = new Button();
			_monthLabel.text = "Month Here";
			
			_prevMonthButton = new Button();
			_prevMonthButton.text = "<";
			
			_nextMonthButton = new Button();
			_nextMonthButton.text = ">";

			// DAYS
			createColumns();

			_daysTable = new DateChooserTable();
			COMPILE::SWF {
			_daysTable.percentWidth = 100;
			}
			getHost().addElement(_daysTable, false);
			
			IEventDispatcher(_daysTable).dispatchEvent( new Event("itemsCreated") );
			model.addEventListener("selectedDateChanged", selectionChangeHandler);

			createButtonsRow();
		}

		private var buttonsRow:TableRow;

		private function createButtonsRow():void
		{
			var view:TableView = _daysTable.getBeadByType(IBeadView) as TableView;
			buttonsRow = new TableRow();

			var tableHeader:TableHeaderCell = new TableHeaderCell();
			tableHeader.className = "buttonsRow";
			tableHeader.addElement(_monthLabel);
			tableHeader.expandColumns = 5;
			buttonsRow.addElement(tableHeader);

			tableHeader= new TableHeaderCell();
			tableHeader.className = "buttonsRow";
			tableHeader.addElement(_prevMonthButton);
			buttonsRow.addElement(tableHeader);
			
			tableHeader= new TableHeaderCell();
			tableHeader.className = "buttonsRow";
			tableHeader.addElement(_nextMonthButton);
			buttonsRow.addElement(tableHeader);
		}
		
		private var columns:Array;
		private var dayNamesInit:Boolean;

		public function createColumns():void
		{
			if(!dayNamesInit)
			{
				columns = [];
				var dateItemRenderer:ClassFactory = new ClassFactory(DateItemRenderer);
				for (var i:int = 0; i < 7; i++)
				{
					var column:TableColumn = new TableColumn();
					column.dataField = "d"+i;
					column.align = "center";
					column.itemRenderer = dateItemRenderer;
					columns.push(column);
				}

				dayNamesInit = true;
			}
		}

		/**
		 * @private
		 */
		private function updateDisplay():void
		{
			_monthLabel.text = model.monthNames[model.displayedMonth] + " " + String(model.displayedYear);

			var len:int = columns.length;
			for(var index:int = 0; index < len; index++)
			{
				var column:TableColumn = columns[index];
				column.label = model.dayNames[index];
			}

			_daysTable.columns = columns;


			var currrentMonth:Array = [];
			var dayIndex:int = 0;
			for(var i:int = 0; i < model.days.length/7; i++)
			{
				currrentMonth[i] = {};
				for(var j:int = 0; j < columns.length; j++)
				{
					currrentMonth[i]["d"+j] = model.days[dayIndex];
					dayIndex++;
				}
			}
			_daysTable.dataProvider = new ArrayList(currrentMonth);
			_daysTable.dispatchEvent( new Event("tableComplete") );

			_daysTable.selectedIndex = model.getIndexForSelectedDate();
			
			var view:TableView = _daysTable.getBeadByType(IBeadView) as TableView;
			view.thead.addElementAt(buttonsRow, 0, false);
			
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
