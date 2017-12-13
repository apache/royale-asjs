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
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.SimpleButton;			
	
	import org.apache.royale.core.BeadViewBase;
	import org.apache.royale.core.IBeadView;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.html.Button;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.core.IChild;
	
	/**
	 *  The SliderTrackView class creates the track area for the org.apache.royale.html.Slider
	 *  component.
	 *  
	 *  @viewbead
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class SliderTrackView extends BeadViewBase implements IBeadView
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function SliderTrackView()
		{
			hitArea = new Shape();
			upView = new Shape();
			downView = new Shape();
			overView = new Shape();					
		}
		
		/**
		 * @private
		 */
		private function drawView(g:Graphics, bgColor:uint):void
		{
			var host:Button = Button(_strand);
            var button:SimpleButton = IChild(_strand).$displayObject as SimpleButton;
			g.clear();
			g.lineStyle(1,0x000000);
			g.beginFill(bgColor);
			g.drawRect(0, 0, host.width, host.height);
			g.endFill();
		}
		
		private var hitArea:Shape;
		
		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
         *  @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
		 */
		override public function set strand(value:IStrand):void
		{
			super.strand = value;
			
			drawView(hitArea.graphics, 0xDD0000);
			drawView(upView.graphics, 0xCCCCCC);
			drawView(downView.graphics, 0x808080);
			drawView(overView.graphics, 0xEEEEEE);
			
            var button:SimpleButton = IChild(value).$displayObject as SimpleButton;
			button.upState = upView;
			button.downState = downView;
			button.overState = overView;
			button.hitTestState = hitArea;
			
			IEventDispatcher(value).addEventListener("widthChanged",sizeChangeHandler);
			IEventDispatcher(value).addEventListener("heightChanged",sizeChangeHandler);					
		}
		
		private var upView:Shape;
		private var downView:Shape;
		private var overView:Shape;
		
		/**
		 * @private
		 */
		private function sizeChangeHandler( event:Event ) : void
		{
			drawView(hitArea.graphics, 0xDD0000);
			drawView(upView.graphics, 0xCCCCCC);
			drawView(downView.graphics, 0x808080);
			drawView(overView.graphics, 0xEEEEEE);
		}
	}
}
