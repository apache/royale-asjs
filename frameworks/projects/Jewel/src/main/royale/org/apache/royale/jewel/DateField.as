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
	import org.apache.royale.core.IDateControlConfigBead;
	import org.apache.royale.core.IFormatter;
	import org.apache.royale.core.StyledUIBase;
	import org.apache.royale.events.Event;
	import org.apache.royale.utils.loadBeadFromValuesManager;
	import org.apache.royale.jewel.beads.views.DateFieldView;
	
	/**
	 * The change event is dispatched when the selectedDate is changed.
	 */
	[Event(name="change", type="org.apache.royale.events.Event")]

	/**
     *  Dispatched when the popup is opened.
     *
     *  @toplevel
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.8
     */
	[Event(name="popUpOpened", type="org.apache.royale.events.Event")]
	
	/**
     *  Dispatched when the popup is closed.
     *
     *  @toplevel
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.8
     */
	[Event(name="popUpClosed", type="org.apache.royale.events.Event")]
	
	/**
	 * The DateField class provides an input field where a date can be entered
	 * and a pop-up calendar control for picking a date as an alternative to
	 * the text field.
	 *  
     *  @toplevel
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.4
	 */
	public class DateField extends StyledUIBase
	{
		/**
		 *  constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function DateField()
		{
			super();
			
			typeNames = "jewel datefield";
		}
		
		/**
		 * The method called when added to a parent. The DateField class uses
		 * this opportunity to install additional beads.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		override public function addedToParent():void
		{
			super.addedToParent();
			loadBeadFromValuesManager(IFormatter, "iFormatter", this);
			
			loadBeadFromValuesManager(IDateControlConfigBead, "iDateControlConfigBead", this);

			dispatchEvent(new Event("initComplete"));
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
		private var _dateFormat:String;

		/**
		 *  A Date format using D for Days, M for Months and Y for Year i.e. DD/MM/YYYY
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.6
		 */
		public function get dateFormat():String
		{
			return _dateFormat;
		}

		public function set dateFormat(value:String):void
		{
			_dateFormat = value.toUpperCase();
		}
		
		//----------------------------------
		//  formatString
		//----------------------------------

		/**
		 *  @private
		 *  Storage for the formatString property.
		 */
		// private var _formatString:String = "MM/DD/YYYY";

		// [Bindable("formatStringChanged")]
		// [Inspectable(defaultValue="null")]

		// /**
		 // *  @private
		 // */
		// private var formatStringOverride:String;
		
		/**
		 *  The format of the displayed date in the text field.
		 *  This property can contain any combination of <code>"M"</code>,
		 *  <code>"MM"</code>, <code>"MMM"</code> (3 letter month names),
		 *  <code>"MMMM"</code> (month names), <code>"D"</code>, <code>"DD"</code>,
		 *  <code>"YY"</code>, <code>"YYYY"</code>,
		 *  delimiter, and punctuation characters.
		 *  
		 *  <p>Only upper case characters are supported.</p>
		 * 
		 *  @default "MM/DD/YYYY"
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		// public function get formatString():String
		// {
			// return _formatString;
		// }

		// /**
		 // *  @private
		 // */
		// public function set formatString(value:String):void
		// {
			// formatStringOverride = value;

			// if (value != _formatString)
			// {
				// _formatString = value /* != null ?
							// value :
							// resourceManager.getString(
								// "SharedResources", "dateFormat")*/;
				// var formatter:IBead = getBeadByType(IFormatter);
				// if (formatter)
					// removeBead(formatter);
				// if (value == "MM/DD/YYYY")
					// addBead(new DateFormatMMDDYYYY());
				// else if (value == "DD/MM/YYYY")
					// addBead(new DateFormatDDMMYYYY());
				// else if (value == "YYYY/MM/DD")
					// addBead(new DateFormatYYYYMMDD());
			// }
		// }
		
		/**
		 *  @private
		 */
		public function get text():String
		{
			// var s:String = ((view as DateFieldView).textInputField as TextInput).text;
			// return s == null ? "" : s;
			return "";
		}
	   
		/**
		 *  @private
		 */
		public function set text(value:String):void
		{
			// ((view as DateFieldView).textInputField as TextInput).text = value == null ? "" : value;
		}
}
}
