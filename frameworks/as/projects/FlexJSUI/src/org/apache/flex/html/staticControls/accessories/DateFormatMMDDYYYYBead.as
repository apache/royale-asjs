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
package org.apache.flex.html.staticControls.accessories
{
	import org.apache.flex.core.IBead;
	import org.apache.flex.core.IDateChooserModel;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.events.Event;
	import org.apache.flex.html.staticControls.TextInput;
	import org.apache.flex.html.staticControls.beads.DateFieldView;
	
	/**
	 * The DateFormatBead class formats the display of a DateField using MM/DD/YYYY format.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class DateFormatMMDDYYYYBead implements IBead
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
		
		private var _strand:IStrand;
		
		/**
		 *  @copy org.apache.flex.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;
			
			var model:IDateChooserModel = _strand.getBeadByType(IDateChooserModel) as IDateChooserModel;
			model.addEventListener("selectedDateChanged",handleTextChange);
		}
		
		/**
		 * @private
		 */
		private function handleTextChange(event:Event):void
		{
			var model:IDateChooserModel = _strand.getBeadByType(IDateChooserModel) as IDateChooserModel;
			var view:DateFieldView = _strand.getBeadByType(DateFieldView) as DateFieldView;
			var input:TextInput = view.textInput;
			
			var d:Date = model.selectedDate;
			var month:String = String(d.getMonth()+1);
			if (Number(month)<10) month = "0"+month;
			var date:String = String(d.getDate());
			if (Number(date)<10) date = "0"+date;
			var fmt:String = month+"/"+date+"/"+String(d.getFullYear());
			input.text = fmt;
		}
		
	}
}