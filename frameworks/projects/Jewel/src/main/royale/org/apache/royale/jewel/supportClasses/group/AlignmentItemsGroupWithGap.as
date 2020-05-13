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
package org.apache.royale.jewel.supportClasses.group
{
    import org.apache.royale.jewel.beads.layouts.IGap;
    import org.apache.royale.jewel.beads.layouts.IVariableRowHeight;
    import org.apache.royale.utils.StringUtil;
    import org.apache.royale.jewel.beads.layouts.GapConstants;
    
    /**
     *  The Jewel AlignmentItemsGroupWithGap class is the base class for groups
	 *  that need to distribute its items in different ways and support gaps.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.7
     */
	public class AlignmentItemsGroupWithGap extends AlignmentItemsGroup
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.7
         */
		public function AlignmentItemsGroupWithGap()
		{
			super();            
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
            return (_layout as IGap).gap;
        }
        public function set gap(value:Number):void
        {
			typeNames = StringUtil.removeWord(typeNames, " gap-" + (_layout as IGap).gap + "x" + GapConstants.GAP_STEP + "px");
			if(value != 0)
				typeNames += " gap-" + value + "x" + GapConstants.GAP_STEP + "px";

			COMPILE::JS
            {
			if (parent)
				setClassName(computeFinalClassNames()); 
			}

			(_layout as IGap).gap = value;
        }
        
        /**
		 *  Specifies whether layout elements are allocated their preferred height.
		 *  Setting this property to false specifies fixed height rows.
		 *  
		 *  If false, the actual height of each layout element is the value of rowHeight.
		 *  The default value is true. 
		 *  
		 *  Note: From Flex but we should see what to do in Royale -> Setting this property to false causes the layout to ignore the layout elements' percentHeight property.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 */
        public function get variableRowHeight():Boolean
        {
            return (_layout as IVariableRowHeight).variableRowHeight;
        }
        public function set variableRowHeight(value:Boolean):void
        {
			typeNames = StringUtil.removeWord(typeNames, " variableRowHeight");
			(_layout as IVariableRowHeight).variableRowHeight = value;
			if(value)
				typeNames += " variableRowHeight";
            
			COMPILE::JS
            {
			if (parent)
				setClassName(computeFinalClassNames()); 
			}

        }
    }
}
