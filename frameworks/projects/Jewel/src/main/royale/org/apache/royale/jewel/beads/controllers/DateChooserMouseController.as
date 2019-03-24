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
package org.apache.royale.jewel.beads.controllers
{	
	import org.apache.royale.core.IBeadController;
	import org.apache.royale.core.IBeadModel;
	import org.apache.royale.core.IBeadView;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.events.MouseEvent;
	import org.apache.royale.jewel.beads.models.DateChooserModel;
	import org.apache.royale.jewel.beads.views.DateChooserView;
	import org.apache.royale.jewel.supportClasses.datechooser.DateChooserTable;
	
	/**
	 *  The DateChooserMouseController class is responsible for listening to
	 *  mouse event related to the DateChooser. Events such as selecting a date
	 *  or changing the calendar.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.4
	 */
	public class DateChooserMouseController implements IBeadController
	{
		/**
		 *  constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function DateChooserMouseController()
		{
		}

		private var model:DateChooserModel;
		
		private var _strand:IStrand;
		
		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;
			
            model = _strand.getBeadByType(IBeadModel) as DateChooserModel;
			                   
            var view:DateChooserView = value.getBeadByType(IBeadView) as DateChooserView;
			view.previousButton.addEventListener(MouseEvent.CLICK, previousButtonClickHandler);
			view.nextButton.addEventListener(MouseEvent.CLICK, nextButtonClickHandler);
			view.viewSelector.addEventListener(MouseEvent.CLICK, viewSelectorClickHandler);
			
            IEventDispatcher(view.table).addEventListener(Event.CHANGE, tableHandler);
		}

		/**
		 * 
		 * @private
		 */
		private function previousButtonClickHandler(event:MouseEvent):void
		{
            event.preventDefault();
            
			var month:Number = model.displayedMonth - 1;
			var year:Number  = model.displayedYear;
			
			if(model.viewState == 0)
			{
				if (month < 0) {
					month = 11;
					year--;
				}
				model.displayedMonth = month;
				model.displayedYear = year;
			} else if(model.viewState == 1) {
				model.navigateYears = model.navigateYears - DateChooserModel.NUM_YEARS_VIEW;
			} else {
				model.displayedYear = --year;
			}
		}
		
		/**
		 * 
		 * @private
		 */
		private function nextButtonClickHandler(event:MouseEvent):void
		{
            event.preventDefault();
            
			var month:Number = model.displayedMonth + 1;
			var year:Number  = model.displayedYear;
			
			if(model.viewState == 0)
			{
				if (month >= 12) {
					month = 0;
					year++;
				}
				model.displayedMonth = month;
				model.displayedYear = year;
			} else if(model.viewState == 1) {
				model.navigateYears = model.navigateYears + DateChooserModel.NUM_YEARS_VIEW;
			} else {
				model.displayedYear = ++year;
			}
		}

		/**
		 * Navigate from days to years. And from years to days
		 * @private
		 */
		private function viewSelectorClickHandler(event:MouseEvent):void
		{
			event.preventDefault();
			
			model.viewState = model.viewState == 0 ? 1 : 0;
		}

		/**
		 * 
		 * @private
		 */
        private function tableHandler(event:Event):void
        {
            var table:DateChooserTable = event.target as DateChooserTable;
			var date:Date = table.selectedItemProperty as Date;

			if(model.viewState == 0)
			{
				model.selectedDate = date;
			} else 
			if(model.viewState == 1) {
				model.changeYear(date.getFullYear());
			} else {
				model.changeMonth(date.getMonth());
			}
        }
	}
}
