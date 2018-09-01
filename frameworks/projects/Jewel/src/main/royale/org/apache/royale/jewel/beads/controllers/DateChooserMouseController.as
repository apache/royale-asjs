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
			view.prevMonthButton.addEventListener(MouseEvent.CLICK, prevMonthClickHandler);
			view.nextMonthButton.addEventListener(MouseEvent.CLICK, nextMonthClickHandler);
			
            IEventDispatcher(view.daysTable).addEventListener(Event.CHANGE, tableHandler);
		}

		private var model:DateChooserModel;
		
        private function tableHandler(event:Event):void
        {
            var table:DateChooserTable = event.target as DateChooserTable;
            model.selectedDate = table.selectedItemProperty as Date;
        }

		/**
		 * @private
		 */
		private function prevMonthClickHandler(event:MouseEvent):void
		{
            event.preventDefault();
            
			var model:DateChooserModel = _strand.getBeadByType(IBeadModel) as DateChooserModel;
			var month:Number = model.displayedMonth - 1;
			var year:Number  = model.displayedYear;
			if (month < 0) {
				month = 11;
				year--;
			}
			model.displayedMonth = month;
			model.displayedYear = year;
		}
		
		/**
		 * @private
		 */
		private function nextMonthClickHandler(event:MouseEvent):void
		{
            event.preventDefault();
            
			var model:DateChooserModel = _strand.getBeadByType(IBeadModel) as DateChooserModel;
			var month:Number = model.displayedMonth + 1;
			var year:Number  = model.displayedYear;
			if (month >= 12) {
				month = 0;
				year++;
			}
			model.displayedMonth = month;
			model.displayedYear = year;
		}
		
	}
}
