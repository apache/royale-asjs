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

package mx.core
{

import org.apache.royale.geom.Rectangle;

/**
 *  The EdgeMetrics class specifies the thickness, in pixels,
 *  of the four edge regions around a visual component.
 *
 *  <p>The following Flex properties have values that are EdgeMetrics
 *  objects:</p>
 *
 *  <ul>
 *  <li>The <code>borderMetrics</code> property of the mx.core.Container and
 *  mx.skins.Border classes includes only the border in the calculations
 *  of the property values of the EdgeMetrics object.</li>
 *
 *  <li>The <code>viewMetrics</code> property of the mx.core.Container
 *  class, and of subclasses of the Container class, includes possible
 *  scrollbars and non-content elements -- such as a Panel container's
 *  header area and the area for a ControlBar component -- in the calculations
 *  of the  property values of the EdgeMetrics object.</li>
 *
 *  <li>The <code>viewMetricsAndPadding</code> property of the
 *  mx.core.Container class includes the items listed for the
 *  <code>viewMetrics</code> property, plus the any areas defined by
 *  the margins of the container in the calculations of the
 *  property values of the EdgeMetrics object.</li>
 *  </ul>
 *
 *  <p>These three properites all return a reference to the same
 *  EdgeMetrics object that the Container is using for its measurement
 *  and layout; they do not return a copy of this object.
 *  If you need a copy, call the <code>clone()</code> method.</p>
 *
 *  @see mx.core.Container
 *  @see mx.skins.Border
 *  @see mx.containers.Panel
 *
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class EdgeMetrics
{
    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    /**
     *  An EdgeMetrics object with a value of zero for its
     *  <code>left</code>, <code>top</code>, <code>right</code>,
     *  and <code>bottom</code> properties.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static const EMPTY:EdgeMetrics = new EdgeMetrics(0, 0, 0, 0);

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     *
     *  @param left The width, in pixels, of the left edge region.
     *
     *  @param top The height, in pixels, of the top edge region.
     *
     *  @param right The width, in pixels, of the right edge region.
     *
     *  @param bottom The height, in pixels, of the bottom edge region.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function EdgeMetrics(left:Number = 0, top:Number = 0,
                                right:Number = 0, bottom:Number = 0)
    {
        super();

        this.left = left;
        this.top = top;
        this.right = right;
        this.bottom = bottom;
    }

    public function convertFromRectangle(rect:Rectangle):void
    {
    	this.left = rect.x;
    	this.top = rect.y;
    	this.right = rect.x + rect.width;
    	this.bottom = rect.y + rect.height;
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  bottom
    //----------------------------------

    /**
     *  The height, in pixels, of the bottom edge region.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    private var _bottom:Number;
	public function get bottom():Number
	{
		return _bottom;
	}
	public function set bottom(value:Number):void 
	{
		_bottom = value;
	}

    //----------------------------------
    //  left
    //----------------------------------

    /**
     *  The width, in pixels, of the left edge region.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    private var _left:Number;
	public function get left():Number 
	{
		return _left;
	}
	public function set left(value:Number):void
	{
		_left = value;
	}

    //----------------------------------
    //  right
    //----------------------------------

    /**
     *  The width, in pixels, of the right edge region.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    private var _right:Number;
	public function get right():Number 
	{
		return _right;
	}
	public function set right(value:Number):void
	{
		_right = value;
	}

    //----------------------------------
    //  top
    //----------------------------------

    /**
     *  The height, in pixels, of the top edge region.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    private var _top:Number;
	public function get top():Number
	{
		return _top;
	}
	public function set top(value:Number):void
	{
		_top = value;
	}

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     *  Returns a copy of this EdgeMetrics object.
     *
     *  @return A copy of this EdgeMetrics object.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function clone():EdgeMetrics
    {
        return new EdgeMetrics(left, top, right, bottom);
    }
}

}
