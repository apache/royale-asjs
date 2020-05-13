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

import mx.containers.beads.TabNavigatorView;
import mx.controls.Button;
import mx.core.Container;
import mx.core.EdgeMetrics;
import mx.managers.IFocusManagerComponent;

import org.apache.royale.core.IBeadView;
import org.apache.royale.core.IChild;
import org.apache.royale.events.Event;

//--------------------------------------
//  Styles
//--------------------------------------

// The fill related styles are applied to the children
// of the TabNavigator, ie: the TabBar
//include "../styles/metadata/FillStyles.as"

// The focus styles are applied to the TabNavigator itself.
//include "../styles/metadata/FocusStyles.as"

/**
 *  Name of CSS style declaration that specifies styles for the first tab.
 *  If this is unspecified, the default value
 *  of the <code>tabStyleName</code> style property is used.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Style(name="firstTabStyleName", type="String", inherit="no")]

/**
 *  Horizontal positioning of tabs at the top of this TabNavigator container.
 *  The possible values are <code>"left"</code>, <code>"center"</code>,
 *  and <code>"right"</code>.
 *  The default value is <code>"left"</code>.
 *
 *  <p>If the value is <code>"left"</code>, the left edge of the first tab
 *  is aligned with the left edge of the TabNavigator container.
 *  If the value is <code>"right"</code>, the right edge of the last tab
 *  is aligned with the right edge of the TabNavigator container.
 *  If the value is <code>"center"</code>, the tabs are centered on the top
 *  of the TabNavigator container.</p>
 *
 *  <p>To see a difference between the alignments,
 *  the total width of all the tabs must be less than
 *  the width of the TabNavigator container.</p>
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Style(name="horizontalAlign", type="String", enumeration="left,center,right", inherit="no")]

/**
 *  Separation between tabs, in pixels.
 *  The default value is -1, so that the borders of adjacent tabs overlap.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Style(name="horizontalGap", type="Number", format="Length", inherit="no")]

/**
 *  Name of CSS style declaration that specifies styles for the last tab.
 *  If this is unspecified, the default value
 *  of the <code>tabStyleName</code> style property is used.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Style(name="lastTabStyleName", type="String", inherit="no")]

/**
 *  Name of CSS style declaration that specifies styles for the text
 *  of the selected tab.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Style(name="selectedTabTextStyleName", type="String", inherit="no")]

/**
 *  Height of each tab, in pixels.
 *  The default value is <code>undefined</code>.
 *  When this property is <code>undefined</code>, the height of each tab is
 *  determined by the font styles applied to this TabNavigator container.
 *  If you set this property, the specified value overrides this calculation.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Style(name="tabHeight", type="Number", format="Length", inherit="no")]

/**
 *  Name of CSS style declaration that specifies styles for the tabs.
 *  
 *  @default undefined
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Style(name="tabStyleName", type="String", inherit="no")]

/**
 *  Width of each tab, in pixels.
 *  The default value is <code>undefined</code>.
 *  When this property is <code>undefined</code>, the width of each tab is
 *  determined by the width of its label text, using the font styles applied
 *  to this TabNavigator container.
 *  If the total width of the tabs would be greater than the width of the
 *  TabNavigator container, the calculated tab width is decreased, but
 *  only to a minimum of 30 pixels.
 *  If you set this property, the specified value overrides this calculation.
 *
 *  <p>The label text on a tab is truncated if it does not fit in the tab.
 *  If a tab label is truncated, a tooltip with the full label text is
 *  displayed when a user rolls the mouse over the tab.</p>
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Style(name="tabWidth", type="Number", format="Length", inherit="no")]

/**
 *  The horizontal offset, in pixels, of the tab bar from the left edge 
 *  of the TabNavigator container. 
 *  A positive value moves the tab bar to the right. A negative
 *  value move the tab bar to the left. 
 * 
 *  @default 0 
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Style(name="tabOffset", type="Number", format="Length", inherit="no")]

//--------------------------------------
//  Excluded APIs
//--------------------------------------

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

[Exclude(name="scroll", kind="event")]

[Exclude(name="fillAlphas", kind="style")]
[Exclude(name="fillColors", kind="style")]
[Exclude(name="horizontalScrollBarStyleName", kind="style")]
[Exclude(name="verticalScrollBarStyleName", kind="style")]

//--------------------------------------
//  Other metadata
//--------------------------------------

//[IconFile("TabNavigator.png")]

/**
 *  The MX TabNavigator container extends the MX ViewStack container by including
 *  a TabBar container for navigating between its child containers.
 * 
 *  <p><b>Note:</b> The direct children of an MX navigator container must be 
 *  MX containers, either MX layout or MX navigator containers, 
 *  or the Spark NavigatorContent container. 
 *  You cannot directly nest a control or a Spark container 
 *  other than the Spark NavigatorContent container within a navigator; 
 *  they must be children of an child MX container.</p>
 *
 *  <p>Like a ViewStack container, a TabNavigator container has a collection
 *  of child containers, in which only one child at a time is visible.
 *  Flex automatically creates a TabBar container at the top of the
 *  TabNavigator container, with a tab corresponding to each child container.
 *  Each tab can have its own label and icon.
 *  When the user clicks a tab, the corresponding child container becomes
 *  visible as the selected child of the TabNavigator container.</p>
 *
 *  <p>When you change the currently visible child container,
 *  you can use the <code>hideEffect</code> property of the container being
 *  hidden and the <code>showEffect</code> property of the newly visible child
 *  container to apply an effect to the child containers.
 *  The TabNavigator container waits for the <code>hideEffect</code> of the
 *  child container being hidden to complete before it reveals the new child
 *  container.
 *  You can interrupt a currently playing effect if you change the
 *  <code>selectedIndex</code> property of the TabNavigator container
 *  while an effect is playing. </p>
 *  
 *  <p>To define the appearance of tabs in a TabNavigator, you can define style properties in a 
 *  Tab type selector, as the following example shows:</p>
 *  <pre>
 *  &lt;fx:Style&gt;
 *    &#64;namespace mx "library://ns.adobe.com/flex/mx"
 *    mx|Tab {
 *       fillColors: #006699, #cccc66;
 *       upSkin: ClassReference("CustomSkinClass");
 *       overSkin: ClassReference("CustomSkinClass");
 *       downSkin: ClassReference("CustomSkinClass");
 *    }  
 *  &lt;/fx:Style&gt;
 *  </pre>
 * 
 *  <p>The Tab type selector defines values on the hidden mx.controls.tabBarClasses.Tab 
 *  class. The default values for the Tab type selector are defined in the 
 *  defaults.css file.</p>
 * 
 *  <p>You can also define the styles in a class selector that you specify using 
 *  the <code>tabStyleName</code> style property; for example:</p>
 *  <pre>
 *  &lt;fx:Style&gt;
 *    &#64;namespace mx "library://ns.adobe.com/flex/mx"
 *    mx|TabNavigator {
 *       tabStyleName:myTabStyle;
 *    }
 *
 *    .myTabStyle {
 *       fillColors: #006699, #cccc66;
 *       upSkin: ClassReference("CustomSkinClass");
 *       overSkin: ClassReference("CustomSkinClass");
 *       downSkin: ClassReference("CustomSkinClass");
 *    }
 *  &lt;/fx:Style&gt;
 *  </pre>
 *
 *  <p>A TabNavigator container has the following default sizing characteristics:</p>
 *     <table class="innertable">
 *        <tr>
 *           <th>Characteristic</th>
 *           <th>Description</th>
 *        </tr>
 *        <tr>
 *           <td>Default size</td>
 *           <td>The default or explicit width and height of the first active child 
 *               plus the tabs, at their default or explicit heights and widths. 
 *               Default tab height is determined by the font, style, and skin applied 
 *               to the TabNavigator container.</td>
 *        </tr>
 *        <tr>
 *           <td>Container resizing rules</td>
 *           <td>By default, TabNavigator containers are only sized once to fit the size 
 *               of the first child container. They do not resize when you navigate to 
 *               other child containers. To force TabNavigator containers to resize when 
 *               you navigate to a different child container, set the resizeToContent 
 *               property to true.</td>
 *        </tr>
 *        <tr>
 *           <td>Child layout rules</td>
 *           <td>If the child is larger than the TabNavigator container, it is clipped. If 
 *               the child is smaller than the TabNavigator container, it is aligned to 
 *               the upper-left corner of the TabNavigator container.</td>
 *        </tr>
 *        <tr>
 *           <td>Default padding</td>
 *           <td>0 pixels for the top, bottom, left, and right values.</td>
 *        </tr>
 *     </table>
 *
 *  @mxml
 *
 *  <p>The <code>&lt;mx:TabNavigator&gt;</code> tag inherits all of the
 *  tag attributes of its superclass,
 *  and adds the following tag attributes:</p>
 *
 *  <pre>
 *  &lt;mx:TabNavigator
 *    <b>Styles</b>
 *    firstTabStyleName="<i>Value of the</i> <code>tabStyleName</code> <i>property</i>"
 *    focusAlpha="0.4"
 *    focusRoundedCorners="tl tr bl br"
 *    horizontalAlign="left|center|right"
 *    horizontalGap="-1"
 *    lastTabStyleName="<i>Value of the</i> <code>tabStyleName</code> <i>property</i>"
 *    selectedTabTextStyleName="undefined"
 *    tabHeight="undefined"
 *    tabOffset="0"
 *    tabStyleName="<i>Name of CSS style declaration that specifies styles for the tabs</i>"
 *    tabWidth="undefined"
 *    &gt;
 *      ...
 *      <i>child tags</i>
 *      ...
 *  &lt;/mx:TabNavigator&gt;
 *  </pre>
 *
 *  @includeExample examples/TabNavigatorExample.mxml
 *
 *  @see mx.containers.ViewStack
 *  @see mx.controls.TabBar
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class TabNavigator extends ViewStack implements IFocusManagerComponent
{
//    include "../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    private static const MIN_TAB_WIDTH:Number = 30;

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
    public function TabNavigator()
    {
        super();

        typeNames += " TabNavigator";
        
        // Most views can't take focus, but a TabNavigator can.
        // Container.init() has set tabEnabled false, so we
        // have to set it back to true.
        tabEnabled = true;
        tabFocusEnabled = true;
        hasFocusableChildren = true;

        // historyManagementEnabled = true;
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden properties
    //
    //--------------------------------------------------------------------------



    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     *  Returns the tab of the navigator's TabBar control at the specified
     *  index.
     *
     *  @param index Index in the navigator's TabBar control.
     *
     *  @return The tab at the specified index.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function getTabAt(index:int):Button
    {
        // TODO
        trace("cacheAsBitmap not implemented");
        return null;
    }

    
    //--------------------------------------------------------------------------
    //
    //  ILayoutView  (pass to view)
    //
    //--------------------------------------------------------------------------
    
    /**
     * @private
     * @royaleignorecoercion org.apache.royale.html.beads.TabNavigatorView
     */
    override public function addElement(c:IChild, dispatchEvent:Boolean = true):void
    {
        var tnView:TabNavigatorView = view as TabNavigatorView;
        tnView.contentArea.addElement(c, dispatchEvent);
        if ((isHeightSizedToContent() || !isNaN(explicitHeight)) &&
            (isWidthSizedToContent() || !isNaN(explicitWidth)))
            this.dispatchEvent(new Event("layoutNeeded"));
    }
    
    /**
     * @private
     * @royaleignorecoercion org.apache.royale.html.beads.TabNavigatorView
     */
    override public function addElementAt(c:IChild, index:int, dispatchEvent:Boolean = true):void
    {
        var tnView:TabNavigatorView = view as TabNavigatorView;
        tnView.contentArea.addElementAt(c, index, dispatchEvent);
        if ((isHeightSizedToContent() || !isNaN(explicitHeight)) &&
            (isWidthSizedToContent() || !isNaN(explicitWidth)))
            this.dispatchEvent(new Event("layoutNeeded"));
    }
    
    /**
     * @private
     * @royaleignorecoercion org.apache.royale.html.beads.TabNavigatorView
     */
    override public function getElementIndex(c:IChild):int
    {
        var tnView:TabNavigatorView = view as TabNavigatorView;
        return tnView.contentArea.getElementIndex(c);
    }
    
    /**
     * @private
     * @royaleignorecoercion org.apache.royale.html.beads.TabNavigatorView
     */
    override public function removeElement(c:IChild, dispatchEvent:Boolean = true):void
    {
        var tnView:TabNavigatorView = view as TabNavigatorView;
        tnView.contentArea.removeElement(c, dispatchEvent);
    }
    
    /**
     * @private
     * @royaleignorecoercion org.apache.royale.html.beads.TabNavigatorView
     */
    override public function get numElements():int
    {
        // the view getter below will instantiate the view which can happen
        // earlier than we would like (when setting mxmlDocument) so we
        // see if the view bead exists on the strand.  If not, nobody
        // has added any children so numElements must be 0
        if (!getBeadByType(IBeadView))
            return 0;
        var tnView:TabNavigatorView = view as TabNavigatorView;
        return tnView.contentArea.numElements;
    }
    
    /**
     * @private
     * @royaleignorecoercion org.apache.royale.html.beads.TabNavigatorView
     */
    override public function getElementAt(index:int):IChild
    {
        var tnView:TabNavigatorView = view as TabNavigatorView;
        return tnView.contentArea.getElementAt(index);
    }

}

}
