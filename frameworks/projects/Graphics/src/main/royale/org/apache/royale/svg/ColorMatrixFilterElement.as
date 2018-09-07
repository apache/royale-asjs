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
package org.apache.royale.svg
{
	
	import org.apache.royale.events.Event;
	COMPILE::JS 
	{
		import org.apache.royale.graphics.utils.addSvgElementToElement;
	}

	/**
	 *  The ColorMatrixFilterElement bead adds an offset to a filtered SVG element
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.3
	 */
	public class ColorMatrixFilterElement extends FilterElement
	{
		private var _red:Number = 0;
		private var _green:Number = 0;
		private var _blue:Number = 0;
		private var _opacity:Number = 1;
		private var _filterElementResult:String = "filterElementResult";

		public function ColorMatrixFilterElement()
		{
		}
		
		
		/**
		 * @royaleignorecoercion Element
		 */
		override public function build():void
		{
			COMPILE::JS 
			{
				super.build();
				var matrixValues:String =  "0 0 0 0 " + red +  " 0 0 0 0 " + green +  " 0 0 0 0 " + blue + " 0 0 0 " + opacity + " 0";
				filterElement.setAttribute("values", matrixValues);
			}
		}

		/**
		 *  The red value. This should be a number between 0 and 1.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.3
		 */
		public function get red():Number
		{
			return _red;
		}

		public function set red(value:Number):void
		{
			_red = value;
		}

		/**
		 *  The blue value. This should be a number between 0 and 1.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.3
		 */
		public function get blue():Number
		{
			return _blue;
		}

		public function set blue(value:Number):void
		{
			_blue = value;
		}

		/**
		 *  The green value. This should be a number between 0 and 1.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.3
		 */
		public function get green():Number
		{
			return _green;
		}

		public function set green(value:Number):void
		{
			_green = value;
		}

		/**
		 *  The opacity value. This should be a number between 0 and 1.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.3
		 */
		public function get opacity():Number
		{
			return _opacity;
		}

		public function set opacity(value:Number):void
		{
			_opacity = value;
		}

		/**
		 *  Where to write the result of this filter. 
		 *  This is useful for using the result as a source for another filter element.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.3
		 */
		public function get filterElementResult():String
		{
			return _filterElementResult;
		}

		public function set filterElementResult(value:String):void
		{
			_filterElementResult = value;
		}

		COMPILE::JS
		override protected function get filterElementType():String
		{
			return "feColorMatrix";
		}
	}
}

