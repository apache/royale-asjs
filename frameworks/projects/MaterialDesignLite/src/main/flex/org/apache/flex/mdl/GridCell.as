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
package org.apache.flex.mdl
{
	import org.apache.flex.core.ContainerBase;
    
    COMPILE::JS
    {
        import org.apache.flex.core.WrappedHTMLElement;
    }
    
	/**
	 *  The GridCell class is a Container component capable of parenting other
	 *  components 
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class GridCell extends ContainerBase
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function GridCell()
		{
			super();

			className = ""; //set to empty string avoid 'undefined' output when no class selector is assigned by user;
		}
		
        /**
         * @flexjsignorecoercion org.apache.flex.core.WrappedHTMLElement
         */
        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
			typeNames = "mdl-cell";

            element = document.createElement('div') as WrappedHTMLElement;
            element.className = typeNames;
            
			positioner = element;
            
            // absolute positioned children need a non-null
            // position value in the parent.  It might
            // get set to 'absolute' if the container is
            // also absolutely positioned
            element.flexjs_wrapper = this;

            return element;
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
		 *  @productversion FlexJS 0.0
		 */
        public function get column():Number
        {
            return _column;
        }
        public function set column(value:Number):void
        {
			if(value > 0 || value < 13)
			{
				_column = value;

				className += " mdl-cell--" + _column + "-col";
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
		 *  @productversion FlexJS 0.0
		 */
        public function get columnDesktop():Number
        {
            return _columnDesktop;
        }
        public function set columnDesktop(value:Number):void
        {
			if(value > 0 || value < 13)
			{
				_columnDesktop = value;

				className += " mdl-cell--" + _columnDesktop + "-col-desktop";
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
		 *  @productversion FlexJS 0.0
		 */
        public function get columnTablet():Number
        {
            return _columnTablet;
        }
        public function set columnTablet(value:Number):void
        {
			if(value > 0 || value < 9)
			{
				_columnTablet = value;

				className += " mdl-cell--" + _columnTablet + "-col-tablet";
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
		 *  @productversion FlexJS 0.0
		 */
        public function get columnPhone():Number
        {
            return _columnPhone;
        }
        public function set columnPhone(value:Number):void
        {
			if(value > 0 || value < 5)
			{
				_columnPhone = value;

				className += " mdl-cell--" + _columnPhone + "-col-phone";
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
		 *  @productversion FlexJS 0.0
		 */
        public function get offset():Number
        {
            return _offset;
        }
        public function set offset(value:Number):void
        {
			if(value > 0 || value < 12)
			{
				_offset = value;

				className += " mdl-cell--" + _offset + "-offset";
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
		 *  @productversion FlexJS 0.0
		 */
        public function get offsetDesktop():Number
        {
            return _offsetDesktop;
        }
        public function set offsetDesktop(value:Number):void
        {
			if(value > 0 || value < 12)
			{
				_offsetDesktop = value;

				className += " mdl-cell--" + _offsetDesktop + "-offset-desktop";
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
		 *  @productversion FlexJS 0.0
		 */
        public function get offsetTablet():Number
        {
            return _offsetTablet;
        }
        public function set offsetTablet(value:Number):void
        {
			if(value > 0 || value < 12)
			{
				_offsetTablet = value;

				className += " mdl-cell--" + _offsetTablet + "-offset-tablet";
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
		 *  @productversion FlexJS 0.0
		 */
        public function get offsetPhone():Number
        {
            return _offsetPhone;
        }
        public function set offsetPhone(value:Number):void
        {
			if(value > 0 || value < 12)
			{
				_offsetPhone = value;

				className += " mdl-cell--" + _offsetPhone + "-offset-phone";
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
		 *  @productversion FlexJS 0.0
		 */
        public function get order():Number
        {
            return _order;
        }
        public function set order(value:Number):void
        {
			if(value > 0 || value < 13)
			{
				_order = value;

				className += " mdl-cell--order-" + _order;
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
		 *  @productversion FlexJS 0.0
		 */
        public function get orderDesktop():Number
        {
            return _orderDesktop;
        }
        public function set orderDesktop(value:Number):void
        {
			if(value > 0 || value < 13)
			{
				_orderDesktop = value;

				className += " mdl-cell--order-" + _orderDesktop + "-desktop";
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
		 *  @productversion FlexJS 0.0
		 */
        public function get orderTablet():Number
        {
            return _orderTablet;
        }
        public function set orderTablet(value:Number):void
        {
			if(value > 0 || value < 13)
			{
				_orderTablet = value;

				className += " mdl-cell--order-" + _orderTablet + "-tablet";
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
		 *  @productversion FlexJS 0.0
		 */
        public function get orderPhone():Number
        {
            return _orderPhone;
        }
        public function set orderPhone(value:Number):void
        {
			if(value > 0 || value < 13)
			{
				_orderPhone = value;

				className += " mdl-cell--order-" + _orderPhone + "-phone";
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
		 *  @productversion FlexJS 0.0
		 */
        public function get hideDesktop():Boolean
        {
            return _hideDesktop;
        }
        public function set hideDesktop(value:Boolean):void
        {
            _hideDesktop = value;

            className += (_hideDesktop ? " mdl-cell--hide-desktop" : "");
        }

		protected var _hideTablet:Boolean = false;
        /**
		 *  A boolean flag to activate "mdl-cell--hide-tablet" effect selector.
		 *  Hides the cell when in tablet mode. Optional on "inner" div elements
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
        public function get hideTablet():Boolean
        {
            return _hideTablet;
        }
        public function set hideTablet(value:Boolean):void
        {
            _hideTablet = value;

            className += (_hideTablet ? " mdl-cell--hide-tablet" : "");
        }

		protected var _hidePhone:Boolean = false;
        /**
		 *  A boolean flag to activate "mdl-cell--hide-phone" effect selector.
		 *  Hides the cell when in phone mode. Optional on "inner" div elements
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
        public function get hidePhone():Boolean
        {
            return _hidePhone;
        }
        public function set hidePhone(value:Boolean):void
        {
            _hidePhone = value;

            className += (_hidePhone ? " mdl-cell--hide-phone" : "");
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
		 *  @productversion FlexJS 0.0
		 */
        public function get strech():Boolean
        {
            return _strech;
        }
        public function set strech(value:Boolean):void
        {
            _strech = value;

            className += (_strech ? " mdl-cell--stretch" : "");
        }

		protected var _alignTop:Boolean = false;
        /**
		 *  A boolean flag to activate "mdl-cell--top" effect selector.
		 *  Aligns the cell to the top of the parent. Optional on "inner" div elements
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
        public function get alignTop():Boolean
        {
            return _alignTop;
        }
        public function set alignTop(value:Boolean):void
        {
            _alignTop = value;

            className += (_alignTop ? " mdl-cell--top" : "");
        }

		protected var _alignMiddle:Boolean = false;
        /**
		 *  A boolean flag to activate "mdl-cell--middle" effect selector.
		 *  Aligns the cell to the middle of the parent. Optional on "inner" div elements
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
        public function get alignMiddle():Boolean
        {
            return _alignMiddle;
        }
        public function set alignMiddle(value:Boolean):void
        {
            _alignMiddle = value;

            className += (_alignMiddle ? " mdl-cell--middle" : "");
        }

		protected var _alignBottom:Boolean = false;
        /**
		 *  A boolean flag to activate "mdl-cell--bottom" effect selector.
		 *  Aligns the cell to the bottom of the parent. Optional on "inner" div elements
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
        public function get alignBottom():Boolean
        {
            return _alignBottom;
        }
        public function set alignBottom(value:Boolean):void
        {
            _alignBottom = value;

            className += (_alignBottom ? " mdl-cell--bottom" : "");
        }
	}
}
