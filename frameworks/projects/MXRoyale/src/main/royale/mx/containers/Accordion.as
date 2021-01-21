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

import mx.core.UIComponent;
import org.apache.royale.events.Event;
import mx.events.FocusEvent;
import mx.events.KeyboardEvent;
import mx.events.MouseEvent;
import mx.core.Container;

[RequiresDataBinding(true)]

//[IconFile("Accordion.png")]

/**
 *  Dispatched when the selected child container changes.
 *
 *  @eventType mx.events.IndexChangedEvent.CHANGE
 *  @helpid 3012
 *  @tiptext change event
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="change", type="mx.events.IndexChangedEvent")]

//--------------------------------------
//  Styles
//--------------------------------------

/**
 *  Name of the CSS style declaration that specifies styles for the accordion
 *  headers (tabs).
 * 
 *  <p>You can use this class selector to set the values of all the style properties 
 *  of the AccordionHeader class, including <code>fillAlphas</code>, <code>fillColors</code>, 
 *  <code>focusAlpha</code>, <code>focusRounderCorners</code>, 
 *  <code>focusSkin</code>, <code>focusThickness</code>, and <code>selectedFillColors</code>.</p>
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="headerStyleName", type="String", inherit="no")]

/**
 *  Number of pixels between children in the horizontal direction.
 *  The default value is 8.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="horizontalGap", type="Number", format="Length", inherit="no")]

/**
 *  Height of each accordion header, in pixels.
 *  The default value is automatically calculated based on the font styles for
 *  the header.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="headerHeight", type="Number", format="Length", inherit="no")]

/**
 *  Duration, in milliseconds, of the animation from one child to another.
 * 
 *  The default value for the Halo theme is 250.
 *  The default value for the Spark theme is 0.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="openDuration", type="Number", format="Time", inherit="no")]

/**
 *  Tweening function used by the animation from one child to another.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="openEasingFunction", type="Function", inherit="no")]

/**
 *  Number of pixels between the container's bottom border and its content area.
 *  The default value is -1, so the bottom border of the last header
 *  overlaps the Accordion container's bottom border.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="paddingBottom", type="Number", format="Length", inherit="no")]

/**
 *  Number of pixels between the container's top border and its content area.
 *  The default value is -1, so the top border of the first header
 *  overlaps the Accordion container's top border.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="paddingTop", type="Number", format="Length", inherit="no")]

/**
 *  Color of header text when rolled over.
 * 
 *  The default value for the Halo theme is <code>0x2B333C</code>.
 *  The default value for the Spark theme is <code>0x000000</code>.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="textRollOverColor", type="uint", format="Color", inherit="yes")]

/**
 *  Color of selected text.
 *  
 *  The default value for the Halo theme is <code>0x2B333C</code>.
 *  The default value for the Spark theme is <code>0x000000</code>.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="textSelectedColor", type="uint", format="Color", inherit="yes")]

/**
 *  Number of pixels between children in the vertical direction.
 *  The default value is -1, so the top and bottom borders
 *  of adjacent headers overlap.
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

[Exclude(name="autoLayout", kind="property")]
[Exclude(name="clipContent", kind="property")]
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

/*
[Exclude(name="focusBlendMode", kind="style")]
*/
[Exclude(name="horizontalScrollBarStyleName", kind="style")]
[Exclude(name="verticalScrollBarStyleName", kind="style")]
[Exclude(name="focusSkin", kind="style")]
[Exclude(name="focusThickness", kind="style")]

//--------------------------------------
//  Other metadata
//--------------------------------------

[DefaultBindingProperty(source="selectedIndex", destination="selectedIndex")]

[DefaultTriggerEvent("change")]

