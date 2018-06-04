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
	import org.apache.royale.core.IChild;
    import org.apache.royale.core.IItemRenderer;
    import org.apache.royale.html.elements.Thead;
	import org.apache.royale.html.elements.Tbody;

    COMPILE::JS
    {
        import org.apache.royale.core.WrappedHTMLElement;
		import org.apache.royale.html.util.addElementToWrapper;
        import org.apache.royale.core.CSSClassList;
    }
    
	/**
	 *  The Material Design Lite (MDL) data-table component is an enhanced version of
	 *  the standard HTML <table>. A data-table consists of rows and columns of well-formatted
	 *  data, presented with appropriate user interaction capabilities.
	 *
	 *  The available row/column/cell types in a data-table are mostly self-formatting; that is,
	 *  once the data-table is defined, the individual cells require very little specific attention.
	 *  For example, the rows exhibit shading behavior on mouseover and selection, numeric values are
	 *  automatically formatted by default, and the addition of a single class makes the table rows
	 *  individually or collectively selectable. This makes the data-table component convenient and easy
	 *  to code for the developer, as well as attractive and intuitive for the user.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.8
	 */
	public class Table extends List
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
		public function Table()
		{
			super();

            COMPILE::JS
            {
                _classList = new CSSClassList();
            }

            typeNames = "mdl-data-table mdl-js-data-table";
		}

        COMPILE::JS
        private var _classList:CSSClassList;

		private var _columns:Array;
        /**
		 *  columns. Optional
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
        public function get columns():Array
        {
            return _columns;
        }
        public function set columns(value:Array):void
        {
			_columns = value;

			if(_columns != null && _columns.length > 0)
			{
				COMPILE::JS
            	{
					for each (var column:TableColumn in _columns){
						thead.addElement(column);
					}
				}
			}
        }

        /**
         *  @copy org.apache.royale.core.IParent#getElementAt()
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9
         */
		override public function getElementAt(index:int):IChild
		{
			var element:IChild;

			COMPILE::JS
            {
                if (_isTbodyAddedToParent)
                {
                    element = tbody.getElementAt(index);
                }
            }
			
			return element;
		}

        /**
         *  @copy org.apache.royale.core.IParent#addElement()
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         */
		override public function addElement(c:IChild, dispatchEvent:Boolean = true):void
		{
            COMPILE::JS
            {
				if (_isTheadAddedToParent && _isTbodyAddedToParent)
                {
                    tbody.addElement(c);
                }
            }
		}

        /**
         *  @copy org.apache.royale.core.IParent#addElementAt()
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9
         */
        override public function addElementAt(c:IChild, index:int, dispatchEvent:Boolean = true):void
		{
            if (!_isTbodyAddedToParent) return;

            COMPILE::JS
            {
				tbody.addElementAt(c, index, dispatchEvent);
            }
		}

        /**
         *  @copy org.apache.royale.core.IParent#removeElement()
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9
         */
        override public function removeElement(c:IChild, dispatchEvent:Boolean = true):void
        {
			if (!_isTbodyAddedToParent) return;

			COMPILE::JS
            {
				tbody.removeElement(c, dispatchEvent);
            }
        }


        COMPILE::JS
		private var thead:Thead;
		private var _isTheadAddedToParent:Boolean = false;

		COMPILE::JS
		private var tbody:Tbody;
        private var _isTbodyAddedToParent:Boolean = false;

        /**
         * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
         */
        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
			addElementToWrapper(this,'table');

            addTHeadToParent();
            addTBodyToParent();

            return element;
        }

		protected var _shadow:Number = 0;
        /**
		 *  A boolean flag to activate "mdl-shadow--Xdp" effect selector.
		 *  Assigns variable shadow depths (0, 2, 3, 4, 6, 8, or 16) to card
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
        public function get shadow():Number
        {
            return _shadow;
        }
        public function set shadow(value:Number):void
        {
            if (_shadow != value)
            {
                COMPILE::JS
                {
                    if (value == 2 || value == 3 || value == 4 || value == 6 || value == 8 || value == 16)
                    {
                        var classVal:String = "mdl-shadow--" + _shadow + "dp";
                        _classList.remove(classVal);

                        classVal = "mdl-shadow--" + value + "dp";
                        _classList.add(classVal);

                        _shadow = value;

                        setClassName(computeFinalClassNames());
                    }
                }
            }
        }

		protected var _selectable:Boolean = false;
        /**
		 *  A boolean flag to activate "mdl-data-table--selectable" effect selector.
		 *  Applies all/individual selectable behavior (checkboxes)
		 *  Optional; goes on table element
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
        public function get selectable():Boolean
        {
            return _selectable;
        }
        public function set selectable(value:Boolean):void
        {
            if (_selectable != value)
            {
                _selectable = value;

                COMPILE::JS
                {
                    var classVal:String = "mdl-data-table--selectable";
                    value ? _classList.add(classVal) : _classList.remove(classVal);
                    setClassName(computeFinalClassNames());
                }
            }
        }

		COMPILE::JS
        private function addTHeadToParent():void
        {
            if (_isTheadAddedToParent) return;

			thead = new Thead();
			super.addElement(thead);

			_isTheadAddedToParent = true;
        }

        COMPILE::JS
		private function addTBodyToParent():void
		{
			if (_isTbodyAddedToParent) return;

            tbody = new Tbody();
            super.addElement(tbody);
			_isTbodyAddedToParent = true;
		}

        COMPILE::JS
        override protected function computeFinalClassNames():String
        {
            return _classList.compute() + super.computeFinalClassNames();
        }
	}
}
