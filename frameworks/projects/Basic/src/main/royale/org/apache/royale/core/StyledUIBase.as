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
package org.apache.royale.core
{
    COMPILE::JS
    {
    import org.apache.royale.core.WrappedHTMLElement;
    import org.apache.royale.html.util.addElementToWrapper;
    }
    import org.apache.royale.events.Event;
    import org.apache.royale.utils.ClassSelectorList;
    import org.apache.royale.utils.IClassSelectorListSupport;

    /**
     *  The StyledUIBase is the base class for UIBase components that makes
     *  heavy use of styles through IClassSelectorListSupport, and supports emphasis property
     *  through IEmphasis.
     *  
     *  For Javascript platform it allows to default size properties (like width and height)
     *  to broswer defaults by removing the property. This is done through NaN value (that is the default)
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.3
     */
    public class StyledUIBase extends UIBase implements IClassSelectorListSupport, IEmphasis
    {
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.3
         */
		public function StyledUIBase()
		{
            classSelectorList = new ClassSelectorList(this);
            super();
		}

        protected var classSelectorList:ClassSelectorList;

        COMPILE::JS
        override protected function setClassName(value:String):void
        {
            classSelectorList.addNames(value);
        }

        /**
         * Add a class selector to the list.
         * 
         * @param name Name of selector to add.
         * 
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion Royale 0.9.3
         */
        public function addClass(name:String):void
        {
            COMPILE::JS
            {
            if(name != "" && name != null)
                classSelectorList.add(name);
            }
        }

        /**
         * Removes a class selector from the list.
         * 
         * @param name Name of selector to remove.
         *
         * @royaleignorecoercion HTMLElement
         * @royaleignorecoercion DOMTokenList
         * 
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion Royale 0.9.3
         */
        public function removeClass(name:String):void
        {
            COMPILE::JS
            {
            classSelectorList.remove(name);
            }
        }

        /**
         * Add or remove a class selector to/from the list.
         * 
         * @param name Name of selector to add or remove.
         * @param value True to add, False to remove.
         * 
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion Royale 0.9.3
         */
        public function toggleClass(name:String, value:Boolean):void
        {
            COMPILE::JS
            {
            classSelectorList.toggle(name, value);
            }
        }

        /**
		 *  Search for the name in the element class list 
		 *
         *  @param name Name of selector to find.
         *  @return return true if the name is found or false otherwise.
         * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.3
		 */
		public function containsClass(name:String):Boolean
        {
            COMPILE::JS
            {
            return classSelectorList.contains(name);    
            }
            COMPILE::SWF
            {//not implemented
            return false;
            }
        }

        private var _emphasis:String;
        /**
		 *  Applies emphasis color display. Possible constant values are: PRIMARY, SECONDARY, EMPHASIZED.
         *  Colors are defined in royale jewel theme CSS.
         * 
         *  Left without value to get the default look (light or dark).
         *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.6
		 */
        public function get emphasis():String
        {
            return _emphasis;
        }
        public function set emphasis(value:String):void
        {
            if (_emphasis != value)
            {
                if(_emphasis)
                {
                    removeClass(_emphasis);
                }
                _emphasis = value;

                addClass(_emphasis);
            }
        }

        /**
         * @return The actual element to be parented.
         * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
         */
        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
			addElementToWrapper(this,'div');
            return element;
        }

        /**
         *  @private
         */
		override public function set percentWidth(value:Number):void
		{
			COMPILE::SWF {
				if (_percentWidth == value)
					return;
				
				if (!isNaN(value))
					_explicitWidth = NaN;
				
				_percentWidth = value;
			}
			COMPILE::JS {
				this._percentWidth = value;
				this.positioner.style.width = isNaN(value) ? null : value.toString() + '%';
				if (!isNaN(value))
					this._explicitWidth = NaN;
			}
			
			dispatchEvent(new Event("percentWidthChanged"));
		}

        /**
         *  @private
         */
		override public function set percentHeight(value:Number):void
		{
			COMPILE::SWF {
				if (_percentHeight == value)
					return;
				
				if (!isNaN(value))
					_explicitHeight = NaN;
				
				_percentHeight = value;
			}
				
			COMPILE::JS {
				this._percentHeight = value;
				this.positioner.style.height = isNaN(value) ? null : value.toString() + '%';
				if (!isNaN(value))
					this._explicitHeight = NaN;
			}
			
			dispatchEvent(new Event("percentHeightChanged"));
		}

        /**
         *  @copy org.apache.royale.core.ILayoutChild#setHeight
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.7
         */
        override public function setHeight(value:Number, noEvent:Boolean = false):void
        {
            if (_height !== value)
            {
                _height = value;
                COMPILE::JS
                {
                    this.positioner.style.height = isNaN(value) ? null : value.toString() + 'px';        
                }
                if (!noEvent)
                    dispatchEvent(new Event("heightChanged"));
            }            
        }

        /**
         *  @copy org.apache.royale.core.ILayoutChild#setWidth
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.7
         */
        override public function setWidth(value:Number, noEvent:Boolean = false):void
        {
            if (_width !== value)
            {
                _width = value;
                COMPILE::JS
                {
                    this.positioner.style.width = isNaN(value) ? null : value.toString() + 'px';        
                }
                if (!noEvent)
                    dispatchEvent(new Event("widthChanged"));
            }
        }

        /**
         *  @copy org.apache.royale.core.ILayoutChild#setWidthAndHeight
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.7
         */
        override public function setWidthAndHeight(newWidth:Number, newHeight:Number, noEvent:Boolean = false):void
        {
            if (_width !== newWidth)
            {
                _width = newWidth;
                COMPILE::JS
                {
                    this.positioner.style.width = isNaN(newWidth) ? null : newWidth.toString() + 'px';        
                }
                if (!noEvent) 
                    dispatchEvent(new Event("widthChanged"));
            }
            if (_height !== newHeight)
            {
                _height = newHeight;
                COMPILE::JS
                {
                    this.positioner.style.height = isNaN(newHeight) ? null : newHeight.toString() + 'px';        
                }
                if (!noEvent)
                    dispatchEvent(new Event("heightChanged"));
            }            
            dispatchEvent(new Event("sizeChanged"));
        }
    }
}