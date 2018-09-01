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
package org.apache.royale.jewel.beads.layouts
{
	import org.apache.royale.jewel.beads.layouts.StyledLayoutBase;
	import org.apache.royale.core.IBeadLayout;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IParentIUIBase;

	COMPILE::JS {
		import org.apache.royale.core.WrappedHTMLElement;
    	import org.apache.royale.core.UIBase;
    }

    /**
     *  The GridLayout class sets its childrens in a grid with cells filling all
	 *  the available space. The cells can be separated by gap.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.4
     */
	public class GridLayout extends StyledLayoutBase implements IBeadLayout
	{
        /**
         *  Constructor.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.4
         */
		public function GridLayout()
		{
			super();
		}

		/**
		 * @royalesuppresspublicvarwarning
		 */
		public static const LAYOUT_TYPE_NAMES:String = "layout grid";

		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 *  @royaleignorecoercion org.apache.royale.core.IParentIUIBase
		 *  @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
		 */
		override public function set strand(value:IStrand):void
		{
			super.strand = value;

			COMPILE::JS
			{
				if (hostClassList.contains("layout"))
					hostClassList.remove("layout");
				hostClassList.add("layout");
				if(hostClassList.contains("grid"))
					hostClassList.remove("grid");
				hostClassList.add("grid");

				setGap(_gap);
			}
		}

		private var _gap:Boolean;
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
            return _gap;
        }

		/**
		 *  @private
		 */
		public function set gap(value:Boolean):void
		{
			if (_gap != value)
            {
				COMPILE::JS
				{
					if(hostComponent)
						setGap(value);
					
					_gap = value;
				}
            }
		}

		COMPILE::JS
		private function setGap(value:Boolean):void
		{
			hostClassList.toggle("gap", value);
		}

		// protected var _gap:Number = 0;
		// /**
		//  *  Assigns variable gap to grid from 1 to 20
		//  *  Activate "gap-Xdp" effect selector to set a numeric gap 
		//  *  between grid cells
		//  *
		//  *  @langversion 3.0
		//  *  @playerversion Flash 10.2
		//  *  @playerversion AIR 2.6
		//  *  @productversion Royale 0.9.4
		//  */
		// public function get gap():Number
        // {
        //     return _gap;
        // }

		// /**
		//  * 
		//  */
		// public function set gap(value:Number):void
		// {
		// 	if (_gap != value)
        //     {
		// 		COMPILE::JS
		// 		{
		// 			if(hostComponent)
		// 				setGap(value);
					
		// 			_gap = value;
		// 		}
        //     }
		// }

		// COMPILE::JS
		// private function setGap(value:Number):void
		// {
		// 	if (value >= 0 && value <= 20)
		// 	{
		// 		if (hostClassList.contains("gap-" + _gap + "dp"))
		// 			hostClassList.remove("gap-" + _gap + "dp");
		// 		if(value != 0)
		// 			hostClassList.add("gap-" + value + "dp");
		// 	} else
		// 		throw new Error("Grid gap needs to be between 0 and 20");
		// }

        /**
         * @copy org.apache.royale.core.IBeadLayout#layout
		 * @royaleignorecoercion org.apache.royale.core.UIBase
         */
		override public function layout():Boolean
		{
            COMPILE::SWF
            {
				// SWF TODO
				return true;
            }

            COMPILE::JS
            {
				/** 
				 *  This Layout uses the following CSS rules
				 *  no code needed in JS for layout
				 * 
				 *  .layout {
				 *		display: flex;
				 *	}
				 *
				 *	.layout.grid {
				 *		flex-wrap: wrap;
				 *	}
				 *
				 *	.layout.grid > * {
				 *		flex: 1;
				 *	}
				 *
				 *	.layout.grid.gap-1dp {
				 *		margin: -1em 0 1em -1em;
				 *	}
				 *
				 *	.layout.grid.gap-1dp > * {
				 *		padding: 1em 0 0 1em;
				 *	}
				 */

                return true;
            }
		}
	}
}
