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
     *  The SimpleTableLayout is the layout for the Table component. On the SWF platform it mimics
	 *  the HTML <table> element and makes sure all the columns and rows are even. It does not
	 *  support column or row spanning.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	public class SimpleTableLayout extends LayoutBase implements IBeadLayout
	{
        /**
         *  Constructor.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function SimpleTableLayout()
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
				var contentView:ILayoutView = layoutView;
				
				var n:int = contentView.numElements;
				if (n == 0) return false;

				var hostWidthSizedToContent:Boolean = host.isWidthSizedToContent();
				var hostHeightSizedToContent:Boolean = host.isHeightSizedToContent();
				var hostWidth:Number = hostWidthSizedToContent ? host.width : contentView.width;
				var hostHeight:Number = hostHeightSizedToContent ? host.height : contentView.height;
				
				var borderMetrics:EdgeData = (ValuesManager.valuesImpl as IBorderPaddingMarginValuesImpl).getBorderMetrics(host);
				
				// adjust the host's usable size by the metrics. If hostSizedToContent, then the
				// resulting adjusted value may be less than zero.
				hostWidth -= borderMetrics.left + borderMetrics.right;
				hostHeight -= borderMetrics.top + borderMetrics.bottom;
				
				var numRows:int = n;
				var numCols:int = 0;

				// pass 1: figure out the number of columns (numRows is already given)
                for (var i:int = 0; i < n; i++)
                {
                    var row:TableRow = contentView.getElementAt(i) as TableRow;
					if (row == null || !row.visible) {
						numRows -= 1;
						continue;
					}
					
					numCols = Math.max(numCols,row.numElements);
				}
				
				// these defaults may change once the next pass is complete.
				var defaultColWidth:Number = hostWidth / numCols;
				var defaultRowHeight:Number = hostHeight / numRows;
				
				var remainingWidth:Number = hostWidth;
				var remainingHeight:Number = hostHeight;
				
				var colWidths:Array = new Array(numCols);
				var colActuals:Array = new Array(numCols);
				for(j=0; j < numCols; j++) { colWidths[j] = 0; colActuals[j] = 0; }
				
				var rowHeights:Array = new Array(numRows);
				for(i=0; i < numRows; i++) rowHeights[i] = 0;
				
				// pass2: figure out the sizes things should be
				for(i=0; i < n; i++)
				{
					row = contentView.getElementAt(i) as TableRow;
					if (row == null || !row.visible) continue;
					
					for(var j:int=0; j < row.numElements; j++)
					{
						var cell:TableCell = row.getElementAt(j) as TableCell;
						if (cell == null || !cell.visible) continue;
						
						if (cell.isWidthSizedToContent()) {
							colWidths[j] = Math.max(colWidths[j],0);
							colActuals[j] = Math.max(colActuals[j],cell.width);
						} else {
							if (isNaN(cell.percentWidth)) {
								colWidths[j] = Math.max(colWidths[j],cell.width);
							} else {
								colWidths[j] = Math.max(colWidths[j],(hostWidth*cell.percentWidth/100.0));
							}
							colActuals[j] = Math.max(colActuals[j],colWidths[j]);
						}
						
						if (cell.isHeightSizedToContent()) {
							rowHeights[i] = Math.max(rowHeights[i],0);
						} else {
							if (isNaN(cell.percentHeight)) {
								rowHeights[i] = Math.max(rowHeights[i],cell.height);
							} else {
								rowHeights[i] = Math.max(rowHeights[i],(hostHeight*cell.percentHeight/100.0));
							}
						}
					}
                }
				
				var needsDefaultColWidthCount:int = 0;
				var needsDefaultRowHeightCount:int = 0;
				
				// pass3: determine default sizes for cells without size
				for(i=0; i < rowHeights.length; i++) {
					if (!isNaN(rowHeights[i]) && rowHeights[i] > 0) remainingHeight -= rowHeights[i];
					else needsDefaultRowHeightCount++;
				}
				for(j=0; j < colWidths.length; j++) {
					if (colWidths[j] == 0) {
						if (colActuals[j] > defaultColWidth) {
							colWidths[j] = colActuals[j];
							remainingWidth -= colActuals[j];
						}
						else {
							needsDefaultColWidthCount++;
						}
					} else {
						remainingWidth -= colWidths[j];
					}
				}
				
				defaultColWidth = remainingWidth / needsDefaultColWidthCount;
				defaultRowHeight = remainingHeight / needsDefaultRowHeightCount;
				
				var ypos:Number = borderMetrics.top;
				
				// pass4: size everything
				for(i=0; i < n; i++)
				{
					row = contentView.getElementAt(i) as TableRow;
					if (row == null || !row.visible) continue;
					
					var xpos:Number = borderMetrics.left;
					
					// the row is an actual display object that can have border and
					// background so it must be placed and sized.
					row.x = xpos;
					row.y = ypos;
					row.setWidthAndHeight(hostWidth, rowHeights[i]);
					
					for(j=0; j < row.numElements; j++)
					{
						cell = row.getElementAt(j) as TableCell;
						if (cell == null || !cell.visible) continue;
						
						var useWidth:Number = colWidths[j] > 0 ? colWidths[j] : defaultColWidth;
						var useHeight:Number = rowHeights[i] > 0 ? rowHeights[i] : defaultRowHeight;
						
						cell.x = xpos;
						cell.y = 0;
						cell.setWidthAndHeight(useWidth, useHeight);
						
						xpos += useWidth;
					}
										
					ypos += rowHeights[i] > 0 ? rowHeights[i] : defaultRowHeight;
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
