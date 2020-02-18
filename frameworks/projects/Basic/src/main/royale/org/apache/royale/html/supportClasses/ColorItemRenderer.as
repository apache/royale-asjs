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
package org.apache.royale.html.supportClasses
{
	import org.apache.royale.html.beads.SolidBackgroundSelectableItemRendererBead;
	import org.apache.royale.utils.CSSUtils;

	/**
	 *  The ColorItemRenderer class displays a color as part of a color palette
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.6
	 */
	public class ColorItemRenderer extends DataItemRenderer
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.6
		 */
		public function ColorItemRenderer()
		{
			super();

            typeNames = 'ColorItemRenderer';
        
            backgroundBead = new SolidBackgroundSelectableItemRendererBead();
            addBead(backgroundBead);
		}
        
        private var backgroundBead:SolidBackgroundSelectableItemRendererBead;

		/**
		 *  Sets the data value and uses the String version of the data for display.
		 *
		 *  @param Object data The object being displayed by the itemRenderer instance.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.6
		 *  @royaleignorecoercion String
		 */
		
		override public function set data(value:Object):void
		{
			super.data = value;
            
            var color:uint;
            if (!isNaN(uint(data)))
            {
                color = uint(data);
            } else if (dataField)
            {
                color = uint(data[dataField]);
            } else
            {
                color = 0x000000;
            }
            backgroundBead.backgroundColor = color;
		}
	}
}
