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
package org.apache.royale.createjs.graphics
{
	COMPILE::SWF
	{
		import org.apache.royale.svg.Rect
	}
		
    COMPILE::JS
    {
        import createjs.Shape;
		import createjs.Stage;
		import createjs.Graphics;
        
        import org.apache.royale.createjs.core.UIBase;
        import org.apache.royale.core.WrappedHTMLElement;
    }
	
	import org.apache.royale.graphics.IFill;
	import org.apache.royale.graphics.SolidColor;
	import org.apache.royale.graphics.SolidColorStroke;
	
	/**
	 * Creates a rectangle.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Royale 0.0
	 */
    
    COMPILE::SWF
	public class Rect extends org.apache.royale.svg.Rect
	{
		// nothing special for SWF version.
	}
    
    COMPILE::JS
    public class Rect extends GraphicShape
    {
		/**
		 * @private
         * @royaleignorecoercion createjs.Shape
		 */
		override protected function redrawShape():void
		{
			if (isNaN(width) || isNaN(height)) return;
			
			var fillColor:String = null;
			var fillAlpha:Number = 1.0;
			if (fill != null) {
				fillAlpha = (fill as SolidColor).alpha;
				fillColor = convertColorToString((fill as SolidColor).color, fillAlpha);
			}
			var strokeColor:String = null;
			var strokeWeight:Number = 0;
			var strokeAlpha:Number = 1.0;
			if (stroke != null) {
				strokeWeight = (stroke as SolidColorStroke).weight;
				strokeAlpha = (stroke as SolidColorStroke).alpha;
				strokeColor = convertColorToString((stroke as SolidColorStroke).color, strokeAlpha);
			}
			
			var rect:createjs.Shape = element as createjs.Shape;
			rect.graphics.setStrokeStyle(strokeWeight);
			rect.graphics.beginStroke(strokeColor);
			rect.graphics.beginFill(fillColor);
			rect.graphics.rect(0, 0, width, height);
			
			var stage:createjs.Stage = rect.getStage();
			if (stage)
				stage.update();
		}
        
    }
}
