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
 *  The IDeferredInstantiationUIComponent interface defines the interface for a component 
 *  or object that defers instantiation.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public interface IDeferredInstantiationUIComponent extends IUIComponent
{
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------

	//----------------------------------
	//  cacheHeuristic
	//----------------------------------

	/**
	 *  @copy mx.core.UIComponent#cacheHeuristic
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
    function set cacheHeuristic(value:Boolean):void;

	//----------------------------------
	//  cachePolicy
	//----------------------------------

	/**
	 *  @copy mx.core.UIComponent#cachePolicy
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
    function get cachePolicy():String

	//----------------------------------
	//  descriptor
	//----------------------------------

	/**
	 *  @copy mx.core.UIComponent#descriptor
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
    function get descriptor():UIComponentDescriptor;
    
	/**
	 *  @private
	 */
    function set descriptor(value:UIComponentDescriptor):void;

	//----------------------------------
	//  id
	//----------------------------------

	/**
	 *  @copy mx.core.UIComponent#id
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
    function get id():String;
    
	/**
	 *  @private
	 */
	function set id(value:String):void;

	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------

	/**
     *  Creates an <code>id</code> reference to this IUIComponent object
	 *  on its parent document object.
     *  This function can create multidimensional references
     *  such as b[2][4] for objects inside one or more repeaters.
     *  If the indices are null, it creates a simple non-Array reference.
     *
     *  @param parentDocument The parent of this IUIComponent object. 
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	function createReferenceOnParentDocument(
						parentDocument:IFlexDisplayObject):void;
	
	/**
     *  Deletes the <code>id</code> reference to this IUIComponent object
	 *  on its parent document object.
     *  This function can delete from multidimensional references
     *  such as b[2][4] for objects inside one or more Repeaters.
     *  If the indices are null, it deletes the simple non-Array reference.
     *
     *  @param parentDocument The parent of this IUIComponent object. 
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	function deleteReferenceOnParentDocument(
						parentDocument:IFlexDisplayObject):void;

	/**
	 *  @copy mx.core.UIComponent#executeBindings()
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	function executeBindings(recurse:Boolean = false):void;

	/**
	 *  For each effect event, register the EffectManager
	 *  as one of the event listeners.
	 *
	 *  @param effects An Array of strings of effect names.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	function registerEffects(effects:Array):void;
}

}
