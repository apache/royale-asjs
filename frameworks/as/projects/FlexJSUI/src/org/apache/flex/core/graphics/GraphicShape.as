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
	
	import org.apache.flex.core.UIBase;
	
	public class GraphicShape extends UIBase
	{
		private var _fill:SolidColor;
		private var _stroke:SolidColorStroke;
		
		public function get stroke():SolidColorStroke
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
		public function set stroke(value:SolidColorStroke):void
		{
			_stroke = value;
		}
		
		public function get fill():SolidColor
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
		public function set fill(value:SolidColor):void
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
		
		protected function beginFill():void
		{
			if(fill)
			{
				fill.begin(this);
			}
		}
		
		protected function endFill():void
		{
			if(fill)
			{
				fill.end(this);
			}
		}
		
	}
}