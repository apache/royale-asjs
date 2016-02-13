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
 *  The IVisualElementContainer interface defines the minimum properties and methods 
 *  required for a container to manage Spark components for display.
 *
 *  <p>Note that the Spark SkinnableDataContainer and DataGroup containers 
 *  do not implement this interface. 
 *  Those containers manage their 
 *  children through the <code>dataProvider</code> property.</p>
 *
 *  @see mx.core.IVisualElement
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
public interface IVisualElementContainer
{
    //----------------------------------
    //  Visual Element iteration
    //----------------------------------
    
    /**
     *  The number of visual elements in this container.
     *  Visual elements include classes that implement 
     *  the IVisualElement interface, such as subclasses of
     *  UIComponent and GraphicElement.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    function get numElements():int;
    
    /**
     *  Returns the visual element at the specified index.
     *
     *  @param index The index of the element to retrieve.
     *
     *  @return The element at the specified index.
     * 
     *  @throws RangeError If the index position does not exist in the child list.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */ 
    function getElementAt(index:int):IVisualElement
    
    //----------------------------------
    //  Visual Element addition
    //----------------------------------
    
    /**
     *  Adds a visual element to this container. 
     *  The element is  added after all other elements   
     *  and appears top of all other elements.  
     *  To add a visual element to a specific index position, use 
     *  the <code>addElementAt()</code> method.
     * 
     *  <p>If you add a visual element that already has a different
     *  container as a parent, the element is removed from 
     *  the other container.</p>  
     *
     *  @param element The visual element to add as a child of this container.
     *
     *  @return The element that was added.
     * 
     *  @event elementAdd spark.events.ElementExistenceEvent Dispatched when 
     *  the element is added to the child list.
     * 
     *  @throws ArgumentError If the element is the same as the visual container.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */   
    function addElement(element:IVisualElement):IVisualElement;
    
    /**
     *  Adds a visual element to this container. 
     *  The element is added at the index position specified.  
     *  An index of 0 represents  the first element in the display list.
     * 
     *  <p>If you add a visual element that already has a different
     *  container as a parent, the element is removed from 
     *  the other container.</p>  
     *
     *  @param element The element to add as a child of this visual container.
     * 
     *  @param index The index position to which the element is added. If 
     *  you specify a currently occupied index position, the child 
     *  that exists at that position and all higher positions are moved 
     *  up one position in the child list.
     *
     *  @return The element that was added.
     * 
     *  @event elementAdd spark.events.ElementExistenceEvent Dispatched when 
     *  the element is added to the child list.
     * 
     *  @throws ArgumentError If the element is the same as the container.
     * 
     *  @throws RangeError If the index position does not exist in the child list.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    function addElementAt(element:IVisualElement, index:int):IVisualElement;
    
    //----------------------------------
    //  Visual Element removal
    //----------------------------------
    
    /**
     *  Removes the specified visual element from the child list of 
     *  this container.  
     *  The index positions of any elements 
     *  above the element in this visual container are decreased by 1.
     *
     *  @param element The element to be removed from the container.
     *
     *  @return The element removed.
     * 
     *  @throws ArgumentError If the element parameter is not a child of 
     *  this visual container.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    function removeElement(element:IVisualElement):IVisualElement;
    
    /**
     *  Removes a visual element from the specified index position 
     *  in the container.
     *  The index positions of any elements 
     *  above the element in this visual container are decreased by 1.
     *
     *  @param index The index of the element to remove.
     *
     *  @return The element removed.
     * 
     *  @throws RangeError If the index does not exist in the child list.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    function removeElementAt(index:int):IVisualElement;
    
    /**
     *  Removes all visual elements from the container.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    function removeAllElements():void;
    
    //----------------------------------
    //  Visual Element index
    //----------------------------------
    
    /**
     *  Returns the index position of a visual element.
     *
     *  @param element The visual element.
     *
     *  @return The index position of the element in the container.
     * 
     *  @throws ArgumentError If the element is not a child of this visual container.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */ 
    function getElementIndex(element:IVisualElement):int;
    
    /**
     *  Changes the position of an existing visual element in the visual container.
     * 
     *  <p>When you call the <code>setElementIndex()</code> method and specify an 
     *  index position that is already occupied, the only positions 
     *  that change are those in between the elements's former and new position.
     *  All others stay the same.</p>
     *
     *  <p>If a visual element is moved to an index 
     *  lower than its current index, the index of all elements in between increases
     *  by 1.  If an element is moved to an index
     *  higher than its current index, the index of all elements in between 
     *  decreases by 1.</p>
     *
     *  @param element The element for which you want to change the index number.
     * 
     *  @param index The resulting index number for the element.
     * 
     *  @throws RangeError If the index does not exist in the child list.
     *
     *  @throws ArgumentError If the element parameter is not a child 
     *  of this visual container.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    function setElementIndex(element:IVisualElement, index:int):void;
    
    //----------------------------------
    //  Visual Element swapping
    //----------------------------------
    
    /**
     *  Swaps the index of the two specified visual elements. All other elements
     *  remain in the same index position.
     *
     *  @param element1 The first visual element.
     * 
     *  @param element2 The second visual element.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    function swapElements(element1:IVisualElement, element2:IVisualElement):void;
    
    /**
     *  Swaps the visual elements at the two specified index 
     *  positions in the  container.  
     *  All other visual elements remain in the same index position.
     *
     *  @param index1 The index of the first element.
     * 
     *  @param index2 The index of the second element.
     * 
     *  @throws RangeError If either index does not exist in 
     *  the visual container.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    function swapElementsAt(index1:int, index2:int):void;

}

}
