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
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.SimpleButton;
	
	import org.apache.flex.core.BeadViewBase;
	import org.apache.flex.core.IBeadView;
	import org.apache.flex.core.IChild;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.events.Event;
    import org.apache.flex.events.IEventDispatcher;
	
    /**
     *  The RightArrowButtonView class is the view for
     *  the right arrow button in a ScrollBar and other controls.
     *  
	 *  @viewbead
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
	public class RightArrowButtonView extends BeadViewBase implements IBeadView
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function RightArrowButtonView()
		{
			upView = new Shape();
			downView = new Shape();
			overView = new Shape();

			drawView(upView.graphics, 0xf8f8f8);
			drawView(downView.graphics, 0xd8d8d8);
			drawView(overView.graphics, 0xe8e8e8);
		}
		
		private function drawView(g:Graphics, bgColor:uint):void
		{
			g.lineStyle(1, 0x808080);
			g.beginFill(bgColor);
			g.drawRoundRect(0, 0, ScrollBarView.FullSize, ScrollBarView.FullSize, ScrollBarView.ThirdSize);
			g.endFill();
			g.lineStyle(0);
			g.beginFill(0);
			g.moveTo(ScrollBarView.QuarterSize, ScrollBarView.QuarterSize);
			g.lineTo(ScrollBarView.ThreeQuarterSize, ScrollBarView.HalfSize);
			g.lineTo(ScrollBarView.QuarterSize, ScrollBarView.ThreeQuarterSize);
			g.lineTo(ScrollBarView.QuarterSize, ScrollBarView.QuarterSize);
			g.endFill();
		}
		
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
			shape.graphics.drawRect(0, 0, ScrollBarView.FullSize, ScrollBarView.FullSize);
			shape.graphics.endFill();
            var button:SimpleButton = IChild(value).$displayObject as SimpleButton;
			button.upState = upView;
			button.downState = downView;
			button.overState = overView;
			button.hitTestState = shape;
            
            IEventDispatcher(_strand).addEventListener("widthChanged",sizeChangeHandler);
            IEventDispatcher(_strand).addEventListener("heightChanged",sizeChangeHandler);
		}
        
		private var upView:Shape;
		private var downView:Shape;
		private var overView:Shape;
		
        private function sizeChangeHandler(event:Event):void
        {
            var button:SimpleButton = IChild(_strand).$displayObject as SimpleButton;
            button.scaleX = button.width / ScrollBarView.FullSize;
            button.scaleY = button.height / ScrollBarView.FullSize;
        }
	}
}
