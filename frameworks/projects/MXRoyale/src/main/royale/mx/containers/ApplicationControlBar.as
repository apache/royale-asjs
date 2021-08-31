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

import mx.core.FlexVersion;
import mx.core.IFlexModuleFactory;
import mx.core.mx_internal;
import mx.styles.CSSStyleDeclaration;
import mx.styles.IStyleClient;
import mx.styles.StyleManager;

use namespace mx_internal;

//--------------------------------------
//  Styles
//--------------------------------------

/**
 *  Alpha values used for the background fill of the container.
 *  The default value is <code>[0,0]</code>.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="fillAlphas", type="Array", arrayType="Number", inherit="no")]

/**
 *  Colors used to tint the background of the container.
 *  Pass the same color for both values for a "flat" looking control.
 *  The default value is <code>[0xFFFFFF,0xFFFFFF]</code>.
 *
 *  <p>You should also set the <code>fillAlphas</code> property to 
 *  a nondefault value because its default value 
 *  of <code>[0,0]</code> makes the colors invisible.</p>
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="fillColors", type="Array", arrayType="uint", format="Color", inherit="no")]

//--------------------------------------
//  Excluded APIs
//--------------------------------------


[Exclude(name="direction", kind="property")]

[Exclude(name="focusIn", kind="event")]
[Exclude(name="focusOut", kind="event")]

[Exclude(name="backgroundAlpha", kind="style")]
[Exclude(name="backgroundAttachment", kind="style")]
[Exclude(name="backgroundImage", kind="style")]
[Exclude(name="backgroundSize", kind="style")]
[Exclude(name="focusBlendMode", kind="style")]
[Exclude(name="focusSkin", kind="style")]
[Exclude(name="focusThickness", kind="style")]
[Exclude(name="focusInEffect", kind="effect")]
[Exclude(name="focusOutEffect", kind="effect")]

//--------------------------------------
//  Other metadata
//--------------------------------------

//[IconFile("ApplicationControlBar.png")]

/**
 *  As of Flex 4, the ApplicationControlBar component is no longer required. Use 
 *  the <code>controlBarContent</code> property of the Spark Application class
 *  to specify the set of components to include in the control bar area. Use
 *  the <code>controlBarLayout</code> property of the Spark Application class
 *  to specify the layout of the control bar area. 
 */
[Alternative(replacement="none", since="4.0")]

