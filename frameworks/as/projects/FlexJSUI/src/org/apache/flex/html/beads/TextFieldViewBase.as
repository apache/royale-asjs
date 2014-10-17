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
package org.apache.flex.html.beads
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	import org.apache.flex.core.CSSTextField;
	import org.apache.flex.core.IBeadView;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.ITextModel;
	import org.apache.flex.core.IUIBase;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.core.ValuesManager;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
	
    /**
     *  The TextFieldViewBase class is the base class for
     *  the components that display text.
     *  It displays text using a TextField, so there is no
     *  right-to-left text support in this view.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
	public class TextFieldViewBase implements IBeadView, ITextFieldView
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function TextFieldViewBase()
		{
			_textField = new CSSTextField();
		}
		
		private var _textField:CSSTextField;
		
        /**
         *  @copy org.apache.flex.core.ITextModel#textField
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function get textField() : CSSTextField
		{
			return _textField;
		}
		
		private var _textModel:ITextModel;
		
		protected var _strand:IStrand;
		
        /**
         *  @copy org.apache.flex.core.IBead#strand
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function set strand(value:IStrand):void
		{
			_strand = value;
			_textModel = value.getBeadByType(ITextModel) as ITextModel;
            _textModel.addEventListener("textChange", textChangeHandler);
            _textModel.addEventListener("htmlChange", htmlChangeHandler);
            IEventDispatcher(_strand).addEventListener("widthChanged", widthChangeHandler);
            IEventDispatcher(_strand).addEventListener("heightChanged", heightChangeHandler);
			DisplayObjectContainer(value).addChild(_textField);
			if (_textModel.text !== null)
				text = _textModel.text;
			if (_textModel.html !== null)
				html = _textModel.html;
		}
		
		public function get strand():IStrand
		{
			return _strand;
		}

        /**
         *  @private
         */
		public function get host() : IUIBase
		{
			return _strand as IUIBase;
		}
		
        /**
         *  @copy org.apache.flex.core.ITextModel#text
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
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

        private function autoSizeIfNeeded():void
        {
            var host:UIBase = UIBase(_strand);
            if (autoHeight)
            {            
                if (textField.height != textField.textHeight + 4)
                {
                    textField.height = textField.textHeight + 4;
                    inHeightChange = true;
                    host.dispatchEvent(new Event("heightChanged"));
                    inHeightChange = false;
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
         *  @copy org.apache.flex.core.ITextModel#html
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
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
			_textField.htmlText = value;
            autoSizeIfNeeded();
		}
		
		private function textChangeHandler(event:Event):void
		{
			text = _textModel.text;
		}
		
		private function htmlChangeHandler(event:Event):void
		{
			html = _textModel.html;
		}
		
        private var autoHeight:Boolean = true;
        private var autoWidth:Boolean = true;
        private var inHeightChange:Boolean = false;
        private var inWidthChange:Boolean = false;
        
		private function widthChangeHandler(event:Event):void
		{
            if (!inWidthChange)
            {
                textField.autoSize = "none";
                autoWidth = false;
    			textField.width = DisplayObject(_strand).width;
                if (autoHeight)
        	        autoSizeIfNeeded()
                else
                    textField.height = DisplayObject(_strand).height;
            }
		}

        private function heightChangeHandler(event:Event):void
        {
            if (!inHeightChange)
            {
                textField.autoSize = "none";
                autoHeight = false;
                textField.height = DisplayObject(_strand).height;
                if (autoWidth)
                    autoSizeIfNeeded();
                else
                    textField.width = DisplayObject(_strand).width;
            }
        }
        
        /**
         *  @copy org.apache.flex.core.IBeadView#viewHeight
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public function get viewHeight():Number
        {
            // textfields with autosize collapse if no text
            if (_textField.text == "" && _textField.autoSize != "none")
                return ValuesManager.valuesImpl.getValue(_strand, "fontSize") + 4;

            return _textField.height;
        }
        
        /**
         *  @copy org.apache.flex.core.IBeadView#viewWidth
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public function get viewWidth():Number
        {
            // textfields with autosize collapse if no text
            if (_textField.text == "" && _textField.autoSize != "none")
                return 0;
            
            return _textField.width;
        }

    }
}
