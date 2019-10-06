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
	import org.apache.royale.core.FormatBase;
	import org.apache.royale.core.IDateFormatter;
	
	/**
	 * The DateFormatter class formats the display of a DateField using a dateFormat.
	 *  
     *  @royaleignoreimport org.apache.royale.core.IStrandWithModel
     * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.6
	 */
	public class SimpleDateFormatter extends FormatBase implements IDateFormatter
	{
		/**
		 * constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
		public function SimpleDateFormatter()
		{
		}

		private var _dateFormat:String;
		protected var _separator:String;
		
		/**
		 *  The dateFormat of the date string.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.6
		 */
		public function get dateFormat():String
		{
			if (_dateFormat == null) {
                _dateFormat = "YYYY/MM/DD";
                _separator = "/";
            }
			return _dateFormat;
		}

		public function set dateFormat(value:String):void
		{
			if (_dateFormat != value) {
                _dateFormat = value;

				var length:int = _dateFormat.length;

                for (var i:int = 0; i < length; i++) {
					var letter:String = _dateFormat.charAt(i);
                    // assumes a single separator
                    if (letter != 'M' && letter != 'Y' && letter != 'D') {
                        _separator = letter;
						break;
                    }
                }
                _dateFormat = value;
            }
		}
		

		/**
		 *  The formatted date
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.6
         *  @royaleignorecoercion Date
		 */
		override public function format(value:Object):String
		{
			
			var selectedDate:Date = value as Date;
			var result:String = "";

			if (selectedDate != null) {
				var month:String = String(selectedDate.getMonth()+1);
				var day:String = String(selectedDate.getDate());
				var year:String = String(selectedDate.getFullYear());
				var tokens:Array = dateFormat.split(_separator);
				var length:int = tokens.length;

				
				for (var i:int = 0; i < length; i++) {
                    switch (tokens[i]) {
                        case "YYYY":
                            result += year;
                            break;
                        case "YY":
							result += year.slice(2,3);
                            break;
                        case "MM":
                            if (Number(month) < 10)
                                month = "0" + month;
                        case "M":
							result += month;
                            break;
                        case "DD":
                            if (Number(day) < 10)
                                day = "0" + day;
                        case "D":
							result += day;
                            break;
                    }

                    if (i <= length - 2) {
						result += _separator;
					}
				}

			}
			return result;
		}
		
		/**
		 *  Returns a Date created from a date string
		 *  
		 *  @param str, the date formated string. Some examples of valid formats are MM/DD/YYYY, DD/MM/YYYY
		 *  @return the date object generated from the string or null
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.6
		 */
		public function getDateFromString(str:String):Date
		{
			if (str != null) {
				var month:int;
				var day:int;
				var year:int;
				var tokens:Array = dateFormat.split(_separator);
				var strtokens:Array = str.split(_separator);
				var length:int = tokens.length;
				
				for (var i:int = 0; i < length; i++) {
                    switch (tokens[i]) {
                        case "YYYY":
                            year = int(strtokens[i]);
				            break;
                        case "YY":
							year = 2000 + int(strtokens[i]);
				            break;
                        case "MM" || "M":
							month = int(strtokens[i]) - 1;
				            break;
                        case "DD" || "D":
							day = int(strtokens[i]);
				            break;
                    }
				}
				
				return new Date(year, month, day);
			}
			return null;
		}
	}
}
