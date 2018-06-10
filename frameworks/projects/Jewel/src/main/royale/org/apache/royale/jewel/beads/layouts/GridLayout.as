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
	import org.apache.royale.core.LayoutBase;
	import org.apache.royale.core.IBeadLayout;
	import org.apache.royale.core.ILayoutChild;
	import org.apache.royale.core.ILayoutView;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.utils.StringUtil;
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
     *  @productversion Royale 0.9.3
     */
	public class GridLayout extends LayoutBase implements IBeadLayout
	{
        /**
         *  Constructor.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.3
         */
		public function GridLayout()
		{
			super();
		}

		COMPILE::JS
		private var hostComponent:UIBase;

		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.3
		 *  @royaleignorecoercion org.apache.royale.core.IParentIUIBase
		 *  @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
		 */
		override public function set strand(value:IStrand):void
		{
			super.strand = value;

			COMPILE::JS
			{
				hostComponent = layoutView as UIBase;
				hostComponent.className = hostComponent.className ? hostComponent.className + " layout grid" : "layout grid";

				setGap(_gap);
			}
		}

		protected var _gap:Number = 0;
		/**
		 *  Assigns variable gap to grid from 1 to 20
		 *  Activate "gap-Xdp" effect selector to set a numeric gap 
		 *  between grid cells
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.3
		 */
		public function get gap():Number
        {
            return _gap;
        }

		/**
		 *  @private
		 */
		public function set gap(value:Number):void
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
		private function setGap(value:Number):void
		{
			if (value >= 0 && value <= 20)
			{
				hostComponent.className = StringUtil.removeWord(hostComponent.className, " gap-" + _gap + "dp");
				hostComponent.className += " gap-" + value + "dp";
				// hostComponent.positioner.classList.remove("gap-" + _gap + "dp");
				// hostComponent.positioner.classList.add("gap-" + value + "dp");
			} else
				throw new Error("Grid gap needs to be between 0 and 20");
		}

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
