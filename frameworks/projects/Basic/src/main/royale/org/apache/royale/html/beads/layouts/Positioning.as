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
package org.apache.royale.html.beads.layouts
{
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.html.beads.IPositioning;

    /**
     *  The Positioning class is an IPositioning bead that adds  
	 *  positioning constraints to its host.
	 *  
	 *  How it behaves will depend on 'position' values for that element
	 *  @see https://www.w3schools.com/css/css_positioning.asp to know more about it
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.8
     */
	public class Positioning implements IPositioning
	{
		protected var host:IUIBase;
		/**
		 * @copy org.apache.royale.core.IStrand
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.8
		 */
		public function set strand(value:IStrand):void
		{
			host = value as IUIBase;

			COMPILE::JS
			{
			host.positioner.style.top = _top + "px";
			host.positioner.style.right = _right + "px";
			host.positioner.style.bottom = _bottom + "px";
			host.positioner.style.left = _left + "px";
			}
		}

        /**
		 *  @private
		 */
		private var _top:Number;
		/**
		 *  The top position constraint value.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.8
		 */
		public function get top():Number
		{
			return _top;
		}
		/**
		 *  @private
		 */
		public function set top(value:Number):void
		{
			_top = value;
		}

		/**
		 *  @private
		 */
		private var _right:Number;
		/**
		 *  The right position constraint value.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.8
		 */
		public function get right():Number
		{
			return _right;
		}
		/**
		 *  @private
		 */
		public function set right(value:Number):void
		{
			_right = value;
		}

		/**
		 *  @private
		 */
		private var _bottom:Number;
		/**
		 *  The bottom position constraint value.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.8
		 */
		public function get bottom():Number
		{
			return _bottom;
		}
		/**
		 *  @private
		 */
		public function set bottom(value:Number):void
		{
			_bottom = value;
		}

		/**
		 *  @private
		 */
		private var _left:Number;

		/**
		 *  The left position constraint value.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.8
		 */
		public function get left():Number
		{
			return _left;
		}
		/**
		 *  @private
		 */
		public function set left(value:Number):void
		{
			_left = value;
		}
    }
}