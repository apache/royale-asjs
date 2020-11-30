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
package org.apache.royale.html.beads.layouts
{
	import org.apache.royale.core.IBeadLayout;
    import org.apache.royale.core.IBorderPaddingMarginValuesImpl;
	import org.apache.royale.core.IChild;
	import org.apache.royale.core.IStrand;
    import org.apache.royale.core.layout.EdgeData;
	import org.apache.royale.core.LayoutBase;
	import org.apache.royale.core.UIBase;
    import org.apache.royale.core.ValuesManager;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.geom.Rectangle;
	import org.apache.royale.html.beads.models.DividedContainerModel;
	import org.apache.royale.html.supportClasses.DividedContainerDivider;
	import org.apache.royale.utils.CSSUtils;

	/**
	 * This sub-class of DividedContainerLayout class is responsible for sizing and
	 * positioning the children of the DividedContainer into rows with separators
	 * between them.
	 *
	 * In order to correctly size and place the children, the DividedContainerLayout
	 * relies on additional information contained in the DividedContainerModel. These
	 * adjustments (which default to zero) can be changed by interacting with
	 * the DividedContainerSeparators and their mouse controllers.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9
	 */
	public class VDividedContainerLayout extends LayoutBase implements IBeadLayout
	{
		/**
		 * Constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		public function VDividedContainerLayout()
		{
		}

		/**
		 * @private
         *  @royaleignorecoercion org.apache.royale.core.IBorderPaddingMarginValuesImpl
		 */
		override public function layout():Boolean
		{
			var host:UIBase = _strand as UIBase;
			var n:int = host.numElements;
			if (n == 0) return false;

			COMPILE::JS {
				host.element.style['position'] = 'absolute';
			}

			var useWidth:Number = host.width;
			var useHeight:Number = host.height;

			var paddingMetrics:EdgeData = (ValuesManager.valuesImpl as IBorderPaddingMarginValuesImpl).getPaddingMetrics(host);
			var borderMetrics:EdgeData = (ValuesManager.valuesImpl as IBorderPaddingMarginValuesImpl).getBorderMetrics(host);

			useWidth -= paddingMetrics.left + paddingMetrics.right + borderMetrics.left + borderMetrics.right;
			useHeight -= paddingMetrics.top + paddingMetrics.bottom + borderMetrics.top + borderMetrics.bottom;

			// Separate the children from the dividers
			var remainingHeight:Number = useHeight;
			var remainingCount:Number = 0;
			var actualChildren:Array = [];
			var separators:Array = [];

			for(var i:int=0; i < n; i++) {
				var child:UIBase = host.getElementAt(i) as UIBase;
				if (child is DividedContainerDivider) {
					separators.push(child);
				} else {
					actualChildren.push(child);
					if (!isNaN(child.explicitHeight)) {
						remainingHeight -= child.explicitHeight;
					} else {
						remainingCount++;
					}
				}
			}

			// calculate defaults
			var numSeparators:Number = separators.length;
			remainingHeight -= numSeparators*10;
			var childInitialHeight:Number = remainingHeight;
			if (remainingCount > 0) {
				childInitialHeight = remainingHeight/remainingCount;
			}
			var xpos:Number = borderMetrics.left + paddingMetrics.left;
			var ypos:Number = borderMetrics.top + paddingMetrics.top;
			var j:int = 0;

			var adjustments:Array = (host.model as DividedContainerModel).pairAdjustments;
			var childHeights:Array = [];

			// size and position a child followed by a separator
			for(i=0; i < actualChildren.length; i++)
			{
				child = actualChildren[i] as UIBase;

				var childWidth:Number = useWidth;
				var childHeight:Number = childInitialHeight;
				if (!isNaN(child.percentHeight)) {
					childHeight = (child.percentHeight/100.0) * remainingHeight;
				}
				else if (!isNaN(child.explicitHeight)) {
					childHeight = child.explicitHeight;
				}
				//trace("1 - VDividedContainerLayout: Setting child to "+childWidth+" x "+childHeight);
				childHeights.push(childHeight);
			}

			//trace("2 - VDividedContainerLayout: adjusting");
			for(j=0, i=0; j < adjustments.length; j++, i++) {
				childHeights[i] += adjustments[j];
				childHeights[i+1] -= adjustments[j];
			}

			for(i=0, j=0; i < actualChildren.length; i++)
			{
				child = actualChildren[i] as UIBase;
				child.x = xpos;
				child.y = ypos;
				//trace("3 - VDividedLayout: setting child to "+useWidth+" x "+childHeights[i]);
				child.setWidth(useWidth);
				child.setHeight(childHeights[i]);
				COMPILE::JS {
					child.element.style['position'] = 'absolute';
				}

				if (j < separators.length) {
					var sep:UIBase = separators[j] as UIBase;
					sep.height = 10;
					sep.width = useWidth;
					sep.x = xpos;
					sep.y = ypos + child.height;
					COMPILE::JS {
						sep.element.style['position'] = 'absolute';
					}
					j += 1;
				}

				ypos += child.height + 10;
			}

			return true;
		}
	}
}
