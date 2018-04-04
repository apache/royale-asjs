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

import mx.core.Container;
import mx.core.FlexVersion;
import mx.core.ScrollPolicy;
import mx.core.mx_internal;
import mx.core.UIComponent;
import mx.styles.CSSStyleDeclaration;
import mx.styles.IStyleClient;
import mx.styles.StyleManager;

use namespace mx_internal;

//--------------------------------------
//  Excluded APIs
//--------------------------------------

[Exclude(name="direction", kind="property")]
[Exclude(name="horizontalScrollPolicy", kind="property")]
[Exclude(name="verticalScrollPolicy", kind="property")]

[Exclude(name="focusIn", kind="event")]
[Exclude(name="focusOut", kind="event")]

[Exclude(name="backgroundColor", kind="style")]
[Exclude(name="borderColor", kind="style")]
[Exclude(name="borderSides", kind="style")]
[Exclude(name="borderThickness", kind="style")]
[Exclude(name="dropShadowColor", kind="style")]
[Exclude(name="dropShadowEnabled", kind="style")]
[Exclude(name="focusBlendMode", kind="style")]
[Exclude(name="focusSkin", kind="style")]
[Exclude(name="focusThickness", kind="style")]
[Exclude(name="shadowDirection", kind="style")]
[Exclude(name="shadowDistance", kind="style")]

[Exclude(name="focusInEffect", kind="effect")]
[Exclude(name="focusOutEffect", kind="effect")]

//--------------------------------------
//  Other metadata
//--------------------------------------

[IconFile("ControlBar.png")]

/**
 *  As of Flex 4, the ControlBar component is no longer required. Use 
 *  the <code>controlBarContent</code> property of the Spark Panel class
 *  to specify the set of components to include in the control bar area. Use
 *  the <code>controlBarLayout</code> property of the Spark Panel class
 *  to specify the layout of the control bar area. 
 */
[Alternative(replacement="none", since="4.0")]

/**
 *  The ControlBar container lets you place controls
 *  at the bottom of a Halo Panel or Halo TitleWindow container.
 *  The <code>&lt;mx:ControlBar&gt;</code> tag must be the last child tag
 *  of the enclosing tag for the Halo Panel or Halo TitleWindow container.
 *
 *  <p><b>Note:</b> The Spark Panel container does not support the ControlBar container. 
 *  Modify the skin of the Spark Panel container to add this functionality.</p>
 *
 *  <p>The ControlBar is a Box with a background
 *  and default style properties.</p>
 *
 *  <p>A ControlBar container has the following default sizing characteristics:</p>
 *     <table class="innertable">
 *        <tr>
 *           <th>Characteristic</th>
 *           <th>Description</th>
 *        </tr>
 *        <tr>
 *           <td>Default size</td>
 *           <td>Height is the default or explicit height of the tallest child, plus the top and bottom padding of the container. 
 *               Width is large enough to hold all of its children at the default or explicit width of the children, 
 *               plus any horizontal gap between the children, plus the left and right padding of the container.</td>
 *        </tr>
 *        <tr>
 *           <td>Default padding</td>
 *           <td>10 pixels for the top, bottom, left, and right values.</td>
 *        </tr>
 *     </table>
 *
 *  @mxml
 *
 *  <p>The <code>&lt;mx:ControlBar&gt;</code> tag inherits all the tag
 *  attributes but adds no additional attributes:</p>
 *
 *  <pre>
 *  &lt;mx:ControlBar&gt;
 *    ...
 *      <i>child tags</i>
 *    ...
 *  &lt;/mx:ControlBar&gt;
 *  </pre>
 *
 *  @see mx.containers.Panel
 *
 *  @includeExample examples/SimpleControlBarExample.mxml
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class ControlBar extends Box
{
    include "../core/Version.as";
    
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
    public function ControlBar()
    {
        super();

        // ControlBar defaults to direction="horizontal", but can be changed
        // later if desired
        direction = BoxDirection.HORIZONTAL;
     }

    //--------------------------------------------------------------------------
    //
    //  Overridden properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  enabled
    //----------------------------------

    [Inspectable(category="General", enumeration="true,false", defaultValue="true")]

    /**
     *  @private
     */
    override public function set enabled(value:Boolean):void
    {
        if (value != super.enabled)
        {
            super.enabled = value;
            
            // Since ControlBar typically has a transparent background and sits on top
            // of a translucent part of the panel, we don't want the default overlay.
            // Instead of the overlay, set the alpha value here.
            alpha = value ? 1 : 0.4;
        }
    }

    //----------------------------------
    //  horizontalScrollPolicy
    //----------------------------------

    [Inspectable(environment="none")]

    /**
     *  @private
     */
    override public function get horizontalScrollPolicy():String
    {
        return ScrollPolicy.OFF;
    }

    /**
     *  @private
     */
    override public function set horizontalScrollPolicy(value:String):void
    {
        // A ControlBar never scrolls.
        // Its horizontalScrollPolicy is initialized to "off" and can't be changed.
    }

    //----------------------------------
    //  includeInLayout
    //----------------------------------

    [Inspectable(category="General", defaultValue="true")]

    /**
     *  @private
     */
    override public function set includeInLayout(value:Boolean):void
    {
        if (includeInLayout != value)
        {
            super.includeInLayout = value;

            var p:Container = parent as Container;
            if (p)
                p.invalidateViewMetricsAndPadding();
        }
    }

    //----------------------------------
    //  verticalScrollPolicy
    //----------------------------------

    [Inspectable(environment="none")]

    /**
     *  @private
     */
    override public function get verticalScrollPolicy():String
    {
        return ScrollPolicy.OFF;
    }

    /**
     *  @private
     */
    override public function set verticalScrollPolicy(value:String):void
    {
        // A ControlBar never scrolls.
        // Its verticalScrollPolicy is initialized to "off" and can't be changed.
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden methods
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    override public function invalidateSize():void
    {
        super.invalidateSize();

        // Since controlbar isn't a "child" of Panel, we need to call
        // invalidateViewMetricsAndPadding() here when our size is invalidated.
        // This causes our parent Panel to adjust size.
        if (parent && parent is Container)
            Container(parent).invalidateViewMetricsAndPadding();
    }

    /**
     *  @private
     */
    override protected function updateDisplayList(unscaledWidth:Number,
                                                  unscaledHeight:Number):void
    {
        super.updateDisplayList(unscaledWidth, unscaledHeight);

        // Make sure we don't have an opaque background for the ControlBar,
        // otherwise the background turns white.
        if (contentPane)
            contentPane.opaqueBackground = null;
    }
}

}
