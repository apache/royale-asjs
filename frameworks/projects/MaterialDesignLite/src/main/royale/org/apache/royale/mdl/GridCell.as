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
        import org.apache.royale.html.util.addOrReplaceClassName;
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

            typeNames = "mdl-cell";
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
			if (_column != value)
            {
                COMPILE::JS
                {
                    if (value > 0 || value < 13)
                    {
                        className = addOrReplaceClassName(className, "mdl-cell--" + value + "-col", "mdl-cell--" + _column + "-col");
                        _column = value;
                    }
                }
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
            if (_columnDesktop != value)
            {
                COMPILE::JS
                {
                    if (value > 0 || value < 13)
                    {
                        className = addOrReplaceClassName(className, "mdl-cell--" + value + "-col-desktop", "mdl-cell--" + _columnDesktop + "-col-desktop");
                        _columnDesktop = value;
                    }
                }
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
            if (_columnTablet != value)
            {
                COMPILE::JS
                {
                    if (value > 0 || value < 13)
                    {
                        className = addOrReplaceClassName(className, "mdl-cell--" + value + "-col-tablet", "mdl-cell--" + _columnTablet + "-col-tablet");
                        _columnTablet = value;
                    }
                }
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
            if (_columnPhone != value)
            {
                COMPILE::JS
                {
                    if (value > 0 || value < 5)
                    {
                        className = addOrReplaceClassName(className, "mdl-cell--" + value + "-col-phone", "mdl-cell--" + _columnPhone + "-col-phone");
                        _columnPhone = value;
                    }
                }
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
			if (_offset != value)
			{
				COMPILE::JS
				{
					if (value > 0 || value < 12)
					{
						className = addOrReplaceClassName(className, "mdl-cell--" + value + "-offset", "mdl-cell--" + _offset + "-offset");
						_offset = value;
					}
				}
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
            if (_offsetDesktop != value)
            {
                COMPILE::JS
                {
                    if (value > 0 || value < 12)
                    {
                        className = addOrReplaceClassName(className, "mdl-cell--" + value + "-offset-desktop", "mdl-cell--" + _offsetDesktop + "-offset-desktop");
                        _offsetDesktop = value;
                    }
                }
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
            if (_offsetTablet != value)
            {
                COMPILE::JS
                {
                    if (value > 0 || value < 12)
                    {
                        className = addOrReplaceClassName(className, "mdl-cell--" + value + "-offset-tablet", "mdl-cell--" + _offsetTablet + "-offset-tablet");
                        _offsetTablet = value;
                    }
                }
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
            if (_offsetPhone != value)
            {
                COMPILE::JS
                {
                    if (value > 0 || value < 12)
                    {
                        className = addOrReplaceClassName(className, "mdl-cell--" + value + "-offset-phone", "mdl-cell--" + _offsetPhone + "-offset-phone");
                        _offsetPhone = value;
                    }
                }
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
            if (_order != value)
            {
                COMPILE::JS
                {
                    if (value > 0 || value < 13)
                    {
                        className = addOrReplaceClassName(className, "mdl-cell--order-" + value, "mdl-cell--order-" + _order);
                        _order = value;
                    }
                }
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
            if (_orderDesktop != value)
            {
                COMPILE::JS
                {
                    if (value > 0 || value < 13)
                    {
                        className = addOrReplaceClassName(className, "mdl-cell--order-" + value + "-desktop", "mdl-cell--order-" + _orderDesktop + "-desktop");
                        _orderDesktop = value;
                    }
                }
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
            if (_orderTablet != value)
            {
                COMPILE::JS
                {
                    if (value > 0 || value < 13)
                    {
                        className = addOrReplaceClassName(className, "mdl-cell--order-" + value + "-tablet", "mdl-cell--order-" + _orderTablet + "-tablet");
                        _orderTablet = value;
                    }
                }
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
            if (_orderPhone != value)
            {
                COMPILE::JS
                {
                    if (value > 0 || value < 13)
                    {
                        className = addOrReplaceClassName(className, "mdl-cell--order-" + value + "-phone", "mdl-cell--order-" + _orderPhone + "-phone");
                        _orderPhone = value;
                    }
                }
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
            if (_hideDesktop != value)
            {
                _hideDesktop = value;

                COMPILE::JS
                {
                    element.classList.remove("mdl-cell--hide-desktop");
                    if (value)
                    {
                        className = addOrReplaceClassName(className, "mdl-cell--hide-desktop");
                    }
                }
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
            if (_hideTablet != value)
            {
                _hideTablet = value;

                COMPILE::JS
                {
                    element.classList.remove("mdl-cell--hide-tablet");
                    if (value)
                    {
                        className = addOrReplaceClassName(className, "mdl-cell--hide-tablet");
                    }
                }
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
            if (_hidePhone != value)
            {
                _hidePhone = value;

                COMPILE::JS
                {
                    element.classList.remove("mdl-cell--hide-phone");
                    if (value)
                    {
                        className = addOrReplaceClassName(className, "mdl-cell--hide-phone");
                    }
                }
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
            if (_strech != value)
            {
                _strech = value;

                COMPILE::JS
                {
                    element.classList.remove("mdl-cell--stretch");
                    if (value)
                    {
                        className = addOrReplaceClassName(className, "mdl-cell--stretch");
                    }
                }
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
            if (_alignTop != value)
            {
                _alignTop = value;

                COMPILE::JS
                {
                    element.classList.remove("mdl-cell--top");
                    if (value)
                    {
                        className = addOrReplaceClassName(className, "mdl-cell--top");
                    }
                }
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
            if (_alignMiddle != value)
            {
                _alignMiddle = value;

                COMPILE::JS
                {
                    element.classList.remove("mdl-cell--middle");
                    if (value)
                    {
                        className = addOrReplaceClassName(className, "mdl-cell--middle");
                    }
                }
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
            if (_alignBottom != value)
            {
                _alignBottom = value;

                COMPILE::JS
                {
                    element.classList.remove("mdl-cell--bottom");
                    if (value)
                    {
                        className = addOrReplaceClassName(className, "mdl-cell--bottom");
                    }
                }
            }
        }
	}
}
