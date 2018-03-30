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

package mx.containers.beads
{

import mx.core.Container;
import mx.core.EdgeMetrics;
import mx.core.IFlexDisplayObject;
/*
import mx.core.mx_internal;

use namespace mx_internal;
*/


/**
 *  @private
 *  The ApplicationLayout class is for internal use only.
 */
public class ApplicationLayout extends BoxLayout
{
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------

	/**
	 *  Constructor.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function ApplicationLayout()
	{
		super();
	}

	//--------------------------------------------------------------------------
	//
	//  Overridden methods
	//
	//--------------------------------------------------------------------------

	/**
	 *  @private
	 *  Lay out children as per Application layout rules.
	 */
	override public function updateDisplayList(unscaledWidth:Number,
											   unscaledHeight:Number):void
	{
		super.updateDisplayList(unscaledWidth, unscaledHeight);
		
		var target:Container = super.target;

		// If there are scrollbars, and any children are at negative
		// co-ordinates, make adjustments to bring them into the visible area.
		if ((getHorizontalAlignValue() > 0) ||
			(getVerticalAlignValue() > 0))
		{
			var paddingLeft:Number = target.getStyle("paddingLeft");
			var paddingTop:Number = target.getStyle("paddingTop");
			var oX:Number = 0;
			var oY:Number = 0;

			var n:int = target.numChildren;
			var i:int;
			var child:IFlexDisplayObject;

			for (i = 0; i < n; i++)
			{
				child = IFlexDisplayObject(target.getChildAt(i));

				if (child.x < paddingLeft)
					oX = Math.max(oX, paddingLeft - child.x);

				if (child.y < paddingTop)
					oY = Math.max(oY, paddingTop - child.y);
			}

			if (oX != 0 || oY != 0)
			{
				for (i = 0; i < n; i++)
				{
					child = IFlexDisplayObject(target.getChildAt(i));
					child.move(child.x + oX, child.y + oY);
				}
			}
		}
	}
}

}
