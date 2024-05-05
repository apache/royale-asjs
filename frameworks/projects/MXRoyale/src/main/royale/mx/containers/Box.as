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
	import org.apache.royale.core.IBeadLayout;
	import org.apache.royale.events.Event;
	import org.apache.royale.html.beads.layouts.HorizontalLayout;
	import org.apache.royale.html.beads.layouts.VerticalLayout;

/*
import flash.events.Event;
*/
import mx.containers.beads.BoxLayout;
import mx.core.Container;
/*
import mx.core.IUIComponent;
import mx.core.mx_internal;

use namespace mx_internal;
*/


/**
 *  A Halo Box container lays out its children in a single vertical column
 *  or a single horizontal row.
 *  The <code>direction</code> property determines whether to use
 *  vertical (default) or horizontal layout.
 * 
 *  <p><b>Note:</b> Adobe recommends that, when possible, you use the Spark containers 
 *  with HorizontalLayout or VerticalLayout instead of the Halo Box container.</p>
 *
 *  <p>The Box class is the base class for the VBox and HBox classes.
 *  You use the <code>&lt;mx:Box&gt;</code>, <code>&lt;mx:VBox&gt;</code>,
 *  and <code>&lt;mx:HBox&gt;</code> tags to define Box containers.</p>
 *
 *  <p>A Box container has the following default sizing characteristics:</p>
 *     <table class="innertable">
 *        <tr>
 *           <th>Characteristic</th>
 *           <th>Description</th>
 *        </tr>
 *        <tr>
 *           <td>Default size</td>
 *           <td><strong>Vertical Box</strong> The height is large enough to hold all its children at the default 
 *               or explicit height of the children, plus any vertical gap between the children, plus the top and 
 *               bottom padding of the container. The width is the default or explicit width of the widest child, 
 *               plus the left and right padding of the container. 
 *               <br><strong>Horizontal Box</strong> The width is large enough to hold all of its children at the 
 *               default width of the children, plus any horizontal gap between the children, plus the left and 
 *               right padding of the container. The height is the default or explicit height of the tallest child, 
 *               plus the top and bottom padding for the container.</br>
 *           </td>
 *        </tr>
 *        <tr>
 *           <td>Default padding</td>
 *           <td>0 pixels for the top, bottom, left, and right values.</td>
 *        </tr>
 *     </table>
 *
 *  @mxml
 *
 *  <p>The <code>&lt;mx:Box&gt;</code> tag inherits all of the tag 
 *  attributes of its superclass, and adds the following tag attributes:</p>
 *
 *  <p>
 *  <pre>
 *  &lt;mx:Box
 *    <strong>Properties</strong>
 *    direction="vertical|horizontal"
 *    <strong>Styles</strong>
 *    horizontalAlign="left|center|right"
 *    horizontalGap="8"
 *    paddingBottom="0"
 *    paddingTop="0"
 *    verticalAlign="top|middle|bottom"
 *    verticalGap="6"
 *    &gt;
 *    ...
 *      <i>child tags</i>
 *    ...
 *  &lt;/mx:Box&gt;
 *  </pre>
 *  </p>
 *
 *  @includeExample examples/SimpleBoxExample.mxml
 *
 *  @see mx.core.Container
 *  @see mx.containers.HBox
 *  @see mx.containers.VBox
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class Box extends Container
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
    public function Box()
    {
        super();
		
		// For Flex compatibility, the BoxLayout is immediately created and added
		// rather than being loaded from a style
        createLayout();
        _layout.direction = _direction;
		addBead(_layout);
    }

    protected function createLayout():void
    {
        _layout = new BoxLayout();
    }
    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
	
	protected var _layout:BoxLayout;
    
    protected function get layoutObject():BoxLayout
    {
        return _layout;
    }

    /**
     *  @private
     */

    //--------------------------------------------------------------------------
    //
    //  Public properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  direction
    //----------------------------------

    [Bindable("directionChanged")]
    [Inspectable(category="General", enumeration="vertical,horizontal", defaultValue="vertical")]
	
	private var _direction:String = BoxDirection.VERTICAL;

    /**
     *  The direction in which this Box container lays out its children.
     *  Possible MXML values are
     *  <code>"horizontal"</code> and <code>"vertical"</code>.
     *  Possible values in ActionScript are <code>BoxDirection.HORIZONTAL</code>
     *  and <code>BoxDirection.VERTICAL</code>.
     *
     *  @default BoxDirection.VERTICAL
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
		
		_layout.direction = value;
		
		dispatchEvent(new Event("directionChanged"));
        if (parent != null &&
            ((isHeightSizedToContent() || !isNaN(explicitHeight)) &&
            (isWidthSizedToContent() || !isNaN(explicitWidth))))
    		dispatchEvent(new Event("layoutNeeded"));

    }

    //--------------------------------------------------------------------------
    //
    //  Overridden methods
    //
    //--------------------------------------------------------------------------

    /**
     *  Calculates the default sizes and minimum and maximum values of the Box
     *  container.
     *
     *  <p>If the Box container's <code>direction</code> property is set to
     *  <code>BoxDirection.HORIZONTAL</code>, its <code>measuredWidth</code>
     *  property is equal to the sum of default widths of all of its children,
     *  plus the thickness of the borders, plus the left and right padding,
     *  plus the horizontal gap between each child.
     *  The value of the <code>measuredHeight</code> property is the maximum of
     *  all the children's default heights, plus room for the borders and
     *  padding.
     *  If the Box container's <code>direction</code> property is set to
     *  <code>BoxDirection.VERTICAL</code>, these two values are reversed.</p>
     *
     *  <p>The Box container's <code>minWidth</code> and <code>minHeight</code>
     *  properties are calculated similarly, by combining the minimum widths
     *  and minimum heights of the children.
     *  If the child's <code>width</code> property is a percentage value,  the
     *  Box container's minimum width is equal to the value of the child's
     *  <code>minWidth</code> property.
     *  If the child's <code>width</code> is unset or  set to a fixed value,
     *  the child refuses to grow or shrink, so the Box container's minimum
     *  width is equal to the value of the child's <code>explicitWidth</code>
     *  property.
     *  The child's minimum height is calculated similarly.</p>
     *
     *  <p>The Box container's <code>maxWidth</code> and
     *  <code>maxHeight</code> properties are not calculated.
     *  The Box container is assumed to have an infinite maximum width and
     *  height.</p>
     *
     *  <p>All of the values described previously are the <i>measured</i>
     *  widths and heights of the Box container.
     *  The user can override the measured values by explicitly supplying
     *  a value for the following properties:</p>
     *
     *  <ul>
     *    <li><code>width</code></li>
     *    <li><code>height</code></li>
     *    <li><code>minWidth</code></li>
     *    <li><code>minHeight</code></li>
     *    <li><code>maxWidth</code></li>
     *    <li><code>maxHeight</code></li>
     *  </ul>
     *
     *  <p>You should not call the <code>measure()</code> method directly.
     *  The Flex LayoutManager calls it at the appropriate time.
     *  At application startup, the Flex LayoutManager attempts to measure
     *  all components from the children to the parents before setting them
     *  to their final sizes.</p>
     *
     *  <p>This is an advanced method for use in subclassing.
     *  If you override this method, your implementation must call
     *  the <code>super.measure()</code> method, or set the
     *  <code>measuredHeight</code> and
     *  <code>measuredWidth</code> properties.
     *  You may also optionally set the following properties:</p>
     *
     *  <ul>
     *    <li><code>measuredMinWidth</code></li>
     *    <li><code>measuredMinHeight</code></li>
     *  </ul>
     *
     *  <p>These properties correspond to the layout properties listed
     *  previously and, therefore, are not separately documented.</p>
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    override protected function measure():void
    {
        super.measure();

        layoutObject.measure();
    }

    [Inspectable(environment="none")]

    /**
     *  The default width of the component, in pixels.
     *  This value is set by the <code>measure()</code> method.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    override public function get measuredWidth():Number
    {
        COMPILE::SWF {
            return super.measuredWidth;
        }
        COMPILE::JS {
            if (isNaN(_measuredWidth) || _measuredWidth </*=*/ 0) {
                measure();
            }
            return super.measuredWidth
        }
    }

    [Inspectable(environment="none")]

    /**
     *  The default height of the component, in pixels.
     *  This value is set by the <code>measure()</code> method.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    override public function get measuredHeight():Number
    {
        COMPILE::SWF {
            return super.measuredHeight;
        }
        COMPILE::JS {
            if (isNaN(_measuredHeight) || _measuredHeight </*=*/ 0) {
                measure();
            }
            return super.measuredHeight;
        }
    }


	override public function addedToParent():void
	{
		// set the layout bead based on the direction
		
//		if (_direction == BoxDirection.VERTICAL) {
//			addBead(new VerticalLayout()); // TBD: replace with MX-specific vertical layout
//		} else {
//			addBead(new HorizontalLayout()); // TBD: replace with MX-specific horizontal layout
//		}
		
		super.addedToParent();
	}

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     *  Method used to convert number of pixels to a
     *  percentage relative to the contents of this container.
     *
     *  <p>The percentage value is relevant only while the
     *  container does not change size or layout.
     *  After a resize and/or new layout has occurred,
     *  the value returned from this method may be stale.</p>
     *
     *  <p>An example of how this method could be used would
     *  be to restore a component's size to a specific number
     *  of pixels after hiding it.</p>
     *
     *  @param pxl The number of pixels for which a percentage
     *  value is desired.
     *
     *  @return The percentage value that would be equivalent
     *  to <code>pxl</code> under the current layout conditions
     *  of this container.
     *  A negative value indicates that the container must grow
     *  in order to accommodate the requested size.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
