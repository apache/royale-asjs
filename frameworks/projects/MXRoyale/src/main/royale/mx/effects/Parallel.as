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

//import mx.effects.effectClasses.ParallelInstance;
import org.apache.royale.effects.Parallel;
/**
 *  The Parallel effect plays multiple child effects at the same time.
 *  
 *  <p>You can create a Paralell effect in MXML,
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
 *  &lt;mx:VBox id="myBox" hideEffect="{WipeRightUp}" &gt;
 *    &lt;mx:TextArea id="aTextArea" text="hello"/&gt;
 *  &lt;/mx:VBox&gt;
 *  </pre>
 *
 *  <p>Notice that the <code>&lt;mx:children&gt;</code> tag is optional.</p>
 *  
 *  <p>Starting a Parallel effect in ActionScript is usually
 *  a five-step process:</p>
 *
 *  <ol>
 *    <li>Create instances of the effect objects to be composited together;
 *    for example: 
 *    <pre>myFadeEffect = new mx.effects.Fade(target);</pre></li>
 *    <li>Set properties, such as <code>duration</code>, on the individual effect objects.</li>
 *    <li>Create an instance of the Parallel effect object;  
 *    for example: 
 *    <pre>myParallelEffect = new mx.effects.Parallel();</pre></li>
 *    <li>Call the <code>addChild()</code> method for each of the effect objects;
 *    for example: 
 *    <pre>myParallelEffect.addChild(myFadeEffect);</pre></li>
 *    <li>Invoke the Parallel effect's <code>play()</code> method; 
 *    for example: 
 *    <pre>myParallelEffect.play();</pre></li>
 *  </ol>
 *
 *  @mxml
 *
 *  <p>The &lt;mx:Parallel&gt; tag
 *  inherits all of the tag attributes of its superclass,
 *  and adds the following tag attributes:</p>
 *  
 *  <pre>
 *  &lt;mx:Parallel id="<i>identifier</i>"&gt;
 *    &lt;mx:children&gt;
 *      &lt;!-- Specify child effect tags --&gt; 
 *    &lt;/mx:children&gt;
 *  &lt;/mx:Parallel&gt;
 *  </pre>
 *
 *  @see mx.effects.effectClasses.ParallelInstance
 *  
 *  @includeExample examples/ParallelEffectExample.mxml
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class Parallel extends org.apache.royale.effects.Parallel
{	// extends CompositeEffect
    //include "../core/Version.as";

	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------

	/**
	 *  Constructor.
	 *
	 *  @param target This argument is ignored for Parallel effects.
	 *  It is included only for consistency with other types of effects.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function Parallel(target:Object = null)
	{
		super();
		//super(target);

		//instanceClass = ParallelInstance;
	}

	//Copied from mx.effects.Effect
	public function end(effectInstance:IEffectInstance = null):void
    {
    }
	
	//----------------------------------
    //  isPlaying Copied from mx.effects.Effect
    //----------------------------------

    /**
     *  @copy mx.effects.IEffect#isPlaying
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get isPlaying():Boolean
    {
        //return _instances && _instances.length > 0;
		return true;
    }
    
	
	
	
	
    /**
     * @inheritDoc
     * 
     * Parallel calculates this number to be the duration of each
     * child effect played at the same time, so the compositeDuration
     * will be equal to the duration of the child effect with the
     * longest duration (including the startDelay and repetition data 
     * of that effect).
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    /* override public function get compositeDuration():Number
    {
        var parallelDuration:Number = 0;
        for (var i:int = 0; i < children.length; ++i)
        {
            var childDuration:Number;
            var child:Effect = Effect(children[i]);
            if (child is CompositeEffect)
                childDuration = CompositeEffect(child).compositeDuration;
            else
                childDuration = child.duration;
            childDuration = 
                childDuration * child.repeatCount +
                (child.repeatDelay * (child.repeatCount - 1)) +
                child.startDelay;
            parallelDuration = Math.max(parallelDuration, childDuration);
        }
        return parallelDuration;
    } */

}

}
