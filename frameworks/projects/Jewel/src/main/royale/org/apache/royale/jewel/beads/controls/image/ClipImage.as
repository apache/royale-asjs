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
	import org.apache.royale.core.StyledUIBase;
	import org.apache.royale.debugging.throwError;
	import org.apache.royale.jewel.Group;
	import org.apache.royale.utils.css.addDynamicSelector;
	
	/**
	 *  The HorizontalListScroll bead is a specialty bead that can be used with
	 *  Jewel List control and gives horizontal scroll to the list
	 * 
	 *  examples of use:
	 * 
	 *  CIRCLE_SHAPE
	 *  <j:ClipImage shape="{ClipImage.CIRCLE_SHAPE}" radius="46" x="50" y="50" units="%"/>
	 * 
	 *  - using a border:
	 *    <j:ClipImage shape="{ClipImage.CIRCLE_SHAPE}" radius="46" x="50" y="50" units="%" border="1" borderColor="#666666"/>
	 *  
	 *  POLYGON_SHAPE
     *  <j:ClipImage shape="{ClipImage.POLYGON_SHAPE}" units="%" points="[50,0,0,100,100,100]"/>
     *  <j:ClipImage shape="{ClipImage.POLYGON_SHAPE}" units="%" points="[20, 0, 0, 20, 30, 50, 0, 80, 20, 100, 50, 70, 80, 100, 100, 80, 70, 50, 100, 20, 80, 0, 50, 30]"/>
	 *  
	 *  ELLIPSE_SHAPE
	 *  <j:ClipImage shape="{ClipImage.ELLIPSE_SHAPE}" radius="46" bradius="20" x="50" y="50" units="%"/>
	 * 
	 *  INSET_SHAPE
	 *  <j:ClipImage shape="{ClipImage.INSET_SHAPE}" inset="[5, 20, 15, 10]" rounds="[5, 20, 0, 10]"  units="%"/>
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

		private var _shape:String;
		/**
		 * the shape for the clip. values can be "inset", "circle", "ellipse", "polygon"
		 */
		public function get shape():String
		{
			return _shape;
		}
		public function set shape(value:String):void
		{
			_shape = value;
			createClipShape(ruleName);
			
			if(_border && _borderColor)
			{
				borderShape = new Group();
				borderShape.className = ruleName;
				borderShape.width = host.width;
				borderShape.minWidth = host.width;
				borderShape.height = host.height;
				borderShape.minHeight = host.height;

				
				host.parent.addElementAt(borderShape, host.parent.getElementIndex(host), false);
				
				COMPILE::JS
				{
				borderShape.element.style.backgroundColor = borderColor;
				borderShape.element.style.display = "inline-flex";
				borderShape.element.style.position = "relative";
				
				host.element.style.position = "absolute";
				host.element.style.left = border + "px";
				host.element.style.top = border + "px";
				host.element.style.position = "relative";
				}

				host.width = host.width - border*2;
				host.height = host.height - border*2;

				borderShape.addElement(host);

				createClipShape(ruleName, true);
			}
			
		}

		private var _radius:Number;
		/*
		 * The radius value for CIRCLE or ELLIPSE shapes
		 */
		public function get radius():Number {
			return _radius;
		}
		public function set radius(value:Number):void {
			_radius = value;
		}
		
		private var _bradius:Number;
		/*
		 * The additional radius value only for ELLIPSE shapes
		 */
		public function get bradius():Number {
			return _bradius;
		}
		public function set bradius(value:Number):void {
			_bradius = value;
		}
		
		private var _x:Number;
		/*
		 * x-position
		 */
		public function get x():Number {
			return _x;
		}
		public function set x(value:Number):void {
			_x = value;
		}

		private var _y:Number;
		/*
		 * y-position
		 */
		public function get y():Number {
			return _y;
		}
		public function set y(value:Number):void {
			_y = value;
		}

		private var _units:String = "%";
		/**
		 * the units to use . values can be "px", "%"
		 * defauls to "%""
		 */
		public function get units():String {
			return _units;
		}
		public function set units(value:String):void {
			_units = value;
		}
		
		private var points_str:String;
		private var _points:Array;
		/**
		 * Only for POLYGON shapes
		 * An Array of x and y points used in POLYGON shapes. Minimun 3 points
		 * If you want just 3 points add them in the following way: [x1, y1, x2, y2, x3, y3]
		 */
		public function get points():Array {
			return _points;
		}
		public function set points(value:Array):void {
			points_str = "";
			_points = value;
			_points.forEach(everyTwo);
		}
		private function everyTwo(element:*, index:Number, arr:Array):void {
			if((index % 2) && (index != arr.length - 1))
            	points_str += element + units + ", ";
			else
            	points_str += element + units + " ";
        }
		
		private var inset_str:String;
		private var _inset:Array;
		/**
		 * Only for INSET shapes
		 * An Array of 4 values used in INSET shapes to limit the inset shape
		 */
		public function get inset():Array {
			return _inset;
		}
		public function set inset(value:Array):void {
			inset_str = "";
			_inset = value;
			_inset.forEach(processInsetValues);
		}
		private function processInsetValues(element:*, index:Number, arr:Array):void {
			if(arr.length == 4)
				inset_str += element + units + " ";
			else
				throwError("ClipImage INSET values must have four.")
        }
		
		private var rounds_str:String;
		private var _rounds:Array;
		/**
		 * Only for INSET shapes
		 * An Array of 4 values used in INSET shapes to round the corners between inset values
		 */
		public function get rounds():Array {
			return _rounds;
		}
		public function set rounds(value:Array):void {
			rounds_str = "round ";
			_rounds = value;
			_rounds.forEach(processRoundsValues);
		}
		private function processRoundsValues(element:*, index:Number, arr:Array):void {
			rounds_str += element + units + " ";
        }

		private var _border:Number;
		/**
		 * the border tickness
		 */
		public function get border():Number {
			return _border;
		}
		public function set border(value:Number):void {
			_border = value;
		}
		
		private var _borderColor:String;
		/**
		 * the border color
		 */
		public function get borderColor():String {
			return _borderColor;
		}
		public function set borderColor(value:String):void {
			_borderColor = value;
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

			ruleName = "clipPath-" + ((new Date()).getTime() + "-" + Math.floor(Math.random()*1000));

			host.addClass(ruleName);
		}

		private var borderShape:Group;
		private var ruleName:String;
		private var selectors:String;

		protected function createClipShape(ruleName:String, before:Boolean = false):void
		{
			selectors = "";

			if(shape == CIRCLE_SHAPE)
			{
				selectors += "clip-path: " + shape + "(" + radius + units + " at " + x + units + " "+ y + units + ");";
			}
			else if(shape == POLYGON_SHAPE)
			{
				selectors += "clip-path: " + shape + "(" + points_str +  ");";
			}
			else if(shape == ELLIPSE_SHAPE)
			{
				selectors += "clip-path: " + shape + "(" + radius + units + " " + bradius + units + " at " + x + units + " "+ y + units + ");";
			}
			else if(shape == INSET_SHAPE)
			{
				selectors += "clip-path: " + shape + "(" + inset_str + rounds_str + ");";
			}

			addDynamicSelector("." + ruleName, selectors);
		}
	}
}
