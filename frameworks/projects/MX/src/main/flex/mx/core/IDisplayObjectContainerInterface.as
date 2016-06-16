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

/*
 *  The IDisplayObjectContainerInterface defines the basic set of APIs
 *  for web version of flash.display.DisplayObjectContainer
 *  
 */
COMPILE::SWF
{
	import flash.display.DisplayObjectContainer;		
}
COMPILE::LATER
{
import flash.text.TextSnapshot;
import flash.geom.Point;
}

    /**
     *  @copy flash.display.DisplayObjectContainer#addChild()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
	COMPILE::SWF
    function addChild(child:flash.display.DisplayObject):flash.display.DisplayObject;
	COMPILE::JS
	function addChild(child:DisplayObject):DisplayObject;
   
    /**
     *  @copy flash.display.DisplayObjectContainer#addChildAt()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
	COMPILE::SWF
	function addChildAt(child:flash.display.DisplayObject, index:int):flash.display.DisplayObject;
	COMPILE::JS
    function addChildAt(child:DisplayObject, index:int):DisplayObject;
    
    /**
     *  @copy flash.display.DisplayObjectContainer#removeChild()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
	COMPILE::SWF
    function removeChild(child:flash.display.DisplayObject):flash.display.DisplayObject;
	COMPILE::JS
	function removeChild(child:DisplayObject):DisplayObject;
    
    /**
     *  @copy flash.display.DisplayObjectContainer#removeChildAt()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
	COMPILE::SWF
    function removeChildAt(index:int):flash.display.DisplayObject;
	COMPILE::JS
	function removeChildAt(index:int):DisplayObject;

    /**
     *  @copy flash.display.DisplayObjectContainer#getChildIndex()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
	COMPILE::SWF
    function getChildIndex(child:flash.display.DisplayObject):int;
	COMPILE::JS
	function getChildIndex(child:DisplayObject):int;
    
    /**
     *  @copy flash.display.DisplayObjectContainer#setChildIndex()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
	COMPILE::SWF
    function setChildIndex(child:flash.display.DisplayObject, index:int):void;
	COMPILE::JS
	function setChildIndex(child:DisplayObject, index:int):void;

    /**
     *  @copy flash.display.DisplayObjectContainer#getChildAt()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
	COMPILE::SWF
    function getChildAt(index:int):flash.display.DisplayObject;
	COMPILE::JS
	function getChildAt(index:int):DisplayObject;
    
    /**
     *  @copy flash.display.DisplayObjectContainer#getChildByName()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
	COMPILE::SWF
    function getChildByName(name:String):flash.display.DisplayObject;
	COMPILE::JS
	function getChildByName(name:String):DisplayObject;

    /**
     *  @copy flash.display.DisplayObjectContainer#numChildren
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get numChildren():int;

    /**
     *  @copy flash.display.DisplayObjectContainer#textSnapshot
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
	COMPILE::LATER
    function get textSnapshot():TextSnapshot;
    
    /**
     *  @copy flash.display.DisplayObjectContainer#getObjectsUnderPoint()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
	COMPILE::LATER
    function getObjectsUnderPoint(point:Point):Array;

    /**
     *  @copy flash.display.DisplayObjectContainer#areInaccessibleObjectsUnderPoint()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
	COMPILE::LATER
    function areInaccessibleObjectsUnderPoint(point:Point):Boolean;

    /**
     *  Determines whether the children of the object are tab enabled. 
     *  
     *  <p><b>Note:</b> Do not use this property with Flex.
     *  Instead, use the <code>UIComponent.hasFocusableChildren</code> property.</p>
     *
     *  @see mx.core.UIComponent#hasFocusableChildren
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
	COMPILE::LATER
    function get tabChildren():Boolean;
	COMPILE::LATER
    function set tabChildren(enable:Boolean):void;
    
    /**
     *  @copy flash.display.DisplayObjectContainer#mouseChildren
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
	COMPILE::LATER
    function get mouseChildren():Boolean;
	COMPILE::LATER
    function set mouseChildren(enable:Boolean):void;

    /**
     *  @copy flash.display.DisplayObjectContainer#contains()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
	COMPILE::SWF
    function contains(child:flash.display.DisplayObject):Boolean;
	COMPILE::JS
	function contains(child:DisplayObject):Boolean;

    /**
     *  @copy flash.display.DisplayObjectContainer#swapChildrenAt()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
	COMPILE::LATER
    function swapChildrenAt(index1:int, index2:int):void;

    /**
     *  @copy flash.display.DisplayObjectContainer#swapChildren()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
	COMPILE::LATER
    function swapChildren(child1:DisplayObject, child2:DisplayObject):void;
