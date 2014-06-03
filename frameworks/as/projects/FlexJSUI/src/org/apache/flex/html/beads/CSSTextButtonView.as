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
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	
	import org.apache.flex.core.CSSTextField;
	import org.apache.flex.core.IBeadView;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.ITextModel;
	import org.apache.flex.core.ValuesManager;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
	import org.apache.flex.html.TextButton;
	import org.apache.flex.utils.SolidBorderUtil;

    /**
     *  The CSSTextButtonView class is the default view for
     *  the org.apache.flex.html.TextButton class.
     *  It allows the look of the button to be expressed
     *  in CSS via the background-image style and displays
     *  a text label.  This view does not support right-to-left
     *  text.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
	public class CSSTextButtonView implements IBeadView
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function CSSTextButtonView()
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
		
		private var textModel:ITextModel;
		
		private var _strand:IStrand;
		
		private var shape:Shape;
		
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
			textModel = value.getBeadByType(ITextModel) as ITextModel;
			textModel.addEventListener("textChange", textChangeHandler);
			textModel.addEventListener("htmlChange", htmlChangeHandler);
			shape = new Shape();
			shape.graphics.beginFill(0xCCCCCC);
			shape.graphics.drawRect(0, 0, 10, 10);
			shape.graphics.endFill();
			SimpleButton(value).upState = upSprite;
			SimpleButton(value).downState = downSprite;
			SimpleButton(value).overState = overSprite;
			SimpleButton(value).hitTestState = shape;
			if (textModel.text !== null)
				text = textModel.text;
			if (textModel.html !== null)
				html = textModel.html;

            setupSkin(overSprite, overTextField, "hover");
			setupSkin(downSprite, downTextField, "active");
			setupSkin(upSprite, upTextField);
			
			IEventDispatcher(_strand).addEventListener("widthChanged",sizeChangeHandler);
			IEventDispatcher(_strand).addEventListener("heightChanged",sizeChangeHandler);
		}
	
		private function setupSkin(sprite:Sprite, textField:TextField, state:String = null):void
		{
			var sw:uint = DisplayObject(_strand).width;
			var sh:uint = DisplayObject(_strand).height;
			
			var borderColor:uint;
			var borderThickness:uint;
			var borderStyle:String;
			var borderStyles:Object = ValuesManager.valuesImpl.getValue(_strand, "border", state);
			if (borderStyles is Array)
			{
				borderColor = borderStyles[2];
				borderStyle = borderStyles[1];
				borderThickness = borderStyles[0];
			}
			var value:Object = ValuesManager.valuesImpl.getValue(_strand, "border-style", state);
			if (value != null)
				borderStyle = value as String;
			value = ValuesManager.valuesImpl.getValue(_strand, "border-color", state);
			if (value != null)
				borderColor = value as uint;
			value = ValuesManager.valuesImpl.getValue(_strand, "border-thickness", state);
			if (value != null)
				borderThickness = value as uint;
			var padding:Object = ValuesManager.valuesImpl.getValue(_strand, "padding", state);
			var paddingLeft:Object = ValuesManager.valuesImpl.getValue(_strand, "padding-left", state);
			var paddingRight:Object = ValuesManager.valuesImpl.getValue(_strand, "padding-right", state);
			var paddingTop:Object = ValuesManager.valuesImpl.getValue(_strand, "padding-top", state);
			var paddingBottom:Object = ValuesManager.valuesImpl.getValue(_strand, "padding-bottom", state);
			if (paddingLeft == null) paddingLeft = padding;
			if (paddingRight == null) paddingRight = padding;
			if (paddingTop == null) paddingTop = padding;
			if (paddingBottom == null) paddingBottom = padding;
			var backgroundColor:Object = ValuesManager.valuesImpl.getValue(_strand, "background-color", state);
			if (borderStyle == "solid")
			{
				var useWidth:Number = Math.max(sw,textField.textWidth);
				var useHeight:Number = Math.max(sh,textField.textHeight);
				
				if ((useWidth-Number(paddingLeft)-Number(paddingRight)-2*borderThickness) < textField.textWidth) 
					useWidth = textField.textWidth+Number(paddingLeft)+Number(paddingRight)+2*borderThickness;
				if ((useHeight-Number(paddingTop)-Number(paddingBottom)-2*borderThickness) < textField.textHeight) 
					useHeight = textField.textHeight+Number(paddingTop)+Number(paddingBottom)+2*borderThickness;
				
				SolidBorderUtil.drawBorder(sprite.graphics, 
					0, 0, useWidth, useHeight,
					borderColor, backgroundColor, borderThickness);
				textField.y = (useHeight - textField.textHeight) / 2;
				textField.x = (useWidth - textField.textWidth) / 2;
			}			
			var backgroundImage:Object = ValuesManager.valuesImpl.getValue(_strand, "background-image", state);
			if (backgroundImage)
			{
				var loader:Loader = new Loader();
				sprite.addChildAt(loader, 0);
				var url:String = backgroundImage as String;
				loader.load(new URLRequest(url));
				loader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE, function (e:flash.events.Event):void { 
					var useWidth:Number = Math.max(sw,textField.textWidth);
					var useHeight:Number = Math.max(sh,textField.textHeight);
					
					if ((useWidth-2*Number(padding)-2*borderThickness) < textField.textWidth) 
						useWidth = textField.textWidth+2*Number(padding)+2*borderThickness;
					if ((useHeight-2*Number(padding)-2*borderThickness) < textField.textHeight) 
						useHeight = textField.textHeight+2*Number(padding)+2*borderThickness;
					
					textField.y = (useHeight - textField.height) / 2;
					textField.x = (useWidth - textField.width) / 2;
					updateHitArea();
				});
			}
		}
		
		private function drawSkin() : void
		{
			setupSkin(overSprite, overTextField, "hover");
			setupSkin(downSprite, downTextField, "active");
			setupSkin(upSprite, upTextField);
			
			updateHitArea();
		}
		
		private function textChangeHandler(event:org.apache.flex.events.Event):void
		{
			text = textModel.text;
		}
		
		private function htmlChangeHandler(event:org.apache.flex.events.Event):void
		{
			html = textModel.html;
		}
		
		private function sizeChangeHandler(event:org.apache.flex.events.Event):void
		{
			drawSkin();
		}
		
		private var upTextField:CSSTextField;
		private var downTextField:CSSTextField;
		private var overTextField:CSSTextField;
		private var upSprite:Sprite;
		private var downSprite:Sprite;
		private var overSprite:Sprite;
		
        /**
         *  The text to be displayed in the button
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
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
			var padding:Object = ValuesManager.valuesImpl.getValue(_strand, "padding");
			
			if ((useWidth-2*Number(padding)) < upTextField.textWidth) 
				useWidth = upTextField.textWidth+2*Number(padding);
			if ((useHeight-2*Number(padding)) < upTextField.textHeight) 
				useHeight = upTextField.textHeight+2*Number(padding);
			
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
         *  @productversion FlexJS 0.0
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
