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

package mx.states
{
import mx.core.ContainerCreationPolicy;
import mx.core.IDeferredInstance;
import mx.core.mx_internal;
import mx.core.UIComponent;
import mx.resources.IResourceManager;
import mx.resources.ResourceManager;

use namespace mx_internal;

[DefaultProperty("targetFactory")]

[ResourceBundle("states")]
    
/**
 *  The AddChild class adds a child display object, such as a component, 
 *  to a container as part of a view state. 
 *  You use this class in the <code>overrides</code> property of the State class.
 *  Use the <code>creationPolicy</code> property to specify to create the child 
 *  at application startup or when you change to a view state. 
 *  
 *  <p>The child does not dispatch the <code>creationComplete</code> event until 
 *  it is added to a container. For example, the following code adds a 
 *  Button control as part of a view state change:</p>
 * 
 *  <pre>
 *  &lt;mx:AddChild relativeTo="{v1}"&gt;
 *      &lt;mx:Button id="b0" label="New Button"/&gt;
 *  &lt;/mx:AddChild&gt; </pre>
 *
 *  <p>In the previous example, the Button control does not dispatch 
 *  the <code>creationComplete</code> event until you change state and the 
 *  Button control is added to a container. 
 *  If the AddChild class defines both the Button and a container, such as a Canvas container, 
 *  then the Button control dispatches the creationComplete event when it is created. 
 *  For example, if the <code>creationPolicy</code> property is set to <code>all</code>, 
 *  the Button control dispatches the event at application startup. 
 *  If the <code>creationPolicy</code> property is set to <code>auto</code>,
 *  the Button control dispatches the event when you change to the view state. </p>
 *
 *  @mxml
 *
 *  <p>The <code>&lt;mx:AddChild&gt;</code> tag
 *  has the following attributes:</p>
 *  
 *  <pre>
 *  &lt;mx:AddChild
 *  <b>Properties</b>
 *  target="null"
 *  targetFactory="null"
 *  creationPolicy="auto"
 *  position="lastChild"
 *  relativeTo="<i>parent of the State object</i>"
 *  /&gt;
 *  </pre>
 *
 *  @see mx.states.State
 *  @see mx.states.RemoveChild
 *  @see mx.states.Transition 
 *  @see mx.effects.AddChildAction
 *
 *  @includeExample examples/StatesExample.mxml
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
 public class AddChild extends UIComponent //OverrideBase 
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
     *  @param relativeTo The component relative to which child is added.
     *
     *  @param target The child object.
     *  All Flex components are subclasses of the UIComponent class.
     *
     *  @param position the location in the display list of the <code>target</code>
     *  relative to the <code>relativeTo</code> component. Must be one of the following:
     *  "firstChild", "lastChild", "before" or "after".
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function AddChild(relativeTo:UIComponent = null,
                             target:UIComponent = null,
                             position:String = "lastChild")
    {
        super();

       // this.relativeTo = relativeTo;
       // this.target = target;
        this.position = position;
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    mx_internal var added:Boolean = false;

    /**
     *  @private
     */
    mx_internal var instanceCreated:Boolean = false;

    /**
     *  @private
     *  Used for accessing localized Error messages.
     */
    private var resourceManager:IResourceManager =
                                    ResourceManager.getInstance();

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //------------------------------------
    //  creationPolicy
    //------------------------------------
    
   
    //------------------------------------
    //  position
    //------------------------------------

    [Inspectable(category="General")]

    /**
     *  The position of the child in the display list, relative to the
     *  object specified by the <code>relativeTo</code> property.
     *  Valid values are <code>"before"</code>, <code>"after"</code>, 
     *  <code>"firstChild"</code>, and <code>"lastChild"</code>.
     *
     *  @default "lastChild"
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public var position:String;

    
}

}
