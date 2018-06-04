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

import mx.core.mx_internal;
import mx.effects.effectClasses.CompositeEffectInstance;
/* import mx.effects.effectClasses.PropertyChanges;
 */
use namespace mx_internal;

[DefaultProperty("children")]

/**
 *  The CompositeEffect class is the parent class for the Parallel
 *  and Sequence classes, which define the <code>&lt;mx:Parallel&gt;</code>
 *  and <code>&lt;mx:Sequence&gt;</code> MXML tags.  
 *  Flex supports two methods to combine, or composite, effects:
 *  parallel and sequence.
 *  When you combine multiple effects in parallel,
 *  the effects play at the same time.
 *  When you combine multiple effects in sequence, 
 *  one effect must complete before the next effect starts.
 *
 *  <p>You can create a composite effect in MXML,
 *  as the following example shows:</p>
 *
 *  <pre>
 *  &lt;mx:Parallel id="WipeRightUp"&gt;
 *    &lt;mx:children&gt;
 *      &lt;mx:WipeRight duration="1000"/&gt;
 *      &lt;mx:WipeUp duration="1000"/&gt;
 *    &lt;/mx:children&gt;
 *  &lt;/mx:Parallel&gt;
 *   
 *  &lt;mx:VBox id="myBox" hideEffect="WipeRightUp"&gt;
 *    &lt;mx:TextArea id="aTextArea" text="hello"/&gt;
 *  &lt;/mx:VBox&gt;
 *  </pre>
 *
 *  <p>The <code>&lt;mx:children&gt;</code> tag is optional.</p>
 *  
 *  <p>Starting a composite effect in ActionScript is usually
 *  a five-step process:</p>
 *
 *  <ol>
 *    <li>Create instances of the effect objects to be composited together; 
 *    for example: 
 *    <pre>myFadeEffect = new mx.effects.Fade(target);</pre></li>
 *    <li>Set properties, such as <code>duration</code>,
 *    on the individual effect objects.</li>
 *    <li>Create an instance of the Parallel or Sequence effect object; 
 *    for example: 
 *    <pre>mySequenceEffect = new mx.effects.Sequence();</pre></li>
 *    <li>Call the <code>addChild()</code> method for each
 *    of the effect objects; for example: 
 *    <pre>mySequenceEffect.addChild(myFadeEffect);</pre></li>
 *    <li>Invoke the composite effect's <code>play()</code> method; 
 *    for example: 
 *    <pre>mySequenceEffect.play();</pre></li>
 *  </ol>
 *  
 *  @mxml
 *
 *  <p>The CompositeEffect class adds the following tag attributes,
 *  and all the subclasses of the CompositeEffect class
 *  inherit these tag attributes:</p>
 *  
 *  <pre>
 *  &lt;mx:<i>tagname</i>&gt;
 *    &lt;mx:children&gt;
 *      &lt;!-- Specify child effect tags --&gt; 
 *    &lt;/mx:children&gt;
 *  &lt;/mx:<i>tagname</i>&gt;
 *  </pre>
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.3
 */
public class CompositeEffect extends Effect
{
/*     include "../core/Version.as";
 */
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor. 
     * 
     *  @param target This argument is ignored for composite effects.
     *  It is included only for consistency with other types of effects.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    public function CompositeEffect(target:Object = null)
    {
       // super(target);
        instanceClass = CompositeEffectInstance;
    }   
    
    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

   

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  children
    //----------------------------------

    [Inspectable(category="General", arrayType="mx.effects.Effect")]
    
    private var _children:Array = [];
    
    /**
     *  An Array containing the child effects of this CompositeEffect.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    public function get children():Array
    {
        return _children;
    }
    public function set children(value:Array):void
    {
       /*  var i:int;
        // array may contain null/uninitialized children, so only set/unset
        // parent property for non-null child values
        if (_children)
            // Remove this effect as the parent of the old child effects
            for (i = 0; i < _children.length; ++i)
                if (_children[i])
                    Effect(_children[i]).parentCompositeEffect = null;*/
        _children = value;
          /*if (_children)
            for (i = 0; i < _children.length; ++i)
                if (_children[i])
                    Effect(_children[i]).parentCompositeEffect = this; */
    }
    
    
}

}
