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

package mx.containers
{

	import org.apache.royale.events.Event;

/* import flash.events.Event;
 */import mx.core.Container;
import mx.core.EdgeMetrics;
import mx.core.IUIComponent;
import mx.core.mx_internal;

use namespace mx_internal;

//--------------------------------------
//  Styles
//--------------------------------------

/**
 *  Horizontal alignment of each child inside its tile cell.
 *  Possible values are <code>"left"</code>, <code>"center"</code>, and
 *  <code>"right"</code>.
 *  If the value is <code>"left"</code>, the left edge of each child
 *  is at the left edge of its cell.
 *  If the value is <code>"center"</code>, each child is centered horizontally
 *  within its cell.
 *  If the value is <code>"right"</code>, the right edge of each child
 *  is at the right edge of its cell.
 *
 *  @default "left"
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="horizontalAlign", type="String", enumeration="left,center,right", inherit="no")]

/**
 *  Number of pixels between children in the horizontal direction.
 *
 *  @default 8
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="horizontalGap", type="Number", format="Length", inherit="no")]

/**
 *  Number of pixels between the container's bottom border and its content area.
 *
 *  @default 0
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="paddingBottom", type="Number", format="Length", inherit="no")]

/**
 *  Number of pixels between the container's top border and its content area.
 *
 *  @default 0
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="paddingTop", type="Number", format="Length", inherit="no")]

/**
 *  Vertical alignment of each child inside its tile cell.
 *  Possible values are <code>"top"</code>, <code>"middle"</code>, and
 *  <code>"bottom"</code>.
 *  If the value is <code>"top"</code>, the top edge of each child
 *  is at the top edge of its cell.
 *  If the value is <code>"middle"</code>, each child is centered vertically
 *  within its cell.
 *  If the value is <code>"bottom"</code>, the bottom edge of each child
 *  is at the bottom edge of its cell.
 *
 *  @default "top"
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="verticalAlign", type="String", enumeration="bottom,middle,top", inherit="no")]

/**
 *  Number of pixels between children in the vertical direction.
 *
 *  @default 6
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="verticalGap", type="Number", format="Length", inherit="no")]

//--------------------------------------
//  Excluded APIs
//--------------------------------------

[Exclude(name="focusIn", kind="event")]
[Exclude(name="focusOut", kind="event")]

[Exclude(name="focusBlendMode", kind="style")]
[Exclude(name="focusSkin", kind="style")]
[Exclude(name="focusThickness", kind="style")]

[Exclude(name="focusInEffect", kind="effect")]
[Exclude(name="focusOutEffect", kind="effect")]

//--------------------------------------
//  Other metadata
//--------------------------------------

/**
 *  The layout-specific container components in Flex 3 have been replaced by a more generic
 *  Group component that takes a generic layout. To get similar behavior from the new
 *  Group component, set the <code>layout</code> property to <code>TileLayout</code>
 *  or use the TileGroup container.
 */
[Alternative(replacement="spark.components.TileGroup", since="4.0")]
[Alternative(replacement="spark.components.BorderContainer", since="4.0")]

/**
 *  A Halo Tile container lays out its children
 *  in a grid of equal-sized cells.
 *  You can specify the size of the cells by using the
 *  <code>tileWidth</code> and <code>tileHeight</code> properties,
 *  or let the Tile container determine the cell size
 *  based on the largest child.
 *  A Tile container's <code>direction</code> property
 *  determines whether its cells are laid out horizontally or
 *  vertically, beginning from the upper-left corner of the
 *  Tile container.
 * 
 *  <p><b>Note:</b> Adobe recommends that, when possible, you use the Spark containers 
 *  with TileLayout instead of the Halo Tile container.</p>
 *
 *  <p>A Tile container has the following default sizing characteristics:</p>
 *     <table class="innertable">
 *        <tr>
 *           <th>Characteristic</th>
 *           <th>Description</th>
 *        </tr>
 *        <tr>
 *           <td>Direction</td>
 *           <td>horizontal</td>
 *        </tr>
 *        <tr>
 *           <td>Default size of all cells</td>
 *           <td>Height is the default or explicit height of the tallest child.<br/>
 *               Width is the default or explicit width of the widest child.<br/>
 *               All cells have the same default size.</td>
 *        </tr>
 *        <tr>
 *           <td>Default size of Tile container</td>
 *           <td>Flex computes the square root of the number of children, and rounds up to the nearest 
 *               integer. For example, if there are 26 children, the square root is 5.1, which is rounded up to 6. 
 *               Flex then lays out the Tile container in a 6 by 6 grid.<br/>
 *               Default height of the Tile container is equal to 
 *               (tile cell default height) <strong>x</strong> (rounded square root of the number of children),
 *               plus any gaps between children and any padding.<br/>
 *               Default width is equal to
 *               (tile cell default width) <strong>x</strong> (rounded square root of the number of children),
 *               plus any gaps between children and any padding.</td>
 *        </tr>
 *        <tr>
 *           <td>Minimum size of Tile container</td>
 *           <td>The default size of a single cell. Flex always allocates enough space to display at least 
 *               one cell.</td>
 *        </tr>
 *        <tr>
 *           <td>Default padding</td>
 *           <td>0 pixels for the top, bottom, left, and right values.</td>
 *        </tr>
 *     </table>
 *
 *  @mxml
 *
 *  <p>The <code>&lt;mx:Tile&gt;</code> tag inherits all of the tag attributes
 *  of its superclass, and adds the following tag attributes:</p>
 *
 *  <pre>
 *  &lt;mx:Tile
 *    <b>Properties</b>
 *    direction="horizontal|vertical"
 *    tileHeight="NaN"
 *    tileWidth="NaN"
 * 
 *    <b>Sttles</b>
 *    horizontalAlign="left|center|right"
 *    horizontalGap="8"
 *    paddingBottom="0"
 *    paddingTop="0"
 *    verticalAlign="top|middle|bottom"
 *    verticalGap="6"
 *    &gt;
 *      ...
 *      <i>child tags</i>
 *     ...
 *  &lt;/mx:Tile&gt;
 *  </pre>
 *
 *  @includeExample examples/TileLayoutExample.mxml
 *
 *  @see mx.core.Container
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 *
 *  @royalesuppresspublicvarwarning
 */
public class Tile extends Container
{
    /* include "../core/Version.as"; */

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
    public function Tile()
    {
        super();
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     *  Cached value from findCellSize() call in measure(),
     *  so that updateDisplayList() doesn't also have to call findCellSize().
     */
    mx_internal var _cellWidth:Number;
    
	public function set cellWidth(value:Number):void
	{
	_cellWidth = value;
	}
	
	public function get cellWidth():Number
	{
	return _cellWidth;
	}
    /**
     *  @private
     *  Cached value from findCellSize() call in measure(),
     *  so that updateDisplaylist() doesn't also have to call findCellSize().
     */
    mx_internal var _cellHeight:Number;

	public function set cellHeight(value:Number):void
	{
	_cellHeight = value;
	}
	
	public function get cellHeight():Number
	{
	return _cellHeight;
	}
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  direction
    //----------------------------------

    /**
     *  @private
     *  Storage for the direction property.
     */
    private var _direction:String = TileDirection.HORIZONTAL;

    [Bindable("directionChanged")]
    [Inspectable(category="General", enumeration="vertical,horizontal", defaultValue="horizontal")]

    /**
     *  Determines how children are placed in the container.
     *  Possible MXML values  are <code>"horizontal"</code> and
     *  <code>"vertical"</code>.
     *  In ActionScript, you can set the direction using the values
     *  TileDirection.HORIZONTAL or TileDirection.VERTICAL.
     *  The default value is <code>"horizontal"</code>.
     *  (If the container is a Legend container, which is a subclass of Tile,
     *  the default value is <code>"vertical"</code>.)
     *
     *  <p>The first child is always placed at the upper-left of the
     *  Tile container.
     *  If the <code>direction</code> is <code>"horizontal"</code>,
     *  the children are placed left-to-right in the topmost row,
     *  and then left-to-right in the second row, and so on.
     *  If the value is <code>"vertical"</code>, the children are placed
     *  top-to-bottom in the leftmost column, and then top-to-bottom
     *  in the second column, and so on.</p>
     *
     *  @default "horizontal"
     * 
     *  @see TileDirection
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get direction():String
    {
        return _direction;
    }

    /**
     *  @private
     */
    public function set direction(value:String):void
    {
        _direction = value;
        
        invalidateSize();
        invalidateDisplayList();
        
        dispatchEvent(new Event("directionChanged"));
    }

    //----------------------------------
    //  tileHeight
    //----------------------------------

    /**
     *  @private
     *  Storage for the tileHeight property.
     */
    private var _tileHeight:Number;

    [Bindable("resize")]
    [Inspectable(category="General")]

    /**
     *  Height of each tile cell, in pixels. 
     *  If this property is <code>NaN</code>, the default, the height
     *  of each cell is determined by the height of the tallest child.
     *  If you set this property, the specified value overrides
     *  this calculation.
     *
     *  @default NaN
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get tileHeight():Number
    {
        return _tileHeight;
    }

    /**
     *  @private
     */
    public function set tileHeight(value:Number):void
    {
        _tileHeight = value;
        
        invalidateSize();
    }

    //----------------------------------
    //  tileWidth
    //----------------------------------

    /**
     *  @private
     *  Storage for the tileWidth property.
     */
    private var _tileWidth:Number;

    [Bindable("resize")]
    [Inspectable(category="General")]

    /**
     *  Width of each tile cell, in pixels.
     *  If this property is <code>NaN</code>, the defualt, the width
     *  of each cell is determined by the width of the widest child.
     *  If you set this property, the specified value overrides
     *  this calculation.
     *
     *  @default NaN
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get tileWidth():Number
    {
        return _tileWidth;
    }

    /**
     *  @private
     */
    public function set tileWidth(value:Number):void
    {
        _tileWidth = value;

        invalidateSize();
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden methods: UIComponent
    //
    //--------------------------------------------------------------------------

    /**
     *  Calculates the default minimum and maximum sizes of the
     *  Tile container.
     *  For more information about the <code>measure()</code> method,
     *  see the <code>UIComponent.measure()</code> method.
     *  
     *  <p>This method first calculates the size of each tile cell.
     *  For a description of how the cell size is determined, see the
     *  <code>tileWidth</code> and <code>tileHeight</code> properties.</p>
     *  
    *  <p>The measured size of a Tile container with children
     *  is sufficient to display the cells in an N-by-N grid
     *  with an equal number of rows and columns, plus room for
     *  the Tile container's padding and borders.
     *  However, there are various special cases, as in the following
     *  examples:</p>
     *
     *  <ul>
     *  <li>If a horizontal Tile container has an
     *  explicit width set, that value determines how many
     *  cells will fit horizontally, and the height required to fit all the
     *  children is calculated, producing an M-by-N grid.</li>
     *
     *  <li>If a vertical Tile container has an
     *  explicit height set, that value determines how many
     *  cells will fit vertically, and the height required to fit all the
     *  children is calculated, producing an N-by-M grid.</li>
     *  </ul>
     *
     *  <p>If there are no children, the measured size is just
     *  large enough for its padding and borders.</p>
     *  
     *  <p>The minimum measured size of a Tile container
     *  with children is just large enough for a single tile cell,
     *  plus padding and borders.
     *  If there are no children, the minimum measured size is just
     *  large enough for its padding and borders.</p>
     * 
     *  @see mx.core.UIComponent#measure()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    override protected function measure():void
    {
        super.measure();

        var preferredWidth:Number;
        var preferredHeight:Number;
        var minWidth:Number;
        var minHeight:Number;

        // Determine the size of each tile cell and cache the values
        // in cellWidth and cellHeight for later use by updateDisplayList().
        findCellSize();

        // Min width and min height are large enough to display a single child.
        minWidth = _cellWidth;
        minHeight = _cellHeight;

        // Determine the width and height necessary to display the tiles
        // in an N-by-N grid (with number of rows equal to number of columns).
        var n:int = numChildren;

        // Don't count children that don't need their own layout space.
        var temp:int = n;
        for (var i:int = 0; i < n; i++)
        {
            if (!IUIComponent(getChildAt(i)).includeInLayout)
                temp--;
        }
        n = temp;

        if (n > 0)
        {
            var horizontalGap:Number = getStyle("horizontalGap");
            var verticalGap:Number = getStyle("verticalGap");
            
            var majorAxis:Number;

            // If an explicit dimension or flex is set for the majorAxis,
            // set as many children as possible along the axis.
            if (direction == TileDirection.HORIZONTAL)
            {
                var unscaledExplicitWidth:Number = explicitWidth / Math.abs(scaleX);
                if (!isNaN(unscaledExplicitWidth))
                {
                    // If we have an explicit height set,
                    // see how many children can fit in the given height:
                    // majorAxis * (_cellWidth + horizontalGap) - horizontalGap == unscaledExplicitWidth
                    majorAxis = Math.floor((unscaledExplicitWidth + horizontalGap) /
                                           (_cellWidth + horizontalGap));
                }
            }
            else
            {
                var unscaledExplicitHeight:Number = explicitHeight / Math.abs(scaleY);
                if (!isNaN(unscaledExplicitHeight))
                {
                    // If we have an explicit height set,
                    // see how many children can fit in the given height:
                    // majorAxis * (cellHeight + verticalGap) - verticalGap == unscaledExplicitHeight
                    majorAxis = Math.floor((unscaledExplicitHeight + verticalGap) /
                                           (_cellHeight + verticalGap));
                }
            }

            // Finally, if majorAxis still isn't defined, use the
            // square root of the number of children.
            if (isNaN(majorAxis))
                majorAxis = Math.ceil(Math.sqrt(n));

            // Even if there's not room, force at least one cell
            // on each row/column.
            if (majorAxis < 1)
                majorAxis = 1;

            var minorAxis:Number = Math.ceil(n / majorAxis);

            if (direction == TileDirection.HORIZONTAL)
            {
                preferredWidth = majorAxis * _cellWidth +
                                 (majorAxis - 1) * horizontalGap;

                preferredHeight = minorAxis * _cellHeight +
                                  (minorAxis - 1) * verticalGap;
            }
            else
            {
                preferredWidth = minorAxis * _cellWidth +
                                 (minorAxis - 1) * horizontalGap;

                preferredHeight = majorAxis * _cellHeight +
                                  (majorAxis - 1) * verticalGap;
            }
        }
        else
        {
            preferredWidth = minWidth;
            preferredHeight = minHeight;
        }

        var vm:EdgeMetrics = viewMetricsAndPadding;
        var hPadding:Number = vm.left + vm.right;
        var vPadding:Number = vm.top + vm.bottom;
        
        // Add padding for margins and borders.
        minWidth += hPadding;
        preferredWidth += hPadding;
        minHeight += vPadding;
        preferredHeight += vPadding;

        measuredMinWidth = Math.ceil(minWidth);
        measuredMinHeight = Math.ceil(minHeight);
        measuredWidth = Math.ceil(preferredWidth);
        measuredHeight = Math.ceil(preferredHeight);
    }

    /**
     *  Sets the positions and sizes of this container's children.
     *  For more information about the <code>updateDisplayList()</code>
     *  method, see the <code>UIComponent.updateDisplayList()</code> method.
     *  
     *  <p>This method positions the children in a checkboard-style grid of
     *  equal-sized cells within the content area of the Tile
     *  container (i.e., the area inside its padding).
     *  For a description of how the cell size is determined,
     *  see the <code>tileWidth</code> and
     *  <code>tileHeight</code>properties.</p>
     *  
     *  <p>The separation between the cells is determined by the
     *  <code>horizontalGap</code> and <code>verticalGap</code> styles.
     *  The placement of each child within its cell is determined by the
     *  <code>horizontalAlign</code> and <code>verticalAlign</code> styles.</p>
     *  
     *  <p>The flow of the children is determined by the
     *  <code>direction</code> property.
     *  The first cell is always placed at the upper left of the content area.
     *  If <code>direction</code> is set to <code>"horizontal"</code>, the
     *  cells are placed left-to-right in the topmost row, and then
     *  left-to-right in the second row, and so on.
     *  If <code>direction</code> is set to <code>"vertical"</code>, the cells
     *  are placed top-to-bottom in the leftmost column, and then top-to-bottom
     *  in the second column, and so on.</p>
     *  
     *  <p>If a child has a <code>percentWidth</code> or
     *  <code>percentHeight</code> value, it is resized in that direction
     *  to fill the specified percentage of its tile cell.</p>
     *
     *  @param unscaledWidth Specifies the width of the component, in pixels,
     *  in the component's coordinates, regardless of the value of the
     *  <code>scaleX</code> property of the component.
     *
     *  @param unscaledHeight Specifies the height of the component, in pixels,
     *  in the component's coordinates, regardless of the value of the
     *  <code>scaleY</code> property of the component.   
     * 
     *  @see mx.core.UIComponent#updateDisplayList()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    override protected function updateDisplayList(unscaledWidth:Number,
                                                  unscaledHeight:Number):void
    {
        super.updateDisplayList(unscaledWidth, unscaledHeight);

        // The measure function isn't called if the width and height of
        // the Tile are hard-coded. In that case, we compute the cellWidth
        // and cellHeight now.
        if (isNaN(_cellWidth) || isNaN(_cellHeight))
            findCellSize();
        
        var vm:EdgeMetrics = viewMetricsAndPadding;
        
        var paddingLeft:Number = getStyle("paddingLeft");
        var paddingTop:Number = getStyle("paddingTop");

        var horizontalGap:Number = getStyle("horizontalGap");
        var verticalGap:Number = getStyle("verticalGap");
       
        var horizontalAlign:String = getStyle("horizontalAlign");
        var verticalAlign:String = getStyle("verticalAlign");

        var xPos:Number = paddingLeft;
        var yPos:Number = paddingTop;

        var xOffset:Number;
        var yOffset:Number;
        
        var n:int = numChildren;
        var i:int;
        var child:IUIComponent;
        
        if (direction == TileDirection.HORIZONTAL)
        {
            var xEnd:Number = Math.ceil(unscaledWidth) - vm.right;

            for (i = 0; i < n; i++)
            {
                child = getLayoutChildAt(i);

                if (!child.includeInLayout)
                    continue;

                // Start a new row?
                if (xPos + _cellWidth > xEnd)
                {
                    // Only if we have not just started one...
                    if (xPos != paddingLeft)
                    {
                        yPos += (_cellHeight + verticalGap);
                        xPos = paddingLeft;
                    }
                }
                
                setChildSize(child); // calls child.setActualSize()

                // Calculate the offsets to align the child in the cell.
                xOffset = Math.floor(calcHorizontalOffset(
                    child.width, horizontalAlign));
                yOffset = Math.floor(calcVerticalOffset(
                    child.height, verticalAlign));
                            
                child.move(xPos + xOffset, yPos + yOffset);

                xPos += (_cellWidth + horizontalGap);
            }
        }
        else
        {
            var yEnd:Number = Math.ceil(unscaledHeight) - vm.bottom;

            for (i = 0; i < n; i++)
            {
                child = getLayoutChildAt(i);

                if (!child.includeInLayout)
                    continue;

                // Start a new column?
                if (yPos + _cellHeight > yEnd)
                {
                    // Only if we have not just started one...
                    if (yPos != paddingTop)
                    {
                        xPos += (_cellWidth + horizontalGap);
                        yPos = paddingTop;
                    }
                }
                
                setChildSize(child); // calls child.setActualSize()

                // Calculate the offsets to align the child in the cell.
                xOffset = Math.floor(calcHorizontalOffset(
                    child.width, horizontalAlign));
                yOffset = Math.floor(calcVerticalOffset(
                    child.height, verticalAlign));
            
                child.move(xPos + xOffset, yPos + yOffset);

                yPos += (_cellHeight + verticalGap);
            }
        }

        // Clear the cached cell size, because if a child's size changes
        // it will be invalid. These cached values are only used to
        // avoid recalculating in updateDisplayList() the same values
        // that were just calculated in measure().
        // They should not persist across invalidation/validation cycles.
        // (An alternative approach we tried was to clear these
        // values in an override of invalidateSize(), but this gets called
        // called indirectly by setChildSize() and child.move() inside
        // the loops above. So we had to save and restore cellWidth
        // and cellHeight around these calls in the loops, which is ugly.)
        _cellWidth = NaN;
        _cellHeight = NaN;
    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     *  Calculate and store the cellWidth and cellHeight.
     */
    mx_internal function findCellSize():void
    {
        // If user explicitly supplied both a tileWidth and
        // a tileHeight, then use those values.
        var widthSpecified:Boolean = !isNaN(tileWidth);
        var heightSpecified:Boolean = !isNaN(tileHeight);
        if (widthSpecified && heightSpecified)
        {
            _cellWidth = tileWidth;
            _cellHeight = tileHeight;
            return;
        }

        // Reset the max child width and height
        var maxChildWidth:Number = 0;
        var maxChildHeight:Number = 0;
        
        // Loop over the children to find the max child width and height.
        var n:int = numChildren;
        for (var i:int = 0; i < n; i++)
        {
            var child:IUIComponent = getLayoutChildAt(i);

            if (!child.includeInLayout)
                continue;
            
            var width:Number = child.getExplicitOrMeasuredWidth();
            if (width > maxChildWidth)
                maxChildWidth = width;
            
            var height:Number = child.getExplicitOrMeasuredHeight();
            if (height > maxChildHeight) 
                maxChildHeight = height;
        }
        
        // If user explicitly specified either width or height, use the
        // user-supplied value instead of the one we computed.
        _cellWidth = widthSpecified ? tileWidth : maxChildWidth;
        _cellHeight = heightSpecified ? tileHeight : maxChildHeight;
    }

    /**
     *  @private
     *  Assigns the actual size of the specified child,
     *  based on its measurement properties and the cell size.
     */
    private function setChildSize(child:IUIComponent):void
    {
        var childWidth:Number;
        var childHeight:Number;
        var childPref:Number;
        var childMin:Number;

        if (child.percentWidth > 0)
        {
            // Set child width to be a percentage of the size of the cell.
            childWidth = Math.min(_cellWidth,
                                  _cellWidth * child.percentWidth / 100);
        }
        else
        {
            // The child is not flexible, so set it to its preferred width.
            childWidth = child.getExplicitOrMeasuredWidth();

            // If an explicit tileWidth has been set on this Tile,
            // then the child may extend outside the bounds of the tile cell.
            // In that case, we'll honor the child's width or minWidth,
            // but only if those values were explicitly set by the developer,
            // not if they were implicitly set based on measurements.
            if (childWidth > _cellWidth)
            {
                childPref = isNaN(child.explicitWidth) ?
                            0 :
                            child.explicitWidth;

                childMin = isNaN(child.explicitMinWidth) ?
                           0 :
                           child.explicitMinWidth;

                childWidth = (childPref > _cellWidth ||
                              childMin > _cellWidth) ?
                             Math.max(childMin, childPref) :
                             _cellWidth;
            }
        }

        if (child.percentHeight > 0)
        {
            childHeight = Math.min(_cellHeight,
                                   _cellHeight * child.percentHeight / 100);
        }
        else
        {
            childHeight = child.getExplicitOrMeasuredHeight();

            if (childHeight > _cellHeight)
            {
                childPref = isNaN(child.explicitHeight) ?
                            0 :
                            child.explicitHeight;

                childMin = isNaN(child.explicitMinHeight) ?
                           0 :
                           child.explicitMinHeight;

                childHeight = (childPref > _cellHeight ||
                               childMin > _cellHeight) ?
                               Math.max(childMin, childPref) :
                               _cellHeight;
            }
        }

        child.setActualSize(childWidth, childHeight);
    }

    /**
     *  @private
     *  Compute how much adjustment must occur in the x direction
     *  in order to align a component of a given width into the cell.
     */
    mx_internal function calcHorizontalOffset(width:Number,
                                              horizontalAlign:String):Number
    {
        var xOffset:Number;

        if (horizontalAlign == "left")
            xOffset = 0;

        else if (horizontalAlign == "center")
            xOffset = (_cellWidth - width) / 2;

        else if (horizontalAlign == "right")
            xOffset = (_cellWidth - width);

        return xOffset;
    }

    /**
     *  @private
     *  Compute how much adjustment must occur in the y direction
     *  in order to align a component of a given height into the cell.
     */
    mx_internal function calcVerticalOffset(height:Number,
                                            verticalAlign:String):Number
    {
        var yOffset:Number;

        if (verticalAlign == "top")
            yOffset = 0;

        else if (verticalAlign == "middle")
            yOffset = (_cellHeight - height) / 2;

        else if (verticalAlign == "bottom")
            yOffset = (_cellHeight - height);

        return yOffset;
    }
}

}
