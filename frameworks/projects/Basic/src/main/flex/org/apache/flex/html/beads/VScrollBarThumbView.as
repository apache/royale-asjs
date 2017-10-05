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
    import flash.display.DisplayObject;

    import org.apache.royale.core.BeadViewBase;
    import org.apache.royale.core.IBeadView;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;	
	
    /**
     *  The VScrollBarThumbView class is the view for
     *  the thumb button in a Vertical ScrollBar.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	public class VScrollBarThumbView extends BeadViewBase implements IBeadView
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function VScrollBarThumbView()
		{
		}
		
		private function drawView(g:Graphics, bgColor:uint):void
		{
            var hh:Number = DisplayObject(_strand).height;
            g.clear();
			g.lineStyle(1);
			g.beginFill(bgColor);
			g.drawRoundRect(0, 0, ScrollBarView.FullSize, hh, ScrollBarView.HalfSize);
			g.endFill();
		}
		
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
            
            upView = new Shape();
            downView = new Shape();
            overView = new Shape();
            
            drawView(upView.graphics, 0xc8c8c8);
            drawView(downView.graphics, 0xc8c8c8);
            drawView(overView.graphics, 0xb8b8b8);

            shape = new Shape();
			shape.graphics.beginFill(0xCCCCCC);
			shape.graphics.drawRect(0, 0, ScrollBarView.FullSize, ScrollBarView.FullSize);
			shape.graphics.endFill();
			SimpleButton(value).upState = upView;
			SimpleButton(value).downState = downView;
			SimpleButton(value).overState = overView;
			SimpleButton(value).hitTestState = shape;
            IEventDispatcher(_strand).addEventListener("heightChanged", heightChangedHandler);
		}

        private function heightChangedHandler(event:Event):void
        {
			DisplayObject(_strand).scaleY = 1.0;
			DisplayObject(_strand).scaleX = 1.0;
			
            var hh:Number = DisplayObject(_strand).height;
            drawView(upView.graphics, 0xc8c8c8);
            drawView(downView.graphics, 0xc8c8c8);
            drawView(overView.graphics, 0xb8b8b8);
            
            shape.graphics.clear();
            shape.graphics.beginFill(0xCCCCCC);
            shape.graphics.drawRect(0, 0, ScrollBarView.FullSize, hh);
            shape.graphics.endFill();
        }
        
		private var upView:Shape;
		private var downView:Shape;
		private var overView:Shape;
		
	}
}
