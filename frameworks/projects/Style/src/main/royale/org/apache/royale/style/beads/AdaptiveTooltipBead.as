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
package org.apache.royale.style.beads
{
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.style.Tooltip;
	import org.apache.royale.core.IParentIUIBase;
	import org.apache.royale.geom.Point;
	/**
	 * Provides core functionality for managing display of Tooltips.
	 * AdaptiveTooltipBead supports avoidance of browser edges when the tooltip is displayed
	 *
	 * This file includes derived work from Spectrum Royale,
	 * also licensed under the Apache License, Version 2.0.
	 *
	 */
	public class AdaptiveTooltipBead extends TooltipBead
	{
		override protected function determinePosition(comp:IUIBase, tooltip:Tooltip):Point
		{
			var margin:int = 0;
			var pt:Point = super.determinePosition(comp, tooltip);
			var screenWidth:Number = (host.popUpParent as IParentIUIBase).width;
			var screenHeight:Number = (host.popUpParent as IParentIUIBase).height;
			if (direction == TooltipBead.LEFT && pt.x < margin)
			{
				direction = TooltipBead.RIGHT;
			} else if (direction == TooltipBead.TOP && pt.y < margin)
			{
				direction = TooltipBead.BOTTOM;
			} else if (direction == TooltipBead.RIGHT && (pt.x + tooltip.getFullHWidth() + margin) > screenWidth)
			{
				direction = TooltipBead.LEFT;
			} else if (direction == TooltipBead.BOTTOM && (pt.y + tooltip.getFullHeight() + margin) > screenHeight)
			{
				direction = TooltipBead.TOP;	
			} else
			{
				return pt;
			}
			return super.determinePosition(comp, tooltip);
		}

	}
}

