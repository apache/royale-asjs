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

package mx.managers
{

/**
 *  The IFocusManagerGroup interface defines the interface that 
 *  any component must implement if it is grouped in sets,
 *  where only one member of the set can be selected at any given time.
 *  For example, a RadioButton implements IFocusManagerGroup
 *  because a set of RadioButtons in the same group 
 *  can only have one RadioButton selected at any one time,
 *  and the FocusManager will make sure not to give focus to the RadioButtons
 *  that are not selected in response to moving focus via the Tab key.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public interface IFocusManagerGroup
{
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------

	//----------------------------------
	//  groupName
	//----------------------------------

	/**
	 *	The name of the group of controls to which the control belongs.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	function get groupName():String;

	/**
	 *  @private
	 */
	function set groupName(value:String):void;

	//----------------------------------
	//  selected
	//----------------------------------

	/**
	 *	A flag that indicates whether this control is selected.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	function get selected():Boolean;

	/**
	 *  @private
	 */
	function set selected(value:Boolean):void;
}

}
