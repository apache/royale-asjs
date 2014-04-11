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
	
	import org.apache.flex.core.IBead;
	import org.apache.flex.core.IBeadView;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.ValuesManager;
	
	/**
	 *  The ImageButtonView class provides an image-only view
	 *  for the standard Button. Unlike the CSSButtonView, this
	 *  class does not support background and border; only images
	 *  for the up, over, and active states.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class ImageButtonView implements IBeadView, IBead
	{
		/**
		 *  Constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function ImageButtonView()
		{
			upSprite = new Sprite();
			downSprite = new Sprite();
			overSprite = new Sprite();
		}
		
		private var _strand:IStrand;
		
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
			
			shape = new Shape();
			shape.graphics.beginFill(0xCCCCCC);
			shape.graphics.drawRect(0, 0, 10, 10);
			shape.graphics.endFill();
			SimpleButton(value).upState = upSprite;
			SimpleButton(value).downState = downSprite;
			SimpleButton(value).overState = overSprite;
			SimpleButton(value).hitTestState = shape;
			
			setupBackground(upSprite);
			setupBackground(overSprite, "hover");
			setupBackground(downSprite, "active");
		}
		
		private var upSprite:Sprite;
		private var downSprite:Sprite;
		private var overSprite:Sprite;
		private var shape:Shape;
		
		/**
		 * @private
		 */
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
					updateHitArea();
				});
			}
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