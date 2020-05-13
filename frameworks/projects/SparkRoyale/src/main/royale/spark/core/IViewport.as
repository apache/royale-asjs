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

package spark.core
{

import mx.core.IVisualElement;

/**
 *  The IViewport interface is implemented by components that support a viewport. 
 *  If a component's children are larger than the component, 
 *  and you want to clip the children to the component boundaries, you can define a viewport and scroll bars. 
 *  A viewport is a rectangular subset of the area of a component that you want to display, 
 *  rather than displaying the entire component.
 *
 *  <p>A viewport on its own is not movable by the application user. 
 *  However, you can combine a viewport with scroll bars so the user can scroll 
 *  the viewport to see the entire content of the component. 
 *  Use the Scroller component to add scrolbars to the component.</p>
 *
 *  @see spark.components.Scroller
 *
 *  @includeExample examples/IViewportExample.mxml
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
public interface IViewport extends IVisualElement
{
    
    /**
     *  The width of the viewport's contents.
     * 
     *  If <code>clipAndEnabledScrolling</code> is true, the viewport's 
     *  <code>contentWidth</code> defines the limit for horizontal scrolling 
     *  and the viewport's actual width defines how much of the content is visible.
     * 
     *  To scroll through the content horizontally, vary the 
     *  <code>horizontalScrollPosition</code> between 0 and
     *  <code>contentWidth - width</code>.  
     * 
     *  <p>Implementations of this property must be Bindable and
     *  must generate events of type <code>propertyChange</code>.</p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
    function get contentWidth():Number;
     */
    
    /**
     *  The height of the viewport's content.
     * 
     *  If <code>clipAndEnabledScrolling</code> is true, the viewport's 
     *  <code>contentHeight</code> defines the limit for vertical scrolling 
     *  and the viewport's actual height defines how much of the content is visible.
     * 
     *  To scroll through the content vertically, vary the 
     *  <code>verticalScrollPosition</code> between 0 and
     *  <code>contentHeight - height</code>.  
     *
     *  <p>Implementations of this property must be Bindable and
     *  must generate events of type <code>propertyChange</code>.</p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
    function get contentHeight():Number;
     */

    /**
     *  The x coordinate of the origin of the viewport in the component's coordinate system, 
     *  where the default value is (0,0) corresponding to the upper-left corner of the component.
     * 
     *  If <code>clipAndEnableScrolling</code> is <code>true</code>, setting this property 
     *  typically causes the viewport to be set to:
     *  <pre>
     *  new Rectangle(horizontalScrollPosition, verticalScrollPosition, width, height)
     *  </pre>
     * 
     *  Implementations of this property must be Bindable and
     *  must generate events of type <code>propertyChange</code>.
     *   
     *  @default 0
     * 
     *  @see #target
     *  @see #verticalScrollPosition
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
    function get horizontalScrollPosition():Number;
    function set horizontalScrollPosition(value:Number):void;
     */
     
     /**
     *  The y coordinate of the origin of the viewport in the component's coordinate system, 
     *  where the default value is (0,0) corresponding to the upper-left corner of the component.
     * 
     *  If <code>clipAndEnableScrolling</code> is <code>true</code>, setting this property 
     *  typically causes the viewport to be set to:
     *  <pre>
     *  new Rectangle(horizontalScrollPosition, verticalScrollPosition, width, height)
     *  </pre>
     * 
     *  Implementations of this property must be Bindable and
     *  must generate events of type <code>propertyChange</code>.
     *   
     *  @default 0
     * 
     *  @see #horizontalScrollPosition
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
    function get verticalScrollPosition():Number;
    function set verticalScrollPosition(value:Number):void;
     */
    
    /**
     *  Returns the amount to add to the viewport's current 
     *  <code>horizontalScrollPosition</code> to scroll by the requested scrolling unit.
     *
     *  @param navigationUnit The amount to scroll. 
     *  The value must be one of the following spark.core.NavigationUnit
     *  constants: 
     *  <ul>
     *   <li><code>LEFT</code></li>
     *   <li><code>RIGHT</code></li>
     *   <li><code>PAGE_LEFT</code></li>
     *   <li><code>PAGE_RIGHT</code></li>
     *   <li><code>HOME</code></li>
     *   <li><code>END</code></li>
     *  </ul>
     *  To scroll by a single column, use <code>LEFT</code> or <code>RIGHT</code>.
     *  To scroll to the first or last column, use <code>HOME</code> or <code>END</code>.
     *
     *  @return The number of pixels to add to <code>horizontalScrollPosition</code>.
     * 
     *  @see spark.core.NavigationUnit
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
    function getHorizontalScrollPositionDelta(navigationUnit:uint):Number;
     */
    
    /**
     *  Returns the amount to add to the viewport's current 
     *  <code>verticalScrollPosition</code> to scroll by the requested scrolling unit.
     *
     *  @param navigationUnit The amount to scroll. 
     *  The value of unit must be one of the following spark.core.NavigationUnit
     *  constants: 
     *  <ul>
     *   <li><code>UP</code></li>
     *   <li><code>DOWN</code></li>
     *   <li><code>PAGE_UP</code></li>
     *   <li><code>PAGE_DOWN</code></li>
     *   <li><code>HOME</code></li>
     *   <li><code>END</code></li>
     *  </ul>
     *  To scroll by a single row use <code>UP</code> or <code>DOWN</code>.
     *  To scroll to the first or last row, use <code>HOME</code> or <code>END</code>.
     *
     *  @return The number of pixels to add to <code>verticalScrollPosition</code>.
     * 
     *  @see spark.core.NavigationUnit
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
    function getVerticalScrollPositionDelta(navigationUnit:uint):Number;
     */
     
    /**
     *  If <code>true</code>, specifies to clip the children to the boundaries of the viewport. 
     *  If <code>false</code>, the container children extend past the container boundaries, 
     *  regardless of the size specification of the component. 
     *  
     *  @default false
     *
     *  @see spark.layouts.supportClasses.LayoutBase#updateScrollRect
     *  @see #verticalScrollPosition
     *  @see #horizontalScrollPosition
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    function get clipAndEnableScrolling():Boolean;
    function set clipAndEnableScrolling(value:Boolean):void;
}

}
