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
package mx.controls.beads
{
    import org.apache.royale.core.IUIBase;

	import org.apache.royale.html.beads.SelectableItemRendererBeadBase;

/**
	 * The TextColorSelectableItemRendererBead adjusts text color according to selection
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.8
	 */
	public class TextColorSelectableItemRendererBead extends SelectableItemRendererBeadBase
	{


		public function TextColorSelectableItemRendererBead(){
			selectedColor = 0x000000;
			backgroundColor = 0xffffff;
		}


		/**
		 * @private
		 */
		override public function updateRenderer():void
		{
			COMPILE::JS
			{
				var element:HTMLElement = (_strand as IUIBase).element;
				element.style.color = selected ? '#'+('00000'+selectedColor.toString(16)).substr(-6) : null;
				element.style.backgroundColor = selected ? '#'+('00000'+backgroundColor.toString(16)).substr(-6)  : null;
			}
		}
	}
}
