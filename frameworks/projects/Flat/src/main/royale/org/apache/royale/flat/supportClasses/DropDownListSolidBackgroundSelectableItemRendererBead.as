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
package org.apache.royale.flat.supportClasses
{
	
    import org.apache.royale.core.ValuesManager;
	import org.apache.royale.core.IStyleableObject;
    import org.apache.royale.html.beads.SolidBackgroundSelectableItemRendererBead;

	/**
	 *  The DropDownListStringItemRenderer is a StringItemRenderer with a particular
     *  className for use in DropDownList.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class DropDownListSolidBackgroundSelectableItemRendererBead extends SolidBackgroundSelectableItemRendererBead
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function DropDownListSolidBackgroundSelectableItemRendererBead()
		{
			super();
			
            (_strand as IStyleableObject).className = 'dropdown-menu-item-renderer';
		}
		
		/**
		 * @private
		 */
		override public function updateRenderer():void
		{
            (_strand as IStyleableObject).className = selected ? 'dropdown-menu-item-renderer-selected' : 'dropdown-menu-item-renderer';
            if (selected)
                selectedColor = ValuesManager.valuesImpl.getValue(this, 'background-color');
            if (hovered)
                highlightColor = ValuesManager.valuesImpl.getValue(this, 'background-color', "hover");
            downColor = selectedColor;
			super.updateRenderer();
		}
	}
}
