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
package org.apache.royale.flat.beads
{
    import flash.display.DisplayObject;
    import flash.display.Loader;
    import flash.display.Shape;
    import flash.display.SimpleButton;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.net.URLRequest;
    
    import org.apache.royale.core.BeadViewBase;
    import org.apache.royale.core.CSSShape;
    import org.apache.royale.core.IBeadView;
    import org.apache.royale.core.IStrand;
    import org.apache.royale.core.ITextModel;
    import org.apache.royale.core.ValuesManager;
    import org.apache.royale.events.Event;
    import org.apache.royale.events.IEventDispatcher;
    import org.apache.royale.utils.CSSBorderUtils;
    import org.apache.royale.utils.CSSUtils;
    import org.apache.royale.utils.StringTrimmer;
    import org.apache.royale.core.UIHTMLElementWrapper;

    /**
     *  The CSSScrollBarButtonView class is the default view for
     *  the buttons in a org.apache.royale.html.ScrollBar class.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	public class CSSScrollBarButtonView extends BeadViewBase implements IBeadView
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function CSSScrollBarButtonView()
		{
			upSprite = new Sprite();
			downSprite = new Sprite();
			overSprite = new Sprite();
            upArrowShape = new CSSShape();
            downArrowShape = new CSSShape();
            overArrowShape = new CSSShape();
            overArrowShape.state = "hover";
            upSprite.addChild(upArrowShape);
            downSprite.addChild(downArrowShape);
            overSprite.addChild(overArrowShape);
		}
		
		private var textModel:ITextModel;
		
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
			super.strand = value;
			shape = new Shape();
			shape.graphics.beginFill(0xCCCCCC);
			shape.graphics.drawRect(0, 0, 10, 10);
			shape.graphics.endFill();
			SimpleButton(value).upState = upSprite;
			SimpleButton(value).downState = downSprite;
			SimpleButton(value).overState = overSprite;
			SimpleButton(value).hitTestState = shape;

            setupBackground(overSprite, overArrowShape, "hover");
            setupBackground(downSprite, downArrowShape, "active");
            setupBackground(upSprite, upArrowShape);
            
            IEventDispatcher(_strand).addEventListener("widthChanged",sizeChangeHandler);
            IEventDispatcher(_strand).addEventListener("heightChanged",sizeChangeHandler);
		}
	
        private function sizeChangeHandler(event:org.apache.royale.events.Event):void
        {
            setupSkins();
        }
        
        protected function setupSkins():void
        {
            setupSkin(overSprite, overArrowShape, "hover");
            setupSkin(downSprite, downArrowShape, "active");
            setupSkin(upSprite, upArrowShape);
            updateHitArea();
        }

		private function setupSkin(sprite:Sprite, shape:CSSShape, state:String = null):void
		{
			var padding:Object = ValuesManager.valuesImpl.getValue(_strand, "padding", state);
			var paddingLeft:Object = ValuesManager.valuesImpl.getValue(_strand, "padding-left", state);
			var paddingRight:Object = ValuesManager.valuesImpl.getValue(_strand, "padding-right", state);
			var paddingTop:Object = ValuesManager.valuesImpl.getValue(_strand, "padding-top", state);
			var paddingBottom:Object = ValuesManager.valuesImpl.getValue(_strand, "padding-bottom", state);
            var obj:DisplayObject = (_strand as UIHTMLElementWrapper).$displayObject;
			var pl:Number = CSSUtils.getLeftValue(paddingLeft, padding, obj.width);
            var pr:Number = CSSUtils.getRightValue(paddingRight, padding, obj.width);
            var pt:Number = CSSUtils.getTopValue(paddingTop, padding, obj.height);
            var pb:Number = CSSUtils.getBottomValue(paddingBottom, padding, obj.height);
			
            var w:Object = ValuesManager.valuesImpl.getValue(shape, "width", state);
            var h:Object = ValuesManager.valuesImpl.getValue(shape, "height", state);
            shape.draw(Number(w), Number(h));
            
		    CSSBorderUtils.draw(sprite.graphics, 
					shape.width + pl + pr, 
					shape.height + pt + pb,
                    _strand as DisplayObject,
                    state, true);
		}
		
        private function setupBackground(sprite:Sprite, shape:CSSShape, state:String = null):void
        {
            var backgroundImage:Object = ValuesManager.valuesImpl.getValue(_strand, "background-image", state);
            if (backgroundImage)
            {
                var loader:Loader = new Loader();
                sprite.addChildAt(loader, 0);
                var url:String = backgroundImage as String;
                loader.load(new URLRequest(url));
                loader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE, function (e:flash.events.Event):void { 
                    setupSkin(sprite, shape, state);
                    updateHitArea();
                });
            }
            else {
                setupSkin(sprite, shape, state);
                updateHitArea();
            }
        }
        
		private var upSprite:Sprite;
		private var downSprite:Sprite;
		private var overSprite:Sprite;
        public var upArrowShape:CSSShape;
        public var downArrowShape:CSSShape;
        public var overArrowShape:CSSShape;
				
		private function updateHitArea():void
		{
			shape.graphics.clear();
			shape.graphics.beginFill(0xCCCCCC);
			shape.graphics.drawRect(0, 0, upSprite.width, upSprite.height);
			shape.graphics.endFill();
			
		}
	}
}
