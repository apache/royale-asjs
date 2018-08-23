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
package org.apache.royale.html.accessories
{
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IBeadModel;
	import org.apache.royale.core.Strand;
	import org.apache.royale.core.IDateChooserModel;
	import org.apache.royale.core.IFormatBead;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IStrandWithModel;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	
	/**
	 * The DateFormatter class wraps an IFormatBead and adds an hour.
	 *  
	 *  @royaleignoreimport org.apache.royale.core.IStrandWithModel
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.3
	 */
	public class DateAndTimeFormatter extends Strand implements IFormatBead
	{

		private var _formattedResult:String;
		private var _originalFormatter:IFormatBead;
		private var _model:IDateChooserModel;
		private var _strand:IStrand;
		/**
		 *  The name of the property on the model holding the value to be formatted.
		 *  The default is selectedDate.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.3
		 */
		public function get propertyName():String
		{
			return _originalFormatter.propertyName;
		}

		public function set propertyName(value:String):void
		{
			_originalFormatter.propertyName = value;
		}
		
		/**
		 *  The name of the event dispatched when the property changes. The
		 *  default is selectedDateChanged.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.3
		 */
		public function get eventName():String
		{
			return _originalFormatter.eventName;
		}

		public function set eventName(value:String):void
		{
			_originalFormatter.eventName = value;
		}

		/**
		 *  The formatted result.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.3
		 */
		public function get formattedString():String
		{
			return _formattedResult;
		}
		
		
		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @royaleignorecoercion org.apache.royale.core.IStrandWithModel
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.3
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;
			_model = IStrandWithModel(_strand).model as IDateChooserModel;
			if (_originalFormatter)
			{
				addBead(_originalFormatter);
			} else
			{
				_originalFormatter = getBeadByType(IFormatBead) as IFormatBead;
			}
			IEventDispatcher(_originalFormatter).addEventListener('formatChanged', formatChangedHandler);
		}
		
		/**
		 *  @copy org.apache.royale.core.UIBase#model
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.3
		 */
		override public function get model():IBeadModel
		{
			return _model;
		}

		override public function addBead(bead:IBead):void
		{
			if (model)
			{
				super.addBead(bead);
			} else
			{
				_originalFormatter = bead as IFormatBead;
			}
		}

		private function formatChangedHandler(event:Event):void
		{
			var dateResult:String = _originalFormatter.formattedString;
			var selectedDate:Date = _model.selectedDate;
			_formattedResult = getFormattedResult(selectedDate);
			dispatchEvent(new Event('formatChanged'));
		}

		protected function getFormattedResult(date:Date):String
		{
			var formattedHour:String = getFormattedHour(date);
			return _originalFormatter.formattedString + " " + formattedHour;
		}
		
		private function getNumberAsPaddedString(value:Number):String
		{
			return (value < 10 ? "0" : "") + value;
		}

		protected function getFormattedHour(date:Date):String
		{
			var hours:String = getNumberAsPaddedString(date.getHours());
			var minutes:String = getNumberAsPaddedString(date.getMinutes());
			var seconds:String = getNumberAsPaddedString(date.getSeconds());
			return hours + ":" + minutes + ":" + seconds;
		}
	}
}
