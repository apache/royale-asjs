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

package spark.layouts.supportClasses
{
COMPILE::SWF
{
    import flash.events.Event;
}

import mx.core.Container;
import mx.core.ILayoutElement;
import mx.core.IVisualElement;
import mx.core.UIComponent;
import mx.core.mx_internal;

import spark.components.Group;
import spark.components.supportClasses.GroupBase;
import spark.core.NavigationUnit;
import spark.layouts.HorizontalAlign;
import spark.layouts.VerticalLayout;

import org.apache.royale.core.IStrand;
import org.apache.royale.core.LayoutBase;
import org.apache.royale.core.UIBase;
import org.apache.royale.events.Event;
import org.apache.royale.events.EventDispatcher;
import org.apache.royale.events.IEventDispatcher;
import org.apache.royale.geom.Point;
import org.apache.royale.geom.Rectangle;
import org.apache.royale.utils.PointUtils;

use namespace mx_internal;

/**
 *  The LayoutBase class defines the base class for all Spark layouts.
 *  To create a custom layout that works with the Spark containers,
 *  you must extend <code>LayoutBase</code> or one of its subclasses.
 *
 *  <p>At minimum, subclasses must implement the <code>updateDisplayList()</code>
 *  method, which positions and sizes the <code>target</code> GroupBase's elements, and 
 *  the <code>measure()</code> method, which calculates the default
 *  size of the <code>target</code>.</p>
 *
 *  <p>Subclasses may override methods like <code>getElementBoundsAboveScrollRect()</code>
 *  and <code>getElementBoundsBelowScrollRect()</code> to customize the way 
 *  the target behaves when it's connected to scrollbars.</p>
 * 
 *  <p>Subclasses that support virtualization must respect the 
 *  <code>useVirtualLayout</code> property and should only retrieve
 *  layout elements within the scrollRect (the value of
 *  <code>getScrollRect()</code>) using <code>getVirtualElementAt()</code>
 *  from within <code>updateDisplayList()</code>.</p>
 *
 *  @mxml 
 *  <p>The <code>&lt;s:LayoutBase&gt;</code> tag inherits all of the tag 
 *  attributes of its superclass and adds the following tag attributes:</p>
 *
 *  <pre>
 *  &lt;s:LayoutBase 
 *    <strong>Properties</strong>
 *    clipAndEnableScrolling="false"
 *    dropIndicator="<i>defined by the skin class</i>"
 *    horizontalScrollPosition="0"
 *    target="null"
 *    typicalLayoutElement="null"
 *    useVirtualLayout="false"
 *    verticalScrollPosition="0"
 *  /&gt;
 *  </pre>
 *
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
public class LayoutBase extends org.apache.royale.core.LayoutBase implements IEventDispatcher
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
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */    
    public function LayoutBase()
    {
        super();
    }
    
    override public function set strand(value:IStrand):void
    {
        _target = value as GroupBase;
        super.strand = value;
        
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  target
    //----------------------------------    

    private var _target:GroupBase;
    
    /**
     *  The GroupBase container whose elements are measured, sized and positioned
     *  by this layout.
     * 
     *  <p>Subclasses may override the setter to perform target specific
     *  actions. For example a 3D layout may set the target's
     *  <code>maintainProjectionCenter</code> property here.</p> 
     *
     *  @default null
     *  @see #updateDisplayList()
     *  @see #measure()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get target():GroupBase
    {
        return _target;
    }
    
    /**
     * @private
     */
    public function set target(value:GroupBase):void
    {
        if (_target == value)
            return;
        clearVirtualLayoutCache();
        _target = value;
    }
    
    //----------------------------------
    //  useVirtualLayout
    //----------------------------------

    private var _useVirtualLayout:Boolean = false;

    [Inspectable(defaultValue="false")]

    /**
     *  A container can hold any number of children. 
     *  However, each child requires an instance of an item renderer. 
     *  If the container has many children, you might notice performance degradation 
     *  as you add more children to the container. 
     *
     *  <p>Instead of creating an item renderer for each child, 
     *  you can configure the container to use a virtual layout. 
     *  With virtual layout, the container reuses item renderers so that it only creates 
     *  item renderers for the currently visible children of the container. 
     *  As a child is moved off the screen, possible by scrolling the container, 
     *  a new child being scrolled onto the screen can reuse its item renderer. </p>
     *  
     *  <p>To configure a container to use virtual layout, set the <code>useVirtualLayout</code> property 
     *  to <code>true</code> for the layout associated with the container. 
     *  Only DataGroup or SkinnableDataContainer with layout set to VerticalLayout, 
     *  HorizontalLayout, or TileLayout supports virtual layout. 
     *  Layout subclasses that do not support virtualization must prevent changing
     *  this property.</p>
     *
     *  <p><b>Note: </b>The BasicLayout class throws a run-time error if you set 
     *  <code>useVirtualLayout</code> to <code>true</code>.</p>
     * 
     *  <p>When <code>true</code>, layouts that support virtualization must use 
     *  the <code>target.getVirtualElementAt()</code> method, 
     *  rather than <code>getElementAt()</code>, and must only get the 
     *  elements they anticipate will be visible given the value of <code>getScrollRect()</code>.</p>
     * 
     *  <p>When <code>true</code>, the layout class must be able to compute
     *  the indices of the layout elements that overlap the <code>scrollRect</code> in its 
     *  <code>updateDisplayList()</code> method based exclusively on cached information, not
     *  by getting layout elements and examining their bounds.</p>
     * 
     *  <p>Typically virtual layouts update their cached information 
     *  in the <code>updateDisplayList()</code> method,
     *  based on the sizes and locations computed for the elements in view.</p>
     * 
     *  <p>Similarly, in the <code>measure()</code> method, virtual layouts should update the target's 
     *  measured size properties based on the <code>typicalLayoutElement</code> and other
     *  cached layout information, not by measuring elements.</p>
     * 
     *  <p>Containers cooperate with layouts that have <code>useVirtualLayout</code> = <code>true</code> by 
     *  recycling item renderers that were previously constructed, but are no longer in use.
     *  An item is considered to be no longer in use if its index is not
     *  within the range of <code>getVirtualElementAt()</code> indices requested during
     *  the container's most recent <code>updateDisplayList()</code> invocation.</p>
     *
     *  @default false
     * 
     *  @see #getScrollRect()
     *  @see #typicalLayoutElement
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get useVirtualLayout():Boolean
    {
        return _useVirtualLayout;
    }

    /**
     *  @private
     */
    public function set useVirtualLayout(value:Boolean):void
    {
        if (_useVirtualLayout == value)
            return;

        dispatchEvent(new org.apache.royale.events.Event("useVirtualLayoutChanged"));
        
        if (_useVirtualLayout && !value)  // turning virtual layout off
            clearVirtualLayoutCache();
                     
        _useVirtualLayout = value;
        /*
        if (target)
            target.invalidateDisplayList();
        */
    }
    
    /**
     *  When <code>useVirtualLayout</code> is <code>true</code>, 
     *  this method can be used by the layout target
     *  to clear cached layout information when the target changes.   
     * 
     *  <p>For example, when a DataGroup's <code>dataProvider</code> or 
     *  <code>itemRenderer</code> property changes, cached 
     *  elements sizes become invalid. </p>
     * 
     *  <p>When the <code>useVirtualLayout</code> property changes to <code>false</code>, 
     *  this method is called automatically.</p>
     * 
     *  <p>Subclasses that support <code>useVirtualLayout</code> = <code>true</code> 
     *  must override this method. </p>
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */ 
    public function clearVirtualLayoutCache():void
    {
    }
    
    /**
     *  Specifies whether this layout supports virtual layout.
     *  
     *  @default true
     */ 
    mx_internal function get virtualLayoutSupported():Boolean
    {
        return true;
    }
    
    //----------------------------------
    //  horizontalScrollPosition
    //----------------------------------
        
    private var _horizontalScrollPosition:Number = 0;
    
    [Bindable]
    [Inspectable(category="General", minValue="0.0")]
    
    /**
     *  @copy spark.core.IViewport#horizontalScrollPosition
     *
     *  @default 0
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get horizontalScrollPosition():Number 
    {
        return _horizontalScrollPosition;
    }
    
    /**
     *  @private
     */
    public function set horizontalScrollPosition(value:Number):void 
    {
        if (value == _horizontalScrollPosition) 
            return;
    
        _horizontalScrollPosition = value;
        scrollPositionChanged();
    }
    
    //----------------------------------
    //  verticalScrollPosition
    //----------------------------------

    private var _verticalScrollPosition:Number = 0;
    
    [Bindable]
    [Inspectable(category="General", minValue="0.0")]    
    
    /**
     *  @copy spark.core.IViewport#verticalScrollPosition
     *
     *  @default 0
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get verticalScrollPosition():Number 
    {
        return _verticalScrollPosition;
    }
    
    /**
     *  @private
     */
    public function set verticalScrollPosition(value:Number):void 
    {
        if (value == _verticalScrollPosition)
            return;
            
        _verticalScrollPosition = value;
        scrollPositionChanged();
    }    
    
    //----------------------------------
    //  clipAndEnableScrolling
    //----------------------------------
        
    private var _clipAndEnableScrolling:Boolean = false;
    
    [Inspectable(category="General", enumeration="true,false")]
    
    /**
     *  @copy spark.core.IViewport#clipAndEnableScrolling
     *
     *  @default false
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get clipAndEnableScrolling():Boolean 
    {
        return _clipAndEnableScrolling;
    }
    
    /**
     *  @private
     */
    public function set clipAndEnableScrolling(value:Boolean):void 
    {
        if (value == _clipAndEnableScrolling) 
            return;
    
        _clipAndEnableScrolling = value;
        var g:GroupBase = target;
        if (g)
            updateScrollRect(g.width, g.height);
    }
    
    //----------------------------------
    //  typicalLayoutElement
    //----------------------------------

    private var _typicalLayoutElement:ILayoutElement = null;

    /**
     *  Used by layouts when fixed row/column sizes are requested but
     *  a specific size isn't specified.
     *  Used by virtual layouts to estimate the size of layout elements
     *  that have not been scrolled into view.
     *
     *  <p>This property references a component that Flex uses to 
     *  define the height of all container children, 
     *  as the following example shows:</p>
     * 
     *  <pre>
     *  &lt;s:Group&gt;
     *    &lt;s:layout&gt;
     *      &lt;s:VerticalLayout variableRowHeight="false"
     *          typicalLayoutElement="{b3}"/&gt; 
     *    &lt;/s:layout&gt;
     *    &lt;s:Button id="b1" label="Button 1"/&gt;
     *    &lt;s:Button id="b2" label="Button 2"/&gt;
     *    &lt;s:Button id="b3" label="Button 3" fontSize="36"/&gt;
     *    &lt;s:Button id="b4" label="Button 4" fontSize="24"/&gt;
     *  &lt;/s:Group&gt;</pre>
     * 
     *  <p>If this property has not been set and the target is non-null 
     *  then the target's first layout element is cached and returned.</p>
     * 
     *  <p>The default value is the target's first layout element.</p>
     *
     *  @default null
     *
     *  @see #target
     *  @see spark.layouts.VerticalLayout#variableRowHeight
     *  @see spark.layouts.HorizontalLayout#variableColumnWidth
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get typicalLayoutElement():ILayoutElement
    {
        if (!_typicalLayoutElement && target && (target.numElements > 0))
            _typicalLayoutElement = target.getElementAt(0) as ILayoutElement;
        return _typicalLayoutElement;
    }

    /**
     *  @private
     *  Current implementation limitations:
     * 
     *  The default value of this property may be initialized
     *  lazily to layout element zero.  That means you can't rely on the
     *  set method being called to stay in sync with the property's value.
     * 
     *  If the default value is lazily initialized, it will not be reset if
     *  the target changes.
     */
    public function set typicalLayoutElement(value:ILayoutElement):void
    {
        if (_typicalLayoutElement == value)
            return;

        _typicalLayoutElement = value;
        /*
        var g:GroupBase = target;
        if (g)
            g.invalidateSize();
        */
    }

    //----------------------------------
    //  dropIndicator
    //----------------------------------
    
    /**
     *  @private
     *  Storage property for the drop indicator
     */
    private var _dropIndicator:UIBase;
    
    /**
     *  The <code>DisplayObject</code> that this layout uses for
     *  the drop indicator during a drag-and-drop operation.
     *
     *  Typically you do not set this property directly,
     *  but instead define a <code>dropIndicator</code> skin part in the 
     *  skin class of the drop target.
     * 
     *  <p>The List control sets this property in response to a
     *  <code>DragEvent.DRAG_ENTER</code> event.
     *  The List initializes this property with an
     *  instance of its <code>dropIndicator</code> skin part.
     *  The List clears this property in response to a
     *  <code>DragEvent.DRAG_EXIT</code> event.</p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get dropIndicator():UIBase
    {
        return _dropIndicator;
    }
    
    /**
     *  @private
     */
    public function set dropIndicator(value:UIBase):void
    {
        /*
        if (_dropIndicator)
            target.overlay.removeDisplayObject(_dropIndicator);
        */
        _dropIndicator = value;
        /*
        if (_dropIndicator)
        {
            _dropIndicator.visible = false;
            target.overlay.addDisplayObject(_dropIndicator, OverlayDepth.DROP_INDICATOR);

            if (_dropIndicator is ILayoutManagerClient)
                UIComponentGlobals.layoutManager.validateClient(ILayoutManagerClient(_dropIndicator), true);

            // Set includeInLayout to false, otherwise it'll still invalidate
            // the parent Group layout as we size and position the indicator.
            if (_dropIndicator is ILayoutElement)
                ILayoutElement(_dropIndicator).includeInLayout = false;
        }
        */
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     *  Measures the target's default size based on its content, and optionally
     *  measures the target's default minimum size.
     *
     *  <p>This is one of the methods that you must override when creating a
     *  subclass of LayoutBase. The other method is <code>updateDisplayList()</code>.
     *  You do not call these methods directly. Flex calls this method as part
     *  of a layout pass. A layout pass consists of three phases.</p>
     *
     *  <p>First, if the target's properties are invalid, the LayoutManager calls
     *  the target's <code>commitProperties</code> method.</p>
     *
     *  <p>Second, if the target's size is invalid, LayoutManager calls the target's
     *  <code>validateSize()</code> method. The target's <code>validateSize()</code>
     *  will in turn call the layout's <code>measure()</code> to calculate the
     *  target's default size unless it was explicitly specified by both target's
     *  <code>explicitWidth</code> and <code>explicitHeight</code> properties.
     *  If the default size changes, Flex will invalidate the target's display list.</p>
     *
     *  <p>Last, if the target's display list is invalid, LayoutManager calls the target's
     *  <code>validateDisplayList</code>. The target's <code>validateDisplayList</code>
     *  will in turn call the layout's <code>updateDisplayList</code> method to
     *  size and position the target's elements.</p>
     *
     *  <p>When implementing this method, you must set the target's
     *  <code>measuredWidth</code> and <code>measuredHeight</code> properties
     *  to define the target's default size. You may optionally set the
     *  <code>measuredMinWidth</code> and <code>measuredMinHeight</code>
     *  properties to define the default minimum size.
     *  A typical implementation iterates through the target's elements
     *  and uses the methods defined by the <code>ILayoutElement</code> to
     *  accumulate the preferred and/or minimum sizes of the elements and then sets
     *  the target's <code>measuredWidth</code>, <code>measuredHeight</code>,
     *  <code>measuredMinWidth</code> and <code>measuredMinHeight</code>.</p>
     *
     *  @see #updateDisplayList()
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function measure():void
    {
    }
    
    /**
     *  Sizes and positions the target's elements.
     *
     *  <p>This is one of the methods that you must override when creating a
     *  subclass of LayoutBase. The other method is <code>measure()</code>.
     *  You do not call these methods directly. Flex calls this method as part
     *  of a layout pass. A layout pass consists of three phases.</p>
     *
     *  <p>First, if the target's properties are invalid, the LayoutManager calls
     *  the target's <code>commitProperties</code> method.</p>
     *
     *  <p>Second, if the target's size is invalid, LayoutManager calls the target's
     *  <code>validateSize()</code> method. The target's <code>validateSize()</code>
     *  will in turn call the layout's <code>measure()</code> to calculate the
     *  target's default size unless it was explicitly specified by both target's
     *  <code>explicitWidth</code> and <code>explicitHeight</code> properties.
     *  If the default size changes, Flex will invalidate the target's display list.</p>
     *
     *  <p>Last, if the target's display list is invalid, LayoutManager calls the target's
     *  <code>validateDisplayList</code>. The target's <code>validateDisplayList</code>
     *  will in turn call the layout's <code>updateDisplayList</code> method to
     *  size and position the target's elements.</p>
     *
     *  <p>A typical implementation iterates through the target's elements
     *  and uses the methods defined by the <code>ILayoutElement</code> to
     *  position and resize the elements. Then the layout must also calculate and set
     *  the target's <code>contentWidth</code> and <code>contentHeight</code>
     *  properties to define the target's scrolling region.</p>
     *
     *  @param unscaledWidth Specifies the width of the target, in pixels,
     *  in the targets's coordinates.
     *
     *  @param unscaledHeight Specifies the height of the component, in pixels,
     *  in the target's coordinates.
     *
     *  @see #measure()
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function updateDisplayList(width:Number, height:Number):void
    {
    }          

    /**
     *  Called by the target after a layout element 
     *  has been added and before the target's size and display list are
     *  validated.   
     *  Layouts that cache per element state, like virtual layouts, can 
     *  override this method to update their cache.
     * 
     *  <p>If the target calls this method, it's only guaranteeing that a
     *  a layout element will exist at the specified index at
     *  <code>updateDisplayList()</code> time, for example a DataGroup
     *  with a virtual layout will call this method when an item is added 
     *  to the targets <code>dataProvider</code>.</p>
     * 
     *  <p>By default, this method does nothing.</p>
     * 
     *  @param index The index of the element that was added.
     * 
     *  @see #elementRemoved()    
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
     public function elementAdded(index:int):void
     {
     }

    /**
     *  This method must is called by the target after a layout element 
     *  has been removed and before the target's size and display list are
     *  validated.   
     *  Layouts that cache per element state, like virtual layouts, can 
     *  override this method to update their cache.
     * 
     *  <p>If the target calls this method, it's only guaranteeing that a
     *  a layout element will no longer exist at the specified index at
     *  <code>updateDisplayList()</code> time.
     *  For example, a DataGroup
     *  with a virtual layout calls this method when an item is added to 
     *  the <code>dataProvider</code> property.</p>
     * 
     *  <p>By default, this method does nothing.</p>
     * 
     *  @param index The index of the element that was added.
     *  @see #elementAdded()
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
     public function elementRemoved(index:int):void
     {
     }

    /**
     *  Called when the <code>verticalScrollPosition</code> or 
     *  <code>horizontalScrollPosition</code> properties change.
     *
     *  <p>The default implementation updates the target's <code>scrollRect</code> property by
     *  calling <code>updateScrollRect()</code>.
     *  Subclasses can override this method to compute other values that are
     *  based on the current <code>scrollPosition</code> or <code>scrollRect</code>.</p>
     *
     *  @see #updateScrollRect()
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */  
    protected function scrollPositionChanged():void
    {
        var g:GroupBase = target;
        if (!g)
            return;

        updateScrollRect(g.width, g.height);
    }

    /**
     *  Called by the target at the end of its <code>updateDisplayList</code>
     *  to have the layout update its scrollRect.
     * 
     *  <p>If <code>clipAndEnableScrolling</code> is <code>true</code>, 
     *  the default implementation sets the origin of the target's <code>scrollRect</code> 
     *  to <code>verticalScrollPosition</code>, <code>horizontalScrollPosition</code>.
     *  It sets its size to the <code>width</code>, <code>height</code>
     *  parameters (the target's unscaled width and height).</p>
     * 
     *  <p>If <code>clipAndEnableScrolling</code> is <code>false</code>, 
     *  the default implementation sets the <code>scrollRect</code> to null.</p>
     *  
     *  @param width The target's width.
     *
     *  @param height The target's height.
     * 
     *  @see #target
     *  @see flash.display.DisplayObject#scrollRect
     *  @see #updateDisplayList()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */ 
    public function updateScrollRect(w:Number, h:Number):void
    {
        COMPILE::SWF
        {
        var g:GroupBase = target;
        if (!g)
            return;
            
        if (clipAndEnableScrolling)
        {
            var hsp:Number = horizontalScrollPosition;
            var vsp:Number = verticalScrollPosition;
            g.scrollRect = new Rectangle(hsp, vsp, w, h);
        }
        else
            g.scrollRect = null;
        }
    }
    
    /**
     *  Delegation method that determines which item  
     *  to navigate to based on the current item in focus 
     *  and user input in terms of NavigationUnit. This method
     *  is used by subclasses of ListBase to handle 
     *  keyboard navigation. ListBase maps user input to
     *  NavigationUnit constants.
     * 
     *  <p>Subclasses can override this method to compute other 
     *  values that are based on the current index and key 
     *  stroke encountered. </p>
     * 
     *  @param currentIndex The current index of the item with focus.
     * 
     *  @param navigationUnit The NavigationUnit constant that determines
     *  which item to navigate to next.  
     * 
     *  @param arrowKeysWrapFocus If <code>true</code>, using arrow keys to 
     *  navigate within the component wraps when it hits either end.
     * 
     *  @return The index of the next item to jump to. Returns -1
     *  when if the layout doesn't recognize the navigationUnit.  
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */  
    public function getNavigationDestinationIndex(currentIndex:int, navigationUnit:uint, arrowKeysWrapFocus:Boolean):int
     {
        if (!target || target.numElements < 1)
            return -1; 
            
         //Sub-classes implement according to their own layout 
         //logic. Common cases handled here. 
         switch (navigationUnit)
         {
             case NavigationUnit.HOME:
                 return 0; 

             case NavigationUnit.END:
                 return target.numElements - 1; 

             default:
                 return -1;
         }
     }

    /**
     *  Returns the bounds of the target's scroll rectangle in layout coordinates.
     * 
     *  Layout methods should not get the target's scroll rectangle directly.
     * 
     *  @return The bounds of the target's scrollRect in layout coordinates, null
     *      if target or clipAndEnableScrolling is false. 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    protected function getScrollRect():Rectangle
    {
        var g:GroupBase = target;
        if (!g /*|| !g.clipAndEnableScrolling*/)
            return null;     
        var vsp:Number = g.verticalScrollPosition;
        var hsp:Number = g.horizontalScrollPosition;
        return new Rectangle(hsp, vsp, g.width, g.height);
    }
    
   /**
     *  Returns the specified element's layout bounds as a Rectangle or null
     *  if the index is invalid, the corresponding element is null,
     *  <code>includeInLayout=false</code>, 
     *  or if this layout's <code>target</code> property is null.
     *   
     *  <p>Layout subclasses that support <code>useVirtualLayout=true</code> must
     *  override this method to compute a potentially approximate value for
     *  elements that are not in view.</p>
     * 
     *  @param index Index of the layout element.
     * 
     *  @return The specified element's layout bounds.
     *
     *  @see mx.core.ILayoutElement#getLayoutBoundsX()
     *  @see mx.core.ILayoutElement#getLayoutBoundsY()
     *  @see mx.core.ILayoutElement#getLayoutBoundsWidth()
     *  @see mx.core.ILayoutElement#getLayoutBoundsHeight()
     *   
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function getElementBounds(index:int):Rectangle
    {
        var g:GroupBase = target;
        if (!g)
            return null;

         var n:int = g.numElements;
         if ((index < 0) || (index >= n))
            return null;
            
         var elt:ILayoutElement = g.getElementAt(index) as ILayoutElement;
         if (!elt || !elt.includeInLayout)
             return null;
            
         var eltX:Number = elt.getLayoutBoundsX();
         var eltY:Number = elt.getLayoutBoundsY();
         var eltW:Number = elt.getLayoutBoundsWidth();
         var eltH:Number = elt.getLayoutBoundsHeight();
         return new Rectangle(eltX, eltY, eltW, eltH);
    }
    
    /**
     *  @private 
     *  Given any descendant element of the target, return its bounds in the 
     *  target's coordinate space.
     */ 
    mx_internal function getChildElementBounds(element:IVisualElement):Rectangle
    {
        // use localToContent
        if (!element)
            return new Rectangle(0,0,0,0);
        
        var parentUIC:UIComponent = element.parent as UIComponent;
        
        // Note that we don't check that the element is a descendant of the target
        // since it can be expensive to calculae. 
        if (parentUIC)
        {
            var g:GroupBase = target;
            // Get the position in local coordinate
            var posPointStart:Point = new Point(element.getLayoutBoundsX(), element.getLayoutBoundsY());
            var sizePoint:Point = new Point(element.getLayoutBoundsWidth(), element.getLayoutBoundsHeight());
            
            // Convert from local to global coordinate space
            var posPoint:Point = PointUtils.localToGlobal(posPointStart, parentUIC);
            // Convert from global to target's local coordinate space
            posPoint = PointUtils.globalToLocal(posPoint, g);
                        
            return new Rectangle(posPoint.x, posPoint.y, sizePoint.x, sizePoint.y);
        }
        
        return new Rectangle(0,0,0,0);
    }
    
    /**
     *  @private 
     *  Convert the localBounds of a descendant element into the target's coordinate system
     */ 
    private function convertLocalToTarget(element:IVisualElement, elementLocalBounds:Rectangle):Rectangle
    {
        // use localToContent
        if (!element)
            return new Rectangle(0,0,0,0);
        
        var parentUIC:UIComponent = element.parent as UIComponent;
        
        // Note that we don't check that the element is a descendant of the target
        // since it can be expensive to calculae. 
        if (parentUIC)
        {
            var g:GroupBase = target;
            // Get the position in local coordinate
            var posPointStart:Point = new Point(element.getLayoutBoundsX() + elementLocalBounds.x, 
                                                element.getLayoutBoundsY() + elementLocalBounds.y);
            
            // Convert from local to global coordinate space
            var posPoint:Point = PointUtils.localToGlobal(posPointStart, parentUIC);
            // Convert from global to target's local coordinate space
            posPoint = PointUtils.globalToLocal(posPoint, g);
            
            return new Rectangle(posPoint.x, posPoint.y, elementLocalBounds.width, elementLocalBounds.height);
        }
        
        return new Rectangle(0,0,0,0);
    }
     
    /**
     *  @private
     *  Return true if the specified element's layout bounds fall within the
     *  scrollRect, or if scrollRect is null.
     */
    mx_internal function isElementVisible(elt:ILayoutElement):Boolean
    {
        if (!elt || !elt.includeInLayout)
            return false;
        
        var g:GroupBase = target;
        if (!g/* || !g.clipAndEnableScrolling*/)
            return true; 
        
        const vsp:Number = g.verticalScrollPosition;
        const hsp:Number = g.horizontalScrollPosition;
        const targetW:Number = g.width;
        const targetH:Number = g.height;
        
        const eltX:Number = elt.getLayoutBoundsX();
        const eltY:Number = elt.getLayoutBoundsY();
        const eltW:Number = elt.getLayoutBoundsWidth();
        const eltH:Number = elt.getLayoutBoundsHeight();
        
        return (eltX < (hsp + targetW)) && ((eltX + eltW) > hsp) &&
               (eltY < (vsp + targetH)) && ((eltY + eltH) > vsp);             
    }

    /**
     *  Returns the bounds of the first layout element that either spans or
     *  is to the left of the scrollRect's left edge.
     * 
     *  <p>This is a convenience method that is used by the default
     *  implementation of the <code>getHorizontalScrollPositionDelta()</code> method.
     *  Subclasses that rely on the default implementation of
     *  <code>getHorizontalScrollPositionDelta()</code> should override this method to
     *  provide an accurate bounding rectangle that has valid <code>left</code> and 
     *  <code>right</code> properties.</p>
     * 
     *  <p>By default this method returns a Rectangle with width=1, height=0, 
     *  whose left edge is one less than the left edge of the <code>scrollRect</code>, 
     *  and top=0.</p>
     * 
     *  @param scrollRect The target's scrollRect.
     *
     *  @return The bounds of the first element that spans or is to
     *  the left of the scrollRect's left edge.
     *  
     *  @see #getElementBoundsRightOfScrollRect()
     *  @see #getElementBoundsAboveScrollRect()
     *  @see #getElementBoundsBelowScrollRect()
     *  @see #getHorizontalScrollPositionDelta()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    protected function getElementBoundsLeftOfScrollRect(scrollRect:Rectangle):Rectangle
    {
        var bounds:Rectangle = new Rectangle();
        bounds.left = scrollRect.left - 1;
        bounds.right = scrollRect.left; 
        return bounds;
    } 

    /**
     *  Returns the bounds of the first layout element that either spans or
     *  is to the right of the scrollRect's right edge.
     * 
     *  <p>This is a convenience method that is used by the default
     *  implementation of the <code>getHorizontalScrollPositionDelta()</code> method.
     *  Subclasses that rely on the default implementation of
     *  <code>getHorizontalScrollPositionDelta()</code> should override this method to
     *  provide an accurate bounding rectangle that has valid <code>left</code> and 
     *  <code>right</code> properties.</p>
     * 
     *  <p>By default this method returns a Rectangle with width=1, height=0, 
     *  whose right edge is one more than the right edge of the <code>scrollRect</code>, 
     *  and top=0.</p>
     * 
     *  @param scrollRect The target's scrollRect.
     *
     *  @return The bounds of the first element that spans or is to
     *  the right of the scrollRect's right edge.
     *  
     *  @see #getElementBoundsLeftOfScrollRect()
     *  @see #getElementBoundsAboveScrollRect()
     *  @see #getElementBoundsBelowScrollRect()
     *  @see #getHorizontalScrollPositionDelta()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    protected function getElementBoundsRightOfScrollRect(scrollRect:Rectangle):Rectangle
    {
        var bounds:Rectangle = new Rectangle();
        bounds.left = scrollRect.right;
        bounds.right = scrollRect.right + 1;
        return bounds;
    } 

    /**
     *  Returns the bounds of the first layout element that either spans or
     *  is above the scrollRect's top edge.
     * 
     *  <p>This is a convenience method that is used by the default
     *  implementation of the <code>getVerticalScrollPositionDelta()</code> method.
     *  Subclasses that rely on the default implementation of
     *  <code>getVerticalScrollPositionDelta()</code> should override this method to
     *  provide an accurate bounding rectangle that has valid <code>top</code> and 
     *  <code>bottom</code> properties.</p>
     * 
     *  <p>By default this method returns a Rectangle with width=0, height=1, 
     *  whose top edge is one less than the top edge of the <code>scrollRect</code>, 
     *  and left=0.</p>
     * 
     *  <p>Subclasses should override this method to provide an accurate
     *  bounding rectangle that has valid <code>top</code> and 
     *  <code>bottom</code> properties.</p>
     * 
     *  @param scrollRect The target's scrollRect.
     *
     *  @return The bounds of the first element that spans or is
     *  above the scrollRect's top edge.
     *  
     *  @see #getElementBoundsLeftOfScrollRect()
     *  @see #getElementBoundsRightOfScrollRect()
     *  @see #getElementBoundsBelowScrollRect()
     *  @see #getVerticalScrollPositionDelta()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    protected function getElementBoundsAboveScrollRect(scrollRect:Rectangle):Rectangle
    {
        var bounds:Rectangle = new Rectangle();
        bounds.top = scrollRect.top - 1;
        bounds.bottom = scrollRect.top;
        return bounds;
    } 

    /**
     *  Returns the bounds of the first layout element that either spans or
     *  is below the scrollRect's bottom edge.
     *
     *  <p>This is a convenience method that is used by the default
     *  implementation of the <code>getVerticalScrollPositionDelta()</code> method.
     *  Subclasses that rely on the default implementation of
     *  <code>getVerticalScrollPositionDelta()</code> should override this method to
     *  provide an accurate bounding rectangle that has valid <code>top</code> and 
     *  <code>bottom</code> properties.</p>
     *
     *  <p>By default this method returns a Rectangle with width=0, height=1, 
     *  whose bottom edge is one more than the bottom edge of the <code>scrollRect</code>, 
     *  and left=0.</p>
     *
     *  @param scrollRect The target's scrollRect.
     *
     *  @return The bounds of the first element that spans or is
     *  below the scrollRect's bottom edge.
     *
     *  @see #getElementBoundsLeftOfScrollRect()
     *  @see #getElementBoundsRightOfScrollRect()
     *  @see #getElementBoundsAboveScrollRect()
     *  @see #getVerticalScrollPositionDelta()
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    protected function getElementBoundsBelowScrollRect(scrollRect:Rectangle):Rectangle
    {
        var bounds:Rectangle = new Rectangle();
        bounds.top = scrollRect.bottom;
        bounds.bottom = scrollRect.bottom + 1;
        return bounds;
    }

    /**
     *  Returns the change to the horizontal scroll position to handle 
     *  different scrolling options. 
     *  These options are defined by the NavigationUnit class: <code>END</code>, <code>HOME</code>, 
     *  <code>LEFT</code>, <code>PAGE_LEFT</code>, <code>PAGE_RIGHT</code>, and <code>RIGHT</code>. 
     *      
     *  @param navigationUnit Takes the following values: 
     *  <ul>
     *  <li> 
     *  <code>END</code>
     *  Returns scroll delta that will right justify the scrollRect
     *  to the content area.
     *  </li>
     *  
     *  <li> 
     *  <code>HOME</code>
     *  Returns scroll delta that will left justify the scrollRect
     *  to the content area.
     *  </li>
     * 
     *  <li> 
     *  <code>LEFT</code>
     *  Returns scroll delta that will left justify the scrollRect
     *  with the first element that spans or is to the left of the
     *  scrollRect's left edge.
     *  </li>
     * 
     *  <li>
     *  <code>PAGE_LEFT</code>
     *  Returns scroll delta that will right justify the scrollRect
     *  with the first element that spans or is to the left of the
     *  scrollRect's left edge.
     *  </li>
     * 
     *  <li> 
     *  <code>PAGE_RIGHT</code>
     *  Returns scroll delta that will left justify the scrollRect
     *  with the first element that spans or is to the right of the
     *  scrollRect's right edge.
     *  </li>
     * 
     *  <li> 
     *  <code>RIGHT</code>
     *  Returns scroll delta that will right justify the scrollRect
     *  with the first element that spans or is to the right of the
     *  scrollRect's right edge.
     *  </li>
     *
     *  </ul>
     * 
     *  <p>The implementation calls <code>getElementBoundsLeftOfScrollRect()</code> and
     *  <code>getElementBoundsRightOfScrollRect()</code> to determine the bounds of
     *  the elements.  Layout classes usually override those methods instead of
     *  the <code>getHorizontalScrollPositionDelta()</code> method.</p>
     *
     *  @return The change to the horizontal scroll position.
     * 
     *  @see spark.core.NavigationUnit
     *  @see #getElementBoundsLeftOfScrollRect()
     *  @see #getElementBoundsRightOfScrollRect()
     *  @see #getHorizontalScrollPositionDelta()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function getHorizontalScrollPositionDelta(navigationUnit:uint):Number
    {
        var g:GroupBase = target;
        if (!g)
            return 0;     

        var scrollRect:Rectangle = getScrollRect();
        if (!scrollRect)
            return 0;
            
        // Special case: if the scrollRect's origin is 0,0 and it's bigger 
        // than the target, then there's no where to scroll to
        if ((scrollRect.x == 0) && (scrollRect.width >= g.contentWidth))
            return 0;  

        // maxDelta is the horizontalScrollPosition delta required 
        // to scroll to the END and minDelta scrolls to HOME. 
        var maxDelta:Number = g.contentWidth - scrollRect.right;
        var minDelta:Number = -scrollRect.left;
        var getElementBounds:Rectangle;
        switch(navigationUnit)
        {
            case NavigationUnit.LEFT:
            case NavigationUnit.PAGE_LEFT:
                // Find the bounds of the first non-fully visible element
                // to the left of the scrollRect.
                getElementBounds = getElementBoundsLeftOfScrollRect(scrollRect);
                break;

            case NavigationUnit.RIGHT:
            case NavigationUnit.PAGE_RIGHT:
                // Find the bounds of the first non-fully visible element
                // to the right of the scrollRect.
                getElementBounds = getElementBoundsRightOfScrollRect(scrollRect);
                break;

            case NavigationUnit.HOME: 
                return minDelta;
                
            case NavigationUnit.END: 
                return maxDelta;
                
            default:
                return 0;
        }
        
        if (!getElementBounds)
            return 0;

        var delta:Number = 0;
        switch (navigationUnit)
        {
            case NavigationUnit.LEFT:
                // Snap the left edge of element to the left edge of the scrollRect.
                // The element is the the first non-fully visible element left of the scrollRect.
                delta = Math.max(getElementBounds.left - scrollRect.left, -scrollRect.width);
            break;    
            case NavigationUnit.RIGHT:
                // Snap the right edge of the element to the right edge of the scrollRect.
                // The element is the the first non-fully visible element right of the scrollRect.
                delta = Math.min(getElementBounds.right - scrollRect.right, scrollRect.width);
            break;    
            case NavigationUnit.PAGE_LEFT:
            {
                // Snap the right edge of the element to the right edge of the scrollRect.
                // The element is the the first non-fully visible element left of the scrollRect. 
                delta = getElementBounds.right - scrollRect.right;
                
                // Special case: when an element is wider than the scrollRect,
                // we want to snap its left edge to the left edge of the scrollRect.
                // The delta will be limited to the width of the scrollRect further below.
                if (delta >= 0)
                    delta = Math.max(getElementBounds.left - scrollRect.left, -scrollRect.width);  
            }
            break;
            case NavigationUnit.PAGE_RIGHT:
            {
                // Align the left edge of the element to the left edge of the scrollRect.
                // The element is the the first non-fully visible element right of the scrollRect.
                delta = getElementBounds.left - scrollRect.left;
                
                // Special case: when an element is wider than the scrollRect,
                // we want to snap its right edge to the right edge of the scrollRect.
                // The delta will be limited to the width of the scrollRect further below.
                if (delta <= 0)
                    delta = Math.min(getElementBounds.right - scrollRect.right, scrollRect.width);
            }
            break;
        }

        // Makse sure we don't get out of bounds. Also, don't scroll 
        // by more than the scrollRect width at a time.
        return Math.min(maxDelta, Math.max(minDelta, delta));
    }
    
    /**
     *  Returns the change to the vertical scroll position to handle 
     *  different scrolling options. 
     *  These options are defined by the NavigationUnit class:
     *  <code>DOWN</code>,  <code>END</code>, <code>HOME</code>, 
     *  <code>PAGE_DOWN</code>, <code>PAGE_UP</code>, and <code>UP</code>. 
     * 
     *  @param navigationUnit Takes the following values: 
     *  <ul>
     *  <li> 
     *  <code>DOWN</code>
     *  Returns scroll delta that will bottom justify the scrollRect
     *  with the first element that spans or is below the scrollRect's
     *  bottom edge.
     *  </li>
     * 
     *  <li> 
     *  <code>END</code>
     *  Returns scroll delta that will bottom justify the scrollRect
     *  to the content area.
     *  </li>
     *  
     *  <li> 
     *  <code>HOME</code>
     *  Returns scroll delta that will top justify the scrollRect
     *  to the content area.
     *  </li>
     * 
     *  <li> 
     *  <code>PAGE_DOWN</code>
     *  Returns scroll delta that will top justify the scrollRect
     *  with the first element that spans or is below the scrollRect's
     *  bottom edge.
     *  </li>
     * 
     *  <code>PAGE_UP</code>
     *  <li>
     *  Returns scroll delta that will bottom justify the scrollRect
     *  with the first element that spans or is above the scrollRect's
     *  top edge.
     *  </li>
     *
     *  <li> 
     *  <code>UP</code>
     *  Returns scroll delta that will top justify the scrollRect
     *  with the first element that spans or is above the scrollRect's
     *  top edge.
     *  </li>
     *
     *  </ul>
     * 
     *  <p>The implementation calls <code>getElementBoundsAboveScrollRect()</code> and
     *  <code>getElementBoundsBelowScrollRect()</code> to determine the bounds of
     *  the elements. Layout classes usually override those methods instead of
     *  the <code>getVerticalScrollPositionDelta()</code> method. </p>
     *
     *  @return The change to the vertical scroll position.
     * 
     *  @see spark.core.NavigationUnit
     *  @see #getElementBoundsAboveScrollRect()
     *  @see #getElementBoundsBelowScrollRect()
     *  @see #getVerticalScrollPositionDelta()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function getVerticalScrollPositionDelta(navigationUnit:uint):Number
    {
        var g:GroupBase = target;
        if (!g)
            return 0;     

        var scrollRect:Rectangle = getScrollRect();
        if (!scrollRect)
            return 0;
            
        // Special case: if the scrollRect's origin is 0,0 and it's bigger 
        // than the target, then there's no where to scroll to
        if ((scrollRect.y == 0) && (scrollRect.height >= g.contentHeight))
            return 0;  
            
        // maxDelta is the horizontalScrollPosition delta required 
        // to scroll to the END and minDelta scrolls to HOME. 
        var maxDelta:Number = g.contentHeight - scrollRect.bottom;
        var minDelta:Number = -scrollRect.top;
        var getElementBounds:Rectangle;
        switch(navigationUnit)
        {
            case NavigationUnit.UP:
            case NavigationUnit.PAGE_UP:
                // Find the bounds of the first non-fully visible element
                // that spans right of the scrollRect.
                getElementBounds = getElementBoundsAboveScrollRect(scrollRect);
                break;

            case NavigationUnit.DOWN:
            case NavigationUnit.PAGE_DOWN:
                // Find the bounds of the first non-fully visible element
                // that spans below the scrollRect.
                getElementBounds = getElementBoundsBelowScrollRect(scrollRect);
                break;

            case NavigationUnit.HOME: 
                return minDelta;

            case NavigationUnit.END: 
                return maxDelta;

            default:
                return 0;
        }
        
        if (!getElementBounds)
            return 0;

        var delta:Number = 0;
        switch (navigationUnit)
        {
            case NavigationUnit.UP:
                // Snap the top edge of element to the top edge of the scrollRect.
                // The element is the the first non-fully visible element above the scrollRect.
                delta = Math.max(getElementBounds.top - scrollRect.top, -scrollRect.height);
            break;    
            case NavigationUnit.DOWN:
                // Snap the bottom edge of the element to the bottom edge of the scrollRect.
                // The element is the the first non-fully visible element below the scrollRect.
                delta = Math.min(getElementBounds.bottom - scrollRect.bottom, scrollRect.height);
            break;    
            case NavigationUnit.PAGE_UP:
            {
                // Snap the bottom edge of the element to the bottom edge of the scrollRect.
                // The element is the the first non-fully visible element below the scrollRect. 
                delta = getElementBounds.bottom - scrollRect.bottom;
                
                // Special case: when an element is taller than the scrollRect,
                // we want to snap its top edge to the top edge of the scrollRect.
                // The delta will be limited to the height of the scrollRect further below.
                if (delta >= 0)
                    delta = Math.max(getElementBounds.top - scrollRect.top, -scrollRect.height);  
            }
            break;
            case NavigationUnit.PAGE_DOWN:
            {
                // Align the top edge of the element to the top edge of the scrollRect.
                // The element is the the first non-fully visible element below the scrollRect.
                delta = getElementBounds.top - scrollRect.top;
                
                // Special case: when an element is taller than the scrollRect,
                // we want to snap its bottom edge to the bottom edge of the scrollRect.
                // The delta will be limited to the height of the scrollRect further below.
                if (delta <= 0)
                    delta = Math.min(getElementBounds.bottom - scrollRect.bottom, scrollRect.height);
            }
            break;
        }

        return Math.min(maxDelta, Math.max(minDelta, delta));
    }
    
   /**
    *  Computes the <code>verticalScrollPosition</code> and 
    *  <code>horizontalScrollPosition</code> deltas needed to 
    *  scroll the element at the specified index into view.
    * 
    *  <p>This method attempts to minimize the change to <code>verticalScrollPosition</code>
    *  and <code>horizontalScrollPosition</code>.</p>
    * 
    *  <p>If <code>clipAndEnableScrolling</code> is <code>true</code> 
    *  and the element at the specified index is not
    *  entirely visible relative to the target's scroll rectangle, then 
    *  return the delta to be added to <code>horizontalScrollPosition</code> and
    *  <code>verticalScrollPosition</code> that scrolls the element completely 
    *  within the scroll rectangle's bounds.</p>
    * 
    *  @param index The index of the element to be scrolled into view.
    *
    *  @return A Point that contains offsets to horizontalScrollPosition 
    *      and verticalScrollPosition that will scroll the specified
    *      element into view, or null if no change is needed. 
    *      If the specified element is partially visible and larger than the
    *      scroll rectangle, meaning it is already the only element visible, then
    *      return null.
    *      If the specified index is invalid, or target is null, then
    *      return null.
    *      If the element at the specified index is null or includeInLayout
    *      false, then return null.
    * 
    *  @see #clipAndEnableScrolling
    *  @see #verticalScrollPosition
    *  @see #horizontalScrollPosition
    *  @see #updateScrollRect()
    *  
    *  @langversion 3.0
    *  @playerversion Flash 10
    *  @playerversion AIR 1.5
    *  @productversion Flex 4
    */
    public function getScrollPositionDeltaToElement(index:int):Point
    {
        return getScrollPositionDeltaToElementHelper(index);
    }
    
    
    /**
     *  @private 
     *  For the offset properties, a value of NaN means don't offset from that edge. A value
     *  of 0 means to put the element flush against that edge.
     * 
     *  @param topOffset Number of pixels to position the element below the top edge.
     *  @param bottomOffset Number of pixels to position the element above the bottom edge.
     *  @param leftOffset Number of pixels to position the element to the right of the left edge.
     *  @param rightOffset Number of pixels to position the element to the left of the right edge.
     */ 
    mx_internal function getScrollPositionDeltaToElementHelper(index:int, 
                                                               topOffset:Number = NaN, 
                                                               bottomOffset:Number = NaN, 
                                                               leftOffset:Number = NaN,
                                                               rightOffset:Number = NaN):Point
    {
        var elementR:Rectangle = getElementBounds(index);
        return getScrollPositionDeltaToElementHelperHelper(
                                                elementR, null, true,
                                                topOffset, bottomOffset, 
                                                leftOffset, rightOffset);
    }
    
    /**
     *  @private 
     *  This takes an element rather than an index so it can be used for
     *  DataGrid which has rows and columns.
     * 
     *  For the offset properties, a value of NaN means don't offset from that edge. A value
     *  of 0 means to put the element flush against that edge.
     * 
     *  @param elementR The bounds of the element to position
     *  @param elementLocalBounds The bounds inside of the element to position
     *  @param entireElementVisible If true, position the entire element in the viewable area
     *  @param topOffset Number of pixels to position the element below the top edge.
     *  @param bottomOffset Number of pixels to position the element above the bottom edge.
     *  @param leftOffset Number of pixels to position the element to the right of the left edge.
     *  @param rightOffset Number of pixels to position the element to the left of the right edge.
     */ 
    protected function getScrollPositionDeltaToElementHelperHelper(
                                    elementR:Rectangle,
                                    elementLocalBounds:Rectangle,
                                    entireElementVisible:Boolean = true,
                                    topOffset:Number = NaN, 
                                    bottomOffset:Number = NaN, 
                                    leftOffset:Number = NaN,
                                    rightOffset:Number = NaN):Point
    {
        if (!elementR)
            return null;
        
        var scrollR:Rectangle = getScrollRect();
        if (!scrollR /*|| !target.clipAndEnableScrolling*/)
            return null;
        
        if (isNaN(topOffset) && isNaN(bottomOffset) && isNaN(leftOffset) && isNaN(rightOffset) &&
            (scrollR.containsRect(elementR) || (!elementLocalBounds && elementR.containsRect(scrollR))))
            return null;
        
        var dx:Number = 0;
        var dy:Number = 0;
        
        if (entireElementVisible)
        {
            var dxl:Number = elementR.left - scrollR.left;     // left justify element
            var dxr:Number = elementR.right - scrollR.right;   // right justify element
            var dyt:Number = elementR.top - scrollR.top;       // top justify element
            var dyb:Number = elementR.bottom - scrollR.bottom; // bottom justify element
            
            // minimize the scroll
            dx = (Math.abs(dxl) < Math.abs(dxr)) ? dxl : dxr;
            dy = (Math.abs(dyt) < Math.abs(dyb)) ? dyt : dyb;
            
            if (!isNaN(topOffset))
                dy = dyt + topOffset;
            else if (!isNaN(bottomOffset))
                dy = dyb - bottomOffset;
            
            if (!isNaN(leftOffset))
                dx = dxl + leftOffset;
            else if (!isNaN(rightOffset))
                dx = dxr - rightOffset;
            
            // scrollR "contains"  elementR in just one dimension
            if ((elementR.left >= scrollR.left) && (elementR.right <= scrollR.right))
                dx = 0;
            else if ((elementR.bottom <= scrollR.bottom) && (elementR.top >= scrollR.top))
                dy = 0;
            
            // elementR "contains" scrollR in just one dimension
            if ((elementR.left <= scrollR.left) && (elementR.right >= scrollR.right))
                dx = 0;
            else if ((elementR.bottom >= scrollR.bottom) && (elementR.top <= scrollR.top))
                dy = 0;
        }
        
        if (elementLocalBounds)
        {
            // Only adjust for local bounds if the element is wider than the scroll width
            if (elementR.width > scrollR.width || !entireElementVisible)
            {
                if (elementLocalBounds.left < scrollR.left)
                    dx = elementLocalBounds.left - scrollR.left;
                else if (elementLocalBounds.right > scrollR.right)
                    dx = elementLocalBounds.right - scrollR.right;
            }
            
            // Only adjust for local bounds if the element is taller than the scroll height
            if (elementR.height > scrollR.height || !entireElementVisible)
            {
                if (elementLocalBounds.bottom > scrollR.bottom) 
                    dy = elementLocalBounds.bottom - scrollR.bottom;
                else if (elementLocalBounds.top <= scrollR.top)
                    dy = elementLocalBounds.top - scrollR.top;
            }
        }
        
        return new Point(dx, dy);
    }
    
    /**
     *  @private
     */  
    mx_internal function getScrollPositionDeltaToAnyElement(element:IVisualElement, 
                                                            elementLocalBounds:Rectangle = null, 
                                                            entireElementVisible:Boolean = true,
                                                            topOffset:Number = NaN,
                                                            bottomOffset:Number = NaN,
                                                            leftOffset:Number = NaN,
                                                            rightOffset:Number = NaN):Point
    {
        
        var elementR:Rectangle = getChildElementBounds(element);
        
        if (elementLocalBounds)
            elementLocalBounds = convertLocalToTarget(element, elementLocalBounds);
        return getScrollPositionDeltaToElementHelperHelper(
            elementR, elementLocalBounds, entireElementVisible,
            topOffset, bottomOffset, 
            leftOffset, rightOffset);
        
    }
    
    /**
     *  @private
     * 
     *  Given an x\y position and a compare point 
     *  (topLeft/topRight/bottomRight/bottomLeft/center), returns the element 
     *  who's compare point is closest to the position. 
     *  For example, the position might be in the bounds of element A, but 
     *  closer to the topLeft corner of element B than to the topLeft corner 
     *  of element A. 
     *  In which case, this function would return the index for element B. 
     */
    mx_internal function getElementNearestScrollPosition(
        position:Point,
        elementComparePoint:String = "center"):int
    {
        var num:int = target.numElements;
        var minDistance:Number = Number.MAX_VALUE;
        var minDistanceElement:int = -1;
        var i:int;
        var rect:Rectangle;
        var dist:int;
        
        // This base implementation uses brute force:  the compare point of every existing 
        // element is compared to the position and the closest one wins.  Most derived layout
        // classes will have a better mechanism for finding the closest element without
        // a linear search like this.
        // TODO (eday) - possible performance optimization: Pull the switch statement out of the 
        // loop and have a separate loop for each case.  
        for (i = 0; i < num; i++)
        {
            rect = getElementBounds(i);
            
            // Allow for rect being null, as numElements may be 
            // non-zero when the actual items haven't been added yet.
            if (rect != null)
            {
                var elementPoint:Point = null;
                switch (elementComparePoint)
                {
                    case "topLeft":
                        elementPoint = rect.topLeft;
                        break;
                    case "bottomRight":
                        elementPoint = rect.bottomRight;
                        break;
                    case "bottomLeft":
                        elementPoint = new Point(rect.left, rect.bottom);
                        break;
                    case "topRight":
                        elementPoint = new Point(rect.right, rect.top);
                        break;
                    case "center":
                        elementPoint = new Point(rect.left + rect.width/2, rect.top + rect.height/2);
                        break;
                }
                
                dist = Point.distance(position, elementPoint); 
                if (dist < minDistance)
                {
                    minDistance = dist;
                    minDistanceElement = i;
                }
            }
        }
        return minDistanceElement;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Drop methods
    //
    //--------------------------------------------------------------------------

    //private var _dragScrollTimer:Timer;
    private var _dragScrollDelta:Point;
    //private var _dragScrollEvent:DragEvent;
    mx_internal var dragScrollRegionSizeHorizontal:Number = 20;
    mx_internal var dragScrollRegionSizeVertical:Number = 20;
    mx_internal var dragScrollSpeed:Number = 5;
    mx_internal var dragScrollInitialDelay:int = 250;
    mx_internal var dragScrollInterval:int = 32;
    mx_internal var dragScrollHidesIndicator:Boolean = false;
    
    /**
     *  Calculates the drop location in the data provider of the drop target for
     *  the specified <code>dragEvent</code>.
     *
     *  @param dragEvent The drag event dispatched by the DragManager.
     *
     *  @return Returns the drop location for this event, or null if the drop 
     *  operation is not available.
     * 
     *  @see #showDropIndicator()
     *  @see #hideDropIndicator()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
    public function calculateDropLocation(dragEvent:DragEvent):DropLocation
    {
        // Find the drop index
        var dropPoint:Point = globalToLocal(dragEvent.stageX, dragEvent.stageY);
        var dropIndex:int = calculateDropIndex(dropPoint.x, dropPoint.y);
        if (dropIndex == -1)
            return null;
        
        // Create and fill the drop location info
        var dropLocation:DropLocation = new DropLocation();
        dropLocation.dragEvent = dragEvent;
        dropLocation.dropPoint = dropPoint;
        dropLocation.dropIndex = dropIndex;
        return dropLocation;
    }
     */
    
    /**
     *  Sizes, positions and parents the drop indicator based on the specified
     *  drop location. Use the <code>calculateDropLocation()</code> method
     *  to obtain the DropLocation object.
     *
     *  <p>Starts/stops drag-scrolling when necessary conditions are met.</p>
     * 
     *  @param dropLocation Specifies the location where to show the drop indicator.
     *  Drop location is obtained through the <code>computeDropLocation()</code> method.
     *
     *  @see #dropIndicator 
     *  @see #hideDropIndicator()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function showDropIndicator(dropLocation:DropLocation):void
    {
        if (!_dropIndicator)
            return;

        // Make the drop indicator invisible, we'll make it visible 
        // only if successfully sized and positioned
        _dropIndicator.visible = false;

        /*
        // Check for drag scrolling
        var dragScrollElapsedTime:int = 0;
        if (_dragScrollTimer)
            dragScrollElapsedTime = _dragScrollTimer.currentCount * _dragScrollTimer.delay;
        _dragScrollDelta = calculateDragScrollDelta(dropLocation,
                                                    dragScrollElapsedTime);
        if (_dragScrollDelta)
        {
            // Update the drag-scroll event
            _dragScrollEvent = dropLocation.dragEvent;

            if (!dragScrollingInProgress())
            {
                // Creates a timer, immediately updates the scroll position
                // based on _dragScrollDelta and redispatches the event.
                startDragScrolling();
                return;
            }
            else
            {
                if (dragScrollHidesIndicator)
                    return;
            }
        }
        else
            stopDragScrolling();
        */

        // Show the drop indicator
        var bounds:Rectangle = calculateDropIndicatorBounds(dropLocation);
        if (!bounds)
            return;
        
        if (_dropIndicator is ILayoutElement)
        {
            var element:ILayoutElement = ILayoutElement(_dropIndicator);
            element.setLayoutBoundsSize(bounds.width, bounds.height);
            element.setLayoutBoundsPosition(bounds.x, bounds.y);
        }
        else
        {
            _dropIndicator.width = bounds.width;
            _dropIndicator.height = bounds.height;
            _dropIndicator.x = bounds.x;
            _dropIndicator.y = bounds.y;
        }
            
        _dropIndicator.visible = true;
    }
    
    /**
     *  Hides the previously shown drop indicator, 
     *  created by the <code>showDropIndicator()</code> method,
     *  removes it from the display list and also stops the drag scrolling.
     *
     *  @see #showDropIndicator()
     *  @see #dropIndicator
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function hideDropIndicator():void
    {
        //stopDragScrolling();
        if (_dropIndicator)
            _dropIndicator.visible = false;
    }

    /**
     *  Returns the index where a new item should be inserted if
     *  the user releases the mouse at the specified coordinates
     *  while completing a drag and drop gesture.
     * 
     *  Called by the <code>calculatedDropLocation()</code> method.
     *
     *  @param x The x coordinate of the drag and drop gesture, in 
     *  local coordinates.
     * 
     *  @param y The y coordinate of the drag and drop gesture, in  
     *  the drop target's local coordinates.
     *
     *  @return The drop index or -1 if the drop operation is not available
     *  at the specified coordinates.
     * 
     *  @see #calculateDropLocation()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    protected function calculateDropIndex(x:Number, y:Number):int
    {
        // Always add to the end by default.
        return target.numElements;
    }
    
    /**
     *  Calculates the bounds for the drop indicator that provides visual feedback
     *  to the user of where the items will be inserted at the end of a drag and drop
     *  gesture.
     * 
     *  Called by the <code>showDropIndicator()</code> method.
     * 
     *  @param dropLocation A valid DropLocation object previously returned 
     *  by the <code>calculateDropLocation()</code> method.
     * 
     *  @return The bounds for the drop indicator or null.
     * 
     *  @see spark.layouts.supportClasses.DropLocation
     *  @see #calculateDropIndex()
     *  @see #calculateDragScrollDelta()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    protected function calculateDropIndicatorBounds(dropLocation:DropLocation):Rectangle
    {
        return null;
    }
    
    /**
     *  Calculates how much to scroll for the specified <code>dropLocation</code>
     *  during a drag and drop gesture.
     *
     *  Called by the <code>showDropIndicator()</code> method to calculate the scroll 
     *  during drag-scrolling.
     *
     *  @param context A valid DropLocation object previously obtained
     *  by calling the <code>calculateDropLocation()</code> method.
     *
     *  @param elapsedTime The duration, in milliseconds, since the drag scrolling start.
     *
     *  @return How much to drag scroll, or null if drag-scrolling is not needed.
     *
     *  @see spark.layouts.supportClasses.DropLocation 
     *  @see #calculateDropIndex()
     *  @see #calculateDropIndicatorBounds()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
    protected function calculateDragScrollDelta(dropLocation:DropLocation, elapsedTime:Number):Point
    {
        var layoutTarget:GroupBase = target;
        if (layoutTarget.numElements == 0)
            return null;
        
        var scrollRect:Rectangle = getScrollRect();
        if (!scrollRect)
            return null;

        // Make sure that the drag-scrolling regions don't overlap 
        var x:Number = dropLocation.dropPoint.x;
        var y:Number = dropLocation.dropPoint.y;
        
        var horizontalRegionSize:Number = Math.min(dragScrollRegionSizeHorizontal, layoutTarget.width/2);
        var verticalRegionSize:Number = Math.min(dragScrollRegionSizeVertical, layoutTarget.height/2);
        // Return early if the mouse is outside of the drag-scroll region.
        if (scrollRect.left + horizontalRegionSize < x && x < scrollRect.right - horizontalRegionSize &&
            scrollRect.top + verticalRegionSize < y && y < scrollRect.bottom - verticalRegionSize )
            return null;
        
        if (elapsedTime < dragScrollInitialDelay)
            return new Point(); // Return zero point to continue firing events, but not actually scroll.
        elapsedTime -= dragScrollInitialDelay;

        // Speedup based on time elapsed
        var timeSpeedUp:Number = Math.min(elapsedTime, 2000) / 2000;
        timeSpeedUp *= 3;
        timeSpeedUp += 1;
        timeSpeedUp *= timeSpeedUp * dragScrollSpeed * dragScrollInterval / 50;

        var minDeltaX:Number = -scrollRect.left;
        var minDeltaY:Number = -scrollRect.top;
        var maxDeltaY:Number = target.contentHeight - scrollRect.bottom;
        var maxDeltaX:Number = target.contentWidth - scrollRect.right;
        
        var deltaX:Number = 0;
        var deltaY:Number = 0;
        
        if (minDeltaX != 0 && x - scrollRect.left < horizontalRegionSize)
        {
            // Scroll left
            deltaX = 1 - (x - scrollRect.left) / horizontalRegionSize;
            deltaX *=  deltaX * timeSpeedUp;
            deltaX = -Math.round(deltaX) - 1;
        }
        else  if (maxDeltaX != 0 && scrollRect.right - x < horizontalRegionSize)
        {
            // Scroll right
            deltaX = 1 - (scrollRect.right - x) / horizontalRegionSize;
            deltaX *= deltaX * timeSpeedUp;
            deltaX = Math.round(deltaX) + 1;
        }
        
        if (minDeltaY != 0 && y - scrollRect.top < verticalRegionSize)
        {
            // Scroll up
            deltaY = 1 - (y - scrollRect.top) / verticalRegionSize;
            deltaY *=  deltaY * timeSpeedUp;
            deltaY = -Math.round(deltaY) - 1;
        }
        else  if (maxDeltaY != 0 && scrollRect.bottom - y < verticalRegionSize)
        {
            // Scroll down
            deltaY = 1 - (scrollRect.bottom - y) / verticalRegionSize;
            deltaY *= deltaY * timeSpeedUp;
            deltaY = Math.round(deltaY) + 1;
        }

        deltaX = Math.max(minDeltaX, Math.min(maxDeltaX, deltaX));
        deltaY = Math.max(minDeltaY, Math.min(maxDeltaY, deltaY));
        
        if (deltaX == 0 && deltaY == 0)
            return null;
        return new Point(deltaX, deltaY);
    }
     */

    /**
     *  @private 
     *  True if the drag-scroll timer is running. 
    private function dragScrollingInProgress():Boolean
    {
        return _dragScrollTimer != null;
    }
     */
    
    /**
     *  @private 
     *  Starts the drag-scroll timer.
    private function startDragScrolling():void
    {
        if (_dragScrollTimer)
            return;

        // Setup the timer to handle the subsequet scrolling
        _dragScrollTimer = new Timer(dragScrollInterval);
        _dragScrollTimer.addEventListener(TimerEvent.TIMER, dragScroll);
        _dragScrollTimer.start();
        
        // Scroll once on start. Scroll after the _dragScrollTimer is
        // initialized to prevent stack overflow as a new event will be
        // dispatched to the list and it may try to start drag scrolling
        // again.
        dragScroll(null);
    }
     */

    /**
     *  @private
     *  Updates the scroll position and dispatches a DragEvent.
    private function dragScroll(event:TimerEvent):void
    {
        // Scroll the target
        horizontalScrollPosition += _dragScrollDelta.x;
        verticalScrollPosition += _dragScrollDelta.y;
        
        // Validate target before dispatching the event
        target.validateNow();
        
        // Re-dispatch the event so that the drag initiator handles it as if
        // the DragProxy is dispatching in response to user input.
        // Always switch over to DRAG_OVER, don't re-dispatch DRAG_ENTER
        var dragEvent:DragEvent = new DragEvent(DragEvent.DRAG_OVER,
                                                _dragScrollEvent.bubbles,
                                                _dragScrollEvent.cancelable, 
                                                _dragScrollEvent.dragInitiator, 
                                                _dragScrollEvent.dragSource, 
                                                _dragScrollEvent.action, 
                                                _dragScrollEvent.ctrlKey, 
                                                _dragScrollEvent.altKey, 
                                                _dragScrollEvent.shiftKey);
        
        dragEvent.draggedItem = _dragScrollEvent.draggedItem;
        dragEvent.localX = _dragScrollEvent.localX;
        dragEvent.localY = _dragScrollEvent.localY;
        dragEvent.relatedObject = _dragScrollEvent.relatedObject;
        _dragScrollEvent.target.dispatchEvent(dragEvent);
    }
     */
    
    /**
     *  @private
     *  Stops the drag-scroll timer. 
    private function stopDragScrolling():void
    {
        if (_dragScrollTimer)
        {
            _dragScrollTimer.stop();
            _dragScrollTimer.removeEventListener(TimerEvent.TIMER, dragScroll);
            _dragScrollTimer = null;
        }

        _dragScrollEvent = null;
        _dragScrollDelta = null;
    }
     */
    
    /**
     *  @private
     *  Work-around the Player globalToLocal and scrollRect changing before
     *  a frame is updated. 
     */
    private function globalToLocal(x:Number, y:Number):Point
    {
        var layoutTarget:GroupBase = target;
        var parent:UIBase = layoutTarget.parent as UIBase;
        var local:Point = PointUtils.globalToLocal(new Point(x, y), parent);
        local.x -= layoutTarget.x;
        local.y -= layoutTarget.y;

        var scrollRect:Rectangle = getScrollRect();
        if (scrollRect)
        {
            local.x += scrollRect.x;
            local.y += scrollRect.y;
        }
        return local;
    }
    
    private var ed:EventDispatcher = new EventDispatcher(this);
    
    public function hasEventListener(type:String):Boolean
    {
        return ed.hasEventListener(type);
    }
    
    COMPILE::JS
    public function dispatchEvent(event:Object):Boolean
    {
        return ed.dispatchEvent(event);
    }
    
    COMPILE::JS
    public function addEventListener(type:String, handler:Function, opt_capture:Boolean = false, opt_handlerScope:Object = null):void
    {
        ed.addEventListener(type, handler, opt_capture, opt_handlerScope);
    }
    
    COMPILE::JS
    public function removeEventListener(type:String, handler:Function, opt_capture:Boolean = false, opt_handlerScope:Object = null):void
    {
        ed.removeEventListener(type, handler, opt_capture, opt_handlerScope);
    }

    COMPILE::SWF
    public function addEventListener(type:String, handler:Function, capture:Boolean = false, priority:int = 0, weak:Boolean = false):void
    {
        ed.addEventListener(type, handler, capture);
    }
    
    COMPILE::SWF
    public function removeEventListener(type:String, handler:Function, capture:Boolean = false):void
    {
        ed.removeEventListener(type, handler, capture);
    }
    
    COMPILE::SWF
    public function dispatchEvent(event:flash.events.Event):Boolean
    {
        return ed.dispatchEvent(event);
    }

    COMPILE::SWF
    public function willTrigger(type:String):Boolean
    {
        return ed.willTrigger(type);
    }
    
    override public function layout():Boolean
    {
        var n:int = layoutView.numElements;
        if (n == 0)
            return false;
        
        var w:Number = target.width;
        var h:Number = target.height;
        if (isHeightSizedToContent())
            h = target.measuredHeight;
        if (isWidthSizedToContent())
            w = target.measuredWidth;
        
        updateDisplayList(w, h);
        
        // update the target's actual size if needed.
        if (isWidthSizedToContent() && isHeightSizedToContent()) {
            target.setActualSize(target.getExplicitOrMeasuredWidth(), 
                target.getExplicitOrMeasuredHeight());
        }
        else if (isWidthSizedToContent())
            target.setWidth(target.getExplicitOrMeasuredWidth());
        else if (isHeightSizedToContent())
            target.setHeight(target.getExplicitOrMeasuredHeight());
        
        return true;
    }

    public function isHeightSizedToContent():Boolean
    {
        return target.isHeightSizedToContent();
    }
    
    public function isWidthSizedToContent():Boolean
    {
        if (target.parent is Group)
        {
            var parentGroup:Group = target.parent as Group;
            if (parentGroup.layout is VerticalLayout)
            {
                var parentLayout:VerticalLayout = parentGroup.layout as VerticalLayout;
                if (parentLayout.horizontalAlign == HorizontalAlign.JUSTIFY)
                    return false;
            }                
        }
        return target.isWidthSizedToContent();
    }
}
}