/**
 *  The ApplicationControlBar container holds components
 *  that provide global navigation and application commands 
 *  For the Halo Application container. 
 *  An ApplicationControlBar for an editor, for example, could include 
 *  Button controls for setting the font weight, a ComboBox control to select
 *  the font, and a MenuBar control to select the edit mode. Typically, you
 *  place an ApplicationControlBar container at the top of the Halo Application container.
 *
 *  <p><b>Note:</b> The Spark Application container does not support 
 *  the ApplicationControlBar container. 
 *  Modify the skin of the Spark Application container to add this functionality.</p>
 *
 *  <p>The ApplicationControlBar container can be in either of the following
 *  modes:</p> 
 *  <ul>
 *    <li>Docked mode: The bar is always at the top of the application's
 *      drawing area and becomes part of the application chrome.
 *      Any application-level scroll bars don't apply to the component, so that
 *      it always remains at the top of the visible area, and the bar expands
 *      to fill the width of the application. To create a docked bar, 
 *      set the value of the <code>dock</code> property to
 *      <code>true</code>.</li>
 *      
 *    <li>Normal mode: The bar can be placed anywhere in the application, 
 *      gets sized and positioned just like any other component, 
 *      and scrolls with the application. 
 *      To create a normal bar, set the value of the <code>dock</code> property to
 *      <code>false</code> (default).</li>
 *  </ul>
 *
 *  <p>The ApplicationControlBar container has the following default sizing characteristics:</p>
 *     <table class="innertable">
 *        <tr>
 *           <th>Characteristic</th>
 *           <th>Description</th>
 *        </tr>
 *        <tr>
 *           <td>Default size</td>
 *           <td>The height is the default or explicit height of the tallest child, plus the top and bottom padding of the container. 
 *               In normal mode, the width is large enough to hold all of its children at the default or explicit width of the children, plus any horizontal gap between the children, plus the left and right padding of the container. In docked mode, the width equals the application width. 
 *               If the application is not wide enough to contain all the controls in the ApplicationControlBar container, the bar is clipped.</td>
 *        </tr>
 *        <tr>
 *           <td>Default padding</td>
 *           <td>5 pixels for the top value.
 *               <br>4 pixels for the bottom value.
 *               <br>8 pixels for the left and right values.</br>
 *           </td>
 *        </tr>
 *     </table>
 *
 *  @mxml
 *
 *  <p>The <code>&lt;mx:ApplicationControlBar&gt;</code> tag 
 *  inherits all of the tag attributes of its superclass, and adds the
 *  following tag attributes.
 *  Unlike the ControlBar container, it is possible to set the
 *  <code>backgroundColor</code> style for an ApplicationControlBar
 *  container.</p>
 *
 *  <pre>
 *  &lt;mx:ApplicationControlBar
 *    <strong>Properties</strong>
 *    dock="false|true"
 *  
 *    <strong>Styles</strong>
 *    fillAlphas="[0, 0]"
 *    fillColors="[0xFFFFFF, 0xFFFFFF]"
 *    &gt;
 *    ...
 *      <i>child tags</i>
 *    ...
 *  &lt;/mx:ApplicationControlBar&gt;
 *  </pre>
 *
 *  @see mx.core.Application
 *
 *  @includeExample examples/SimpleApplicationControlBarExample.mxml
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class ApplicationControlBar extends ControlBar
{
    //include "../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     *  Whether the value of the <code>dock</code> property has changed.
     */
    private var dockChanged:Boolean = false;

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
    public function ApplicationControlBar()
    {
        super();
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  dock
    //----------------------------------

    /**
     *  @private
     *  Storage for the dock property.
     */
    private var _dock:Boolean = false;

    [Inspectable(category="General", enumeration="false,true", defaultValue="false")]
    [Bindable("dockChanged")]

    /**
     *  If <code>true</code>, specifies that the ApplicationControlBar should be docked to the
     *  top of the application. If <code>false</code>, specifies that the ApplicationControlBar 
     *  gets sized and positioned just like any other component. This property is supported when 
     *  the application is of type <code>Application</code>, otherwise the value of 
     *  <code>dock</code> has no effect.
     *
     *  @default false
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get dock():Boolean
    {
        return _dock;
    }
    
    /**
     *  @private
     */
    public function set dock(value:Boolean):void
    {
        if (_dock != value)
        {
            _dock = value;
            dockChanged = true;
            invalidateProperties();

            dispatchEvent(new Event("dockChanged"));
        }
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden properties
    //
    //--------------------------------------------------------------------------

    [Inspectable(category="General", enumeration="true,false", defaultValue="true")]

    //----------------------------------
    //  enabled
    //----------------------------------

    /**
     *  @private
     */
    override public function set enabled(value:Boolean):void
    {
       // var oldBlocker:Object = blocker;

        super.enabled = value;

     /*   if (blocker && blocker != oldBlocker)
        {
            if (blocker is IStyleClient)
            {
                IStyleClient(blocker).setStyle("borderStyle",
                                               "applicationControlBar");
            }
        }  */
    }
    
    /**
     *  @private
     */
    override public function set moduleFactory(factory:IFlexModuleFactory):void
    {
        super.moduleFactory = factory;
        
        if (FlexVersion.compatibilityVersion >= FlexVersion.VERSION_4_0)
        {
            var typeSelector:CSSStyleDeclaration = 
                styleManager.getStyleDeclaration("mx.containers.ApplicationControlBar");
            
            if (typeSelector)
            {
                if (typeSelector.getStyle("borderStyle") === undefined)
                    typeSelector.setStyle("borderStyle", "applicationControlBar");
                if (typeSelector.getStyle("docked") === undefined)
                    typeSelector.setStyle("docked", false);
                if (typeSelector.getStyle("dropShadowEnabled") === undefined)
                    typeSelector.setStyle("dropShadowEnabled", true);
                if (typeSelector.getStyle("shadowDistance") === undefined)
                    typeSelector.setStyle("shadowDistance", 5);
            }
        }
    }
    
    //--------------------------------------------------------------------------
    //
    //  Overridden methods
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    override protected function commitProperties():void
    {
        super.commitProperties();

        if (dockChanged)
        {
            dockChanged = false;

         /*   var applicationClass:Class = Class(systemManager.getDefinitionByName("mx.core::Application"));
            if (applicationClass && parent is applicationClass)
                applicationClass(parent).dockControlBar(this, _dock); */
        }
    }
    
    //--------------------------------------------------------------------------
    //
    //   methods
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     *  This method forces a recaldculation of docking the AppControlBar.
     */
    public function resetDock(value:Boolean):void
    {
        _dock = !value
        dock = value;
    }
}

}
