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
	import org.apache.royale.events.EventDispatcher;

/*
import flash.display.DisplayObject;
import flash.geom.Rectangle;
*/
import mx.containers.utilityClasses.ConstraintColumn;
import mx.containers.utilityClasses.ConstraintRow;
/*
import mx.containers.utilityClasses.CanvasLayout;
*/
import mx.containers.utilityClasses.IConstraintLayout;
import mx.core.Container;
import mx.core.EdgeMetrics;
import mx.core.IUIComponent;
/*
import mx.core.mx_internal;
import mx.styles.IStyleClient;

use namespace mx_internal;
*/

/**
 *  A Halo Canvas layout container defines a rectangular region
 *  in which you place child containers and controls.
 *  It is the only container that lets you explicitly specify the location
 *  of its children within the container by using the <code>x</code> and
 *  <code>y</code> properties of each child.
 * 
 *  <p><b>Note:</b> Adobe recommends that, when possible, you use the Spark containers 
 *  with BasicLayout instead of the Halo Canvas container.</p>
 *
 *  <p>Flex sets the children of a Canvas layout container to their
 *  preferred width and preferred height.
 *  You may override the value for a child's
 *  preferred width by setting its <code>width</code> property to either
 *  a fixed pixel value or a percentage of the container size.
 *  You can set the preferred height in a similar manner.</p>
 *
 *  <p>If you use percentage sizing inside a Canvas container,
 *  some of your components may overlap.
 *  If this is not the effect you want, plan your component positions
 *  and sizes carefully.</p>
 *
 *  <p>The Canvas container has the following default sizing characteristics:</p>
 *     <table class="innertable">
 *        <tr>
 *           <th>Characteristic</th>
 *           <th>Description</th>
 *        </tr>
 *        <tr>
 *           <td>Default size</td>
 *           <td>Large enough to hold all its children at the default sizes of the children</td>
 *        </tr>
 *        <tr>
 *           <td>Default padding</td>
 *           <td>0 pixels for the top, bottom, left, and right values</td>
 *        </tr>
 *     </table>
 *
 *  @mxml
 *
 *  <p>The <code>&lt;mx:Canvas&gt;</code> tag inherits all the tag attributes
 *  of its superclass. Use the following syntax:</p>
 *
 *  <p>
 *  <pre>
 *  &lt;mx:Canvas&gt;
 *    ...
 *      <i>child tags</i>
 *    ...
 *  &lt;/mx:Canvas&gt;
 *  </pre>
 *  </p>
 *  
 *  @includeExample examples/SimpleCanvasExample.mxml
 *
 *  @see mx.core.Container
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class Canvas extends Container implements IConstraintLayout
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
    public function Canvas()
    {
        super();
		typeNames = "Canvas";

        //layoutObject.target = this;
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    //private var layoutObject:CanvasLayout = new CanvasLayout();
    
    //--------------------------------------------------------------------------
    //
    //  Overridden properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  usePadding
    //----------------------------------
    
    /**
     *  @private
     */
