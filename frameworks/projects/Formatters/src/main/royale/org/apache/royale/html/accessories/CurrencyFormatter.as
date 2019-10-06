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
	 * The CurrencyFormatter class formats a value in separated groups. The formatter listens
	 * to a property on a model and when the property changes, formats it and dispatches a
	 * formatChanged event.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.8
	 */
	public class CurrencyFormatter extends FormatBase
	{
		/**
		 *  constructor
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
		public function CurrencyFormatter()
		{
			super();
		}
		
		private var _fractionalDigits:Number = 2;
    private var _currencySymbol:String = "$";
		
		/**
		 *  Number of digits after the decimal separator
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
		public function get fractionalDigits():int
		{
			return _fractionalDigits;
		}
		public function set fractionalDigits(value:int):void
		{
            _fractionalDigits = value;
		}
		
        /**
         *  The currency symbol, such as "$"
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         */
        public function get currencySymbol():String
        {
            return _currencySymbol;
        }
        public function set currencySymbol(value:String):void
        {
            _currencySymbol = value;
        }

        /**
         *  Computes the formatted string.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         */
		override public function format(value:Object):String
		{
			if (value == null) return "";
			
			var num:Number = Number(value);
			var source:String = num.toFixed(fractionalDigits);
			
			return currencySymbol + source;
		}
	}
}
