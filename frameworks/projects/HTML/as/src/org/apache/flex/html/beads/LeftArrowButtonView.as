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
	import org.apache.flex.core.IStrand;
    import org.apache.flex.events.Event;
	
    /**
     *  The LeftArrowButtonView class is the view for
     *  the left arrow button in a ScrollBar and other controls.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
	public class LeftArrowButtonView extends BeadViewBase implements IBeadView
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function LeftArrowButtonView()
		{
			upView = new Shape();
			downView = new Shape();
			overView = new Shape();

			drawView(upView.graphics, 0xCCCCCC);
			drawView(downView.graphics, 0x808080);
			drawView(overView.graphics, 0xEEEEEE);
		}
		
		private function drawView(g:Graphics, bgColor:uint):void
		{
			g.lineStyle(1);
			g.beginFill(bgColor);
			g.drawRect(0, 0, 16, 16);
			g.endFill();
			g.lineStyle(0);
			g.beginFill(0);
			g.moveTo(4, 8);
			g.lineTo(12, 12);
			g.lineTo(12, 4);
			g.lineTo(4, 8);
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
			shape.graphics.drawRect(0, 0, 16, 16);
			shape.graphics.endFill();
			SimpleButton(value).upState = upView;
			SimpleButton(value).downState = downView;
			SimpleButton(value).overState = overView;
			SimpleButton(value).hitTestState = shape;
            
            SimpleButton(_strand).addEventListener("widthChanged",sizeChangeHandler);
            SimpleButton(_strand).addEventListener("heightChanged",sizeChangeHandler);
		}
        
		private var upView:Shape;
		private var downView:Shape;
		private var overView:Shape;
		
        private function sizeChangeHandler(event:Event):void
        {
            SimpleButton(_strand).scaleX = SimpleButton(_strand).width / 16;
            SimpleButton(_strand).scaleY = SimpleButton(_strand).height / 16;
        }
	}
}