//    override mx_internal function get usePadding():Boolean
//    {
//        // We never use padding.
//        return false;
//    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  constraintColumns
    //----------------------------------
    
    /**
     *  @private
     *  Storage for the constraintColumns property.
     */
    private var _constraintColumns:Array = [];
    
    [ArrayElementType("mx.containers.utilityClasses.ConstraintColumn")]
    [Inspectable(arrayType="mx.containers.utilityClasses.ConstraintColumn")]

    /**
     *  @copy mx.containers.utilityClasses.IConstraintLayout#constraintColumns
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get constraintColumns():Array
    {
        return _constraintColumns;
    }
    
    /**
     *  @private
     */
    public function set constraintColumns(value:Array):void
    {
        if (value != _constraintColumns)
        {
            var n:int = value.length;
            for (var i:int = 0; i < n; i++)
            {
                ConstraintColumn(value[i]).container = this;
            }
           _constraintColumns = value;
           
           //invalidateSize();
           //invalidateDisplayList();
		   dispatchEvent(new Event("layoutNeeded"));
        }
    }

    //----------------------------------
    //  constraintRows
    //----------------------------------
        
    /**
     *  @private
     *  Storage for the constraintRows property.
     */
    private var _constraintRows:Array = [];

    [ArrayElementType("mx.containers.utilityClasses.ConstraintRow")]
    [Inspectable(arrayType="mx.containers.utilityClasses.ConstraintRow")]
        
    /**
     *  @copy mx.containers.utilityClasses.IConstraintLayout#constraintRows
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get constraintRows():Array
    {
        return _constraintRows;
    }
    
    /**
     *  @private
     */
    public function set constraintRows(value:Array):void
    {
        if (value != _constraintRows)
        {
            var n:int = value.length;
            for (var i:int = 0; i < n; i++)
            {
                ConstraintRow(value[i]).container = this;
            }
            _constraintRows = value;
            
            //invalidateSize();
            //invalidateDisplayList();;
			dispatchEvent(new Event("layoutNeeded"));
        }
    }
    
    //--------------------------------------------------------------------------
    //
    //  Overridden methods
    //
    //--------------------------------------------------------------------------

    /**
     *  Calculates the preferred minimum and preferred maximum sizes
     *  of the Canvas.
     *
     *  <p>The <code>measuredWidth</code> of the Canvas is just large enough
     *  to display all of its children at their preferred widths
     *  without clipping them.
     *  This <code>measure()</code> method calculates the position of the
     *  right-most child, calculates the position of that child's right edge,
     *  and then adds room for the thickness of the Canvas container's border
     *  and the right padding.
     *  The <code>measuredHeight</code> is calculated similarly.</p>
     *
     *  <p>The Canvas container's <code>minWidth</code> and
     *  <code>minHeight</code> properties are not calculated,
     *  so Flex uses a default value of 0.</p>
     *
     *  <p>The Canvas container's <code>maxWidth</code> and
     *  <code>maxHeight</code> properties are not calculated.
     *  The container is assumed to have an infinite maximum
     *  width and height.</p>
     *
     *  <p>All of the values described previously are the <i>measured</i> widths
     *  and heights of Canvas.
     *  The user can override the measured values by calling the
     *  explicitly supplying a value
     *  for the following properties:</p>
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
     *  <p>You should not call this method directly.
     *  The Flex LayoutManager calls it at the appropriate time.
     *  At application startup, the Flex LayoutManager attempts to measure
     *  all components from the children to the parents before setting them
     *  to their final sizes.</p>
     *
     *  <p>This is an advanced method for use in subclassing.
     *  If you override this method, your implementation must either
     *  call the <code>super.measure()</code> method or set the
     *  <code>measuredHeight</code> and
     *  <code>measuredWidth</code> properties.
     *  You may also optionally set the following properties:
     *  <ul>
     *    <li><code>measuredMinWidth</code></li>
     *    <li><code>measuredMinHeight</code></li>
     *  </ul>
     *  These properties correspond to the layout properties listed previously
     *  and, therefore, are not documented separately.</p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
//    override protected function measure():void
//    {
//        super.measure();
//
//        layoutObject.measure();
//    }
    
    /**
     *  Sets the size of each child of the container.
     *
     *  <p>Canvas does not change the positions of its children.
     *  Each child is positioned according to the values of its
     *  <code>x</code> and <code>y</code> properties.</p>
     *
     *  <p>Canvas does set each child's width and height to be equal
     *  to that child's <code>measuredWidth</code> and
     *  <code>measuredHeight</code> if no <code>width</code>
     *  and <code>height</code> values are supplied.
     *  The child can also be made resizable by setting
     *  <code>width</code> and/or <code>height</code> to a percent value.
     *  Resizable children are bound by the right and bottom edges
     *  of the Canvas container.
     *  In this case, the child's <code>minWidth</code>,
     *  <code>minHeight</code>, <code>maxWidth</code>, and
     *  <code>maxHeight</code> values are honored.</p>
     *
     *  <p>You should not call this method directly.
     *  The Flex LayoutManager calls it at the appropriate time.
     *  At application startup, the Flex LayoutManager calls
     *  <code>updateDisplayList()</code> method on every component,
     *  starting with the Application object and working downward.</p>
     *
     *  <p>This is an advanced method for use in subclassing.
     *  If you override this method, your implementation should call the
     *  <code>super.updateDisplayList()</code> method and call the
     *  <code>move()</code> and <code>setActualSize()</code> methods
     *  on each of the children.
     *  For the purposes of performing layout, you should get the size
     *  of this container from the <code>unscaledWidth</code> and
     *  <code>unscaledHeight</code> properties, not the <code>width</code>
     *  and <code>height</code> properties.
     *  The <code>width</code> and <code>height</code> properties
     *  do not take into account the value of the <code>scaleX</code>
     *  and <code>scaleY</code> properties for this container.</p>
     *
     *  @param unscaledWidth Specifies the width of the component, in pixels,
     *  in the component's coordinates, regardless of the value of the
     *  <code>scaleX</code> property of the component.
     *
     *  @param unscaledHeight Specifies the height of the component, in pixels,
     *  in the component's coordinates, regardless of the value of the
     *  <code>scaleY</code> property of the component.
     *
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
//    override protected function updateDisplayList(unscaledWidth:Number,
//                                                  unscaledHeight:Number):void
//    {
//        super.updateDisplayList(unscaledWidth, unscaledHeight);
//
//        layoutObject.updateDisplayList(unscaledWidth, unscaledHeight);
//    }
    
}

}
