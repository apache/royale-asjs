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
package org.apache.royale.jewel.beads.controls.datechooser
{
	import org.apache.royale.core.DispatcherBead;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.events.MouseEvent;
	import org.apache.royale.jewel.beads.controls.Disabled;
	import org.apache.royale.jewel.beads.itemRenderers.ITextItemRenderer;
	import org.apache.royale.jewel.beads.models.DateChooserModel;
	import org.apache.royale.jewel.beads.views.DateChooserView;
	import org.apache.royale.jewel.supportClasses.datechooser.DateChooserTable;
	import org.apache.royale.jewel.supportClasses.table.TBodyContentArea;
	import org.apache.royale.jewel.supportClasses.table.TableCell;
	import org.apache.royale.jewel.supportClasses.table.TableRow;

	/**
	 *  Disable dates which are outside restriction provided by minDate and maxDate properties
	 *  in DateChooser component. User can set just one restriction (minDate or maxDate), or both
	 *  for a complete Range.
	 * 
	 *  If a selectionDate is set this bead doesn't affect it and the component just represent the selected
	 *  date as disabled. An extension could be done to remove selectedDate and not allow selections on
	 *  ranges outside the restriction.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.8
	 */
	public class DateChooserDateRangeRestriction extends DispatcherBead
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.8
		 */
		public function DateChooserDateRangeRestriction()
		{
		}

		private var _minDate:Date;
		/**
		 *  The minimun date
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.8
		 */
		[Bindable]
		public function get minDate():Date
		{
			return _minDate;
		}
		public function set minDate(value:Date):void
		{
			if (_minDate != value)
			{
				_minDate = value;
				refreshDateRange();
			}
		}

		private var _maxDate:Date;
		/**
		 *  The maximun date
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.8
		 */
		[Bindable]
		public function get maxDate():Date
		{
			return _maxDate;
		}
		public function set maxDate(value:Date):void
		{
			if (_maxDate != value)
			{
				_maxDate = value;
				refreshDateRange();
			}
		}

		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.8
		 *  @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 */
		public override function set strand(value:IStrand):void
		{
			super.strand = value;
			(_strand as IEventDispatcher).addEventListener("initComplete", handleDateChooserInitComplete);
		}

		private var model:DateChooserModel;
		private var view:DateChooserView;
		private var table:DateChooserTable;
		private var tableContent:TBodyContentArea;

		private function handleDateChooserInitComplete(event:Event):void
		{
			(_strand as IEventDispatcher).removeEventListener("initComplete", handleDateChooserInitComplete);
			setUpBead();
		}

		public function setUpBead():void
		{
			model = _strand.getBeadByType(DateChooserModel) as DateChooserModel;

			view = _strand.getBeadByType(DateChooserView) as DateChooserView;
			view.previousButton.addEventListener(MouseEvent.CLICK, refreshDateRange);
			view.nextButton.addEventListener(MouseEvent.CLICK, refreshDateRange);
			view.viewSelector.addEventListener(MouseEvent.CLICK, refreshDateRange);

			refreshDateRange();
		}

		public function refreshDateRange():void
		{
			if (!view)
				return;

			if (view.table)
				view.table.removeEventListener(Event.CHANGE, refreshDateRange);
			table = view.table;
			view.table.addEventListener(Event.CHANGE, refreshDateRange);
			tableContent = table.getBeadByType(TBodyContentArea) as TBodyContentArea;

			var n:int = table.dataProvider.length;
			for (var i:int = 0; i < tableContent.numElements; i++)
			{
				var row:TableRow = tableContent.getElementAt(i) as TableRow;
				for (var j:int = 0; j < row.numElements; j++)
				{
					var tableCell:TableCell = row.getElementAt(j) as TableCell;
					var renderer:ITextItemRenderer  = tableCell.getElementAt(0) as ITextItemRenderer;
					disableRenderer(renderer);
				}
			}
		}

		/**
		 *  <code>true</code> if the date1's year is less than date2's year.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.8
		 */
		private function isLessThanYear(date1:Date, date2:Date):Boolean
		{
			return date1.getYear() < date2.getYear();
		}

		/**
		 *  <code>true</code> if the date1's month is less than date2's month.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.8
		 */
		private function isLessThanMonth(date1:Date, date2:Date):Boolean
		{
			return date1.getYear() == date2.getYear() && date1.getMonth() < date2.getMonth();
		}

		/**
		 *  <code>true</code> if the date1's day is less than date2's day.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.8
		 */
		private function isLessThanDay(date1:Date, date2:Date):Boolean
		{
			return date1.getYear() == date2.getYear() && date1.getMonth() == date2.getMonth() && date1.getDate() < date2.getDate();
		}

		private function disableRenderer(renderer:ITextItemRenderer):void
		{
			var rendererDate:Date = renderer.data[renderer.labelField];
			if (!rendererDate)
				return;

			var disabled:Disabled = (renderer as IStrand).getBeadByType(Disabled) as Disabled;
			if (disabled == null)
			{
				disabled = new Disabled();
				(renderer as IStrand).addBead(disabled);
			}

			if (model.viewState == 0) // Day view
			{
				if (minDate && maxDate)
					disabled.disabled = isLessThanDay(rendererDate, minDate) && isLessThanDay(maxDate, rendererDate);
				else if (minDate)
					disabled.disabled = isLessThanDay(rendererDate, minDate);
				else if (maxDate)
					disabled.disabled = isLessThanDay(maxDate, rendererDate);
			}
			else if (model.viewState == 1) // Year view
			{
				if (minDate && maxDate)
					disabled.disabled = isLessThanYear(rendererDate, minDate) && isLessThanYear(maxDate, rendererDate);
				else if (minDate)
					disabled.disabled = isLessThanYear(rendererDate, minDate);
				else if (maxDate)
					disabled.disabled = isLessThanYear(maxDate, rendererDate);
			}
			else if (model.viewState == 2) // Month view
			{
				if (minDate && maxDate)
					disabled.disabled = isLessThanMonth(rendererDate, minDate) && isLessThanMonth(maxDate, rendererDate);
				else if (minDate)
					disabled.disabled = isLessThanMonth(rendererDate, minDate);
				else if (maxDate)
					disabled.disabled = isLessThanMonth(maxDate, rendererDate);
			}

			// ensure no selection remains in dates out of the range
			// if(disabled.disabled)
			// {
			// 	var selectionBead:ISelectableItemRenderer = getSelectionRenderBead(renderer);
			// 	if(selectionBead && selectionBead.selected)
			// 		selectionBead.selected = false;
			// }
		}
	}
}