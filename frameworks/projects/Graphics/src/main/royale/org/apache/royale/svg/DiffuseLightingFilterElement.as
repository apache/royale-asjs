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
	
	import org.apache.royale.core.IBead;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.utils.CSSUtils;

	COMPILE::JS 
	{
		import org.apache.royale.graphics.utils.addSvgElementToElement;
	}

	/**
	 *  The DiffuseLightingFilterElement 
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.5
	 */
	public class DiffuseLightingFilterElement extends FilterElement
	{
		
		private var _surfaceScale:Number;
		private var _azimuth:Number = 0;
		private var _lightingColor:uint = 0xFFFFFFFF;
		private var _elevation:Number = 0;

		public function DiffuseLightingFilterElement()
		{
		}
		
		/**
		* @royaleignorecoercion Element
		*/
		COMPILE::JS
		override public function build():void
		{
			super.build();
			filterElement.setAttribute("lightingColor", CSSUtils.attributeFromColor(lightingColor));
			filterElement.setAttribute("surfaceScale", surfaceScale);
			var distantLight:Element = addSvgElementToElement(filterElement, "feDistantLight");
			distantLight.setAttribute("azimuth", "" + azimuth);
			distantLight.setAttribute("elevation", "" + elevation);
		}
			
		COMPILE::JS
		override protected function get filterElementType():String
		{
			return "feDiffuseLighting";
		}


		public function get azimuth():Number 
		{
			return _azimuth;
		}
		
		public function set azimuth(value:Number):void 
		{
			_azimuth = value;
		}

		public function get elevation():Number  
		{
			return _elevation;
		}
		
		public function set elevation(value:Number ):void 
		{
			_elevation = value;
		}

		public function get surfaceScale():Number 
		{
			return _surfaceScale;
		}
		
		public function set surfaceScale(value:Number):void 
		{
			_surfaceScale = value;
		}

		public function get lightingColor():uint  
		{
			return _lightingColor;
		}
		
		public function set lightingColor(value:uint ):void 
		{
			_lightingColor = value;
		}
	}
}

