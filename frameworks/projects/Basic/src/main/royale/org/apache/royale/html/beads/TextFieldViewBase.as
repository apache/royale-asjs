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
package org.apache.royale.html.beads
{
	import flash.text.StyleSheet;
	
	import org.apache.royale.core.CSSTextField;
	import org.apache.royale.core.IBeadView;
	import org.apache.royale.core.ILayoutChild;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.ITextModel;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.core.ValuesManager;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	
    /**
     *  The TextFieldViewBase class is the base class for
     *  the components that display text.
     *  It displays text using a TextField, so there is no
     *  right-to-left text support in this view.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    COMPILE::SWF
	public class TextFieldViewBase implements IBeadView, ITextFieldView
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function TextFieldViewBase()
		{
			_textField = new CSSTextField();
		}
		
		private var _textField:CSSTextField;
		
        /**
         *  @copy org.apache.royale.core.ITextModel#textField
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function get textField() : CSSTextField
		{
			return _textField;
		}
		
		private var _textModel:ITextModel;
		
		protected var _strand:IStrand;
		
        /**
         *  @copy org.apache.royale.core.IBead#strand
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function set strand(value:IStrand):void
		{
			_strand = value;
			_textModel = value.getBeadByType(ITextModel) as ITextModel;
            _textModel.addEventListener("textChange", textChangeHandler);
            _textModel.addEventListener("htmlChange", htmlChangeHandler);
            IEventDispatcher(_strand).addEventListener("widthChanged", widthChangeHandler);
            IEventDispatcher(_strand).addEventListener("heightChanged", heightChangeHandler);
            IEventDispatcher(_strand).addEventListener("sizeChanged", sizeChangeHandler);
			UIBase(value).$sprite_addChild(_textField);

            var ilc:ILayoutChild = host as ILayoutChild;
            autoHeight = ilc.isHeightSizedToContent();
            autoWidth = ilc.isWidthSizedToContent();
			
			if (_textModel.text !== null)
				text = _textModel.text;
			if (_textModel.html !== null)
				html = _textModel.html;            
			
            if (!autoWidth && !isNaN(ilc.explicitWidth))
            {
                widthChangeHandler(null);
            }
            if (!autoHeight && !isNaN(ilc.explicitHeight))
            {
                heightChangeHandler(null);
            }
            
            // textfield's collapse to height==4 if no text
            if (autoHeight && _textModel.text === null)
            {
                var fontHeight:Number = ValuesManager.valuesImpl.getValue(_strand, "fontSize") + 4;
                if (textField.height != fontHeight) 
                {
                    textField.autoSize = "none";
                    textField.height = fontHeight;
                }
            }
		}
		
        /**
         *  @private
         */
		public function get host() : IUIBase
		{
			return _strand as IUIBase;
		}
		
        /**
         *  @copy org.apache.royale.core.ITextModel#text
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function get text():String
		{
			return _textField.text;
		}

        /**
         *  @private
         */
        public function set text(value:String):void
		{
            if (value == null)
                value = "";
			_textField.text = value;
            autoSizeIfNeeded();
		}

        /**
         *  Handle autosizing.  The built-in player algorithm
         *  doesn't work the way we would like, especially
         *  when it collapses Textfields with empty strings.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        protected function autoSizeIfNeeded():void
        {
            var host:UIBase = UIBase(_strand);
            if (autoHeight)
            {   
                if (textField.text != "")
                {
                    if (textField.height != textField.textHeight + 4)
                    {
                        textField.height = textField.textHeight + 4;
                        inHeightChange = true;
                        host.dispatchEvent(new Event("heightChanged"));
                        inHeightChange = false;
                    }
                }
                else
                {
                    var fontHeight:Number = ValuesManager.valuesImpl.getValue(_strand, "fontSize") + 4;
                    if (textField.height != fontHeight)
                    {
                        textField.height = fontHeight;
                        inHeightChange = true;
                        host.dispatchEvent(new Event("heightChanged"));
                        inHeightChange = false;                        
                    }
                }
            }
            if (autoWidth)
            {
                if (textField.width != textField.textWidth + 4)
                {
                    textField.width = textField.textWidth + 4;
                    inWidthChange = true;
                    host.dispatchEvent(new Event("widthChanged"));
                    inWidthChange = false;                    
                }
            }
        }
        
        /**
         *  @copy org.apache.royale.core.ITextModel#html
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function get html():String
		{
			return _textField.htmlText;
		}
		
        /**
         *  @private
         */
        public function set html(value:String):void
		{
			convertToTextFieldHTML(value);
            autoSizeIfNeeded();
		}
		
        private function convertToTextFieldHTML(input:String):void
        {
            var classCount:int = 0;
            var ss:StyleSheet;
            var c:int = input.indexOf("<span");
            while (c != -1)
            {
                var c1:int = input.indexOf(">", c);
                if (c1 == -1)
                {
                    trace("did not parse span correctly");
                    return;
                }
                var tag:String = input.substring(c, c1 + 1);
                var c2:int = tag.indexOf("style=");
                if (c2 != -1)
                {
                    var quote:String = tag.charAt(c2 + 6);
                    var c3:int = tag.indexOf(quote, c2 + 7);
                    if (c3 != -1)
                    {
                        var styles:String = tag.substring(c2 + 7, c3);
                        if (!ss)
                            ss = new StyleSheet();
                        var styleObject:Object = {};
                        var list:Array = styles.split(";");
                        for each (var pair:String in list)
                        {
                            var parts:Array = pair.split(":");
                            var name:String = parts[0];
                            var c4:int = name.indexOf("-");
                            if (c4 != -1)
                            {
                                var firstChar:String = name.charAt(c4 + 1);
                                firstChar = firstChar.toUpperCase();
                                var tail:String = name.substring(c4 + 2);
                                name = name.substring(0, c4) + firstChar + tail;
                            }
                            styleObject[name] = parts[1];
                        }
                        var className:String = "css" + classCount++;
                        ss.setStyle("." + className, styleObject);
                        var newTag:String = "<span class='" + className + "'>";
                        input = input.replace(tag, newTag);
                        c1 += newTag.length - tag.length;
                    }
                }
                c = input.indexOf("<span", c1);
            }
            _textField.styleSheet = ss;   
            _textField.htmlText = input;
        }
        
		private function textChangeHandler(event:Event):void
		{
			text = _textModel.text;
		}
		
		private function htmlChangeHandler(event:Event):void
		{
			html = _textModel.html;
		}
		
        /**
         *  Whether we are autosizing the height.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        protected var autoHeight:Boolean;

        /**
         *  Whether we are autosizing the width.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        protected var autoWidth:Boolean;
        
        /**
         *  A flag to prevent looping.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        protected var inHeightChange:Boolean = false;
        
        /**
         *  A flag to prevent looping.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        protected var inWidthChange:Boolean = false;
        
        /**
         *  Determine the width of the TextField.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		protected function widthChangeHandler(event:Event):void
		{
            if (!inWidthChange)
            {
                textField.autoSize = "none";
                autoWidth = false;
    			textField.width = host.width;
                if (autoHeight)
        	        autoSizeIfNeeded()
                else
                    textField.height = host.height;
            }
		}

        /**
         *  Determine the height of the TextField.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        protected function heightChangeHandler(event:Event):void
        {
            if (!inHeightChange)
            {
                textField.autoSize = "none";
                autoHeight = false;
                textField.height = host.height;
                if (autoWidth)
                    autoSizeIfNeeded();
                else
                    textField.width = host.width;
            }
        }
        
        /**
         *  Determine the size of the TextField.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        protected function sizeChangeHandler(event:Event):void
        {
            var ilc:ILayoutChild = host as ILayoutChild;
            autoHeight = ilc.isHeightSizedToContent();
            if (!autoHeight)
            {
                textField.autoSize = "none";
                textField.height = host.height;
            }
            
            autoWidth = ilc.isWidthSizedToContent();
            if (!autoWidth)
            {
                textField.autoSize = "none";
                textField.width = host.width;
            }
            
            if (autoWidth) {
                (host as UIBase).setWidth(textField.textWidth + 4, true);
            }
            if (autoHeight) {
                (host as UIBase).setHeight(textField.textHeight + 4, true);
            }
        }
    }
}
