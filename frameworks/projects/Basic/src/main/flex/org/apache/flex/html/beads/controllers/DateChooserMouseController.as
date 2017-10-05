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
package org.apache.flex.html.beads.controllers
{	
	import org.apache.flex.html.beads.DateChooserView;
	import org.apache.flex.html.beads.models.DateChooserModel;
	import org.apache.flex.html.supportClasses.DateChooserButton;
    import org.apache.flex.html.supportClasses.DateChooserList;
	
	import org.apache.flex.core.IBeadController;
	import org.apache.flex.core.IBeadModel;
	import org.apache.flex.core.IBeadView;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.MouseEvent;
	import org.apache.flex.events.IEventDispatcher;
	
	/**
	 *  The DateChooserMouseController class is responsible for listening to
	 *  mouse event related to the DateChooser. Events such as selecting a date
	 *  or changing the calendar.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class DateChooserMouseController implements IBeadController
	{
		/**
		 *  constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function DateChooserMouseController()
		{
		}
		
		private var _strand:IStrand;
		
		/**
		 *  @copy org.apache.flex.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;
			
            var view:DateChooserView = value.getBeadByType(IBeadView) as DateChooserView;
			view.prevMonthButton.addEventListener("click", prevMonthClickHandler);
			view.nextMonthButton.addEventListener("click", nextMonthClickHandler);
			
            IEventDispatcher(view.dayList).addEventListener("change", listHandler);
		}
		
        private function listHandler(event:Event):void
        {
            var list:DateChooserList = event.target as DateChooserList;
            var model:DateChooserModel = _strand.getBeadByType(IBeadModel) as DateChooserModel;                     
            model.selectedDate = list.selectedItem as Date;
            IEventDispatcher(_strand).dispatchEvent( new Event("change") );
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
