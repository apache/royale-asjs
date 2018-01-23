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
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	
	import org.apache.royale.core.BeadViewBase;
	import org.apache.royale.core.CSSTextField;
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IBeadView;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IStrandWithModel;
	import org.apache.royale.core.ValuesManager;
	import org.apache.royale.html.beads.models.ImageAndTextModel;
    import org.apache.royale.utils.SolidBorderUtil;
	
	/**
	 *  The ImageButtonView class provides an image-only view
	 *  for the standard Button. Unlike the CSSButtonView, this
	 *  class does not support background and border; only images
	 *  for the up, over, and active states.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class ImageAndTextButtonView extends BeadViewBase implements IBeadView, IBead
	{
		/**
		 *  Constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function ImageAndTextButtonView()
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
		}
		
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
			super.strand = value;
            textModel = IStrandWithModel(value).model as ImageAndTextModel;
            textModel.addEventListener("textChange", textChangeHandler);
            textModel.addEventListener("htmlChange", htmlChangeHandler);
            textModel.addEventListener("imageChange", imageChangeHandler);
			
			shape = new Shape();
			shape.graphics.beginFill(0xCCCCCC);
			shape.graphics.drawRect(0, 0, 10, 10);
			shape.graphics.endFill();
			SimpleButton(value).upState = upSprite;
			SimpleButton(value).downState = downSprite;
			SimpleButton(value).overState = overSprite;
			SimpleButton(value).hitTestState = shape;
			
			setupBackground(upSprite, upTextField, 0xCCCCCC);
			setupBackground(overSprite, overTextField, 0xFFCCCC, "hover");
			setupBackground(downSprite, downTextField, 0x808080, "active");
            upTextField.styleParent = value;
            downTextField.styleParent = value;
            overTextField.styleParent = value;

		}
		
		private var upSprite:Sprite;
		private var downSprite:Sprite;
		private var overSprite:Sprite;
		private var shape:Shape;
        
        private var textModel:ImageAndTextModel;
		
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
                
		/**
		 * @private
		 */
		private function setupBackground(sprite:Sprite, textField:CSSTextField, color:uint, state:String = null):void
		{
			var backgroundImage:Object = image;
			if (backgroundImage)
			{
				var loader:Loader = new Loader();
				sprite.addChildAt(loader, 0);
                sprite.addChild(textField);
				var url:String = backgroundImage as String;
				loader.load(new URLRequest(url));
				loader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE, function (e:flash.events.Event):void { 
                    var padding:int = 2;
                    var borderWidth:int = 1;
					updateHitArea();
                    loader.x = padding;
                    textField.x = loader.width + padding;
                    textField.y = padding;
                    loader.y = (textField.height + padding + padding - loader.height) / 2;
                    sprite.graphics.clear();
                    sprite.graphics.beginFill(color);
                    sprite.graphics.drawRect(0, 0, sprite.width, sprite.height);
                    sprite.graphics.endFill();
                    SolidBorderUtil.drawBorder(sprite.graphics, 
                        0, 0, textField.x + textField.width + padding, textField.height + padding + padding,
                        0x000000, color, borderWidth);
				});
			}
		}
        
        private function textChangeHandler(event:Event):void
        {
            text = textModel.text;
        }
        
        private function htmlChangeHandler(event:Event):void
        {
            html = textModel.html;
        }
		
        private function imageChangeHandler(event:Event):void
        {
            setupBackground(upSprite, upTextField, 0xCCCCCC);
            setupBackground(overSprite, overTextField, 0xFFCCCC, "hover");
            setupBackground(downSprite, downTextField, 0x808080, "active");
        }
        
        /**
         *  The CSSTextField in the up state
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public var upTextField:CSSTextField;
        
        /**
         *  The CSSTextField in the down state
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public var downTextField:CSSTextField;
        
        /**
         *  The CSSTextField in the over state
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public var overTextField:CSSTextField;
        
        /**
         *  @copy org.apache.royale.html.core.ITextModel#text
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
            shape.graphics.clear();
            shape.graphics.beginFill(0xCCCCCC);
            shape.graphics.drawRect(0, 0, upSprite.width, upSprite.height);
            shape.graphics.endFill();
            
        }
        
        /**
         *  @copy org.apache.royale.html.core.ITextModel#text
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

        /**
		 * @private
		 */
		private function updateHitArea():void
		{
			shape.graphics.clear();
			shape.graphics.beginFill(0xCCCCCC);
			shape.graphics.drawRect(0, 0, upSprite.width, upSprite.height);
			shape.graphics.endFill();
			
		}
	}
}
