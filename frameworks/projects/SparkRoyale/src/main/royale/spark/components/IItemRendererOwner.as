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

package spark.components
{

import mx.core.IVisualElement;

/**
 *  The IItemRendererOwner interface defines the basic set of APIs
 *  that a class must implement to  support items renderers. 
 *  A class  that implements the IItemRendererOwner interface 
 *  is called the host component of the item renderer.
 *  
 *  <p>The class defining the item renderer must implement the 
 *  IItemRenderer interface.</p> 
 *  
 *  @see spark.components.IItemRenderer
 *
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 *  
 */
public interface IItemRendererOwner
{

    /**
     *  Returns the String for display in an item renderer.
     *  The String is written to the <code>labelText</code>
     *  property of the item renderer.
     *
     *  @param item The data item to display.
     *
     *  @return The String for display in an item renderer.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    function itemToLabel(item:Object):String;
    
    /**
     *  Updates the renderer for reuse. 
     *  This method first prepares the item
     *  renderer for reuse by cleaning out any stale properties
     *  as well as updating it with new properties.
     * 
     *  <p>The last thing this method should do is set the <code>data</code> property 
     *  of the item renderer.</p>    
     *
     *  @param renderer The item renderer.
     *  @param itemIndex The index of the data in the data provider.
     *  @param data The data object this item renderer is representing.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    function updateRenderer(renderer:IVisualElement, itemIndex:int, data:Object):void;  

}   
}
