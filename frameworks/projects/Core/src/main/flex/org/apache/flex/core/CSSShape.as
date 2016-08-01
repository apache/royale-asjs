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
package org.apache.flex.core
{
    import flash.display.DisplayObject;
    import flash.display.Graphics;
    import flash.display.Shape;
    
    import org.apache.flex.core.IChild;
    import org.apache.flex.events.Event;
    import org.apache.flex.utils.CSSBorderUtils;
    import org.apache.flex.events.Event;        
    import org.apache.flex.events.EventDispatcher;
    
    /**
     *  The Border class is a class used internally by many
     *  controls to draw a border.  The border actually drawn
     *  is dictated by the IBeadView in the CSS.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
    COMPILE::SWF
	public class CSSShape extends EventDispatcher implements IStyleableObject, IChild
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function CSSShape()
		{
			_shape = new WrappedShape();
            _shape.flexjs_wrapper = this;
		}

        private var _shape:WrappedShape;
        public function get $diplayObject():DisplayObject
        {
            return _shape;
        }

        public function get $shape():Shape
        {
            return _shape;
        }

        /**
         *  @copy org.apache.flex.core.HTMLElementWrapper#element
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public function get element():IFlexJSElement
        {
            return _shape;
        }

        private var _parent:IUIBase;
        public function get parent():IUIBase
        {
            return _parent;
        }
        public function set parent(val:IUIBase):void
        {
            _parent = val;
        }

        public function get width():Number
        {
            return _shape.width;
        }

        public function set width(value:Number):void
        {
            _shape.width = value;
        }

        public function get height():Number
        {
            return _shape.height;
        }

        public function set height(value:Number):void
        {
            _shape.height = value;
        }

        public function get x():Number
        {
            return _shape.x;
        }

        public function set x(value:Number):void
        {
            _shape.x = value;
        }

        public function get y():Number
        {
            return _shape.y;
        }

        public function set y(value:Number):void
        {
            _shape.y = value;
        }        

        public function get visible():Boolean
        {
            return _shape.visible;
        }

        public function set visible(value:Boolean):void
        {
            _shape.visible = value;
        }
        public function get alpha():Number
        {
            return _shape.alpha;
        }

        public function set alpha(value:Number):void
        {
            _shape.alpha = value;
        }        

        private var _id:String;
        
        /**
         *  An id property for MXML documents.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public function get id():String
        {
            return _id;
        }
        
        /**
         *  @private
         */
        public function set id(value:String):void
        {
            if (_id != value)
            {
                _id = value;
                dispatchEvent(new Event("idChanged"));
            }
        }
        
        private var _className:String;
        
        /**
         *  The classname.  Often used for CSS
         *  class selector lookups.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public function get className():String
        {
            return _className;
        }
        
        /**
         *  @private
         */
        public function set className(value:String):void
        {
            if (_className != value)
            {
                _className = value;
                dispatchEvent(new Event("classNameChanged"));
            }
        }
        
        private var _styles:Object;
        
        /**
         *  The object that contains
         *  "styles" and other associated
         *  name-value pairs.  You can
         *  also specify a string in
         *  HTML style attribute format.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public function get style():Object
        {
            return _styles;
        }
        
        /**
         *  @private
         */
        public function set style(value:Object):void
        {
            if (_styles != value)
            {
                if (value is String)
                {
                    _styles = ValuesManager.valuesImpl.parseStyles(value as String);
                }
                else
                    _styles = value;
                dispatchEvent(new Event("stylesChanged"));
            }
        }

        public var state:String;
        
        /**
         *  Draw the contents based on styles
         * 
         *  @param width The width.
         *  @param height The height.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public function draw(w:Number, h:Number):void
        {
            CSSBorderUtils.draw(_shape.graphics, w, h, this, state, true);            
        }
   	}
}
