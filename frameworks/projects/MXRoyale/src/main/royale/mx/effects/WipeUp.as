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

package mx.effects
{

import org.apache.royale.core.IUIBase;
import org.apache.royale.effects.Wipe;

/**
 *  The WipeUp class defines a wipe up effect.
 *  The before or after state of the component must be invisible. 
 * 
 *  <p>You often use this effect with the <code>showEffect</code> 
 *  and <code>hideEffect</code> triggers. The <code>showEffect</code> 
 *  trigger occurs when a component becomes visible by changing its 
 *  <code>visible</code> property from <code>false</code> to <code>true</code>. 
 *  The <code>hideEffect</code> trigger occurs when the component becomes 
 *  invisible by changing its <code>visible</code> property from 
 *  <code>true</code> to <code>false</code>.</p>
 *
 *  <p>This effect inherits the <code>MaskEffect.show</code> property. 
 *  If you set the value to <code>true</code>, the component appears. 
 *  If you set the value to <code>false</code>, the component disappears. 
 *  The default value is <code>true</code>.</p>
 *  
 *  <p>If you specify this effect for a <code>showEffect</code> or 
 *  <code>hideEffect</code> trigger, Flex sets the <code>show</code> property 
 *  for you, either to <code>true</code> if the component becomes invisible, 
 *  or <code>false</code> if the component becomes visible.</p> 
 *  
 *  @mxml
 *
 *  <p>The <code>&lt;mx:WipeUp&gt;</code> tag
 *  inherits all of the tag attributes of its superclass,
 *  and adds the following tag attributes:</p>
 *  
 *  <pre>
 *  &lt;mx:WipeUp
 *    id="ID"
 *  /&gt;
 *  </pre>
 *
 *  @see mx.effects.effectClasses.WipeUpInstance
 *  
 *  @includeExample examples/WipeUpExample.mxml
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class WipeUp extends Wipe
{

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     *
     *  @param target The Object to animate with this effect.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function WipeUp(target:Object = null)
    {
        super(target as IUIBase);

        direction = "up";
    }
}

}
