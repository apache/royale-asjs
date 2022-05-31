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
package org.apache.royale.jewel
{
	import org.apache.royale.core.IDateChooserModel;
	import org.apache.royale.jewel.Group;
	import org.apache.royale.core.IPopUp;

	/**
	 * The change event is dispatched when the selectedDate is changed.
	 */
	[Event(name="change", type="org.apache.royale.events.Event")]

	/**
	 *  The DateChooser class is a component that displays a calendar.
	 *
     *  @toplevel
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.4
	 */
	public class DateChooser extends Group implements IPopUp
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function DateChooser()
		{
			super();

			typeNames = "jewel datechooser";

			// default to today
			selectedDate = new Date();
		}

		[Bindable("selectedDateChanged")]
		/**
		 *  The currently selected date (or null if no date has been selected).
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function get selectedDate():Date
		{
			return IDateChooserModel(model).selectedDate;
		}
		public function set selectedDate(value:Date):void
		{
			IDateChooserModel(model).selectedDate = value;
		}
	}
}
