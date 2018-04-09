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
//	import org.apache.royale.html.beads.layouts.HorizontalLayout;

	import org.apache.royale.core.LayoutBase;
    import org.apache.royale.core.IBorderPaddingMarginValuesImpl;
	import org.apache.royale.core.ILayoutChild;
	import org.apache.royale.core.ILayoutHost;
	import org.apache.royale.core.ILayoutView;
	import org.apache.royale.core.ILayoutParent;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IParentIUIBase;
    import org.apache.royale.core.layout.EdgeData;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.events.Event;

	COMPILE::SWF {
		import org.apache.royale.core.IUIBase;
		import org.apache.royale.core.ValuesManager;
		import org.apache.royale.events.IEventDispatcher;
		import org.apache.royale.geom.Rectangle;
		import org.apache.royale.utils.CSSUtils;
	}

	public class HorizontalFlexLayout extends LayoutBase
	{
		/**
		 * Constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
		public function HorizontalFlexLayout()
		{
			super();
		}

		private var _grow:Number = -1;

		/**
		 * Sets the amount items grow in proportion to other items.
		 * The default is 0 which prevents the items from expanding to
		 * fit the space. Use a negative value to unset this property.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
		public function get grow():Number {
			return _grow;
		}
		public function set grow(value:Number):void {
			_grow = value;
		}

		private var _shrink:Number = -1;

		/**
		 * Sets the amount an item may shrink in proportion to other items.
		 * The default is 1 which allows items to shrink to fit into the space.
		 * Set this to 0 if you want to allow scrolling of the space. Use a
		 * negative value to unset this property.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
		public function get shrink():Number {
			return _shrink;
		}
		public function set shrink(value:Number):void {
			_shrink = value;
		}

		/**
		 * @copy org.apache.royale.core.IBeadLayout#layout
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
         *  @royaleignorecoercion org.apache.royale.core.IBorderPaddingMarginValuesImpl
		 */
		COMPILE::SWF
		override public function layout():Boolean
		{
			
			var contentView:ILayoutView = layoutView;

			var n:Number = contentView.numElements;
			if (n == 0) return false;

			var spacing:String = "none";

			var maxWidth:Number = 0;
			var maxHeight:Number = 0;
			var growCount:Number = 0;
			var childData:Array = [];
			var hostWidthSizedToContent:Boolean = host.isWidthSizedToContent();
			var hostHeightSizedToContent:Boolean = host.isHeightSizedToContent();
			var hostWidth:Number = host.width;
			var hostHeight:Number = host.height;

			var ilc:ILayoutChild;
			var data:Object;
			var canAdjust:Boolean = false;
			
			var paddingMetrics:EdgeData = (ValuesManager.valuesImpl as IBorderPaddingMarginValuesImpl).getPaddingMetrics(host);
			var borderMetrics:EdgeData = (ValuesManager.valuesImpl as IBorderPaddingMarginValuesImpl).getBorderMetrics(host);
			
			// adjust the host's usable size by the metrics. If hostSizedToContent, then the
			// resulting adjusted value may be less than zero.
			hostWidth -= paddingMetrics.left + paddingMetrics.right + borderMetrics.left + borderMetrics.right;
			hostHeight -= paddingMetrics.top + paddingMetrics.bottom + borderMetrics.top + borderMetrics.bottom;
			
			if ((hostWidth <= 0 && !hostWidthSizedToContent) || (hostHeight <= 0 && !hostHeightSizedToContent)) return false;
			
			var remainingWidth:Number = hostWidth;

			//trace("HorizontalFlexLayout for "+UIBase(host).id+" with remainingWidth: "+remainingWidth);

			// First pass determines the data about the child.
			for(var i:int=0; i < n; i++)
			{
				var child:IUIBase = contentView.getElementAt(i) as IUIBase;
				if (child == null || !child.visible) {
					childData.push({width:0, height:0, mt:0, ml:0, mr:0, mb:0, canAdjust:false});
					continue;
				}

				ilc = child as ILayoutChild;
				
				var margins:Object = childMargins(child, hostWidth, hostHeight);

				var flexGrow:Object = ValuesManager.valuesImpl.getValue(child, "flex-grow");
				var growValue:Number = 0;
				if (flexGrow != null) {
					growValue = Number(flexGrow);
					if (!isNaN(growValue) && growValue > 0) growCount++;
					else growValue = 0;
				}

				var useHeight:Number = -1;
				if (!hostHeightSizedToContent) {
					if (ilc) {
						if (!isNaN(ilc.percentHeight)) useHeight = hostHeight * (ilc.percentHeight/100.0);
						else if (!isNaN(ilc.explicitHeight)) useHeight = ilc.explicitHeight;
						else useHeight = hostHeight;
					}
				}

				var useWidth:Number = -1;
				if (ilc) {
					if (!isNaN(ilc.explicitWidth)) useWidth = ilc.explicitWidth;
					else if (!isNaN(ilc.percentWidth)) useWidth = hostWidth * (ilc.percentWidth/100.0);
					else if (ilc.width > 0) useWidth = ilc.width;
				}
				if (growValue == 0 && useWidth > 0) remainingWidth -= useWidth + margins.left + margins.right;
				else remainingWidth -= margins.left + margins.right;

				if (maxWidth < useWidth) maxWidth = useWidth;
				if (maxHeight < useHeight) maxHeight = useHeight;

				childData.push({width:useWidth, height:useHeight, 
								mt:margins.top, ml:margins.left, mr:margins.right, mb:margins.bottom, 
								grow:growValue, canAdjust:canAdjust});
			}

			var xpos:Number = borderMetrics.left + paddingMetrics.left;
			var ypos:Number = borderMetrics.top + paddingMetrics.top;

			// Second pass sizes and positions the children based on the data gathered.
			for(i=0; i < n; i++)
			{
				child = contentView.getElementAt(i) as IUIBase;
				data = childData[i];
				//if (data.width == 0 || data.height == 0) continue;

				useHeight = (data.height < 0 ? maxHeight : data.height);

				var setWidth:Boolean = true;
				if (data.width != 0) {
					if (data.grow > 0 && growCount > 0) {
						useWidth = remainingWidth / growCount;
						setWidth = false;
					} else {
						useWidth = data.width;
					}
				} else {
					useWidth = child.width;
				}

				ilc = child as ILayoutChild;
				if (ilc) {
					ilc.setX(xpos + data.ml);
					ilc.setY(ypos + data.mt);
					if (data.height > 0) {
						//ilc.height = useHeight;
						ilc.setHeight(useHeight);
					}
					if (useWidth > 0) {
						if (setWidth) ilc.setWidth(useWidth);
						else ilc.width = useWidth;
					}
				} else {
					child.x = xpos + data.ml;
					child.y = ypos + data.mt;
					child.height = useHeight;
					if (data.width > 0) {
						child.width = useWidth;
					}
				}

				xpos += useWidth + data.mr + data.ml;

				//trace("HorizontalFlexLayout: setting child "+i+" to "+child.width+" x "+child.height+" at "+child.x+", "+child.y);
			}

			//trace("HorizontalFlexLayout: complete");

			return true;
		}
		/**
		 * @copy org.apache.royale.core.IBeadLayout#layout
		 * @royaleignorecoercion org.apache.royale.core.ILayoutHost
		 * @royaleignorecoercion org.apache.royale.core.UIBase
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
		COMPILE::JS
		override public function layout():Boolean
		{

			var contentView:ILayoutView = layoutView;

			// set the display on the contentView
			(contentView as UIBase).setDisplayStyleForLayout("flex");
			// contentView.element.style["display"] = "flex";
			contentView.element.style["flex-flow"] = "row";

			var n:int = contentView.numElements;
			if (n == 0) return false;

			for(var i:int=0; i < n; i++) {
				var child:UIBase = contentView.getElementAt(i) as UIBase;
				if (!child)
				{
					continue;
				}
				
				if (grow >= 0) child.element.style["flex-grow"] = String(grow);
				if (shrink >= 0) child.element.style["flex-shrink"] = String(shrink);
				if (!isNaN(child.percentWidth))
					child.element.style["flex-basis"] = child.percentWidth.toString() + "%";
				child.dispatchEvent(new Event("layoutNeeded"));
			}

			return true;
		}
	}
}
