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

package mx.core
{

/**
 *  The IRawChildrenContainer interface defines the APIs for containers that 
 *  can return an IChildList that represents all their children. 
 *  This interface should be implemented by any container that has overridden
 *  IChildList APIs such as <code>numChildren</code> and <code>addChild()</code>
 *  method to manage only a subset of its actual children.
 *  The mx.core.Container class, for example, has a set of content children
 *  separate from the non-content children, such as borders, title bars,
 *  and dividers.
 *
 *  @see mx.core.Container
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public interface IRawChildrenContainer
{
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------

	//----------------------------------
	//  rawChildren
	//----------------------------------

	/**
	 *  Returns an IChildList representing all children.
	 *  This is used by FocusManager to find non-content children that may
	 *  still receive focus (for example, components in ControlBars).
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	function get rawChildren():IChildList;
}

}
