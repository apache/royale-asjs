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
    COMPILE::SWF
    {
        import flash.display.Sprite;
    }
    import org.apache.royale.core.IBead;
    import org.apache.royale.core.IUIBase;
    import org.apache.royale.core.IStrand;
    import org.apache.royale.utils.CSSUtils;

	/**
	 *  UnselectableElement bead prevents from text selection of html element
	 *
	 *  @viewbead
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.8
	 */
	public class SolidBackgroundSelectableItemRendererBead extends SelectableItemRendererBeadBase
	{

		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
		public function SolidBackgroundSelectableItemRendererBead()
		{
		}

        /**
         * @private
		 *  @royaleignorecoercion org.apache.royale.core.IUIBase
         */
        override public function updateRenderer():void
        {
            COMPILE::SWF
            {
                super.updateRenderer();
                
                var host:Sprite = _strand as Sprite;
                host.graphics.clear();
                host.graphics.beginFill(useColor, (down||selected||hovered)?1:0);
                host.graphics.drawRect(0, 0, host.width, host.height);
                host.graphics.endFill();
            }
            COMPILE::JS
            {
                super.updateRenderer();
                var element:HTMLElement = (_strand as IUIBase).element;
                element.style.backgroundColor = CSSUtils.attributeFromColor(useColor);
            }
        }
        

	}
}
