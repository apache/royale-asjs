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

package mx.effects.effectClasses
{

import mx.core.IUIComponent;

/**
 *  The PropertyChanges class defines the start and end values
 *  for a set of properties of a target component of a transition.
 *  The <code>start</code> and <code>end</code> fields
 *  of the PropertyChanges class contain the same set of properties, 
 *  but with different values. 
 *
 *  <p>Target properties that have the same start and end values
 *  are not included in the <code>start</code> and <code>end</code> fields.</p>
 *
 *  @see mx.states.Transition
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class PropertyChanges
{
    //include "../../core/Version.as";

	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------

	/**
	 *  The PropertyChanges constructor.
	 *
	 *  @param target Object that is a target of an effect.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function PropertyChanges(target:Object)
	{
		super();

		this.target = target;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------

	//----------------------------------
	//  end
	//----------------------------------

	/**
	 *  An Object containing the ending properties of the <code>target</code>
	 *  component modified by the change in view state.
	 *
	 *  <p>For example, for a <code>target</code> component that is both
	 *  moved and resized by a change to the view state, <code>end</code>
	 *  contains the ending position and size of the component, 
	 *  as the following example shows:
	 *  <pre>{ x: 100, y: 100, width: 200, height: 200 }</pre></p>
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public var end:Object = {};

	//----------------------------------
	//  start
	//----------------------------------

	/**
	 *  An Object containing the starting properties of the <code>target</code>
	 *  component modified by the change in view state.
	 *
	 *  <p>For example, for a <code>target</code> component that is both
	 *  moved and resized by a change to the view state, <code>start</code>
	 *  contains the starting position and size of the component,
	 *  as the following example shows:
	 *  <pre>{ x: 0, y: 0, width: 100, height: 100}</pre></p>
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public var start:Object = {};

	//----------------------------------
	//  target
	//----------------------------------

	/**
	 *  A target component of a transition.
	 *  The <code>start</code> and <code>end</code> fields
	 *  of the PropertyChanges object define how the target component
	 *  is modified by the change to the view state.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public var target:Object;

    // TODO (chaase): This flag is currently used by the transform-related
    // effects. We should investigate whether we really need it, or can get
    // by without it
    /**
     *  This flag controls whether values that are the same in the
     *  start and end states are stripped from those objects. 
     * 
     *  @default true
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public var stripUnchangedValues:Boolean = true;
}

}
