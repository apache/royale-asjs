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
	import org.apache.royale.html.beads.IPaddings;

    /**
     *  The Paddings class is an IPaddings bead that adds padding to its host
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.7
     */
	public class Paddings implements IPaddings
	{
		protected var host:IUIBase;
		/**
		 * @copy org.apache.royale.core.IStrand
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 */
		public function set strand(value:IStrand):void
		{
			host = value as IUIBase;
			if(_padding)
			{
				_paddingTop = _padding;
				_paddingRight = _padding;
				_paddingBottom = _padding;
				_paddingLeft = _padding;
				
				COMPILE::JS
				{
				host.positioner.style.padding = _padding + "px";
				}
			} else {
				COMPILE::JS
				{
				host.positioner.style.paddingTop = _paddingTop + "px";
				host.positioner.style.paddingRight = _paddingRight + "px";
				host.positioner.style.paddingBottom = _paddingBottom + "px";
				host.positioner.style.paddingLeft = _paddingLeft + "px";
				}
			}
		}

		/**
		 *  @private
		 */
		private var _padding:Number;
		/**
		 *  The padding value. Setting this value override the rest of values
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 */
		public function get padding():Number
		{
			return _padding;
		}
		/**
		 *  @private
		 */
		public function set padding(value:Number):void
		{
			_padding = value;
		}

        /**
		 *  @private
		 */
		private var _paddingTop:Number;
		/**
		 *  The top padding value.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 */
		public function get paddingTop():Number
		{
			return _paddingTop;
		}
		/**
		 *  @private
		 */
		public function set paddingTop(value:Number):void
		{
			_paddingTop = value;
		}

		/**
		 *  @private
		 */
		private var _paddingRight:Number;
		/**
		 *  The right padding value.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 */
		public function get paddingRight():Number
		{
			return _paddingRight;
		}
		/**
		 *  @private
		 */
		public function set paddingRight(value:Number):void
		{
			_paddingRight = value;
		}

		/**
		 *  @private
		 */
		private var _paddingBottom:Number;
		/**
		 *  The bottom padding value.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 */
		public function get paddingBottom():Number
		{
			return _paddingBottom;
		}
		/**
		 *  @private
		 */
		public function set paddingBottom(value:Number):void
		{
			_paddingBottom = value;
		}

		/**
		 *  @private
		 */
		private var _paddingLeft:Number;

		/**
		 *  The left padding value.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 */
		public function get paddingLeft():Number
		{
			return _paddingLeft;
		}
		/**
		 *  @private
		 */
		public function set paddingLeft(value:Number):void
		{
			_paddingLeft = value;
		}
    }
}