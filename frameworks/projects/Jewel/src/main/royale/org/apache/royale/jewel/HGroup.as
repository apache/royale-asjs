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
    import org.apache.royale.jewel.beads.layouts.HorizontalLayout;
    import org.apache.royale.utils.StringUtil;

    /**
     *  This Group subclass uses HorizontalLayout as its default layout.
     *
     *  @toplevel
     *  @see org.apache.royale.jewel.beads.layouts
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.4
     */
	public class HGroup extends Group
	{
        /**
         *  Constructor.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.4
         */
		public function HGroup()
		{
			super();

			typeNames += " " + HorizontalLayout.LAYOUT_TYPE_NAMES;

			layout = new HorizontalLayout();
			addBead(layout);
		}

        public function get layout():HorizontalLayout
        {
            return _layout as HorizontalLayout;
        }
		public function set layout(value:HorizontalLayout):void
        {
            _layout = value;
        }
        
        /**
		 *  Assigns variable gap in steps of GAP_STEP. You have available GAPS*GAP_STEP gap styles
		 *  Activate "gap-{X}x{GAP_STEP}px" effect selector to set a numeric gap between elements.
		 *  i.e: gap-2x3px will result in a gap of 6px
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
        public function get gap():Number
        {
            return layout.gap;
        }

        public function set gap(value:Number):void
        {
			typeNames = StringUtil.removeWord(typeNames, " gap-" + layout.gap + "x" + HorizontalLayout.GAP_STEP + "px");
			if(value != 0)
				typeNames += " gap-" + value + "x" + HorizontalLayout.GAP_STEP + "px";

			COMPILE::JS
            {
				if (parent)
                	setClassName(computeFinalClassNames()); 
			}

			layout.gap = value;
        }
	}
}
