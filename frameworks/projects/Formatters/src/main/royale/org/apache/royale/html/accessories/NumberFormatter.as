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
	
	/**
	 * The NumberFormatter class formats a value in separated groups. The formatter listens
	 * to a property on a model and when the property changes, formats it and dispatches a
	 * formatChanged event.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class NumberFormatter extends FormatBase
	{
		/**
		 *  constructor
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function NumberFormatter()
		{
			super();
		}
		
		private var _groupSize:Number = 3;
		private var _thousandsSeparator:String = ",";
		

		/**
		 *  Character to use to separate thousands groups. The default is
		 *  the comma (,).
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get thousandsSeparator():String
		{
			return _thousandsSeparator;
		}
		public function set thousandsSeparator(value:String):void
		{
			_thousandsSeparator = value;
		}
		
		/**
		 *  The formatted string.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		override public function format(value:Object):String
		{
			if (value == null) return "";
			
			var num:Number = Number(value);
			var source:String = String(value);
			var parts:Array = source.split(thousandsSeparator);
			source = parts.join("");
			
			var l:int = source.length;
			var result:String = "";
			var group:int = 0;
			
			for(var i:int=l-1; i >= 0; i--)
			{
				if (group == _groupSize && result.length > 0) {
					result = thousandsSeparator + result;
					group = 0;
				}
				result = source.charAt(i) + result;
				group++;
			}
			
			return result;
		}
	}
}
