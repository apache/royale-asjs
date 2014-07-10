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
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	
    import org.apache.flex.core.BeadViewBase;
	import org.apache.flex.core.IBeadView;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.ITextModel;
	import org.apache.flex.core.ValuesManager;
	import org.apache.flex.utils.SolidBorderUtil;

    /**
     *  The CSSButtonView class is the default view for
     *  the org.apache.flex.html.Button class.
     *  It allows the look of the button to be expressed
     *  in CSS via the background-image style.  This view
     *  does not display text.  Use CSSTextButtonView and
     *  TextButton instead.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
	public class CSSButtonView extends BeadViewBase implements IBeadView
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function CSSButtonView()
		{
			upSprite = new Sprite();
			downSprite = new Sprite();
			overSprite = new Sprite();
		}
		
		private var textModel:ITextModel;
		
		private var shape:Shape;
		
        /**
         *  @copy org.apache.flex.core.IBead#strand
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		override public function set strand(value:IStrand):void
		{
			super.strand = value;
			shape = new Shape();
			shape.graphics.beginFill(0xCCCCCC);
			shape.graphics.drawRect(0, 0, 10, 10);
			shape.graphics.endFill();
			SimpleButton(value).upState = upSprite;
			SimpleButton(value).downState = downSprite;
			SimpleButton(value).overState = overSprite;
			SimpleButton(value).hitTestState = shape;

            setupBackground(overSprite, "hover");
            setupBackground(downSprite, "active");
            setupBackground(upSprite);
		}
	
		private function setupSkin(sprite:Sprite, state:String = null):void
		{
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
				SolidBorderUtil.drawBorder(sprite.graphics, 
					0, 0, sprite.width + Number(paddingLeft) + Number(paddingRight), 
					sprite.height + Number(paddingTop) + Number(paddingBottom),
					borderColor, backgroundColor, borderThickness);
			}			
		}
		
        private function setupBackground(sprite:Sprite, state:String = null):void
        {
            var backgroundImage:Object = ValuesManager.valuesImpl.getValue(_strand, "background-image", state);
            if (backgroundImage)
            {
                var loader:Loader = new Loader();
                sprite.addChildAt(loader, 0);
                var url:String = backgroundImage as String;
                loader.load(new URLRequest(url));
                loader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE, function (e:flash.events.Event):void { 
                    setupSkin(sprite, state);
                    updateHitArea();
                });
            }
        }
        
		private var upSprite:Sprite;
		private var downSprite:Sprite;
		private var overSprite:Sprite;
				
		private function updateHitArea():void
		{
			shape.graphics.clear();
			shape.graphics.beginFill(0xCCCCCC);
			shape.graphics.drawRect(0, 0, upSprite.width, upSprite.height);
			shape.graphics.endFill();
			
		}
	}
}
