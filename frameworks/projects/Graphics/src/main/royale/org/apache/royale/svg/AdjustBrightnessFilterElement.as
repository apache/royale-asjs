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
	COMPILE::JS 
	{
		import org.apache.royale.graphics.utils.addSvgElementToElement;
	}

	/**
	 *  The AdjustBrightnessFilterElement adjusts the brightness of the filter
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.5
	 */
	public class AdjustBrightnessFilterElement extends FilterElement
	{
		private var _brightnessFactor:Number = 1.0;

		public function AdjustBrightnessFilterElement()
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
				var funcR:Element = addSvgElementToElement(filterElement, "feFuncR") as Element;
				funcR.setAttribute("type", "linear");
				funcR.setAttribute("slope", brightnessFactor);
				var funcG:Element = addSvgElementToElement(filterElement, "feFuncG") as Element;
				funcG.setAttribute("type", "linear");
				funcG.setAttribute("slope", brightnessFactor);
				var funcB:Element = addSvgElementToElement(filterElement, "feFuncB") as Element;
				funcB.setAttribute("type", "linear");
				funcB.setAttribute("slope", brightnessFactor);
			}
		}

		/**
		 *  The brightnessFactor value, can be between 0 and 255.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.5
		 */
		public function get brightnessFactor():Number
		{
			return _brightnessFactor;
		}

		public function set brightnessFactor(value:Number):void
		{
			_brightnessFactor = value;
		}

		COMPILE::JS
		override protected function get filterElementType():String
		{
			return "feComponentTransfer";
		}
	}
}

