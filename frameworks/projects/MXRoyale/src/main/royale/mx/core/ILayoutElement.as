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

import org.apache.royale.events.IEventDispatcher;
//import flash.geom.Matrix;
//import flash.geom.Matrix3D;
//import flash.geom.Vector3D;

/**
 *  The ILayoutElement interface is used primarily by the layout classes to query,
 *  size and position the elements of GroupBase containers.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
public interface ILayoutElement extends IEventDispatcher
{
/**
     *  The horizontal distance in pixels from the left edge of the component to the
     *  anchor target's left edge.
     *
     *  <p>By default the anchor target is the container's content area. In layouts
     *  with advanced constraints, the target can be a constraint column.</p>
     *
     *  <p>Setting the property to a number or to a numerical string like "10"
     *  specifies use of the default anchor target.</p>
     *
     *  <p>To specify an anchor target, set the property value to a string in the format
     *  "anchorTargetName:value". For example, "col1:10".</p>
     *
     *  @default null
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    function get left():Object;
    
    /**
     *  @private
     */
    function set left(value:Object):void;

    /**
     *  The horizontal distance in pixels from the right edge of the component to the
     *  anchor target's right edge.
     *
     *  <p>By default the anchor target is the container's content area. In layouts
     *  with advanced constraints, the target can be a constraint column.</p>
     *
     *  <p>Setting the property to a number or to a numerical string like "10"
     *  specifies use of the default anchor target.</p>
     *
     *  <p>To specify an anchor target, set the property value to a string in the format
     *  "anchorTargetName:value". For example, "col1:10".</p>
     *
     *  @default null
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    function get right():Object;
    
    /**
     *  @private
     */
    function set right(value:Object):void;

    /**
     *  The vertical distance in pixels from the top edge of the component to the
     *  anchor target's top edge.
     *
     *  <p>By default the anchor target is the container's content area. In layouts
     *  with advanced constraints, the target can be a constraint row.</p>
     *
     *  <p>Setting the property to a number or to a numerical string like "10"
     *  specifies use of the default anchor target.</p>
     *
     *  <p>To specify an anchor target, set the property value to a string in the format
     *  "anchorTargetName:value". For example, "row1:10".</p>
     *
     *  @default null
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    function get top():Object;
    
    /**
     *  @private
     */
    function set top(value:Object):void;

    /**
     *  The vertical distance in pixels from the bottom edge of the component to the
     *  anchor target's bottom edge.
     *
     *  <p>By default the anchor target is the container's content area. In layouts
     *  with advanced constraints, the target can be a constraint row.</p>
     *
     *  <p>Setting the property to a number or to a numerical string like "10"
     *  specifies use of the default anchor target.</p>
     *
     *  <p>To specify an anchor target, set the property value to a string in the format:
     *  "anchorTargetName:value". For example, "row1:10".</p>
     *
     *  @default null
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    function get bottom():Object;
    
    /**
     *  @private
     */
    function set bottom(value:Object):void;

    /**
     *  The horizontal distance in pixels from the center of the component to the
     *  center of the anchor target's content area.
     *
     *  <p>The default anchor target is the container itself.</p>
     *
     *  <p>In layouts with advanced constraints, the anchor target can be a constraint column.
     *  Then the content area is the space between the preceding column
     *  (or container side) and the target column.</p>
     *
     *  <p>Setting the property to a number or to a numerical string like "10"
     *  specifies use of the default anchor target.</p>
     *
     *  <p>To specify an anchor target, set the property value to a string in the format
     *  "constraintColumnId:value". For example, "col1:10".</p>
     *
     *  @default null
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    function get horizontalCenter():Object;
    
    /**
     *  @private
     */
    function set horizontalCenter(value:Object):void;

    /**
     *  The vertical distance in pixels from the center of the component to the
     *  center of the anchor target's content area.
     *
     *  <p>The default anchor target is the container itself.</p>
     *
     *  <p>In layouts with advanced constraints, the anchor target can be a constraint row.
     *  Then the content area is the space between the preceding row
     *  (or container side) and the target row.</p>
     *
     *  <p>Setting the property to a number or to a numerical string like "10"
     *  specifies use of the default anchor target.</p>
     *
     *  <p>To specify an anchor target, set the property value to a string in the format
     *  "constraintColumnId:value". For example, "row1:10".</p>
     *
     *  @default null
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    function get verticalCenter():Object;
    
    /**
     *  @private
     */
    function set verticalCenter(value:Object):void;

    /**
     *  The vertical distance in pixels from the anchor target to
     *  the control's baseline position.
     *
     *  <p>By default the anchor target is the top edge of the container's
     *  content area. In layouts with advanced constraints, the target can be
     *  a constraint row.</p>
     *
     *  <p>Setting the property to a number or to a numerical string like "10"
     *  specifies use of the default anchor target.</p>
     *
     *  <p>To specify an anchor target, set the property value to a string in the format:
     *  "anchorTargetName:value". For example, "row1:10".</p>
     *
     *  @default null
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    function get baseline():Object;
     
    
    /**
     *  @private
     */
    function set baseline(value:Object):void;

    /**
     *  The y-coordinate of the baseline
     *  of the first line of text of the component.
     *
     *  <p>This property is used to implement
     *  the <code>baseline</code> constraint style.
     *  It is also used to align the label of a FormItem
     *  with the controls in the FormItem.</p>
     *
     *  <p>Each component should override this property.</p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    function get baselinePosition():Number;
    
    /**
     *  Specifies the width of a component as a percentage
     *  of its parent's size. Allowed values are 0-100.
     *  Setting the <code>width</code> or <code>explicitWidth</code> properties
     *  resets this property to NaN.
     *
     *  <p>This property returns a numeric value only if the property was
     *  previously set; it does not reflect the exact size of the component
     *  in percent.</p>
     *
     *  @default NaN
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    function get percentWidth():Number;
    
    /**
     *  @private
     */
    function set percentWidth(value:Number):void;

    /**
     *  Specifies the height of a component as a percentage
     *  of its parent's size. Allowed values are 0-100.
     *  Setting the <code>height</code> or <code>explicitHeight</code> properties
     *  resets this property to NaN.
     *
     *  <p>This property returns a numeric value only if the property was
     *  previously set; it does not reflect the exact size of the component
     *  in percent.</p>
     *
     *  @default NaN
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    function get percentHeight():Number;
    
    /**
     *  @private
     */
    function set percentHeight(value:Number):void;
 
    /**
     *  @copy mx.core.UIComponent#includeInLayout
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */   
    function get includeInLayout():Boolean;
    
    /**
     *  @private
     */
    function set includeInLayout(value:Boolean):void;
    
    /**
     *  Returns the element's preferred width.   
     * 
     *  @param postLayoutTransform When <code>postLayoutTransform</code> is <code>true</code>,
     *  the method returns the element's bounding box width.  
     *  The bounding box is in the element's parent
     *  coordinate space and is calculated from  the element's preferred size and
     *  layout transform matrix.
     *
     *  @return Returns the element's preferred width.  Preferred width is
     *  usually based on the default element size and any explicit overrides.
     *  For UIComponent this is the same value as returned by 
     *  the <code>getExplicitOrMeasuredWidth()</code> method.
     * 
     *  @see #getPreferredBoundsHeight()
     *  @see #getLayoutMatrix()
     *  @see #getLayoutMatrix3D()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    function getPreferredBoundsWidth(postLayoutTransform:Boolean = true):Number;

    /**
     *  Returns the element's preferred height.  
     *
     *  @param postLayoutTransform When <code>postLayoutTransform</code> is <code>true</code>,
     *  the method returns the element's bounding box height.  
     *  The bounding box is in the element's parent
     *  coordinate space and is calculated from  the element's preferred size and
     *  layout transform matrix.
     *
     *  @return Returns the element's preferred height.  Preferred height is
     *  usually based on the default element size and any explicit overrides.
     *  For UIComponent this is the same value as returned by 
     *  the <code>getExplicitOrMeasuredHeight()</code> method.
     *
     *  @see #getPreferredBoundsWidth()
     *  @see #getLayoutMatrix()
     *  @see #getLayoutMatrix3D()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    function getPreferredBoundsHeight(postLayoutTransform:Boolean = true):Number;

    /**
     *  Returns the element's minimum width.
     * 
     *  @param postLayoutTransform When <code>postLayoutTransform</code> is <code>true</code>,
     *  the method returns the element's bounding box width. 
     *  The bounding box is in the element's parent
     *  coordinate space and is calculated from the element's minimum size and
     *  layout transform matrix.
     *
     *  @return The element's maximum width.
     *
     *  @see #getMinBoundsHeight()
     *  @see #getLayoutMatrix()
     *  @see #getLayoutMatrix3D()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    function getMinBoundsWidth(postLayoutTransform:Boolean = true):Number;

    /**
     *  Returns the element's minimum height.
     * 
     *  @param postLayoutTransform When <code>postLayoutTransform</code> is <code>true</code>,
     *  the method returns the element's bounding box height. 
     *  The bounding box is in the element's parent
     *  coordinate space and is calculated from the element's minimum size and
     *  layout transform matrix.
     *
     *  @return The element's maximum height.
     *
     *  @see #getMinBoundsWidth()
     *  @see #getLayoutMatrix()
     *  @see #getLayoutMatrix3D()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    function getMinBoundsHeight(postLayoutTransform:Boolean = true):Number;

    /**
     *  Returns the element's maximum width.
     * 
     *  @param postLayoutTransform When <code>postLayoutTransform</code> is true, the method returns
     *  the element's bounding box width. The bounding box is in the element's parent
     *  coordinate space and is calculated from the element's maximum size and
     *  layout transform matrix.
     *
     *  @return The element's maximum width.
     *
     *  @see #getMaxBoundsHeight()
     *  @see #getLayoutMatrix()
     *  @see #getLayoutMatrix3D()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    function getMaxBoundsWidth(postLayoutTransform:Boolean = true):Number;

    /**
     *  Returns the element's maximum height.
     * 
     *  @param postLayoutTransform When <code>postLayoutTransform</code> is true, the method returns
     *  the element's bounding box height. The bounding box is in the element's parent
     *  coordinate space and is calculated from the element's maximum size and
     *  layout transform matrix.
     *
     *  @return The element's maximum height.
     *
     *  @see #getMaxBoundsWidth()
     *  @see #getLayoutMatrix()
     *  @see #getLayoutMatrix3D()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    function getMaxBoundsHeight(postLayoutTransform:Boolean = true):Number;
    
    /**
     *  Returns the x coordinate of the element's bounds at the specified element size.
     * 
     *  <p>This method is typically used by layouts during a call to the 
     *  <code>measure()</code> method to predict what
     *  the element position will be, if the element is resized to particular dimensions.</p>
     * 
     *  @param width The element's bounds width, or NaN to use the preferred width.
     *  @param height The element's bounds height, or NaN to use the preferred height.
     *  @param postLayoutTransform When <code>postLayoutTransform</code> is true, the method returns
     *  x coordinate of the element's bounding box top-left corner.
     *  The bounding box is in element's parent coordinate space and is calculated
     *  from the specified bounds size, layout position and layout transform matrix.
     *
     *  @return The x coordinate of the element's bounds at the specified element size.
     *
     *  @see #setLayoutBoundsSize()
     *  @see #getLayoutMatrix()
     *  @see #getLayoutMatrix3D()
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    function getBoundsXAtSize(width:Number, height:Number, postLayoutTransform:Boolean = true):Number;

    /**
     *  Returns the y coordinate of the element's bounds at the specified element size.
     * 
     *  This method is typically used by layouts during a call to 
     *  the <code>measure()</code> to predict what
     *  the element position will be, if the element is resized to particular dimensions.
     * 
     *  @param width The element's bounds width, or NaN to use the preferred width.
     *  @param height The element's bounds height, or NaN to use the preferred height.
     *  @param postLayoutTransform When <code>postLayoutTransform</code> is true, the method returns
     *  the y coordinate of the element's bounding box top-left corner.
     *  The bounding box is in element's parent coordinate space and is calculated
     *  from the specified bounds size, layout position and layout transform matrix.
     *  
     *  @return The y coordinate of the element's bounds at the specified element size.
     *
     *  @see #setLayoutBoundsSize()
     *  @see #getLayoutBoundsY()
     *  @see #getLayoutMatrix()
     *  @see #getLayoutMatrix3D()
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    function getBoundsYAtSize(width:Number, height:Number, postLayoutTransform:Boolean = true):Number;
    
    /**
     *  Returns the element's layout width. This is the size that the element uses
     *  to draw on screen.
     *
     *  @param postLayoutTransform When <code>postLayoutTransform</code> is true, the method returns
     *  the element's bounding box width. The bounding box is in element's parent
     *  coordinate space and is calculated from the element's layout size and
     *  layout transform matrix.
     *  
     *  @return The element's layout width.
     *
     *  @see #getLayoutBoundsHeight()
     *  @see #getLayoutMatrix()
     *  @see #getLayoutMatrix3D()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    function getLayoutBoundsWidth(postLayoutTransform:Boolean = true):Number;

    /**
     *  Returns the element's layout height. This is the size that the element uses
     *  to draw on screen.
     *
     *  @param postLayoutTransform When <code>postLayoutTransform</code> is true, the method returns
     *  the element's bounding box width. The bounding box is in the element's parent
     *  coordinate space and is calculated from the element's layout size and
     *  layout transform matrix.
     *  
     *  @return The element's layout height.
     *
     *  @see #getLayoutBoundsWidth()
     *  @see #getLayoutMatrix()
     *  @see #getLayoutMatrix3D()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    function getLayoutBoundsHeight(postLayoutTransform:Boolean = true):Number;
    
    /**
     *  Returns the x coordinate that the element uses to draw on screen.
     *
     *  @param postLayoutTransform When <code>postLayoutTransform</code> is true, the method returns
     *  x coordinate of the element's bounding box top-left corner.
     *  The bounding box is in the element's parent coordinate space and is calculated
     *  from the element's layout size, layout position and layout transform matrix.
     * 
     *  @return The x coordinate that the element uses to draw on screen.
     * 
     *  @see #getLayoutBoundsY()
     *  @see #getLayoutMatrix()
     *  @see #getLayoutMatrix3D()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    function getLayoutBoundsX(postLayoutTransform:Boolean = true):Number;

    /**
     *  Returns the y coordinate that the element uses to draw on screen.
     *
     *  @param postLayoutTransform When <code>postLayoutTransform</code> is true, the method returns
     *  y coordinate of the element's bounding box top-left corner.
     *  The bounding box is in the element's parent coordinate space and is calculated
     *  from the element's layout size, layout position, and layout transform matrix.
     * 
     *  @return The y coordinate that the element uses to draw on screen.
     * 
     *  @see #getLayoutBoundsX()
     *  @see #getLayoutMatrix()
     *  @see #getLayoutMatrix3D()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    function getLayoutBoundsY(postLayoutTransform:Boolean = true):Number;

    /**
     *  Sets the coordinates that the element uses to draw on screen.
     *
     *  <p>Note that calls to the <code>setLayoutBoundSize()</code> method can affect the layout position, so 
     *  call <code>setLayoutBoundPosition()</code> after calling <code>setLayoutBoundSize()</code>.</p>
     *
     *  @param x The x-coordinate of the top-left corner of the bounding box. 
     *
     *  @param y The y-coordinate of the top-left corner of the bounding box.
     *
     *  @param postLayoutTransform When <code>postLayoutTransform</code> is <code>true</code>, 
     *  the element is positioned in such a way that the top-left corner of its bounding box is (x, y).
     *  The bounding box is in the element's parent coordinate space and is calculated
     *  from the element's layout size, layout position and layout transform matrix.
     *
     *  @see #setLayoutBoundsSize()
     *  @see #getLayoutMatrix()
     *  @see #getLayoutMatrix3D()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    function setLayoutBoundsPosition(x:Number, y:Number, postLayoutTransform:Boolean = true):void;

    /**
     *  Sets the layout size of the element.  
     *  This is the size that the element uses to draw on screen.
     *  
     *  <p>If the <code>width</code> and/or <code>height</code> parameters are left unspecified (NaN),
     *  Flex sets the element's layout size to its preferred width and/or preferred height.</p>
     * 
     *  <p>Note that calls to the <code>setLayoutBoundSize()</code> method can affect the layout position, so 
     *  call <code>setLayoutBoundPosition()</code> after calling <code>setLayoutBoundSize()</code>.</p>
     *
     *  @param width The element's layout width.
     *
     *  @param height The element's layout height.
     *
     *  @param postLayoutTransform When <code>postLayoutTransform</code> is true, the specified sizes
     *  are those of the element's bounding box.
     *  The bounding box is in the element's parent coordinate space and is calculated
     *  from the element's layout size, layout position, and layout transform matrix.
     * 
     *  @see #setLayoutBoundsPosition()
     *  @see #getLayoutMatrix()
     *  @see #getLayoutMatrix3D()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    function setLayoutBoundsSize(width:Number,
                                 height:Number,
                                 postLayoutTransform:Boolean = true):void;

    /**
     *  Returns the transform matrix that is used to calculate the component's
     *  layout relative to its siblings.
     *
     *  <p>This matrix is typically defined by the
     *  component's 2D properties such as <code>x</code>, <code>y</code>,
     *  <code>rotation</code>, <code>scaleX</code>, <code>scaleY</code>,
     *  <code>transformX</code>, and <code>transformY</code>.
     *  Some components may have additional transform properties that
     *  are applied on top of the layout matrix to determine the final,
     *  computed matrix.  For example <code>UIComponent</code>
     *  defines the <code>offsets</code> property.</p>
     *  
     *  @return The layout transform Matrix for this element.
     *  Do not directly modify the return value; call the <code>setLayoutMatrix()</code> method instead.
     * 
     *  @see #setLayoutMatrix()
     *  @see #getLayoutMatrix3D()
     *  @see #setLayoutMatrix3D()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
    function getLayoutMatrix():Matrix;
     */

    /**
     *  Sets the transform Matrix that is used to calculate the component's layout
     *  size and position relative to its siblings.
     *
     *  <p>The matrix is typically defined by the
     *  component's 2D properties such as <code>x</code>, <code>y</code>,
     *  <code>rotation</code>, <code>scaleX</code>, <code>scaleY</code>,
     *  <code>transformX</code>, and <code>transformY</code>.
     *  Some components may have additional transform properties that
     *  are applied on top of the layout matrix to determine the final,
     *  computed matrix.  For example <code>UIComponent</code>
     *  defines the <code>offsets</code>.</p>
     *  
     *  <p>Note that layout Matrix is factored in the <code>getPreferredSize()</code>,
     *  <code>getMinSize()</code>, <code>getMaxSize()</code>, <code>getLayoutSize()</code> 
     *  methods when computed in parent coordinates
     *  as well as in <code>getLayoutPosition()</code> in both parent and child coordinates.
     *  Layouts that calculate the transform matrix explicitly typically call
     *  this method and work with sizes in child coordinates.
     *  Layouts calling this method pass <code>false</code>
     *  to the <code>invalidateLayout()</code> method so that a subsequent layout pass is not
     *  triggered.</p>
     *
     *  @param Matrix The matrix.
     *
     *  @param invalidateLayout <code>true</code> to cause the parent container 
     *  to re-layout its children. You typically pass <code>true</code>
     *  to the <code>invalidateLayout()</code> method.
     * 
     *  @see #getLayoutMatrix()
     *  @see #getLayoutMatrix3D()
     *  @see #setLayoutMatrix3D()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
    function setLayoutMatrix(value:Matrix, invalidateLayout:Boolean):void;
     */
    
    /**
     *  Contains <code>true</code> if the element has 3D Matrix.
     *
     *  <p>Use <code>hasLayoutMatrix3D</code> instead of calling and examining the
     *  return value of <code>getLayoutMatrix3D()</code> because that method returns a valid
     *  matrix even when the element is in 2D.</p>
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
    function get hasLayoutMatrix3D():Boolean;
     */

    /**
     *  Returns the layout transform Matrix3D for this element.
     * 
     *  <p>This matrix is typically defined by the
     *  component's transform properties such as <code>x</code>, <code>y</code>, 
     *  <code>z</code>, <code>rotationX</code>, <code>rotationY</code>,
     *  <code>rotationZ</code>, <code>scaleX</code>, <code>scaleY</code>,
     *  <code>scaleZ</code>, <code>transformX</code>, and <code>transformY</code>.
     *  Some components may have additional transform properties that
     *  are applied on top of the layout matrix to determine the final,
     *  computed matrix.  For example <code>UIComponent</code>
     *  defines the <code>offsets</code> property.</p>
     * 
     *  @return The layout transform Matrix3D for this element.
     *  Do not directly modify the return value but call the <code>setLayoutMatrix()</code> method instead.
     *  
     *  @see #getLayoutMatrix()
     *  @see #setLayoutMatrix()
     *  @see #setLayoutMatrix3D()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
    function getLayoutMatrix3D():Matrix3D;
     */

    /**
     *  Sets the transform Matrix3D that is used to calculate the component's layout
     *  size and position relative to its siblings.
     *
     *  <p>This matrix is typically defined by the
     *  component's transform properties such as <code>x</code>, <code>y</code>, 
     *  <code>z</code>, <code>rotationX</code>, <code>rotationY</code>,
     *  <code>rotationZ</code>, <code>scaleX</code>, <code>scaleY</code>,
     *  <code>scaleZ</code>, <code>transformX</code>, and <code>transformY</code>.
     *  Some components may have additional transform properties that
     *  are applied on top of the layout matrix to determine the final,
     *  computed matrix.  For example <code>UIComponent</code>
     *  defines the <code>offsets</code> property.</p>
     *  
     *  <p>Note that layout Matrix3D is factored in the <code>getPreferredSize()</code>,
     *  <code>getMinSize()</code>, <code>getMaxSize()</code>, <code>getLayoutSize()</code> 
     *  when computed in parent coordinates
     *  as well as in <code>getLayoutPosition()</code> in both parent and child coordinates.
     *  Layouts that calculate the transform matrix explicitly typically call
     *  this method and work with sizes in child coordinates.
     *  Layouts calling this method pass <code>false</code>
     *  to the <code>invalidateLayout()</code> method so that a subsequent layout pass is not
     *  triggered.</p>
     *
     *  @param Matrix The matrix.
     *
     *  @param invalidateLayout <code>true</code> to cause the parent container 
     *  to re-layout its children. You typically pass <code>true</code>
     *  to the <code>invalidateLayout()</code> method.
     * 
     *  @see #getLayoutMatrix()
     *  @see #setLayoutMatrix()
     *  @see #getLayoutMatrix3D()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
    function setLayoutMatrix3D(value:Matrix3D, invalidateLayout:Boolean):void;
     */

    /**
     *  A utility method to update the rotation, scale, and translation of the 
     *  transform while keeping a particular point, specified in the component's 
     *  own coordinate space, fixed in the parent's coordinate space.  
     *  This function will assign the rotation, scale, and translation values 
     *  provided, then update the x/y/z properties as necessary to keep 
     *  the transform center fixed.
     *
     *  @param transformCenter The point, in the component's own coordinates, 
     *  to keep fixed relative to its parent.
     *
     *  @param scale The new values for the scale of the transform.
     *
     *  @param rotation the new values for the rotation of the transform
     *
     *  @param translation The new values for the translation of the transform.
     *
     *  @param postLayoutScale The new values for the post-layout scale 
     *  of the transform.
     *
     *  @param postLayoutRotation The new values for the post-layout rotation 
     *  of the transform.
     *
     *  @param postLayoutTranslation The new values for the post-layout translation 
     *  of the transform.
     *
     *  @param invalidateLayout If <code>true</code>, the parent container size and display are
     *  invalidated. Layouts calling this method pass <code>false</code>
     *  so that a subsequent layout pass is not triggered.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
    function transformAround(transformCenter:Vector3D,
                                    scale:Vector3D = null,
                                    rotation:Vector3D = null,
                                    translation:Vector3D = null,
                                    postLayoutScale:Vector3D = null,
                                    postLayoutRotation:Vector3D = null,
                                    postLayoutTranslation:Vector3D = null,
                                    invalidateLayout:Boolean = true):void;    
     */
}

}
