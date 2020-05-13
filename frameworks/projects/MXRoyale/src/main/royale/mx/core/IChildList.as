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

COMPILE::SWF
{
    import flash.display.DisplayObject;
}
import org.apache.royale.core.IUIBase;

/**
 *  The IChildList interface defines the properties and methods
 *  for accessing and manipulating child lists, which are subsets
 *  of a DisplayObjectContainer's children.
 *
 *  <p>As an example, consider the Container class.
 *  It overrides DisplayObjectContainer APIs such as the 
 *  <code>numChildren</code> and <code>getChildAt()</code> methods
 *  to access only "content" children, which are the controls
 *  and other containers that you put inside it.
 *  But a Container can also have additional children
 *  created automatically by the framework, such as a background or border
 *  skin and scrollbars.
 *  So Container exposes a property called <code>rawChildren</code> 
 *  of type IChildList, which lets you access all its children,
 *  not just the content children.</p>
 *
 *  <p>As another example, the SystemManager class is a DisplayObjectContainer
 *  whose children are partitioned into various layers:
 *  normal children like the Application are on the bottom,
 *  popups above them, tooltips above them, and cursors on the top.
 *  The SystemManager class has properties named <code>popUpChildren</code>,
 *  <code>toolTipChildren</code>, and <code>cursorChildren</code>
 *  which let you access these layers, and the type of each of these
 *  properties is IChildList.
 *  Therefore, you can count the number of popups using the 
 *  <code>systemManager.popUpChildren.numChildren</code> property,
 *  insert another DisplayObject into the tooltip layer using the 
 *  <code>systemManager.toolTipChildren.addChild()</code> method, and so on.</p>
 *
 *  @see mx.core.Container#rawChildren
 *  @see mx.managers.SystemManager#rawChildren
 *  @see mx.managers.SystemManager#popUpChildren
 *  @see mx.managers.SystemManager#toolTipChildren
 *  @see mx.managers.SystemManager#cursorChildren
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public interface IChildList
{
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------

	//----------------------------------
	//  numChildren
	//----------------------------------

	/**
	 *  The number of children in this child list.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	function get numChildren():int;
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------

    /**
     *  Adds a child DisplayObject after the end of this child list.
     *
	 *  <p>Calling <code>childList.addChild(child)</code> is the same as calling
	 *  <code>childList.addChild(child, childList.numChildren)</code>
	 *  After it has been added, its index of the new child
	 *  will be <code>(child.numChildren - 1)</code></p>
     *
     *  @param child The DisplayObject to add as a child.
     *
     *  @return The child that was added; this is the same
	 *  as the argument passed in.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    [SWFOverride(params="flash.display.DisplayObject", altparams="mx.core.UIComponent", returns="flash.display.DisplayObject"))]
	function addChild(child:IUIComponent):IUIComponent;
	
    /**
     *  Adds a child DisplayObject to this child list at the index specified.
	 *  An index of 0 represents the beginning of the DisplayList,
	 *  and an index of <code>numChildren</code> represents the end.
	 *
	 *  <p>Adding a child anywhere except at the end of a child list
	 *  will increment the indexes of children that were previously
	 *  at that index or at higher indices.</p>
     *
     *  @param child The DisplayObject to add as a child.
	 *
     *  @param index The index to add the child at.
     *
     *  @return The child that was added; this is the same
	 *  as the <code>child</code> argument passed in.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    [SWFOverride(params="flash.display.DisplayObject,int", altparams="mx.core.UIComponent,int", returns="flash.display.DisplayObject"))]
	function addChildAt(child:IUIComponent, index:int):IUIComponent;
	
    /**
     *  Removes the specified child DisplayObject from this child list.
	 *
	 *  <p>Removing a child anywhere except from the end of a child list
	 *  will decrement the indexes of children that were at higher indices.</p>
     *
	 *  <p>The removed child will have its parent set to null and will be
	 *  garbage collected if no other references to it exist.</p>
     *
     *  @param child The DisplayObject to remove.
     *
     *  @return The child that was removed; this is the same
	 *  as the argument passed in.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    [SWFOverride(params="flash.display.DisplayObject", altparams="mx.core.UIComponent", returns="flash.display.DisplayObject"))]
	function removeChild(child:IUIComponent):IUIComponent;
	
    /**
     *  Removes the child DisplayObject at the specified index
	 *  from this child list.
	 *
	 *  <p>Removing a child anywhere except from the end of a child list
	 *  will decrement the indexes of children that were at higher indices.</p>
     *
     *  <p>The removed child will have its parent set to null and will be
	 *  garbage collected if no other references to it exist.</p>
     *
     *  @param index The child index of the DisplayObject to remove.
     *
     *  @return The child that was removed.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */	     
    [SWFOverride(returns="flash.display.DisplayObject"))]
	function removeChildAt(index:int):IUIComponent;
	
	/**
	 *  Gets the child DisplayObject at the specified index in this child list.
	 *
	 *  @param index An integer from 0 to <code>(numChildren - 1)</code>
	 *  that specifies the index of a child in this child list.
	 *
	 *  @return The child at the specified index.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
    [SWFOverride(returns="flash.display.DisplayObject"))]
  	function getChildAt(index:int):IUIComponent;
	
    /**
     *  Gets the child DisplayObject with the specified name
	 *  in this child list.
     *
     *  @param name The name of the child to return.
	 *
     *  @return The child with the specified name.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    [SWFOverride(returns="flash.display.DisplayObject"))]
  	function getChildByName(name:String):IUIComponent;
  	
	/**
	 *  Gets the index of a specific child in this child list.
	 *
	 *  <p>The first child in the child list has an index of 0,
	 *  the second child has an index of 1, and the last child
	 *  has an index of <code>(numChildren - 1)</code>.</p>
	 *
	 *  <p>If <code>getChildIndex(myChild)</code> returns 5,
	 *  then <code>myView.getChildAt(5)</code> returns
	 *  <code>myChild</code>.</p>
	 *
	 *  <p>If you add a child by calling the <code>addChild()</code> method,
	 *  the new child's index is equal to the largest index among the
	 *  existing children plus one.</p>
	 *
	 *  <p>You can insert a child at a specified index by using the
	 *  <code>addChildAt()</code> method
	 *  In that case the children previously at that index and higher
	 *  indices have their index increased by 1 so that all
	 *  children are indexed from 0 to <code>(numChildren - 1)</code>.</p>
	 *
	 *  <p>If you remove a child by calling the <code>removeChild()</code>
	 *  or <code>removeChildAt()</code> method, then the children
	 *  at higher indices have their index decreased by 1 so that
	 *  all children are indexed from 0 to <code>(numChildren - 1)</code>.</p>
	 *
	 *  <p>If you change a child's index by calling the
	 *  <code>setChildIndex()</code> method, then the children between
	 *  the old index and the new index, inclusive, have their indexes
	 *  adjusted so that all children are indexed from
	 *  0 to <code>(numChildren - 1)</code>.</p>
	 *
	 *  @param child The child whose index to get.
	 *
	 *  @return The index of the child, which is an integer
	 *  between 0 and <code>(numChildren - 1)</code>.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
    [SWFOverride(params="flash.display.DisplayObject", altparams="mx.core.UIComponent"))]
  	function getChildIndex(child:IUIComponent):int;
  	
	/**
	 *  Changes the index of a particular child in this child list.
	 *  See the <code>getChildIndex()</code> method for a
	 *  description of the child's index.
	 * 
	 *  @param child The child whose index to set.
	 *
	 *  @param newIndex The new index for the specified child.
	 *  This must be an integer between zero and <code>(numChildren - 1)</code>.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
    [SWFOverride(params="flash.display.DisplayObject,int", altparams="mx.core.UIComponent,int"))]
	function setChildIndex(child:IUIComponent, newIndex:int):void;
	
	/**
	 *  Determines if a DisplayObject is in this child list,
	 *  or is a descendant of an child in this child list.
	 *
	 *  @param child The DisplayObject to test.
	 *
	 *  @return <code>true</code> if the DisplayObject is in this child list
	 *  or is a descendant of an child in this child list;
	 *  <code>false</code> otherwise.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
    [SWFOverride(params="flash.display.DisplayObject", altparams="mx.core.UIComponent"))]
	function contains(child:IUIBase):Boolean;
}

}
