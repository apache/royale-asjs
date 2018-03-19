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
/*
import mx.core.mx_internal;
use namespace mx_internal;
*/

/**
 *  The Halo HBox container lays out its children in a single horizontal row.
 *  You use the <code>&lt;mx:HBox&gt;</code> tag instead of the
 *  <code>&lt;mx:Box&gt;</code> tag as a shortcut to avoid having to
 *  set the <code>direction</code> property to
 *  <code>"horizontal"</code>.
 * 
 *  <p><b>Note:</b> Adobe recommends that, when possible, you use the Spark containers 
 *  with HorizontalLayout instead of the Halo HBox container.</p>
 *
 *  <p>An HBox container has the following default sizing characteristics:</p>
 *     <table class="innertable">
 *        <tr>
 *           <th>Characteristic</th>
 *           <th>Description</th>
 *        </tr>
 *        <tr>
 *           <td>Default size</td>
 *           <td>The width is large enough to hold all its children at the default or explicit width of the children, 
 *               plus any horizontal gap between the children, plus the left and right padding of the container. 
 *               The height is the default or explicit height of the tallest child, 
 *               plus the top and bottom padding for the container.
 *           </td>
 *        </tr>
 *        <tr>
 *           <td>Default padding</td>
 *           <td>0 pixels for the top, bottom, left, and right values.</td>
 *        </tr>
 *     </table>
 *
 *  @mxml
 *  
 *  <p>The <code>&lt;mx:HBox&gt;</code> tag inherits all of the tag 
 *  attributes of its superclass, except <code>direction</code>, and adds 
 *  no new tag attributes.</p>
 *
 *  @includeExample examples/HBoxExample.mxml
 *
 *  @see mx.core.Container
 *  @see mx.containers.Box
 *  @see mx.containers.VBox
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class HBox extends Box
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
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function HBox()
    {
        super();
		typeNames = "HBox";
        
        super.direction = BoxDirection.HORIZONTAL;
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  direction
    //----------------------------------
    
    [Inspectable(environment="none")]   

    /**
     *  @private
     *  Don't allow user to change the direction
     */
    override public function set direction(value:String):void
    {
    }

}

}
