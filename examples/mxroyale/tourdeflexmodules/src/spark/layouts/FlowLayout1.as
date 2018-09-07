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
package
{
import mx.core.ILayoutElement;

import spark.components.supportClasses.GroupBase;
import spark.layouts.supportClasses.LayoutBase;

public class FlowLayout1 extends LayoutBase
{
    
    //---------------------------------------------------------------
    //
    //  Class properties
    //
    //---------------------------------------------------------------
    
    //---------------------------------------------------------------
    //  horizontalGap
    //---------------------------------------------------------------

    private var _horizontalGap:Number = 10;

    public function set horizontalGap(value:Number):void
    {
        _horizontalGap = value;
        
        // We must invalidate the layout
        var layoutTarget:GroupBase = target;
        if (layoutTarget)
            layoutTarget.invalidateDisplayList();
    }
    
    //---------------------------------------------------------------
    //  verticalAlign
    //---------------------------------------------------------------

    private var _verticalAlign:String = "bottom";
    
    public function set verticalAlign(value:String):void
    {
        _verticalAlign = value;
        
        // We must invalidate the layout
        var layoutTarget:GroupBase = target;
        if (layoutTarget)
            layoutTarget.invalidateDisplayList();
    }
    
	//---------------------------------------------------------------
	//  horizontalAlign
	//---------------------------------------------------------------
	
	private var _horizontalAlign:String = "left"; // center, right
	
	public function set horizontalAlign(value:String):void
	{
		_horizontalAlign = value;
		
		// We must invalidate the layout
		var layoutTarget:GroupBase = target;
		if (layoutTarget)
			layoutTarget.invalidateDisplayList();
	}
	
    //---------------------------------------------------------------
    //
    //  Class methods
    //
    //---------------------------------------------------------------
    
    override public function updateDisplayList(containerWidth:Number,
                                               containerHeight:Number):void
    {
        var element:ILayoutElement;
        var layoutTarget:GroupBase = target;
        var count:int = layoutTarget.numElements;
        var hGap:Number = _horizontalGap;

        // The position for the current element
        var x:Number = 0;
        var y:Number = 0;
        var elementWidth:Number;
        var elementHeight:Number;

        var vAlign:Number = 0;
        switch (_verticalAlign)
        {
            case "middle" : vAlign = 0.5; break;
            case "bottom" : vAlign = 1; break;
        }

        // Keep track of per-row height, maximum row width
        var maxRowWidth:Number = 0;

        // loop through the elements
        // while we can start a new row
        var rowStart:int = 0;
        while (rowStart < count)
        {
            // The row always contains the start element
            element = useVirtualLayout ? layoutTarget.getVirtualElementAt(rowStart) :
										 layoutTarget.getElementAt(rowStart);
									     
            var rowWidth:Number = element.getPreferredBoundsWidth();
            var rowHeight:Number =  element.getPreferredBoundsHeight();
            
            // Find the end of the current row
            var rowEnd:int = rowStart;
            while (rowEnd + 1 < count)
            {
                element = useVirtualLayout ? layoutTarget.getVirtualElementAt(rowEnd + 1) :
										     layoutTarget.getElementAt(rowEnd + 1);
                
                // Since we haven't resized the element just yet, get its preferred size
                elementWidth = element.getPreferredBoundsWidth();
                elementHeight = element.getPreferredBoundsHeight();

                // Can we add one more element to this row?
                if (rowWidth + hGap + elementWidth > containerWidth)
                    break;

                rowWidth += hGap + elementWidth;
                rowHeight = Math.max(rowHeight, elementHeight);
                rowEnd++;
            }
            
			x = 0;
			switch (_horizontalAlign)
			{
				case "center" : x = Math.round(containerWidth - rowWidth) / 2; break;
				case "right" : x = containerWidth - rowWidth;
			}
			
            // Keep track of the maximum row width so that we can
            // set the correct contentSize
            maxRowWidth = Math.max(maxRowWidth, x + rowWidth);

            // Layout all the elements within the row
            for (var i:int = rowStart; i <= rowEnd; i++) 
            {
                element = useVirtualLayout ? layoutTarget.getVirtualElementAt(i) : 
											 layoutTarget.getElementAt(i);

                // Resize the element to its preferred size by passing
                // NaN for the width and height constraints
                element.setLayoutBoundsSize(NaN, NaN);

                // Find out the element's dimensions sizes.
                // We do this after the element has been already resized
                // to its preferred size.
                elementWidth = element.getLayoutBoundsWidth();
                elementHeight = element.getLayoutBoundsHeight();

                // Calculate the position within the row
                var elementY:Number = Math.round((rowHeight - elementHeight) * vAlign);

                // Position the element
                element.setLayoutBoundsPosition(x, y + elementY);

                x += hGap + elementWidth;
            }

            // Next row will start with the first element after the current row's end
            rowStart = rowEnd + 1;

            // Update the position to the beginning of the row
            x = 0;
            y += rowHeight;
        }

        // Set the content size which determines the scrolling limits
        // and is used by the Scroller to calculate whether to show up
        // the scrollbars when the the scroll policy is set to "auto"
        layoutTarget.setContentSize(maxRowWidth, y);
    }
}
}