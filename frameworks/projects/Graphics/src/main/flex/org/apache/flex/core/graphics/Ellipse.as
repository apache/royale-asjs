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
package org.apache.flex.core.graphics
{
    COMPILE::AS3
    {
        import flash.geom.Point;
        import flash.geom.Rectangle;            
    }
    COMPILE::JS
    {
        import org.apache.flex.core.WrappedHTMLElement;
    }

	public class Ellipse extends GraphicShape
	{
		
		/**
		 *  Draw the ellipse.
		 *  @param x The x position of the top-left corner of the bounding box of the ellipse.
		 *  @param y The y position of the top-left corner of the bounding box of the ellipse.
		 *  @param width The width of the ellipse.
		 *  @param height The height of the ellipse.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
         *  @flexjsignorecoercion org.apache.flex.core.WrappedHTMLElement
         *  @flexjsignorecoercion SVGEllipseElement
		 */
		public function drawEllipse(x:Number, y:Number, width:Number, height:Number):void
		{
            COMPILE::AS3
            {
                graphics.clear();
                applyStroke();
                beginFill(new Rectangle(x, y, width, height), new Point(x,y));
                graphics.drawEllipse(x,y,width,height);
                endFill();                    
            }
            COMPILE::JS
            {
                var style:String = getStyleStr();
                var ellipse:WrappedHTMLElement = document.createElementNS('http://www.w3.org/2000/svg', 'ellipse') as WrappedHTMLElement;
                ellipse.flexjs_wrapper = this;
                ellipse.setAttribute('style', style);
                if (stroke)
                {
                    ellipse.setAttribute('cx', String(width / 2 + stroke.weight));
                    ellipse.setAttribute('cy', String(height / 2 + stroke.weight));
                    setPosition(x, y, stroke.weight * 2, stroke.weight * 2);
                }
                else
                {
                    ellipse.setAttribute('cx', String(width / 2));
                    ellipse.setAttribute('cy', String(height / 2));
                    setPosition(x, y, 0, 0);
                }
                ellipse.setAttribute('rx', String(width / 2));
                ellipse.setAttribute('ry', String(height / 2));
                element.appendChild(ellipse);
                
                resize(x, y, (ellipse as SVGEllipseElement).getBBox());

            }
		}
		
		override protected function draw():void
		{
			drawEllipse(0, 0, width, height);	
		}
		
	}
}