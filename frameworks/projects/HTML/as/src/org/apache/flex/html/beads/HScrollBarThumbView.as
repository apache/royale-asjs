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
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.SimpleButton;
    import flash.display.DisplayObject;

    import org.apache.flex.core.BeadViewBase;
    import org.apache.flex.core.IBeadView;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;	
	
    /**
     *  The HScrollBarThumbView class is the view for
     *  the thumb button in a Horizontal ScrollBar.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
	public class HScrollBarThumbView extends BeadViewBase implements IBeadView
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function HScrollBarThumbView()
		{
		}
		
		private function drawView(g:Graphics, bgColor:uint):void
		{
            var ww:Number = DisplayObject(_strand).width;
            g.clear();
			g.lineStyle(1);
			g.beginFill(bgColor);
			g.drawRect(0, 0, ww, 16);
			g.endFill();
            ww = Math.round(ww / 2);
			g.moveTo(ww, 4);
			g.lineTo(ww, 12);
			g.moveTo(ww - 4, 4);
			g.lineTo(ww - 4, 12);
			g.moveTo(ww + 4, 4);
			g.lineTo(ww + 4, 12);
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
            
            upView = new Shape();
            downView = new Shape();
            overView = new Shape();
            
            drawView(upView.graphics, 0xCCCCCC);
            drawView(downView.graphics, 0x808080);
            drawView(overView.graphics, 0xEEEEEE);

            shape = new Shape();
			shape.graphics.beginFill(0xCCCCCC);
			shape.graphics.drawRect(0, 0, 16, 16);
			shape.graphics.endFill();
			SimpleButton(value).upState = upView;
			SimpleButton(value).downState = downView;
			SimpleButton(value).overState = overView;
			SimpleButton(value).hitTestState = shape;
            IEventDispatcher(_strand).addEventListener("widthChanged", widthChangedHandler);
		}

        private function widthChangedHandler(event:Event):void
        {
			DisplayObject(_strand).scaleY = 1.0;
			DisplayObject(_strand).scaleX = 1.0;
			
            var ww:Number = DisplayObject(_strand).width;
            drawView(upView.graphics, 0xCCCCCC);
            drawView(downView.graphics, 0x808080);
            drawView(overView.graphics, 0xEEEEEE);
            
            shape.graphics.clear();
            shape.graphics.beginFill(0xCCCCCC);
            shape.graphics.drawRect(0, 0, ww, 16);
            shape.graphics.endFill();
        }
        
		private var upView:Shape;
		private var downView:Shape;
		private var overView:Shape;
		
	}
}
