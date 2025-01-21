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
package org.apache.royale.createjs.core
{
    COMPILE::JS
    {
        import createjs.Container;
        import createjs.Text;
        import createjs.Shape;
        import createjs.Stage;
        
        import org.apache.royale.createjs.core.UIBase;
        import org.apache.royale.core.WrappedHTMLElement;
		
		import org.apache.royale.graphics.IFill;
		import org.apache.royale.graphics.IStroke;
		import org.apache.royale.graphics.SolidColor;
    }
	
	COMPILE::SWF
	{
		import org.apache.royale.core.UIBase;
	}
	
	/**
	 * This is the base class for CreateJS component wrappers used by Royale
	 * applications. This class provides standard properties that most of the
	 * Royale CreateJS wrapper classes use, such as a fill color.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Royale 0.0
	 */
	
	COMPILE::SWF
	public class CreateJSBase extends org.apache.royale.core.UIBase
	{
		// does nothing for SWF version.
	}
    
    COMPILE::JS
    public class CreateJSBase extends UIBase
    {		
		private var _stroke:IStroke;
		
		/**
		 * The color, weight, and alpha value of a stroke or outline.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 0.0
		 */
		public function get stroke():IStroke
		{
			return _stroke;
		}
		public function set stroke(value:IStroke):void
		{
			_stroke = value;
			redrawShape();
		}
		
		private var _fill:IFill;
		
		/**
		 * The color and alpha values of a fill.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 0.0
		 */
		public function get fill():IFill
		{
			return _fill;
		}
		public function set fill(value:IFill):void
		{
			_fill = value;
			redrawShape();
		}
		
		private var _textColor:IFill;
		
		/**
		 * The color and alpha for text.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 0.0
		 */
		public function get textColor():IFill
		{
			return _textColor;
		}
		
		public function set textColor(value:IFill):void
		{
			_textColor = value;
			redrawShape();
		}
		
		/**
		 * @private
		 */
		override public function set x(value:Number):void
		{
			super.x = value;
			redrawShape();
		}
		
		/**
		 * @private
		 */
		override public function set y(value:Number):void
		{
			super.y = value;
			redrawShape();
		}
		
		/**
		 * @private
		 */
		override public function set width(value:Number):void
		{
			super.width = value;
			redrawShape();
		}
		
		/**
		 * @private
		 */
		override public function set height(value:Number):void
		{
			super.height = value;
			redrawShape();
		}
		
		/**
		 * The redrawShape function is called whenever visual changes are made
		 * to a component. This includes its size, position, and color. Each
		 * subclass provides this function.
		 * @private
		 */
		protected function redrawShape():void
		{
			// handle in subclass
		}
    }
}
