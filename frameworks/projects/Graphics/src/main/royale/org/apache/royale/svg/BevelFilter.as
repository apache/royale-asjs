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
	
	COMPILE::SWF 
	{
		import flash.filters.BevelFilter;
		
		import org.apache.royale.core.IRenderedObject;
	}

	/**
	 *  BevelFilter is a bead that injects a series of beads in the correct 
	 *  order and initialized them.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.5
	 */
	public class BevelFilter extends Filter implements IChainableFilter
	{
		private var _source:String;
		private var _result:String;
		private var _isNice:Boolean;
		private var _strength:Number;
		private var _angle:Number
		private var _distance:Number
		private var _highlightColor:uint;
		private var _altitude:Number;
		

		public function BevelFilter()
		{
		}
		
		public function build():void
		{
			children = [];
			var blurFilterElement:BlurFilterElement = new BlurFilterElement();
			blurFilterElement.in = "SourceGraphic";
			blurFilterElement.stdDeviation = distance;
			children.push(blurFilterElement);
			var diffuseLightingFilterElement:DiffuseLightingFilterElement = new DiffuseLightingFilterElement();
			diffuseLightingFilterElement.azimuth = angle;
			diffuseLightingFilterElement.surfaceScale = strength;
			diffuseLightingFilterElement.lightingColor = highlightColor;
			diffuseLightingFilterElement.elevation = altitude;
			diffuseLightingFilterElement.result = "diffuseResult";
			if (result)
			{
				diffuseLightingFilterElement.result += "_" + result;
			}
			children.push(diffuseLightingFilterElement);
			var cf1:CompositeFilterElement = new CompositeFilterElement();
			cf1.k1 = 1;
			cf1.k2 = 0;
			cf1.k3 = 0;
			cf1.k4 = 0;
			cf1.operator = "arithmetic";
			cf1.in2 = diffuseLightingFilterElement.result;
			children.push(cf1);
			var cf2:CompositeFilterElement = new CompositeFilterElement();
			cf2.k1 = 1;
			cf2.k2 = 0;
			cf2.k3 = 1;
			cf2.k4 = 0;
			cf2.operator = "arithmetic";
			cf2.in2 = "SourceGraphic";
			cf2.result = result;
			children.push(cf2);
		}

		COMPILE::JS
		override protected function filter():void
		{
			build();
			super.filter();
		}

		COMPILE::SWF
		override protected function filter():void
		{
			var filter:flash.filters.BevelFilter = new flash.filters.BevelFilter();
			filter.strength = strength;
//			filter.altitude = altitude;
			filter.highlightColor = highlightColor;
			filter.angle = angle;
			host.$displayObject.filters = [filter];
		}

		public function get isNice():Boolean 
		{
			return _isNice;
		}
		
		public function set isNice(value:Boolean):void 
		{
			_isNice = value;
		}

		public function get strength():Number 
		{
			return _strength;
		}
		
		public function set strength(value:Number):void 
		{
			_strength = value;
		}

		public function get angle():Number 
		{
			return _angle;
		}
		
		public function set angle(value:Number):void 
		{
			_angle = value;
		}

		public function get distance():Number 
		{
			return _distance;
		}
		
		public function set distance(value:Number):void 
		{
			_distance = value;
		}

		public function get highlightColor():uint
		{
			return _highlightColor;
		}
		
		public function set highlightColor(value:uint):void 
		{
			_highlightColor = value;
		}

		public function get altitude():Number 
		{
			return _altitude;
		}
		
		public function set altitude(value:Number):void 
		{
			_altitude = value;
		}

		public function get source():String 
		{
			return _source;
		}
		
		public function set source(value:String):void 
		{
			_source = value;
		}

		public function get result():String 
		{
			return _result;
		}
		
		public function set result(value:String):void 
		{
			_result = value;
		}
	}
}

