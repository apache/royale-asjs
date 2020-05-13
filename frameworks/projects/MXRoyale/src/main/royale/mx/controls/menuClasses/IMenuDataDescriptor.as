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

package mx.controls.menuClasses
{

import mx.collections.ICollectionView;

/**
 *  The IMenuDataDescriptor interface defines the interface that a 
 *  dataDescriptor for a Menu or MenuBar control must implement. 
 *  The interface provides methods for parsing and modifyng a collection
 *  of data that is displayed by a Menu or MenuBar control.
 *
 *  @see mx.collections.ICollectionView
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public interface IMenuDataDescriptor
{
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------

    /**
     *  @copy mx.controls.treeClasses.DefaultDataDescriptor#getChildren()  
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
	function getChildren(node:Object, model:Object = null):ICollectionView;
	
	/**
     *  @copy mx.controls.treeClasses.DefaultDataDescriptor#hasChildren() 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
	function hasChildren(node:Object, model:Object = null):Boolean;

	/**
     *  @copy mx.controls.treeClasses.DefaultDataDescriptor#getData() 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
	function getData(node:Object, model:Object = null):Object;

    /**
     *  @copy mx.controls.treeClasses.DefaultDataDescriptor#isBranch() 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
	function isBranch(node:Object, model:Object = null):Boolean;

	/**
     *  @copy mx.controls.treeClasses.DefaultDataDescriptor#getType()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
	function getType(node:Object):String;

	/**
     *  @copy mx.controls.treeClasses.DefaultDataDescriptor#addChildAt()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function addChildAt(parent:Object, newChild:Object, index:int,
						model:Object = null):Boolean;

    /**
     *  @copy mx.controls.treeClasses.DefaultDataDescriptor#removeChildAt()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function removeChildAt(parent:Object, child:Object, index:int,
						   model:Object = null):Boolean;
	
	/**
     *  @copy mx.controls.treeClasses.DefaultDataDescriptor#isEnabled()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
	function isEnabled(node:Object):Boolean;

	/**
     *  @copy mx.controls.treeClasses.DefaultDataDescriptor#setEnabled()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
	function setEnabled(node:Object, value:Boolean):void;

	/**
     *  @copy mx.controls.treeClasses.DefaultDataDescriptor#isToggled()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
	function isToggled(node:Object):Boolean;

	/**
     *  @copy mx.controls.treeClasses.DefaultDataDescriptor#setToggled()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
	function setToggled(node:Object, value:Boolean):void;

	/**
     *  @copy mx.controls.treeClasses.DefaultDataDescriptor#getGroupName()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
	function getGroupName(node:Object):String;
}

}
