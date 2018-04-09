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
	import org.apache.royale.core.LayoutBase;
	
	import org.apache.royale.core.IBeadLayout;
    import org.apache.royale.core.IBorderPaddingMarginValuesImpl;
	import org.apache.royale.core.ILayoutChild;
	import org.apache.royale.core.ILayoutView;
    import org.apache.royale.core.layout.EdgeData;
    import org.apache.royale.core.ValuesManager;
	import org.apache.royale.html.TableCell;
	import org.apache.royale.html.TableRow;
	
	COMPILE::SWF {
		import org.apache.royale.geom.Rectangle;
		import org.apache.royale.utils.CSSUtils;
	}

    /**
     *  The TableCellLayout is the default layout for TableCell items. It places the cell's contents
	 *  vertically centered within the cell.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	public class TableCellLayout extends HorizontalLayout implements IBeadLayout
	{
        /**
         *  Constructor.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function TableCellLayout()
		{
			super();
		}

        /**
         * @copy org.apache.royale.core.IBeadLayout#layout
		 * @royaleignorecoercion org.apache.royale.core.ILayoutHost
		 * @royaleignorecoercion org.apache.royale.core.UIBase
         */
		override public function layout():Boolean
		{
            COMPILE::SWF
            {
				if (!super.layout()) return false;
				
				var contentView:ILayoutView = layoutView;
				var n:int = contentView.numElements;
				if (n == 0) return false;
				
				// find the overall size and position in the centervar contentView:ILayoutView = layoutView;
				
				var hostWidthSizedToContent:Boolean = host.isWidthSizedToContent();
				var hostHeightSizedToContent:Boolean = host.isHeightSizedToContent();
				var hostWidth:Number = hostWidthSizedToContent ? host.width : contentView.width;
				var hostHeight:Number = hostHeightSizedToContent ? host.height : contentView.height;
				
				var paddingMetrics:EdgeData = (ValuesManager.valuesImpl as IBorderPaddingMarginValuesImpl).getPaddingMetrics(host);
				var borderMetrics:EdgeData = (ValuesManager.valuesImpl as IBorderPaddingMarginValuesImpl).getBorderMetrics(host);
				
				// adjust the host's usable size by the metrics. If hostSizedToContent, then the
				// resulting adjusted value may be less than zero.
				hostWidth -= paddingMetrics.left + paddingMetrics.right + borderMetrics.left + borderMetrics.right;
				hostHeight -= paddingMetrics.top + paddingMetrics.bottom + borderMetrics.top + borderMetrics.bottom;
				
				var totalHeight:Number = 0;
				
				for(var i:int=0; i < n; i++)
				{
					var child:ILayoutChild = contentView.getElementAt(i) as ILayoutChild;
					if (child == null || !child.visible) continue;
					var positions:Object = childPositions(child);
					var margins:Object = childMargins(child, hostWidth, hostHeight);
					
					totalHeight += margins.top + child.height + margins.bottom;
				}
				
				var shiftBy:Number = (hostHeight - totalHeight)/2;
				
				for(i=0; i < n; i++)
				{
					child = contentView.getElementAt(i) as ILayoutChild;
					if (child == null || !child.visible) continue;
					child.y += shiftBy;
				}

                return true;

            }

            COMPILE::JS
            {
                return true;
            }
		}
	}
}