//NOTE:
// Will probably use this in the MX layouts
//
//    public function pixelsToPercent(pxl:Number):Number
//    {
//        var vertical:Boolean = isVertical();
//
//        // Compute our total percent and total # pixels for that percent.
//        var totalPerc:Number = 0;
//        var totalSize:Number = 0;
//
//        var n:int = numChildren;
//        for (var i:int = 0; i < n; i++)
//        {
//            var child:IUIComponent = getLayoutChildAt(i);
//
//            var size:Number = vertical ? child.height : child.width;
//            var perc:Number = vertical ? child.percentHeight : child.percentWidth;
//
//            if (!isNaN(perc))
//            {
//                totalPerc += perc;
//                totalSize += size;
//            }
//        }
//
//        // Now if we found one let's compute the percent amount
//        // that we'd require for a given number of pixels.
//        var p:Number = 100;
//        if (totalSize != pxl)
//        {
//            // Now we want the ratio of pixels per percent to
//            // remain constant as we assume the a component
//            // will consume them. So,
//            //
//            //  (totalSize - pxl) / totalPerc = totalSize / (totalPerc + p)
//            //
//            // where we solve for p.
//
//            p = ((totalSize * totalPerc) / (totalSize - pxl)) - totalPerc;
//        }
//
//        return p;
//    }
	
	/**
	 * @private
	 */
	public function isVertical():Boolean
	{
		return _direction == BoxDirection.VERTICAL;
	}
}

}
