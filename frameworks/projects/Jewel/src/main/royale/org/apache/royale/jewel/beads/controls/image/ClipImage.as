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
package org.apache.royale.jewel.beads.controls.image
{
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.utils.css.addDynamicSelector;
	import org.apache.royale.core.StyledUIBase;
	
	/**
	 *  The HorizontalListScroll bead is a specialty bead that can be used with
	 *  Jewel List control and gives horizontal scroll to the list
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.10.0
	 */
	public class ClipImage implements IBead
	{
		public static const INSET_SHAPE:String = "inset";
		public static const CIRCLE_SHAPE:String = "circle";
		public static const ELLIPSE_SHAPE:String = "ellipse";
		public static const POLYGON_SHAPE:String = "polygon";
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.10.0
		 */
		public function ClipImage()
		{
		}

		private var _shape:String = "circle";
		/**
		 * the shape for the clip. values can be "inset", "circle", "ellipse", "polygon"
		 */
		private function get shape():String
		{
			return _shape;
		}
		private function set shape(value:String):void
		{
			_shape = value;
		}

		private var _radius:Number = 46;
		/*
		 * when circle or ellipse the radius
		 */
		private function get radius():Number {
			return _radius;
		}
		private function set radius(value:Number):void {
			_radius = value;
		}
		
		private var _x:Number = 50;
		/*
		 * x-position
		 */
		private function get x():Number {
			return _x;
		}
		private function set x(value:Number):void {
			_x = value;
		}

		private var _y:Number = 50;
		/*
		 * y-position
		 */
		private function get y():Number {
			return _y;
		}
		private function set y(value:Number):void {
			_y = value;
		}

		private var _units:String = "%";
		/**
		 * the units to use . values can be "px", "%"
		 */
		private function get units():String {
			return _units;
		}
		private function set units(value:String):void {
			_units = value;
		}
		
		private var host:StyledUIBase;
		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.10.0
		 */
		public function set strand(value:IStrand):void
		{
			host = value as StyledUIBase;

			createClip();
		}

		protected function createClip():void
		{
			var ruleName:String = "clipPath-" + ((new Date()).getTime() + "-" + Math.floor(Math.random()*1000));
			var selectors:String = "";
			
			if(shape == INSET_SHAPE)
			{
				//selectors = "clip-path: " + shape + "(46" + units + " at 50" + units + " 50" + units + ");";

			} else if(shape == CIRCLE_SHAPE)
			{
				selectors = "clip-path: " + shape + "(" + radius + units + " at " + x + units + " "+ y + units + ");";

			} else if(shape == ELLIPSE_SHAPE)
			{
				//selectors = "clip-path: " + shape + "(46" + units + " at 50" + units + " 50" + units + ");";

			} else if(shape == POLYGON_SHAPE)
			{
				//selectors = "clip-path: " + shape + "(46" + units + " at 50" + units + " 50" + units + ");";

			}

			addDynamicSelector(".jewel.image." + ruleName, selectors);

			host.addClass(ruleName);
		}
	}
}
