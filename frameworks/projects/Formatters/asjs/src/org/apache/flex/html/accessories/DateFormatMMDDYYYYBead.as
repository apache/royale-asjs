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
package org.apache.flex.html.accessories
{
	import org.apache.flex.core.IBead;
	import org.apache.flex.core.IDateChooserModel;
	import org.apache.flex.core.IFormatBead;
	import org.apache.flex.core.IStrand;
    import org.apache.flex.core.IStrandWithModel;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.EventDispatcher;
	import org.apache.flex.html.TextInput;
	import org.apache.flex.html.beads.DateFieldView;
	
	/**
	 * The DateFormatBead class formats the display of a DateField using MM/DD/YYYY format.
	 *  
     *  @flexjsignoreimport org.apache.flex.core.IStrandWithModel
     * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class DateFormatMMDDYYYYBead extends EventDispatcher implements IBead, IFormatBead
	{
		/**
		 * constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function DateFormatMMDDYYYYBead()
		{
		}
		
		private var _propertyName:String;
		private var _eventName:String;
		private var _formattedResult:String;
		
		/**
		 *  The name of the property on the model holding the value to be formatted.
		 *  The default is selectedDate.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get propertyName():String
		{
			if (_propertyName == null) {
				return "selectedDate";
			}
			return _propertyName;
		}
		public function set propertyName(value:String):void
		{
			_propertyName = value;
		}
		
		/**
		 *  The name of the event dispatched when the property changes. The
		 *  default is selectedDateChanged.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get eventName():String
		{
			if (_eventName == null) {
				return _propertyName+"Changed";
			}
			return _eventName;
		}
		public function set eventName(value:String):void
		{
			_eventName = value;
		}
		
		/**
		 *  The formatted result.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get formattedString():String
		{
			return _formattedResult;
		}
		
		private var _strand:IStrand;
		
		/**
		 *  @copy org.apache.flex.core.IBead#strand
		 *  
         *  @flexjsignorecoercion org.apache.flex.core.IStrandWithModel
         * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;
			
			var model:IDateChooserModel = IStrandWithModel(_strand).model as IDateChooserModel;
			model.addEventListener("selectedDateChanged",handleTextChange);
		}
		
		/**
		 * @private
         * 
         * @flexjsignorecoercion org.apache.flex.core.IStrandWithModel
		 */
		private function handleTextChange(event:Event):void
		{
			var model:IDateChooserModel = IStrandWithModel(_strand).model as IDateChooserModel;
			/*var view:DateFieldView = _strand.getBeadByType(DateFieldView) as DateFieldView;
			var input:TextInput = view.textInput;*/
			
			var d:Date = model.selectedDate;
			var month:String = String(d.getMonth()+1);
			if (Number(month)<10) month = "0"+month;
			var date:String = String(d.getDate());
			if (Number(date)<10) date = "0"+date;
			var fmt:String = month+"/"+date+"/"+String(d.getFullYear());
			/*input.text = fmt;*/
			_formattedResult = month+"/"+date+"/"+String(d.getFullYear());
			
			dispatchEvent( new Event("formatChanged") );
		}
		
	}
}
