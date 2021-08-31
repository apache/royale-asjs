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
package org.apache.royale.jewel
{
	import org.apache.royale.jewel.beads.layouts.GridLayout;
	import org.apache.royale.jewel.supportClasses.container.AlignmentItemsContainer;
	import org.apache.royale.utils.StringUtil;

	/**
	 *  The Grid class is a container that uses Grid Layout.
	 *  Grid Layout need other immediate children to work as cells
	 *  to host cell content.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.4
	 */
	public class Grid extends AlignmentItemsContainer
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function Grid()
		{
			super();

			typeNames += " " + GridLayout.LAYOUT_TYPE_NAMES;

			layout = new GridLayout();
			addBead(layout);
		}

		public function get layout():GridLayout
        {
            return _layout as GridLayout;
        }
		public function set layout(value:GridLayout):void
        {
            _layout = value;
        }
		

        /**
		 *  Assigns variable gap to grid from 1 to 20
		 *  Activate "gap-Xdp" effect selector to set a numeric gap 
		 *  between grid cells
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
        public function get gap():Boolean
        {
            return layout.gap;
        }

        public function set gap(value:Boolean):void
        {
			typeNames = StringUtil.removeWord(typeNames, " gap");
			typeNames += " gap";

			COMPILE::JS
            {
				if (parent)
                	setClassName(computeFinalClassNames()); 
			}

			layout.gap = value;
        }

        // public function get gap():Number
        // {
        //     return layout.gap;
        // }

        // public function set gap(value:Number):void
        // {
		// 	typeNames = StringUtil.removeWord(typeNames, " gap-" + layout.gap + "dp");
		// 	if(value != 0)
		// 		typeNames += " gap-" + value + "dp";

		// 	COMPILE::JS
        //     {
		// 		if (parent)
        //         	setClassName(computeFinalClassNames()); 
		// 	}

		// 	layout.gap = value;
        // }
	}
}