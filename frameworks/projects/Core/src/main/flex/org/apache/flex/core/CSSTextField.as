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
	COMPILE::SWF {
        import flash.display.DisplayObject;
		import flash.text.TextField;
		import flash.text.TextFieldAutoSize;
		import flash.text.TextFormat;
        import org.apache.flex.events.Event;        
        import org.apache.flex.events.EventDispatcher;
	}

    import org.apache.flex.core.ValuesManager;
    import org.apache.flex.events.Event;
    import org.apache.flex.utils.CSSUtils;

    /**
     *  The CSSTextField class implements CSS text styles in a TextField.
     *  Not every CSS text style is currently supported.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
    COMPILE::SWF
	public class CSSTextField extends EventDispatcher
	{
        /**
         *  Constructor.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function CSSTextField()
		{
			_textField = new WrappedTextField();
            _textField.flexjs_wrapper = this;

		}

        private var _textField:WrappedTextField;
        
        public function get $textField():TextField
        {
            return _textField;
        }
        

        public function get $displayObject():DisplayObject
        {
            return _textField;
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
            return _textField;
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
            return _textField.width;
        }

        public function set width(value:Number):void
        {
            _textField.width = value;
        }

        public function get height():Number
        {
            return _textField.height;
        }

        public function set height(value:Number):void
        {
            _textField.height = value;
        }

        public function get x():Number
        {
            return _textField.x;
        }

        public function set x(value:Number):void
        {
            _textField.x = value;
        }

        public function get y():Number
        {
            return _textField.y;
        }

        public function set y(value:Number):void
        {
            _textField.y = value;
        }

        public function get visible():Boolean
        {
            return _textField.visible;
        }

        public function set visible(value:Boolean):void
        {
            _textField.visible = value;
        }

        public function get alpha():Number
        {
            return _textField.alpha;
        }

        public function set alpha(value:Number):void
        {
            _textField.alpha = value;
        }

        public function get embedFonts():Boolean
        {
            return _textField.embedFonts;
        }

        public function set embedFonts(value:Boolean):void
        {
            _textField.embedFonts = value;
        }

        public function get selectable():Boolean
        {
            return _textField.selectable;
        }

        public function set selectable(value:Boolean):void
        {
            _textField.selectable = value;
        }

        public function get type():String
        {
            return _textField.type;
        }

        public function set type(value:String):void
        {
            _textField.type = value;
        }

        public function get mouseEnabled():Boolean
        {
            return _textField.mouseEnabled;
        }

        public function set mouseEnabled(value:Boolean):void
        {
            _textField.mouseEnabled = value;
        }

        public function get autoSize():String
        {
            return _textField.autoSize;
        }

        public function set autoSize(value:String):void
        {
            _textField.autoSize = value;
        }

        public function get textColor():uint
        {
            return _textField.textColor;
        }

        public function set textColor(value:uint):void
        {
            _textField.textColor = value;
        }

        public function get textWidth():Number
        {
            return _textField.textWidth;
        }

        public function get textHeight():Number
        {
            return _textField.textHeight;
        }

        public function get wordWrap():Boolean
        {
            return _textField.wordWrap;
        }

        public function set wordWrap(value:Boolean):void
        {
            _textField.wordWrap = value;
        }

        public function get multiline():Boolean
        {
            return _textField.multiline;
        }

        public function set multiline(value:Boolean):void
        {
            _textField.multiline = value;
        }

        public function get restrict():String
        {
            return _textField.restrict;
        }

        public function set restrict(value:String):void
        {
            _textField.restrict = value;
        }

        public function get maxChars():int
        {
            return _textField.maxChars;
        }

        public function set maxChars(value:int):void
        {
            _textField.maxChars = value;
        }

        public function get displayAsPassword():Boolean
        {
            return _textField.displayAsPassword;
        }

        public function set displayAsPassword(value:Boolean):void
        {
            _textField.displayAsPassword = value;
        }

        public function get htmlText():String
        {
            return _textField.htmlText;
        }

        public function set htmlText(value:String):void
        {
            _textField.htmlText = value;
        }

        public function get name():String
        {
            return _textField.name;
        }

        public function set name(value:String):void
        {
            _textField.name = value;
        }

        public function get background():Boolean
        {
            return _textField.background;
        }

        public function set background(value:Boolean):void
        {
            _textField.background = value;
        }

        public function get backgroundColor():uint
        {
            return _textField.backgroundColor;
        }

        public function set backgroundColor(value:uint):void
        {
            _textField.backgroundColor = value;
        }

        public function get border():Boolean
        {
            return _textField.border;
        }

        public function set border(value:Boolean):void
        {
            _textField.border = value;
        }

        public function get borderColor():uint
        {
            return _textField.borderColor;
        }

        public function set borderColor(value:uint):void
        {
            _textField.borderColor = value;
        }

        public function get numLines():int
        {
            return _textField.numLines;
        }

        /**
         *  @private
         *  The styleParent property is set if the CSSTextField
         *  is used in a SimpleButton-based instance because
         *  the parent property is null, defeating CSS lookup.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public var styleParent:Object;

        /**
         *  @private
         *  The CSS pseudo-state for lookups.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public var styleState:String;

        /**
         *  @private
         *  The parentDrawsBackground property is set if the CSSTextField
         *  shouldn't draw a background
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public var parentDrawsBackground:Boolean;

        /**
         *  @private
         *  The parentHandlesPadding property is set if the CSSTextField
         *  shouldn't worry about padding
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public var parentHandlesPadding:Boolean;

        /**
         *  @private
         */
		public function set text(value:String):void
		{
			var sp:Object = parent;
			if (styleParent)
				sp = styleParent;
			sp.addEventListener("classNameChanged", updateStyles);

			var tf: TextFormat = new TextFormat();
			tf.font = ValuesManager.valuesImpl.getValue(sp, "fontFamily", styleState) as String;
			tf.size = ValuesManager.valuesImpl.getValue(sp, "fontSize", styleState);
			tf.bold = ValuesManager.valuesImpl.getValue(sp, "fontWeight", styleState) == "bold";
			tf.color = CSSUtils.toColor(ValuesManager.valuesImpl.getValue(sp, "color", styleState));
            if (!parentHandlesPadding)
            {
        		var padding:Object = ValuesManager.valuesImpl.getValue(sp, "padding", styleState);
        		var paddingLeft:Object = ValuesManager.valuesImpl.getValue(sp,"padding-left", styleState);
        		var paddingRight:Object = ValuesManager.valuesImpl.getValue(sp,"padding-right", styleState);
        		tf.leftMargin = CSSUtils.getLeftValue(paddingLeft, padding, width);
        		tf.rightMargin = CSSUtils.getRightValue(paddingRight, padding, width);
            }
            var align:Object = ValuesManager.valuesImpl.getValue(sp, "text-align", styleState);
            if (align == "center")
			{
				_textField.autoSize = TextFieldAutoSize.NONE;
                tf.align = "center";
			}
            else if (align == "right")
			{
                tf.align = "right";
				_textField.autoSize = TextFieldAutoSize.NONE;
			}
            if (!parentDrawsBackground)
            {
                var backgroundColor:Object = ValuesManager.valuesImpl.getValue(sp, "background-color", styleState);
                if (backgroundColor != null)
                {
                    _textField.background = true;
                    _textField.backgroundColor = CSSUtils.toColor(backgroundColor);
                }
            }
			_textField.defaultTextFormat = tf;
			_textField.text = value;
		}

        public function get text():String
        {
            return _textField.text;
        }

        private function updateStyles(event:Event):void
        {
            // force styles to be re-calculated
            this.text = text;
        }

	}

	COMPILE::JS
	public class CSSTextField extends TextField
	{
	}
}
