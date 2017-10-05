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

package org.apache.royale.effects
{
	
	/**
	 *  ICompoundEffect aggregates several related effects. Implementors will decide on the order in which they're played.
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public interface ICompoundEffect extends IEffect
	{
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  duration
		//----------------------------------
		
		/**
		 *  Add an effect to the parent.
		 * 
		 *  @param c The subeffect to add.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		function addChild(c:IEffect):void;
		
		/**
		 *  Add an effect to the parent at a certain position.
		 * 
		 *  @param c The subeffect to add.
		 *  @param index The position where the subeffect is added.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		function addChildAt(c:IEffect, index:int):void;
		
		/**
		 *  Gets the index of this subeffect.
		 * 
		 *  @param c The subeffect to add.
		 *  @return The index (zero-based).
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		function getChildIndex(c:IEffect):int;
		
		/**
		 *  Remove an effect from the parent.
		 * 
		 *  @param c The subeffect to remove.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		function removeChild(c:IEffect):void;
		
		/**
		 *  The number of elements in the parent.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		function get numChildren():int;
		
		/**
		 *  Get an effect from the parent.
		 * 
		 *  @param index The position of the subeffect.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		function getChildAt(index:int):IEffect;
	}
	
}
