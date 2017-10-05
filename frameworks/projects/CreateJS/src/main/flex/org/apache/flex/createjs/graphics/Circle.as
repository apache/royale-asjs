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
		import org.apache.royale.svg.Circle
	}

    COMPILE::JS
    {
        import createjs.Shape;
		import createjs.Stage;

        import org.apache.royale.createjs.core.UIBase;
        import org.apache.royale.core.WrappedHTMLElement;
    }

    import org.apache.royale.events.Event;
	import org.apache.royale.graphics.IFill;
	import org.apache.royale.graphics.SolidColor;
	import org.apache.royale.graphics.SolidColorStroke;

	/**
	 * Creates a circle.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Royale 0.0
	 */

    COMPILE::SWF
	public class Circle extends org.apache.royale.svg.Circle
	{
		// nothing special for SWF version.
	}

    COMPILE::JS
    public class Circle extends GraphicShape
    {
		private var _radius:Number = 0;

		/**
		 * The radius of the circle.
	 	 *
	 	 *  @langversion 3.0
	 	 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 0.0
		 */
		public function get radius():Number
		{
			return _radius;
		}
		public function set radius(value:Number):void
		{
			if (value != _radius) {
				var centerX:Number = super.x + _radius;
				var centerY:Number = super.y + _radius;

				_radius = value;

				this.x = centerX;
				this.y = centerY;

				dispatchEvent(new Event("radiusChanged"));
			}
		}

		/**
		 * The center X position of the circle.
	 	 *
	 	 *  @langversion 3.0
	 	 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 0.0
		 */
		override public function set x(value:Number):void
		{
			var realX:Number = value - radius;
			super.x = realX;
		}
		override public function get x():Number
		{
			var realX:Number = super.x;
			return realX + radius;
		}

		/**
		 * The center Y position of the circle.
	 	 *
	 	 *  @langversion 3.0
	 	 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 0.0
		 */
		override public function set y(value:Number):void
		{
			var realY:Number = value - radius;
			super.y = realY;
		}
		override public function get y():Number
		{
			var realY:Number = super.y;
			return realY + radius;
		}

		/**
		 * @private
         * @royaleignorecoercion createjs.Shape
	 	 *
	 	 *  @langversion 3.0
	 	 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 0.0
		 */
		override protected function redrawShape():void
		{
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

			var circle:createjs.Shape = element as createjs.Shape;
			circle.graphics.setStrokeStyle(strokeWeight);
			circle.graphics.beginStroke(strokeColor);
			circle.graphics.beginFill(fillColor);
			circle.graphics.drawCircle(0, 0, radius);

			var stage:createjs.Stage = circle.getStage();
			if (stage)
				stage.update();
		}

    }
}
