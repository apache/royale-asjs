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
	import org.apache.royale.core.IDateChooserModel;
	import org.apache.royale.core.IFormatBead;
	import org.apache.royale.core.IStrand;
    import org.apache.royale.core.IStrandWithModel;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.EventDispatcher;
	
	/**
	 * The DateFormatBead class formats the display of a DateField using a format.
	 *  
     *  @royaleignoreimport org.apache.royale.core.IStrandWithModel
     * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.8
	 */
	public class SimpleDateFormatBead extends EventDispatcher implements IBead, IFormatBead
	{
		/**
		 * constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
		public function SimpleDateFormatBead()
		{
		}

		private var _format:String;
		private var _seperator:String;
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
		 *  @productversion Royale 0.8
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
		 *  @productversion Royale 0.8
		 */
		public function get eventName():String
		{
			if (_eventName == null) {
				return propertyName+"Changed";
			}
			return _eventName;
		}

		public function set eventName(value:String):void
		{
			_eventName = value;
		}

		/**
		 *  The format of the date string.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
		public function get format():String
		{
			if (_format == null) {
                _format = "YYYY/MM/DD";
                _seperator = "/";
            }
			return _format;
		}

		public function set format(value:String):void
		{
			if (_format != value) {
                _format = value;

				var length:int = _format.length;

                for (var i:int = 0; i < length; i++) {
					var letter:String = _format.charAt(i);
                    // assumes a single separator
                    if (letter != 'M' && letter != 'Y' && letter != 'D') {
                        _seperator = letter;
						break;
                    }
                }
                _format = value;
            }
		}
		
		/**
		 *  The formatted result.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
		public function get formattedString():String
		{
			return _formattedResult;
		}
		
		private var _strand:IStrand;
		
		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
         *  @royaleignorecoercion org.apache.royale.core.IStrandWithModel
         * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;
			
			var model:IDateChooserModel = IStrandWithModel(_strand).model as IDateChooserModel;
			model.addEventListener(propertyName+"Changed",handleTextChange);
		}
		
		/**
		 * @private
         * 
         * @royaleignorecoercion org.apache.royale.core.IStrandWithModel
		 */
		private function handleTextChange(event:Event):void
		{
			var model:IDateChooserModel = IStrandWithModel(_strand).model as IDateChooserModel;
			
			var selectedDate:Date = model.selectedDate;
			if (selectedDate != null) {
				var month:String = String(selectedDate.getMonth()+1);
				var day:String = String(selectedDate.getDate());
				var year:String = String(selectedDate.getFullYear());
				var tokens:Array = _format.split(_seperator);
				var length:int = tokens.length;

				_formattedResult = "";
				
				for (var i:int = 0; i < length; i++) {
                    switch (tokens[i]) {
                        case "YYYY":
                            _formattedResult += year;
                            break;
                        case "YY":
							_formattedResult += year.slice(2,3);
                            break;
                        case "MM":
                            if (Number(month) < 10)
                                month = "0" + month;
                        case "M":
							_formattedResult += month;
                            break;
                        case "DD":
                            if (Number(day) < 10)
                                day = "0" + day;
                        case "D":
							_formattedResult += day;
                            break;
                    }

                    if (i <= length - 2) {
						_formattedResult += _seperator;
					}
				}

				dispatchEvent(new Event("formatChanged") );
			}
		}
		
	}
}
