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

import mx.core.mx_internal;
import mx.effects.EffectInstance;

use namespace mx_internal;

/**
 *  The ActionEffectInstance class is the superclass for all 
 *  action effect instance classes.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */  
 public class ActionEffectInstance extends EffectInstance
{
    //include "../../core/Version.as";

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
	public function ActionEffectInstance(target:Object)
	{
		super(target);
	}

	//--------------------------------------------------------------------------
	//
	//  Variables
	//
	//--------------------------------------------------------------------------

	/**
	 *  Indicates whether the effect has been played (<code>true</code>), 
	 *  or not (<code>false</code>). 
	 *
	 *  <p>The <code>play()</code> method sets this property to 
	 *  <code>true</code> after the effect plays;
	 *  you do not set it directly.</p> 
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	protected var playedAction:Boolean = false;
	
	/**
	 *  @private
	 */
	private var _startValue:*;
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 *  Subclasses implement this method to save the starting state
	 *  before the effect plays.
	 *
	 *  @return Returns the starting state value.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	protected function saveStartValue():*
	{
	}
	
	/**
	 *  Returns the starting state value that was saved by the
	 *  <code>saveStartValue()</code> method.
	 *
	 *  @return Returns the starting state value.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	protected function getStartValue():*
	{
		return _startValue;
	}
		
	//--------------------------------------------------------------------------
	//
	//  Overridden methods
	//
	//--------------------------------------------------------------------------

	/**
	 *  @private
	 */
	override public function play():void
	{
		super.play();	
		
		// Don't save the value if we are playing in reverse.
		if (!playReversed)
			_startValue = saveStartValue();
		
		playedAction = true;
	}
	
	/**
	 *  @private
	 */
    override public function end():void
    {
    	if (!playedAction)
    		play();
    	
    	super.end();
    }
}

}
