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
package mx.controls.beads
{
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldType;
    import flash.text.TextFieldAutoSize;
	
    import org.apache.royale.core.BeadViewBase;
	import org.apache.royale.core.CSSTextField;
	import org.apache.royale.core.IBeadView;
	import org.apache.royale.core.IStrand;
    import org.apache.royale.core.UIBase;
	import org.apache.royale.core.ValuesManager;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.html.TextButton;
    import org.apache.royale.html.beads.models.ImageAndTextModel;
	import org.apache.royale.utils.CSSUtils;
    import org.apache.royale.utils.SolidBorderUtil;
    import org.apache.royale.utils.StringTrimmer;

    /**
     *  The CSSTextButtonView class is the default view for
     *  the mx.core.Button class.
     *  It allows the look of the button to be expressed
     *  in CSS via the background-image style and displays
     *  a text label.  This view does not support right-to-left
     *  text.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	public class CSSImageAndTextButtonView extends BeadViewBase implements IBeadView
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function CSSImageAndTextButtonView()
		{
			upSprite = new Sprite();
			downSprite = new Sprite();
			overSprite = new Sprite();
			upTextField = new CSSTextField();
			downTextField = new CSSTextField();
			overTextField = new CSSTextField();
			upTextField.selectable = false;
			upTextField.type = TextFieldType.DYNAMIC;
			downTextField.selectable = false;
			downTextField.type = TextFieldType.DYNAMIC;
			overTextField.selectable = false;
			overTextField.type = TextFieldType.DYNAMIC;
			upTextField.autoSize = "left";
			downTextField.autoSize = "left";
			overTextField.autoSize = "left";
			upSprite.addChild(upTextField);
			downSprite.addChild(downTextField);
			overSprite.addChild(overTextField);
		}
		
		private var textModel:ImageAndTextModel;
		
		private var shape:Shape;
		
        /**
         *  @copy org.apache.royale.core.IBead#strand
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		override public function set strand(value:IStrand):void
		{
			_strand = value;
			textModel = value.getBeadByType(ImageAndTextModel) as ImageAndTextModel;
			textModel.addEventListener("textChange", textChangeHandler);
			textModel.addEventListener("htmlChange", htmlChangeHandler);
            textModel.addEventListener("imageChange", imageChangeHandler);
			shape = new Shape();
			shape.graphics.beginFill(0xCCCCCC);
			shape.graphics.drawRect(0, 0, 10, 10);
			shape.graphics.endFill();
            upTextField.styleParent = _strand;
            downTextField.styleParent = _strand;
            overTextField.styleParent = _strand;
            upTextField.parentDrawsBackground = true;
            downTextField.parentDrawsBackground = true;
            overTextField.parentDrawsBackground = true;
            upTextField.parentHandlesPadding = true;
            downTextField.parentHandlesPadding = true;
            overTextField.parentHandlesPadding = true;
            UIBase(value).$sprite_addChild(upSprite);
            /* TODO switch sprites on mouse state 
			SimpleButton(value).downState = downSprite;
			SimpleButton(value).overState = overSprite;
			SimpleButton(value).hitTestState = shape;
            */
			if (textModel.text !== null)
				text = textModel.text;
			if (textModel.html !== null)
				html = textModel.html;

            sizeTextField(upTextField);
            sizeTextField(downTextField);
            sizeTextField(overTextField);
            setupSkins();
			
			IEventDispatcher(_strand).addEventListener("widthChanged",sizeChangeHandler);
			IEventDispatcher(_strand).addEventListener("heightChanged",sizeChangeHandler);
            IEventDispatcher(_strand).addEventListener("sizeChanged",sizeChangeHandler);
		}
	
        protected function sizeTextField(tf:TextField):void
        {
            if (tf.autoSize == TextFieldAutoSize.NONE)
            {
                tf.width = tf.textWidth + 4;
                tf.height = tf.textHeight + 4;
            }
        }
        
        protected function setupSkins():void
        {
            setupSkin(overSprite, overTextField, "hover");
            setupSkin(downSprite, downTextField, "active");
            setupSkin(upSprite, upTextField);
            updateHitArea();
        }
        
		private function setupSkin(sprite:Sprite, textField:TextField, state:String = null):void
		{
			var sw:uint = DisplayObject(_strand).width;
			var sh:uint = DisplayObject(_strand).height;
			
			textField.defaultTextFormat.leftMargin = 0;
			textField.defaultTextFormat.rightMargin = 0;
            // set it again so it gets noticed
			textField.defaultTextFormat = textField.defaultTextFormat;
            
			var borderColor:uint;
			var borderThickness:uint;
			var borderStyle:String;
			var borderStyles:Object = ValuesManager.valuesImpl.getValue(_strand, "border", state);
			if (borderStyles is Array)
			{
				borderColor = CSSUtils.toColor(borderStyles[2]);
				borderStyle = borderStyles[1];
				borderThickness = borderStyles[0];
			}
            else if (borderStyles is String)
                borderStyle = borderStyles as String;
			var value:Object = ValuesManager.valuesImpl.getValue(_strand, "border-style", state);
			if (value != null)
				borderStyle = value as String;
			value = ValuesManager.valuesImpl.getValue(_strand, "border-color", state);
			if (value != null)
				borderColor = CSSUtils.toColor(value);
			value = ValuesManager.valuesImpl.getValue(_strand, "border-width", state);
			if (value != null)
				borderThickness = value as uint;
            if (borderStyle == "none")
            {
                borderStyle = "solid";
                borderThickness = 0;
            }
            
            var borderRadius:String;
            var borderEllipseWidth:Number = NaN;
            var borderEllipseHeight:Number = NaN;
            value = ValuesManager.valuesImpl.getValue(_strand, "border-radius", state);
            if (value != null)
            {
                if (value is Number)
                    borderEllipseWidth = 2 * (value as Number);
                else
                {
                    borderRadius = value as String;
                    var arr:Array = StringTrimmer.splitAndTrim(borderRadius, "/");
                    borderEllipseWidth = 2 * CSSUtils.toNumber(arr[0]);
                    if (arr.length > 1)
                        borderEllipseHeight = 2 * CSSUtils.toNumber(arr[1]);
                } 
            }

			var padding:Object = ValuesManager.valuesImpl.getValue(_strand, "padding", state);
			var paddingLeft:Object = ValuesManager.valuesImpl.getValue(_strand, "padding-left", state);
			var paddingRight:Object = ValuesManager.valuesImpl.getValue(_strand, "padding-right", state);
			var paddingTop:Object = ValuesManager.valuesImpl.getValue(_strand, "padding-top", state);
			var paddingBottom:Object = ValuesManager.valuesImpl.getValue(_strand, "padding-bottom", state);
            var pl:Number = CSSUtils.getLeftValue(paddingLeft, padding, DisplayObject(_strand).width);
            var pr:Number = CSSUtils.getRightValue(paddingRight, padding, DisplayObject(_strand).width);
            var pt:Number = CSSUtils.getTopValue(paddingTop, padding, DisplayObject(_strand).height);
            var pb:Number = CSSUtils.getBottomValue(paddingBottom, padding, DisplayObject(_strand).height);
            
			var backgroundColor:Object = ValuesManager.valuesImpl.getValue(_strand, "background-color", state);
            var bgColor:uint;
            var bgAlpha:Number = 1;
            if (backgroundColor != null)
            {
                bgColor = CSSUtils.toColorWithAlpha(backgroundColor);
                if (bgColor & 0xFF000000)
                {
                    bgAlpha = bgColor >>> 24 / 255;
                    bgColor = bgColor & 0xFFFFFF;
                }
            }
			if (borderStyle == "solid")
			{
				var useWidth:Number = Math.max(sw,textField.textWidth);
				var useHeight:Number = Math.max(sh,textField.textHeight);
				
				if ((useWidth-pl-pr-2*borderThickness) < textField.textWidth) 
					useWidth = textField.textWidth+pl+pr+2*borderThickness;
				if ((useHeight-pt-pb-2*borderThickness) < textField.textHeight) 
					useHeight = textField.textHeight+pt+pb+2*borderThickness;
				
                sprite.graphics.clear();
				SolidBorderUtil.drawBorder(sprite.graphics, 
					0, 0, useWidth, useHeight,
					borderColor, backgroundColor == null ? null : bgColor, borderThickness, bgAlpha,
                    borderEllipseWidth, borderEllipseHeight);
				textField.y = ((useHeight - textField.textHeight) / 2) - 2;
				textField.x = ((useWidth - textField.textWidth) / 2) - 2;
			}			
            var backgroundImage:Object = image;
            if (backgroundImage)
            {
                var loader:Loader = new Loader();
                sprite.addChildAt(loader, 0);
                sprite.addChild(textField);
                var url:String = backgroundImage as String;
                loader.load(new URLRequest(url));
                loader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE, function (e:flash.events.Event):void { 
                    updateHitArea();
                    loader.x = pl;
                    textField.x = loader.width + pl;
                    textField.y = pt;
                    loader.y = (textField.height + pt + pb - loader.height) / 2;
                    sprite.graphics.clear();
                    SolidBorderUtil.drawBorder(sprite.graphics, 
                        0, 0, textField.x + textField.width + pr + borderThickness, 
                        textField.y + textField.height + pb + borderThickness,
                        borderColor, backgroundColor == null ? null : bgColor, borderThickness, bgAlpha,
                        borderEllipseWidth, borderEllipseHeight);
                });
            }
			var textColor:Object = ValuesManager.valuesImpl.getValue(_strand, "color", state);
			if (textColor) {
				textField.textColor = Number(textColor);
			}
		}
				
		private function textChangeHandler(event:org.apache.royale.events.Event):void
		{
			text = textModel.text;
		}
		
		private function htmlChangeHandler(event:org.apache.royale.events.Event):void
		{
			html = textModel.html;
		}
		
		private function sizeChangeHandler(event:org.apache.royale.events.Event):void
		{
			setupSkins();
		}
		
		private var upTextField:CSSTextField;
		private var downTextField:CSSTextField;
		private var overTextField:CSSTextField;
		private var upSprite:Sprite;
		private var downSprite:Sprite;
		private var overSprite:Sprite;
		
        /**
         *  The URL of an icon to use in the button
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public function get image():String
        {
            return textModel.image;
        }
        
        private function imageChangeHandler(event:org.apache.royale.events.Event):void
        {
            setupSkins();
        }

        /**
         *  The text to be displayed in the button
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function get text():String
		{
			return upTextField.text;
		}
        
        /**
         *  @private
         */
		public function set text(value:String):void
		{
			upTextField.text = value;
			downTextField.text = value;
			overTextField.text = value;
			updateHitArea();
		}
		
		private function updateHitArea():void
		{
			var useWidth:uint = Math.max(DisplayObject(_strand).width, upTextField.textWidth);
			var useHeight:uint = Math.max(DisplayObject(_strand).height, upTextField.textHeight);
			
			shape.graphics.clear();
			shape.graphics.beginFill(0xCCCCCC);
			shape.graphics.drawRect(0, 0, useWidth, useHeight);
			shape.graphics.endFill();
			
		}
		
        /**
         *  The html-formatted text to be displayed in the button
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function get html():String
		{
			return upTextField.htmlText;
		}
		
        /**
         *  @private
         */
		public function set html(value:String):void
		{
			upTextField.htmlText = value;
			downTextField.htmlText = value;
			overTextField.htmlText = value;
		}
	}
}
