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
package org.apache.royale.html.beads.controllers
{
	import org.apache.royale.html.beads.DateChooserView;
	import org.apache.royale.html.beads.models.DateChooserModel;

 	import org.apache.royale.core.IBeadController;
 	import org.apache.royale.core.IBeadModel;
	import org.apache.royale.core.IBeadView;
 	import org.apache.royale.core.IStrand;
 	import org.apache.royale.events.Event;
 	import org.apache.royale.events.KeyboardEvent;
 	import org.apache.royale.events.IEventDispatcher;

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
	public class DateChooserKeyboardController extends CalendarNavigation implements IBeadController
	{
		/**
		 *  constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function DateChooserKeyboardController()
		{
		}
		
		private var _strand:IStrand;
		
		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;
			var view:DateChooserView = value.getBeadByType(IBeadView) as DateChooserView;
			IEventDispatcher(_strand).addEventListener(KeyboardEvent.KEY_DOWN, keyboardHandler);
		}

		private function keyboardHandler(event:KeyboardEvent):void
		{
			var model:DateChooserModel = _strand.getBeadByType(IBeadModel) as DateChooserModel;
			var changed:Boolean = false;
			var newDate:Date;

			switch (event.key) {
				case "ArrowUp":
					newDate = previousWeek(model);
					changed = true;
				break;
				case "ArrowDown":
					newDate = nextWeek(model);
					changed = true;
				break;
				case "ArrowLeft":
					newDate = previousDay(model);
					changed = true;
				break;
				case "ArrowRight":
					newDate = nextDay(model);
					changed = true;
				break;
			}

			if (changed) {
				model.selectedDate = newDate;
				IEventDispatcher(_strand).dispatchEvent( new Event("change") );
			}
		}
	}
}
