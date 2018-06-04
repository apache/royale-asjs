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
	COMPILE::JS {
		import goog.DEBUG;
	}
	import org.apache.royale.events.Event;
	import mx.core.Container;
	import mx.core.IUIComponent;
	import mx.core.UIComponent;
/*
import flash.display.DisplayObject;
import flash.events.Event;

import mx.automation.IAutomationObject;
import mx.core.Container;
import mx.core.ContainerCreationPolicy;
import mx.core.EdgeMetrics;
import mx.core.IInvalidating;
import mx.core.INavigatorContent;
import mx.core.ISelectableList;
import mx.core.IUIComponent;
import mx.core.ScrollPolicy;
import mx.core.UIComponent;
import mx.core.mx_internal;
import mx.effects.Effect;
import mx.effects.EffectManager;
import mx.events.ChildExistenceChangedEvent;
import mx.events.CollectionEvent;
import mx.events.CollectionEventKind;
import mx.events.EffectEvent;
import mx.events.FlexEvent;
import mx.events.IndexChangedEvent;
import mx.events.PropertyChangeEvent;
import mx.geom.RoundedRectangle;
import mx.managers.HistoryManager;
import mx.managers.IHistoryManagerClient;

use namespace mx_internal;
*/
//--------------------------------------
//  Events
//--------------------------------------

/**
 *  Dispatched when the selected child container changes.
 *
 *  @eventType mx.events.IndexChangedEvent.CHANGE
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Event(name="change", type="mx.events.IndexChangedEvent")]

//--------------------------------------
//  Styles
//--------------------------------------

//include "../styles/metadata/GapStyles.as"

/**
 *  Number of pixels between the container's bottom border and its content area.
 *  The default value is 0.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Style(name="paddingBottom", type="Number", format="Length", inherit="no")]

/**
 *  Number of pixels between the container's top border and its content area.
 *  The default value is 0.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="paddingTop", type="Number", format="Length", inherit="no")]

//--------------------------------------
//  Excluded APIs
//--------------------------------------
/*
[Exclude(name="autoLayout", kind="property")]
[Exclude(name="defaultButton", kind="property")]
[Exclude(name="horizontalLineScrollSize", kind="property")]
[Exclude(name="horizontalPageScrollSize", kind="property")]
[Exclude(name="horizontalScrollBar", kind="property")]
[Exclude(name="horizontalScrollPolicy", kind="property")]
[Exclude(name="horizontalScrollPosition", kind="property")]
[Exclude(name="maxHorizontalScrollPosition", kind="property")]
[Exclude(name="maxVerticalScrollPosition", kind="property")]
[Exclude(name="verticalLineScrollSize", kind="property")]
[Exclude(name="verticalPageScrollSize", kind="property")]
[Exclude(name="verticalScrollBar", kind="property")]
[Exclude(name="verticalScrollPolicy", kind="property")]
[Exclude(name="verticalScrollPosition", kind="property")]

[Exclude(name="focusIn", kind="event")]
[Exclude(name="focusOut", kind="event")]
[Exclude(name="scroll", kind="event")]

[Exclude(name="focusBlendMode", kind="style")]
[Exclude(name="focusSkin", kind="style")]
[Exclude(name="focusThickness", kind="style")]
[Exclude(name="horizontalScrollBarStyleName", kind="style")]
[Exclude(name="verticalScrollBarStyleName", kind="style")]

[Exclude(name="focusInEffect", kind="effect")]
[Exclude(name="focusOutEffect", kind="effect")]
*/
//--------------------------------------
//  Other metadata
//--------------------------------------

//[IconFile("ViewStack.png")]

