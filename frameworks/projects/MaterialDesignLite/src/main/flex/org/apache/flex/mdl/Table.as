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
	import org.apache.flex.core.IChild;
	import org.apache.flex.core.IUIBase;
    
    COMPILE::JS
    {
        import org.apache.flex.core.WrappedHTMLElement;
    }
    
	/**
	 *  The Table class is a Container component capable of parenting other
	 *  four components (CardTitle, CardMedia, CardSupportingText and CardActions. 
     *  The Panel uses the following bead types:
	 * 
	 *  org.apache.flex.core.IBeadModel: the data model for the Card.
	 *  org.apache.flex.core.IBeadView: creates the parts of the Card.
	 *  
	 *  @see PanelWithControlBar
	 *  @see ControlBar
	 *  @see TitleBar
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class Table extends List
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function Table()
		{
			super();

			className = ""; //set to empty string avoid 'undefined' output when no class selector is assigned by user;
		}

		private var _columns:Array;
        /**
		 *  columns. Optional
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
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
						head.addElement(column);
					}
				}
			}
        }

		override public function addElement(c:IChild, dispatchEvent:Boolean = true):void
		{
			/*COMPILE::SWF
            {
                if(_elements == null)
                    _elements = [];
                _elements[_elements.length] = c;
                $displayObjectContainer.addChild(c.$displayObject);
                if (c is IUIBase)
                {
                    IUIBase(c).addedToParent();
                }
                    
            }*/
            COMPILE::JS
            {
				if(c is THead) {
					positioner.appendChild(c.positioner);
					(c as IUIBase).addedToParent();
				} else
				{
					element.appendChild(c.positioner);
					(c as IUIBase).addedToParent();
				}
            }
		}
		
		COMPILE::JS
		private var head:THead;

        /**
         * @flexjsignorecoercion org.apache.flex.core.WrappedHTMLElement
         */
        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
			typeNames = "mdl-data-table mdl-js-data-table";

            positioner = document.createElement('table') as WrappedHTMLElement;
			
			head = new THead();
			addElement(head);

			element = document.createElement('tbody') as WrappedHTMLElement;
			
			positioner.appendChild(element);
			element.flexjs_wrapper = this;

            return element;
        }
		
		COMPILE::JS
		override protected function setClassName(value:String):void
		{
			positioner.className = value;
		}
        
		protected var _shadow:Number = 0;
        /**
		 *  A boolean flag to activate "mdl-shadow--Xdp" effect selector.
		 *  Assigns variable shadow depths (0, 2, 3, 4, 6, 8, or 16) to card
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
        public function get shadow():Number
        {
            return _shadow;
        }
        public function set shadow(value:Number):void
        {
			COMPILE::JS
			{
				positioner.classList.remove("mdl-shadow--" + _shadow + "dp");
				
				if(value == 2 || value == 3 || value == 4 || value == 6 || value == 8 || value == 16)
				{
					_shadow = value;

					positioner.classList.add("mdl-shadow--" + _shadow + "dp");
					typeNames = positioner.className;
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
		 *  @productversion FlexJS 0.0
		 */
        public function get selectable():Boolean
        {
            return _selectable;
        }
        public function set selectable(value:Boolean):void
        {
			_selectable = value;

			COMPILE::JS
            {
				positioner.classList.toggle("mdl-data-table--selectable", _selectable);
				typeNames = positioner.className;
			}
        }
	}
}
