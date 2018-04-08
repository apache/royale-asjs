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
	 * positioning the children of the DividedContainer into columns with separators
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
	public class HDividedContainerLayout extends LayoutBase implements IBeadLayout
	{
		/**
		 * Constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		public function HDividedContainerLayout()
		{
		}

		private var _strand: IStrand;

		/**
		 * @copy org.apache.royale.core.IStrand#strand
		 */
		override public function set strand(value:IStrand):void
		{
			_strand = value;
			super.strand = value;
		}

		/**
		 * @private
         * @royaleignorecoercion org.apache.royale.core.IBorderPaddingMarginValuesImpl
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

			// Separate the children from the dividers and determine left over width
			var remainingWidth:Number = useWidth;
			var remainingCount:Number = 0;
			var actualChildren:Array = [];
			var separators:Array = [];

			for(var i:int=0; i < n; i++) {
				var child:UIBase = host.getElementAt(i) as UIBase;
				if (child is DividedContainerDivider) {
					separators.push(child);
				} else {
					actualChildren.push(child);
					if (!isNaN(child.explicitWidth)) {
						remainingWidth -= child.explicitWidth;
					} else {
						remainingCount++;
					}
				}
			}

			// calculate defaults
			var numSeparators:Number = separators.length;
			remainingWidth -= numSeparators*10;
			var childInitialWidth:Number = remainingWidth;
			if (remainingCount > 0) {
				childInitialWidth = remainingWidth/remainingCount;
			}
			var xpos:Number = borderMetrics.left + paddingMetrics.left;
			var ypos:Number = borderMetrics.top + paddingMetrics.top;
			var j:int = 0;

			var adjustments:Array = (host.model as DividedContainerModel).pairAdjustments;
			var childWidths:Array = [];

			// size and position a child followed by a separator
			for(i=0; i < actualChildren.length; i++)
			{
				child = actualChildren[i] as UIBase;

				var childWidth:Number = childInitialWidth;
				var childHeight:Number = useHeight;
				if (!isNaN(child.percentWidth)) {
					childWidth = (child.percentWidth/100.0) * remainingWidth;
				}
				else if (!isNaN(child.explicitWidth)) {
					childWidth = child.explicitWidth;
				}
				//trace("1 - HDividedContainerLayout: Setting child to "+childWidth+" x "+childHeight);
				childWidths.push(childWidth);
			}

			//trace("2 - HDividedContainerLayout: adjusting");
			for(j=0, i=0; j < adjustments.length; j++, i++) {
				childWidths[i] += adjustments[j];
				childWidths[i+1] -= adjustments[j];
			}

			for(i=0, j=0; i < actualChildren.length; i++)
			{
				child = actualChildren[i] as UIBase;
				child.x = xpos;
				child.y = ypos;
				//trace("3 - HDividedLayout: setting child to "+childWidths[i]+" x "+useHeight);
				child.setWidth(childWidths[i]);
				child.setHeight(useHeight);
				COMPILE::JS {
					child.element.style['position'] = 'absolute';
				}

				if (j < separators.length) {
					var sep:UIBase = separators[j] as UIBase;
					sep.width = 10;
					sep.height = useHeight;
					sep.x = xpos + child.width;
					sep.y = ypos;
					COMPILE::JS {
						sep.element.style['position'] = 'absolute';
					}
					j += 1;
				}

				xpos += child.width + 10;
			}

			return true;
		}
	}
}