/**
 *  An MX ViewStack navigator container consists of a collection of child
 *  containers stacked on top of each other, where only one child
 *  at a time is visible.
 *  When a different child container is selected, it seems to replace
 *  the old one because it appears in the same location.
 *  However, the old child container still exists; it is just invisible.
 * 
 *  <p><b>Note:</b> The direct children of an MX navigator container must be 
 *  MX containers, either MX layout or MX navigator containers, 
 *  or the Spark NavigatorContent container. 
 *  You cannot directly nest a control or a Spark container 
 *  other than the Spark NavigatorContent container within a navigator; 
 *  they must be children of an child MX container.</p>
 *
 *  <p>A ViewStack container does not provide a user interface
 *  for selecting which child container is currently visible.
 *  Typically, you set its <code>selectedIndex</code> or
 *  <code>selectedChild</code> property in ActionScript in response to
 *  some user action. 
 *  Alternately, you can associate an MX LinkBar, TabBar, ButtonBar, or ToggleButtonBar
 *  control or a Spark ButtonBar control with a ViewStack container to provide a navigation interface.
 *  To do so, specify the ViewStack container as the value of the
 *  <code>dataProvider</code> property of the LinkBar, TabBar or
 *  ToggleButtonBar container.</p>
 *
 *  <p>You might decide to use a more complex navigator container than the
 *  ViewStack container, such as a TabNavigator container or Accordion
 *  container. In addition to having a collection of child containers,
 *  these containers provide their own user interface controls
 *  for navigating between their children.</p>
 *
 *  <p>When you change the currently visible child container, 
 *  you can use the <code>hideEffect</code> property of the container being
 *  hidden and the <code>showEffect</code> property of the newly visible child
 *  container to apply an effect to the child containers.
 *  The ViewStack container waits for the <code>hideEffect</code> of the child
 *  container being hidden  to complete before it reveals the new child
 *  container. 
 *  You can interrupt a currently playing effect if you change the 
 *  <code>selectedIndex</code> property of the ViewStack container 
 *  while an effect is playing.</p>
 *
 *  <p>The ViewStack container has the following default sizing characteristics:</p>
 *     <table class="innertable">
 *        <tr>
 *           <th>Characteristic</th>
 *           <th>Description</th>
 *        </tr>
 *        <tr>
 *           <td>Default size</td>
 *           <td>The width and height of the initial active child.</td>
 *        </tr>
 *        <tr>
 *           <td>Container resizing rules</td>
 *           <td>By default, ViewStack containers are sized only once to fit the size of the 
 *               first child container. They do not resize when you navigate to other child 
 *               containers. To force ViewStack containers to resize when you navigate 
 *               to a different child container, set the resizeToContent property to true.</td>
 *        </tr>
 *        <tr>
 *           <td>Child sizing rules</td>
 *           <td>Children are sized to their default size. If the child is larger than the ViewStack 
 *               container, it is clipped. If the child is smaller than the ViewStack container, 
 *               it is aligned to the upper-left corner of the ViewStack container.</td>
 *        </tr>
 *        <tr>
 *           <td>Default padding</td>
 *           <td>0 pixels for top, bottom, left, and right values.</td>
 *        </tr>
 *     </table>
 *
 *  @mxml
 *
 *  <p>The <code>&lt;mx:ViewStack&gt;</code> tag inherits the
 *  tag attributes of its superclass, with the exception of scrolling-related
 *  attributes, and adds the following tag attributes:</p>
 *
 *  <pre>
 *  &lt;mx:ViewStack
 *    <b>Properties</b>
 *    historyManagementEnabled="false|true"
 *    resizeToContent="false|true"
 *    selectedIndex="0"
 *    
 *    <b>Styles</b>
 *    horizontalGap="8"
 *    paddingBottom="0"
 *    paddingTop="0"
 *    verticalGap="6"
 *    
 *    <b>Events</b>
 *    change="<i>No default</i>"
 *    &gt;
 *      ...
 *      <i>child tags</i>
 *      ...
 *  &lt;/mx:ViewStack&gt;
 *  </pre>
 *
 *  @includeExample examples/ViewStackExample.mxml
 *
 *  @see mx.controls.LinkBar
 *  @see mx.controls.ButtonBar
 *  @see mx.controls.TabBar
 *  @see mx.controls.ToggleButtonBar
 *  @see spark.components.ButtonBar
 *  @see mx.managers.HistoryManager
 *  @see mx.managers.LayoutManager
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class ViewStack extends Container //implements IHistoryManagerClient, ISelectableList
{
    //include "../core/Version.as";

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
    public function ViewStack()
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
     */
    //private var needToInstantiateSelectedChild:Boolean = false;

    /**
     *  @private
     *  This flag gets set when selectedIndex is set.
     *  Later, when measure()
     *  is called, it causes the HistoryManager to save the state.
     */
    //private var bSaveState:Boolean = false;

    /**
     *  @private
     *  This flag gets set by loadState().
     *  It prevents the newly restored state from being saved.
     */
    //private var bInLoadState:Boolean = false;
    
    /**
     *  @private
     *  True until commitProperties has been called at least once.
     */
    //private var firstTime:Boolean = true;

    /**
     *  @private
     *  We'll measure ourselves once and then store the results here
     *  for the lifetime of the ViewStack
     */
	/*
    mx_internal var vsMinWidth:Number;
    mx_internal var vsMinHeight:Number;
    mx_internal var vsPreferredWidth:Number;
    mx_internal var vsPreferredHeight:Number;
	*/
    /**
     *  @private
     *  Remember which child has an overlay mask, if any.
     *  Used for the dissolve effect.
     */
    //private var effectOverlayChild:UIComponent;

    /**
     *  @private
     *  Keep track of the overlay's targetArea
     *  Used for the dissolve effect.
     */
    //private var effectOverlayTargetArea:RoundedRectangle;

    /**
     *  @private
     *  Store the last selectedIndex
     */
    //private var lastIndex:int = -1;

    /**
     *  @private
     *  Whether a change event has to be dispatched in commitProperties()
     */
    //private var dispatchChangeEventPending:Boolean = false;

    /**
     *  @private
     *  If we're in the middle of adding a child
     */
    private var addingChildren:Boolean = false;
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  selectedChild
    //----------------------------------

    [Bindable("valueCommit")]
    [Bindable("creationComplete")]

    /**
     *  A reference to the currently visible child container.
     *  The default is a reference to the first child.
     *  If there are no children, this property is <code>null</code>.
     * 
     *  <p><strong>Note:</strong> You can only set this property in an
     *  ActionScript statement, not in MXML.</p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get selectedChild():Object //INavigatorContent
    {
        if (selectedIndex == -1)
            return null;

        return null; //INavigatorContent(getChildAt(selectedIndex));
    }

    /**
     *  @private
     */
    public function set selectedChild(
                            value:Object):void //INavigatorContent):void
    {
        var newIndex:int; //= getChildIndex(DisplayObject(value));

        if (newIndex >= 0 && newIndex < numChildren)
            selectedIndex = newIndex;
    }

    //----------------------------------
    //  selectedIndex
    //----------------------------------

    /**
     *  @private
     *  Storage for the selectedIndex property.
     */
    private var _selectedIndex:int = -1;

    /**
     *  @private
     */
    private var proposedSelectedIndex:int = -1;

    /**
     *  @private
     */
    private var initialSelectedIndex:int = -1;

    [Bindable("change")]
    [Bindable("valueCommit")]
    [Bindable("creationComplete")]
    [Inspectable(category="General")]

    /**
     *  The zero-based index of the currently visible child container.
     *  Child indexes are in the range 0, 1, 2, ..., n - 1,
     *  where <i>n</i> is the number of children.
     *  The default value is 0, corresponding to the first child.
     *  If there are no children, the value of this property is <code>-1</code>.
     * 
     *  <p><strong>Note:</strong> When you add a new child to a ViewStack 
     *  container, the <code>selectedIndex</code> property is automatically 
     *  adjusted, if necessary, so that the selected child remains selected.</p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get selectedIndex():int
    {
        return proposedSelectedIndex == -1 ?
               _selectedIndex :
               proposedSelectedIndex;
    }

    /**
     *  @private
     */
    public function set selectedIndex(value:int):void
    {
        // Bail if the index isn't changing.
        if (value == selectedIndex)
            return;
        
        // ignore, probably coming from tabbar
        if (addingChildren)
            return;

        // Propose the specified value as the new value for selectedIndex.
        // It gets applied later when measure() calls commitSelectedIndex().
        // The proposed value can be "out of range", because the children
        // may not have been created yet, so the range check is handled
        // in commitSelectedIndex(), not here. Other calls to this setter
        // can change the proposed index before it is committed. Also,
        // childAddHandler() proposes a value of 0 when it creates the first
        // child, if no value has yet been proposed.
        proposedSelectedIndex = value;
        invalidateProperties();

        // Set a flag which will cause the HistoryManager to save state
        // the next time measure() is called.
        //if (historyManagementEnabled && _selectedIndex != -1 && !bInLoadState)
        //    bSaveState = true;

        //dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
    }

    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     */
	COMPILE::JS
    override public function addChildAt(item:IUIComponent, index:int):IUIComponent //(item:DisplayObject, index:int):DisplayObject
    {
        addingChildren = true;
        //var obj:DisplayObject = super.addChildAt(item, index);
        var obj:IUIComponent = super.addChildAt(item, index);
        //internalDispatchEvent(CollectionEventKind.ADD, obj, index);
        //childAddHandler(item);
        addingChildren = false;
        return obj;
    }

    //--------------------------------------------------------------------------
    //
    //  IList Implementation
    //  Viewstack implements IList so it can be plugged into a Spark ButtonBar
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     *  IList implementation of length returns numChildren
     */
    public function get length():int
    {
        return numChildren;
    }

}

}

