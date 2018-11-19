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

package mx.controls
{

import mx.core.UIComponent;

/**
 *  The Spacer control helps you lay out children within a parent container.
 *  Although the Spacer control does not draw anything, it does allocate space
 *  for itself within its parent container. 
 *  
 *  <p>In the following example, a flexible Spacer control is used
 *  to push the Button control to the right, so that the Button control
 *  is aligned with the right edge of the HBox container:</p>
 *
 *  <pre>
 *  &lt;mx:HBox&gt;
 *      &lt;mx:Image source="Logo.jpg"/&gt;
 *      &lt;mx:Label text="Company XYZ"/&gt;
 *      &lt;mx:Spacer width="100%"/&gt;
 *      &lt;mx:Button label="Close"/&gt;
 *  &lt;/mx:HBox&gt;
 *  </pre>
 *
 *  @mxml
 *  
 *  <p>The <code>&lt;mx:Spacer&gt;</code> tag inherits all of the tag attributes
 *  of its superclass, and adds no new tag attributes.</p>
 *  
 *  <pre>
 *  &lt;mx:Spacer/&gt;
 *  </pre>
 *  
 *  @includeExample examples/SpacerExample.mxml
 *  
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class Spacer extends UIComponent
{
    //--------------------------------------------------------------------------
    //
    //  Constructor variables
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
    public function Spacer()
    {
        super();
    }
	
}

}
