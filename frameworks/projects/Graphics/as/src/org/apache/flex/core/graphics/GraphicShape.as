/**
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.apache.flex.core.graphics
{
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import org.apache.flex.core.UIBase;
	
	public class GraphicShape extends UIBase
	{
		private var _fill:IFill;
		private var _stroke:IStroke;
		
		public function get stroke():IStroke
		{
			return _stroke;
		}
		
		/**
		 *  A solid color fill. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion FlexJS 0.0
		 */
		public function set stroke(value:IStroke):void
		{
			_stroke = value;
		}
		
		public function get fill():IFill
		{
			return _fill;
		}
		/**
		 *  A solid color fill. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion FlexJS 0.0
		 */
		public function set fill(value:IFill):void
		{
			_fill = value;
		}
		
		protected function applyStroke():void
		{
			if(stroke)
			{
				stroke.apply(this);
			}
		}
		
		protected function beginFill(targetBounds:Rectangle,targetOrigin:Point):void
		{
			if(fill)
			{
				fill.begin(this, targetBounds,targetOrigin);
			}
		}
		
		protected function endFill():void
		{
			if(fill)
			{
				fill.end(this);
			}
		}
		
		/**
		 * This is where the drawing methods get called from
		 */
		protected function draw():void
		{
			//Overwrite in subclass
		}
		
		override public function addedToParent():void
		{
			super.addedToParent();
			draw();
		}
		
	}
}