/**
 *  An MX Accordion navigator container has a collection of child MX containers
 *  or Spark NavigatorContent containers, but only one of them at a time is visible.
 *  It creates and manages navigator buttons (accordion headers), which you use
 *  to navigate between the children.
 *  There is one navigator button associated with each child container,
 *  and each navigator button belongs to the Accordion container, not to the child.
 *  When the user clicks a navigator button, the associated child container
 *  is displayed.
 *  The transition to the new child uses an animation to make it clear to
 *  the user that one child is disappearing and a different one is appearing.
 * 
 *  <p><b>Note:</b> The direct children of an MX navigator container must be 
 *  MX containers, either MX layout or MX navigator containers, 
 *  or the Spark NavigatorContent container. 
 *  You cannot directly nest a control or a Spark container 
 *  other than the Spark NavigatorContent container within a navigator; 
 *  they must be children of an child MX container.</p>
 *
 *  <p>The Accordion container does not extend the ViewStack container,
 *  but it implements all the properties, methods, styles, and events
 *  of the ViewStack container, such as <code>selectedIndex</code>
 *  and <code>selectedChild</code>.</p>
 *
 *  <p>An Accordion container has the following default sizing characteristics:</p>
 *     <table class="innertable">
 *        <tr>
 *           <th>Characteristic</th>
 *           <th>Description</th>
 *        </tr>
 *        <tr>
 *           <td>Default size</td>
 *           <td>The width and height of the currently active child.</td>
 *        </tr>
 *        <tr>
 *           <td>Container resizing rules</td>
 *           <td>Accordion containers are only sized once to fit the size of the first child container by default. 
 *               They do not resize when you navigate to other child containers by default. 
 *               To force Accordion containers to resize when you navigate to a different child container, 
 *               set the resizeToContent property to true.</td>
 *        </tr>
 *        <tr>
 *           <td>Child sizing rules</td>
 *           <td>Children are sized to their default size. The child is clipped if it is larger than the Accordion container. 
 *               If the child is smaller than the Accordion container, it is aligned to the upper-left corner of the 
 *               Accordion container.</td>
 *        </tr>
 *        <tr>
 *           <td>Default padding</td>
 *           <td>-1 pixel for the top, bottom, left, and right values.</td>
 *        </tr>
 *     </table>
 *
 *  @mxml
 *
 *  <p>The <code>&lt;mx:Accordion&gt;</code> tag inherits all of the
 *  tag attributes of its superclass, with the exception of scrolling-related
 *  attributes, and adds the following tag attributes:</p>
 *
 *  <pre>
 *  &lt;mx:Accordion
 *    <strong>Properties</strong>
 *    headerRenderer="<i>IFactory</i>"
 *    historyManagementEnabled="true|false"
 *    resizeToContent="false|true"
 *    selectedChild"<i>A reference to the first child</i>"
 *    selectedIndex="undefined"
 *  
 *    <strong>Styles</strong>
 *    headerHeight="depends on header font styles"
 *    headerStyleName="<i>No default</i>"
 *    horizontalGap="8"
 *    openDuration="250"
 *    openEasingFunction="undefined"
 *    paddingBottom="-1"
 *    paddingTop="-1"
 *    textRollOverColor="0xB333C"
 *    textSelectedColor="0xB333C"
 *    verticalGap="-1"
 *  
 *    <strong>Events</strong>
 *    change="<i>No default</i>"
 *    &gt;
 *      ...
 *      <i>child tags</i>
 *      ...
 *  &lt;/mx:Accordion&gt;
 *  </pre>
 *
 *  @includeExample examples/AccordionExample.mxml
 *
 *  @see mx.containers.accordionClasses.AccordionHeader
 *
 *  @tiptext Accordion allows for navigation between different child views
 *  @helpid 3013
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class Accordion extends Container //implements IHistoryManagerClient, IFocusManagerComponent
{
 //   include "../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     *  Base for all header names (_header0 - _headerN).
     */
    private static const HEADER_NAME_BASE:String = "_header";

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
    public function Accordion()
    {
        super();

      
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

   
}

}
