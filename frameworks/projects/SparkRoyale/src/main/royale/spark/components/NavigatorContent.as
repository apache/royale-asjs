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

package spark.components
{
//import flash.events.Event;
import org.apache.royale.events.Event;
/* import mx.core.ContainerCreationPolicy;
import mx.core.IDeferredContentOwner; */
import mx.core.INavigatorContent;

/**
 *  The NavigatorContent class defines a Spark container that can be used 
 *  in an MX navigator container, such as the ViewStack, TabNavigator and Accordion containers.
 *
 *  <p>Do not use a NavigatorContent container outside of an MX navigator container.</p>
 *
 *  <p>The creation policy of the NavigatorContent container is based on the creation policy 
 *  of its parent navigator container: </p>
 *
 *  <ul>
 *    <li>If the creation policy of the parent is none, then the creation policy of the NavigatorContent is none.</li>
 *    <li>If the creation policy of the parent is all, then the creation policy of the NavigatorContent is all.</li>
 *    <li>If the creation policy of the parent is auto, then the creation policy of the NavigatorContent is none.</li>
 *  </ul>
 * 
 *  <p>The NavigatorContent container does not support the queued creation policy.</p>
 *
 *  <p>The NavigatorContent container has the following default characteristics:</p>
 *  <table class="innertable">
 *     <tr><th>Characteristic</th><th>Description</th></tr>
 *     <tr><td>Default size</td><td>Large enough to display its children</td></tr>
 *     <tr><td>Minimum size</td><td>0 pixels</td></tr>
 *     <tr><td>Maximum size</td><td>10000 pixels wide and 10000 pixels high</td></tr>
 *  </table>
 *
 *  @mxml
 *
 *  <p>The <code>&lt;s:NavigatorContent&gt;</code> tag inherits all of the tag 
 *  attributes of its superclass and adds the following tag attributes:</p>
 *
 *  <pre>
 *  &lt;s:NavigatorContent
 *    <strong>Properties</strong>
 *    icon="null"
 *    label=""
 *  
 *  /&gt;
 *  </pre>
 *
 *  @see mx.containers.Accordion
 *  @see mx.containers.TabNavigator
 *  @see mx.containers.ViewStack
 *  @includeExample examples/NavigatorContentExample.mxml
 
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Royale 0.9.4
 */
public class NavigatorContent extends SkinnableContainer implements INavigatorContent
{

   // include "../core/Version.as";
    

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
     *  @productversion Royale 0.9.4
     */
    public function NavigatorContent()
    {
        super();
    }
    
    
    //--------------------------------------------------------------------------
    //
    //  Properties 
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  icon
    //----------------------------------

    /**
     *  @private
     *  Storage for the icon property.
     */
    private var _icon:Class = null;

    [Bindable("iconChanged")]
    [Inspectable(category="General", defaultValue="", format="EmbeddedFile")]

    /**
     *  The Class of the icon displayed by some navigator
     *  containers to represent this Container.
     *
     *  <p>For example, if this Container is a child of a TabNavigator,
     *  this icon appears in the corresponding tab.
     *  If this Container is a child of an Accordion,
     *  this icon appears in the corresponding header.</p>
     *
     *  <p>To embed the icon in the SWF file, use the &#64;Embed()
     *  MXML compiler directive:</p>
     *
     *  <pre>
     *    icon="&#64;Embed('filepath')"
     *  </pre>
     *
     *  <p>The image can be a JPEG, GIF, PNG, SVG, or SWF file.</p>
     *
     *  @default null
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    public function get icon():Class
    {
        return _icon;
    }

    /**
     *  @private
     */
    public function set icon(value:Class):void
    {
        _icon = value;

        dispatchEvent(new Event("iconChanged"));
    }

    //----------------------------------
    //  label
    //----------------------------------

    /**
     *  @private
     *  Storage for the label property.
     */
    private var _label:String = "";

    [Bindable("labelChanged")]
    [Inspectable(category="General", defaultValue="")]

    /**
     *  The text displayed by some navigator containers to represent
     *  this Container.
     *
     *  <p>For example, if this Container is a child of a TabNavigator,
     *  this string appears in the corresponding tab.
     *  If this Container is a child of an Accordion,
     *  this string appears in the corresponding header.</p>
     *
     *  @default ""
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Royale 0.9.4
     */
    public function get label():String
    {
        return _label;
    }

    /**
     *  @private
     */
    public function set label(value:String):void
    {
        _label = value;

        dispatchEvent(new Event("labelChanged"));
    }

    
    //--------------------------------------------------------------------------
    //
    //  Overridden Methods
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     *  Create components that are children of this Container.
     */
   /*  override protected function createChildren():void
    {
        // if nobody has overridden creationPolicy, get it from the
        // navigator parent
        if (creationPolicy == ContainerCreationPolicy.AUTO)
        {
            if (parent is IDeferredContentOwner)
            {
                var parentCreationPolicy:String = IDeferredContentOwner(parent).creationPolicy;
                creationPolicy = parentCreationPolicy == 
                        ContainerCreationPolicy.ALL ? ContainerCreationPolicy.ALL : 
                                                        ContainerCreationPolicy.NONE;

            }
        }

        super.createChildren();
    } */

}

}
