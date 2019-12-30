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
package org.apache.royale.core
{
    COMPILE::SWF
    {
        import flash.display.Shape;            
    }
    COMPILE::JS
    {
    	import org.apache.royale.utils.html.getStyle;
    }
	
	import org.apache.royale.core.UIBase;
	
    /**
     *  The FilledRectangle class draws a simple filled
     *  rectangle without a border and with square corners.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	public class FilledRectangle extends UIBase
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function FilledRectangle()
		{
			super();
			
            COMPILE::SWF
            {
                _shape = new flash.display.Shape();
                this.addChild(_shape);
            }
		}
		
        COMPILE::SWF
		private var _shape:flash.display.Shape;
		
		private var _fillColor:uint = 0x000000;
        
        /**
         *  The color of the rectangle.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function get fillColor():uint
		{
			return _fillColor;
		}
        
        /**
         *  @private 
         */
		public function set fillColor(value:uint):void
		{
			_fillColor = value;
		}
		
        /**
         *  @private 
         */
		override public function addedToParent():void
		{
			super.addedToParent();
			drawRect(0, 0, this.width, this.height);
		}
		
        /**
         *  Draw the rectangle.
         *  @param x The x position of the top-left corner of the rectangle.
         *  @param y The y position of the top-left corner.
         *  @param width The width of the rectangle.
         *  @param height The height of the rectangle.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function drawRect(x:Number, y:Number, width:Number, height:Number):void
		{
            COMPILE::SWF
            {
                _shape.graphics.clear();
                _shape.graphics.beginFill(_fillColor);
                _shape.graphics.drawRect(x, y, width, height);
                _shape.graphics.endFill();                    
            }
            COMPILE::JS
            {
                var style:CSSStyleDeclaration = getStyle(this);
                style.position = 'absolute';
                style.backgroundColor = '#' + _fillColor.toString(16);
                if (!isNaN(x)) this.x = x;
                if (!isNaN(y)) this.y = y;
                if (!isNaN(width)) this.width = width;
                if (!isNaN(height)) this.height = height;
            }
		}
	}
}
