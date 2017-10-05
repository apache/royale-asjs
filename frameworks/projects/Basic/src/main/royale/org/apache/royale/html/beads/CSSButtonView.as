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
    import flash.display.DisplayObject;
    import flash.display.Loader;
    import flash.display.Shape;
    import flash.display.SimpleButton;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.net.URLRequest;
    
    import org.apache.royale.core.BeadViewBase;
    import org.apache.royale.core.IBeadView;
    import org.apache.royale.core.IStrand;
    import org.apache.royale.core.ITextModel;
    import org.apache.royale.core.ValuesManager;
    import org.apache.royale.events.Event;
    import org.apache.royale.events.IEventDispatcher;
    import org.apache.royale.utils.CSSBorderUtils;
    import org.apache.royale.utils.CSSUtils;
    import org.apache.royale.utils.StringTrimmer;

    /**
     *  The CSSButtonView class is the default view for
     *  the org.apache.royale.html.Button class.
     *  It allows the look of the button to be expressed
     *  in CSS via the background-image style.  This view
     *  does not display text.  Use CSSTextButtonView and
     *  TextButton instead.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	public class CSSButtonView extends BeadViewBase implements IBeadView
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
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

            setupBackground(overSprite, "hover");
            setupBackground(downSprite, "active");
            setupBackground(upSprite);
            
            IEventDispatcher(_strand).addEventListener("widthChanged",sizeChangeHandler);
            IEventDispatcher(_strand).addEventListener("heightChanged",sizeChangeHandler);
		}
	
        private function sizeChangeHandler(event:org.apache.royale.events.Event):void
        {
            setupSkins();
        }
        
        protected function setupSkins():void
        {
            setupSkin(overSprite, "hover");
            setupSkin(downSprite, "active");
            setupSkin(upSprite);
            updateHitArea();
        }

		private function setupSkin(sprite:Sprite, state:String = null):void
		{
			var padding:Object = ValuesManager.valuesImpl.getValue(_strand, "padding", state);
			var paddingLeft:Object = ValuesManager.valuesImpl.getValue(_strand, "padding-left", state);
			var paddingRight:Object = ValuesManager.valuesImpl.getValue(_strand, "padding-right", state);
			var paddingTop:Object = ValuesManager.valuesImpl.getValue(_strand, "padding-top", state);
			var paddingBottom:Object = ValuesManager.valuesImpl.getValue(_strand, "padding-bottom", state);
			var pl:Number = CSSUtils.getLeftValue(paddingLeft, padding, DisplayObject(_strand).width);
            var pr:Number = CSSUtils.getRightValue(paddingRight, padding, DisplayObject(_strand).width);
            var pt:Number = CSSUtils.getTopValue(paddingTop, padding, DisplayObject(_strand).height);
            var pb:Number = CSSUtils.getBottomValue(paddingBottom, padding, DisplayObject(_strand).height);
			
		    CSSBorderUtils.draw(sprite.graphics, 
					DisplayObject(_strand).width + pl + pr, 
					DisplayObject(_strand).height + pt + pb,
                    _strand as DisplayObject,
                    state, true);
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
            else {
                setupSkin(sprite, state);
                updateHitArea();
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
