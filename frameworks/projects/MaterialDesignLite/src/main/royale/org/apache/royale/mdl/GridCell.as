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
package org.apache.royale.mdl
{
	import org.apache.royale.html.Group;

    COMPILE::JS
    {
        import org.apache.royale.core.WrappedHTMLElement;
		import org.apache.royale.html.util.addElementToWrapper;
    }

	/**
	 *  The GridCell class represents a cell in MDL component.
	 *  This cell is a container component capable of parenting other
	 *  components. It has several properties to allow multiple layouts
	 *  configurations
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.8
	 */
	public class GridCell extends Group
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
		public function GridCell()
		{
			super();

			className = ""; //set to empty string avoid 'undefined' output when no class selector is assigned by user;
		}

        /**
         * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
         */
        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
			typeNames = "mdl-cell";
			return addElementToWrapper(this,'div');
        }

		protected var _column:Number = 4;
        /**
		 *  A boolean flag to activate "mdl-cell--N-col" effect selector.
		 *  Sets the column size for the cell to N. N is 1-12 inclusive.
		 *  Defaults to 4. Optional on "inner" div elements
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
        public function get column():Number
        {
            return _column;
        }
        public function set column(value:Number):void
        {
			COMPILE::JS
			{
				element.classList.remove("mdl-cell--" + _column + "-col");

				if(value > 0 || value < 13)
				{
					_column = value;

					element.classList.add("mdl-cell--" + _column + "-col");
				}

				typeNames = element.className;
			}
        }

		protected var _columnDesktop:Number;
        /**
		 *  A boolean flag to activate "mdl-cell--N-col-desktop" effect selector.
		 *  Sets the column size for the cell to N in desktop mode only.
		 *  N is 1-12 inclusive. Optional on "inner" div elements
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
        public function get columnDesktop():Number
        {
            return _columnDesktop;
        }
        public function set columnDesktop(value:Number):void
        {
			COMPILE::JS
			{
				element.classList.remove("mdl-cell--" + _columnDesktop + "-col-desktop");

				if(value > 0 || value < 13)
				{
					_columnDesktop = value;

					element.classList.add("mdl-cell--" + _columnDesktop + "-col-desktop");
				}

				typeNames = element.className;
			}
        }

		protected var _columnTablet:Number;
        /**
		 *  A boolean flag to activate "mdl-cell--N-col-tablet" effect selector.
		 *  Sets the column size for the cell to N in tablet mode only.
		 *  N is 1-8 inclusive. Optional on "inner" div elements
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
        public function get columnTablet():Number
        {
            return _columnTablet;
        }
        public function set columnTablet(value:Number):void
        {
			COMPILE::JS
			{
				element.classList.remove("mdl-cell--" + _columnTablet + "-col-tablet");

				if(value > 0 || value < 9)
				{
					_columnTablet = value;

					element.classList.add("mdl-cell--" + _columnTablet + "-col-tablet");
				}

				typeNames = element.className;
			}
        }

		protected var _columnPhone:Number;
        /**
		 *  A boolean flag to activate "mdl-cell--N-col-phone" effect selector.
		 *  Sets the column size for the cell to N in phone mode only.
		 *  N is 1-4 inclusive. Optional on "inner" div elements
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
        public function get columnPhone():Number
        {
            return _columnPhone;
        }
        public function set columnPhone(value:Number):void
        {
			COMPILE::JS
			{
				element.classList.remove("mdl-cell--" + _columnPhone + "-col-phone");

				if(value > 0 || value < 5)
				{
					_columnPhone = value;

					element.classList.add("mdl-cell--" + _columnPhone + "-col-phone");
				}

				typeNames = element.className;
			}
        }

		protected var _offset:Number;
        /**
		 *  A boolean flag to activate "mdl-cell--N-offset" effect selector.
		 *  Adds N columns of whitespace before the cell.
		 *  N is 1-11 inclusive. Optional on "inner" div elements
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
        public function get offset():Number
        {
            return _offset;
        }
        public function set offset(value:Number):void
        {
			COMPILE::JS
			{
				element.classList.remove("mdl-cell--" + _offset + "-offset");

				if(value > 0 || value < 12)
				{
					_offset = value;

					element.classList.add("mdl-cell--" + _offset + "-offset");
				}

				typeNames = element.className;
			}
        }

		protected var _offsetDesktop:Number;
        /**
		 *  A boolean flag to activate "mdl-cell--N-offset-desktop" effect selector.
		 *  Adds N columns of whitespace before the cell in desktop mode.
		 *  N is 1-11 inclusive. Optional on "inner" div elements
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
        public function get offsetDesktop():Number
        {
            return _offsetDesktop;
        }
        public function set offsetDesktop(value:Number):void
        {
			COMPILE::JS
			{
				element.classList.remove("mdl-cell--" + _offsetDesktop + "-offset-desktop");

				if(value > 0 || value < 12)
				{
					_offsetDesktop = value;

					element.classList.add("mdl-cell--" + _offsetDesktop + "-offset-desktop");
				}

				typeNames = element.className;
			}
        }

		protected var _offsetTablet:Number;
        /**
		 *  A boolean flag to activate "mdl-cell--N-offset-tablet" effect selector.
		 *  Adds N columns of whitespace before the cell in tablet mode.
		 *  N is 1-11 inclusive. Optional on "inner" div elements
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
        public function get offsetTablet():Number
        {
            return _offsetTablet;
        }
        public function set offsetTablet(value:Number):void
        {
			COMPILE::JS
			{
				element.classList.remove("mdl-cell--" + _offsetTablet + "-offset-tablet");

				if(value > 0 || value < 12)
				{
					_offsetTablet = value;

					element.classList.add("mdl-cell--" + _offsetTablet + "-offset-tablet");
				}

				typeNames = element.className;
			}
        }

		protected var _offsetPhone:Number;
        /**
		 *  A boolean flag to activate "mdl-cell--N-offset-phone" effect selector.
		 *  Adds N columns of whitespace before the cell in phone mode.
		 *  N is 1-11 inclusive. Optional on "inner" div elements
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
        public function get offsetPhone():Number
        {
            return _offsetPhone;
        }
        public function set offsetPhone(value:Number):void
        {
			COMPILE::JS
			{
				element.classList.remove("mdl-cell--" + _offsetPhone + "-offset-phone");

				if(value > 0 || value < 12)
				{
					_offsetPhone = value;

					element.classList.add("mdl-cell--" + _offsetPhone + "-offset-phone");
				}

				typeNames = element.className;
			}
        }

		protected var _order:Number;
        /**
		 *  A boolean flag to activate "mdl-cell--order-N" effect selector.
		 *  Reorders cell to position N.
		 *  N is 1-12 inclusive; optional on "inner" div elements
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
        public function get order():Number
        {
            return _order;
        }
        public function set order(value:Number):void
        {
			COMPILE::JS
			{
				element.classList.remove("mdl-cell--order-" + _order);

				if(value > 0 || value < 13)
				{
					_order = value;

					element.classList.add("mdl-cell--order-" + _order);
				}

				typeNames = element.className;
			}
        }

		protected var _orderDesktop:Number;
        /**
		 *  A boolean flag to activate "mdl-cell--order-N-desktop" effect selector.
		 *  Reorders cell to position N when in desktop mode.
		 *  N is 1-12 inclusive; optional on "inner" div elements
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
        public function get orderDesktop():Number
        {
            return _orderDesktop;
        }
        public function set orderDesktop(value:Number):void
        {
			COMPILE::JS
			{
				element.classList.remove("mdl-cell--order-" + _orderDesktop + "-desktop");

				if(value > 0 || value < 13)
				{
					_orderDesktop = value;

					element.classList.add("mdl-cell--order-" + _orderDesktop + "-desktop");
				}

				typeNames = element.className;
			}
        }

		protected var _orderTablet:Number;
        /**
		 *  A boolean flag to activate "mdl-cell--order-N-tablet" effect selector.
		 *  Reorders cell to position N when in tablet mode.
		 *  N is 1-12 inclusive; optional on "inner" div elements
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
        public function get orderTablet():Number
        {
            return _orderTablet;
        }
        public function set orderTablet(value:Number):void
        {
			COMPILE::JS
			{
				element.classList.remove("mdl-cell--order-" + _orderTablet + "-tablet");

				if(value > 0 || value < 13)
				{
					_orderTablet = value;

					element.classList.add("mdl-cell--order-" + _orderTablet + "-tablet");
				}

				typeNames = element.className;
			}
        }

		protected var _orderPhone:Number;
        /**
		 *  A boolean flag to activate "mdl-cell--order-N-phone" effect selector.
		 *  Reorders cell to position N when in phone mode.
		 *  N is 1-12 inclusive; optional on "inner" div elements
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
        public function get orderPhone():Number
        {
            return _orderPhone;
        }
        public function set orderPhone(value:Number):void
        {
			COMPILE::JS
			{
				element.classList.remove("mdl-cell--order-" + _orderPhone + "-phone");

				if(value > 0 || value < 13)
				{
					_orderPhone = value;

					element.classList.add("mdl-cell--order-" + _orderPhone + "-phone");
				}

				typeNames = element.className;
			}
        }

		protected var _hideDesktop:Boolean = false;
        /**
		 *  A boolean flag to activate "mdl-cell--hide-desktop" effect selector.
		 *  Hides the cell when in desktop mode. Optional on "inner" div elements
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
        public function get hideDesktop():Boolean
        {
            return _hideDesktop;
        }
        public function set hideDesktop(value:Boolean):void
        {
            _hideDesktop = value;

			COMPILE::JS
            {
                element.classList.toggle("mdl-cell--hide-desktop", _hideDesktop);
				typeNames = element.className;
            }
        }

		protected var _hideTablet:Boolean = false;
        /**
		 *  A boolean flag to activate "mdl-cell--hide-tablet" effect selector.
		 *  Hides the cell when in tablet mode. Optional on "inner" div elements
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
        public function get hideTablet():Boolean
        {
            return _hideTablet;
        }
        public function set hideTablet(value:Boolean):void
        {
            _hideTablet = value;

			COMPILE::JS
            {
                element.classList.toggle("mdl-cell--hide-tablet", _hideTablet);
				typeNames = element.className;
            }
        }

		protected var _hidePhone:Boolean = false;
        /**
		 *  A boolean flag to activate "mdl-cell--hide-phone" effect selector.
		 *  Hides the cell when in phone mode. Optional on "inner" div elements
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
        public function get hidePhone():Boolean
        {
            return _hidePhone;
        }
        public function set hidePhone(value:Boolean):void
        {
            _hidePhone = value;

			COMPILE::JS
            {
                element.classList.toggle("mdl-cell--hide-phone", _hidePhone);
				typeNames = element.className;
            }
        }

		protected var _strech:Boolean = false;
        /**
		 *  A boolean flag to activate "mdl-cell--stretch" effect selector.
		 *  Stretches the cell vertically to fill the parent. Default.
		 *  Optional on "inner" div elements
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
        public function get strech():Boolean
        {
            return _strech;
        }
        public function set strech(value:Boolean):void
        {
            _strech = value;

			COMPILE::JS
            {
                element.classList.toggle("mdl-cell--stretch", _strech);
				typeNames = element.className;
            }
        }

		protected var _alignTop:Boolean = false;
        /**
		 *  A boolean flag to activate "mdl-cell--top" effect selector.
		 *  Aligns the cell to the top of the parent. Optional on "inner" div elements
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
        public function get alignTop():Boolean
        {
            return _alignTop;
        }
        public function set alignTop(value:Boolean):void
        {
            _alignTop = value;

			COMPILE::JS
            {
                element.classList.toggle("mdl-cell--top", _alignTop);
				typeNames = element.className;
            }
        }

		protected var _alignMiddle:Boolean = false;
        /**
		 *  A boolean flag to activate "mdl-cell--middle" effect selector.
		 *  Aligns the cell to the middle of the parent. Optional on "inner" div elements
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
        public function get alignMiddle():Boolean
        {
            return _alignMiddle;
        }
        public function set alignMiddle(value:Boolean):void
        {
            _alignMiddle = value;

			COMPILE::JS
            {
                element.classList.toggle("mdl-cell--middle", _alignMiddle);
				typeNames = element.className;
            }
        }

		protected var _alignBottom:Boolean = false;
        /**
		 *  A boolean flag to activate "mdl-cell--bottom" effect selector.
		 *  Aligns the cell to the bottom of the parent. Optional on "inner" div elements
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
        public function get alignBottom():Boolean
        {
            return _alignBottom;
        }
        public function set alignBottom(value:Boolean):void
        {
            _alignBottom = value;

			COMPILE::JS
            {
                element.classList.toggle("mdl-cell--bottom", _alignBottom);
				typeNames = element.className;
            }
        }
	}
}
