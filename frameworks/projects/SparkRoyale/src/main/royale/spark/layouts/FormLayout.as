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

package spark.layouts
{
	import mx.containers.utilityClasses.ConstraintColumn;
	import mx.containers.utilityClasses.Flex;
	import mx.core.ILayoutElement;
	import mx.core.mx_internal;
	
	import spark.components.supportClasses.GroupBase;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.layouts.supportClasses.LayoutBase;

    import org.apache.royale.events.Event;
    
	use namespace mx_internal;
	
	/**
	 *  The FormLayout class defines the default layout for Spark Form skins.
	 *  FormLayout provides a vertical layout for the child FormItem containers in the Form.
	 *  
	 *  If any of the child containers uses a FormItemLayout, FormLayout will
	 *  align the ConstraintColumns of each child.
	 *  The number of columns across children should be the same, and the columns
	 *  should have the same type of width setting.
	 *  For example, if the first child's second column has a percent width, then the 
	 *  second child's second column should also be a percent width.
	 *
	 *  <p><b>Note</b>: Only use the FormLayout class with the Spark Form container. 
	 *  Do not use it to lay out the contents of any other container.</p>
	 *
	 *  @see spark.components.Form
	 *  @see spark.components.FormHeading
	 *  @see spark.components.FormItem
	 *  @see spark.layouts.FormItemLayout
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 2.5
	 *  @productversion Flex 4.5
	 */
	public class FormLayout extends VerticalLayout
	{
		//--------------------------------------------------------------------------
		//
		//  Class methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 *  Return the sum of all of the column widths
		 */
		private static function calculateColumnWidthsSum(columnWidths:Vector.<Number>):Number
		{
			if (columnWidths == null)
				return 0;
			
			var sum:Number = 0;
			var columnWidthsLength:int = columnWidths.length;
			for (var i:int = 0; i < columnWidthsLength; i++)
			{
				sum += columnWidths[i];
			}
			
			return sum;
		}
		
		/**
		 *  @private
		 *  Look for the layout property of several known types. 
		 *  For Form, we want the content layout. 
		 *  For SkinnableComponent, we want the skin's layout. 
		 *  For GroupBase, we get the layout (it has no skin).
		 *  If that layout is an IFormItemLayout, then it will
		 *  participate in the FormLayout's column alignment
		 */ 
		private static function getElementLayout(elt:ILayoutElement):LayoutBase
		{
			var layout:LayoutBase = null;
			
			if (elt is SkinnableComponent)
			{
				var skin:GroupBase = SkinnableComponent(elt).skin as GroupBase;
				if (skin)
					layout = skin.layout as LayoutBase;
			}
			else if (elt is GroupBase)
			{
				layout = GroupBase(elt).layout as LayoutBase;
			}
			
			return layout;
		}
		
		/**
		 *  @private
		 *  Returns a vector containing the layout elements that have a FormItemLayout and
		 *  thus are participating in the Form's column alignment step.
		 */ 
		private static function getFormItems(layoutTarget:GroupBase):Vector.<ILayoutElement>
		{
			if (!layoutTarget)
				return new Vector.<ILayoutElement>();
			
			const nElts:int = layoutTarget.numElements;
			var elt:ILayoutElement;
			var formItems:Vector.<ILayoutElement> = new Vector.<ILayoutElement>();
			
			for (var i:int = 0; i < nElts; i++)
			{
				elt = layoutTarget.getElementAt(i) as ILayoutElement;
				if (!elt.includeInLayout)
					continue;
				
				if (getElementLayout(elt) is FormItemLayout)
					formItems.push(elt);
			}
			
			return formItems;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */                  
		public function FormLayout()
		{
			super();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 */
		override public function set target(value:GroupBase):void
		{
			if (target == value)
				return;
			
			// reset FormItemLayout columns when value is null.
			// target is set to null in GroupBase when swapping layouts.
			if (value == null)
			{
				var layout:LayoutBase;
				const nElts:int = target.numElements;
				var elt:ILayoutElement
				
				for (var i:int = 0; i < nElts; i++)
				{ 
					elt = target.getElementAt(i) as ILayoutElement;
					if (!elt.includeInLayout)
						continue;
					
					layout = getElementLayout(elt);
					
					// Reset the column widths of each FormItemLayout
					if (layout is FormItemLayout)
						(layout as FormItemLayout).setLayoutColumnWidths(null);
				}
			}
			
			super.target = value;
		}
		
		//--------------------------------------------------------------------------
		//
		//  IFormLayout Implementation
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 *  Overridden column widths value to be used.
		 */
		private var columnWidthsOverride:Vector.<Number>;
		
		/**
		 *  @private
		 */
		public function getMeasuredColumnWidths():Vector.<Number>
		{
			const layoutTarget:GroupBase = target;
			if (!layoutTarget)
				return null;
			
			var formItems:Vector.<ILayoutElement> = getFormItems(layoutTarget);
			
			return calculateColumnMaxWidths(formItems);
		}
		
		/**
		 *  @private
		 */
		public function setLayoutColumnWidths(value:Vector.<Number>):void
		{
			columnWidthsOverride = value;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 */
		override public function measure():void
		{
			super.measure();
			
			const layoutTarget:GroupBase = target;
			if (!layoutTarget)
				return;
			
			var formItems:Vector.<ILayoutElement> = getFormItems(layoutTarget);
			var hPadding:Number = paddingLeft + paddingRight;
			
			// Calculate preferred width based on columns
			var columnMaxWidths:Vector.<Number> = columnWidthsOverride == null ? calculateColumnMaxWidths(formItems) : columnWidthsOverride;
			var formWidth:Number = calculateColumnWidthsSum(columnMaxWidths) + hPadding;
			
			// Calculate minimum preferred width based on columns
			constrainPercentColumnWidths(columnMaxWidths, 0, formItems);
			var formMinWidth:Number = calculateColumnWidthsSum(columnMaxWidths) + hPadding;
			
			// use measured column widths to set Form's measuredWidth
			// Assumes measuredWidth is already set in super.measure()
			layoutTarget.measuredWidth = Math.max(formWidth, layoutTarget.measuredWidth);
			layoutTarget.measuredMinWidth = Math.max(formMinWidth, layoutTarget.measuredMinWidth);
		}
		
		/**
		 *  @private
		 */
		override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{            
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			const layoutTarget:GroupBase = target;
			if (!layoutTarget)
				return;
			
			var formItems:Vector.<ILayoutElement> = getFormItems(layoutTarget);
			
			// Need to get the max column widths again because they might have changed
			// due to resolution of certain constraints
			var columnMaxWidths:Vector.<Number> = (columnWidthsOverride == null) ? calculateColumnMaxWidths(formItems) : columnWidthsOverride;
			var hPadding:Number = paddingLeft + paddingRight;
			
			if (columnMaxWidths.length > 0)
			{
				// Adjust percent size columns to fit in the Form's width
				constrainPercentColumnWidths(columnMaxWidths, unscaledWidth - hPadding, formItems);
				
				for each (var formItem:ILayoutElement in formItems)
				{
					// Force each form item to use the max column widths
					var fiLayout:FormItemLayout = getElementLayout(formItem) as FormItemLayout;
					fiLayout.setLayoutColumnWidths(columnMaxWidths);
				}
				
				// Recalculate contentWidth; contentHeight already includes padding.
				var contentWidth:Number = calculateColumnWidthsSum(columnMaxWidths);
				layoutTarget.setContentSize(contentWidth + hPadding, layoutTarget.contentHeight);
                
                for each (formItem in formItems)
                {
                    formItem.dispatchEvent(new Event("layoutNeeded"));
                }
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 *  Iterate through all of the form items (elements with a FormItemLayout layout)
		 *  and calculate the maximum width for each column.
		 * 
		 *  If a column is flexible (has percentWidth), it is treated the same as a content
		 *  width column.
		 *  
		 *  @param formItems Vector of items with a FormItemLayout.
		 *  
		 *  @return A vector of the maximum widths for the columns of form items.
		 */
		private function calculateColumnMaxWidths(formItems:Vector.<ILayoutElement>):Vector.<Number>
		{
			// TODO (klin): Add support for columns with different types of widths across different
			// form items. This would require additional parameter of availableWidth.
			if (formItems.length == 0)
				return new Vector.<Number>();
			
			var columnMaxWidths:Vector.<Number> = new Vector.<Number>();
			var formItem:ILayoutElement;
			var fiLayout:FormItemLayout;
			var lastColumnCount:Number = NaN;
			
			// Find the preferred column widths for each form item and calculate the max.
			for each (formItem in formItems)
			{
				fiLayout = getElementLayout(formItem) as FormItemLayout;
				
				var colWidths:Vector.<Number> = fiLayout.getMeasuredColumnWidths();
				
				if (isNaN(lastColumnCount))
					lastColumnCount = colWidths.length;
				
				if (columnMaxWidths.length == 0)
				{
					for (var j:int = 0; j < colWidths.length; j++)
						columnMaxWidths[j] = 0;
				}
				
				// TODO (jszeto): grab this error message from a resource bundle
				if (lastColumnCount != colWidths.length)
					throw new Error("The Form must have form items with the same number of constraint columns");
				
				for (var k:int = 0; k < colWidths.length; k++)
				{
					columnMaxWidths[k] = Math.max(columnMaxWidths[k], colWidths[k]);
				}
			}
			
			return columnMaxWidths;
		}
		
		/**
		 *  @private
		 *  Adjusts the widths of percent size columns to fill the constrainedWidth.
		 *  This method updates the provided column widths vector in place.
		 *  
		 *  The percent size column widths are first reset to their minimum width. 
		 *  If the given column widths from the content and fixed size columns already
		 *  fill the available width, then the percent size column widths stay at their
		 *  minimum width. Otherwise, the remaining width is distributed to the percent 
		 *  size columns based on the ratio of the percentWidth to the sum of all the 
		 *  percent widths.
		 */
		private function constrainPercentColumnWidths(colWidths:Vector.<Number>, constrainedWidth:Number, formItems:Vector.<ILayoutElement>):void
		{
			if (formItems.length == 0)
				return;
			
			// TODO (klin): What happens when the form items have different types of columns?
			const fiLayout:FormItemLayout = getElementLayout(formItems[0]) as FormItemLayout;
			const constraintColumns:Array /*Vector.<ConstraintColumn>*/ = fiLayout.constraintColumns;
			const numCols:int = constraintColumns.length;
			var col:ConstraintColumn;
			var childInfoArray:Array /* of ColumnFlexChildInfo */ = [];
			var childInfo:ColumnFlexChildInfo;
			var remainingWidth:Number = constrainedWidth;
			var percentMinWidths:Number = 0;
			var totalPercent:Number = 0;
			
			// Set percent width columns back to minWidth and
			// find the remaining width.
			for (var i:int = 0; i < numCols; i++)
			{
				col = constraintColumns[i];
				if (!isNaN(col.percentWidth))
				{
					colWidths[i] = (!isNaN(col.minWidth)) ? Math.ceil(Math.max(col.minWidth, 0)) : 0;
					percentMinWidths += colWidths[i];
					totalPercent += col.percentWidth;
					
					// Fill childInfoArray for distributing the width.
					childInfo = new ColumnFlexChildInfo();
					childInfo.index = i;
					childInfo.percent = col.percentWidth;
					childInfo.min = col.minWidth;
					childInfo.max = col.maxWidth;
					childInfoArray.push(childInfo);
				}
				else
				{
					remainingWidth -= colWidths[i];
				}
			}
			
			// If there's space remaining, distribute the width to the percent size
			// columns based on their ratio of percentWidth to sum of all the percentWidths.
			if (remainingWidth > percentMinWidths)
			{
				Flex.flexChildrenProportionally(constrainedWidth, 
					remainingWidth,
					totalPercent,
					childInfoArray);
				
				var roundOff:Number = 0;
				for each (childInfo in childInfoArray)
				{
					// Make sure the calculated widths are rounded to pixel boundaries
					var colWidth:Number = Math.round(childInfo.size + roundOff);
					roundOff += childInfo.size - colWidth;
					
					colWidths[childInfo.index] = colWidth;
					
					remainingWidth -= colWidth;
				}
				// TODO (klin): What do we do if there's remainingWidth after all this?
			}
		}
	}
}

////////////////////////////////////////////////////////////////////////////////
//
//  Helper class: ColumnFlexChildInfo
//
////////////////////////////////////////////////////////////////////////////////

import mx.containers.utilityClasses.FlexChildInfo;

class ColumnFlexChildInfo extends FlexChildInfo
{
	public var index:int;
}