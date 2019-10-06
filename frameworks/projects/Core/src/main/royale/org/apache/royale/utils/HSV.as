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
package org.apache.royale.utils
{
	
	/**
	 *  The HSV class stores colors in HSV format	
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.6
	 * 
	 *  @royalesuppresspublicvarwarning
	 */
	public class HSV
	{
		private var _h:Number;
		private var _s:Number;
		private var _v:Number;
		
		/**
		 *  Constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.6
		 */
		public function HSV(h:Number=NaN, s:Number=NaN, v:Number=NaN)
		{
			_h = h;
			_s = s;
			_v = v;
		}
	
		public function get h():Number 
		{
			return _h;
		}
		
		public function set h(value:Number):void
		{
			_h = value;
		}
		
		public function get s():Number 
		{
			return _s;
		}
		
		public function set s(value:Number):void
		{
			_s = value;
		}

		public function get v():Number
		{
			return _v;
		}

		public function set v(value:Number):void
		{
			_v = value;
		}
	}
}

