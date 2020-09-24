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

import spark.components.IItemRendererOwner; 
import mx.core.IDataRenderer;
import mx.core.IVisualElement; 

/**
 *  The IItemRenderer interface defines the basic set of APIs
 *  that a class must implement to create an item renderer that can 
 *  communicate with a host component.
 *  The host component, such as the List or ButtonBar controls, 
 *  must implement the IItemRendererOwner interface. 
 *   
 *  
 *  @see spark.components.IItemRendererOwner
 *
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 *  
 */
public interface IItemRenderer extends IDataRenderer, IVisualElement
{
    
    /**
     *  The index of the item in the data provider
     *  of the host component of the item renderer.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     *  
     */
    function get itemIndex():int;
    function set itemIndex(value:int):void;
    
    /**
     *  Contains <code>true</code> if the item renderer is being dragged.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     *  
     */
    function get dragging():Boolean;
    function set dragging(value:Boolean):void;

    /**
     *  The String to display in the item renderer. 
     *
     *  <p>The host component of the item renderer can use the 
     *  <code>itemToLabel()</code> method to convert the data item 
     *  to a String for display by the item renderer. </p>
     * 
     *  <p>For controls like List and ButtonBar, you can use the 
     *  <code>labelField</code> or <code>labelFunction</code> properties 
     *  to specify the field of the data item that contains the String.
     *  Otherwise the host component uses the <code>toString()</code> method 
     *  to convert the data item to a String. </p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     *  
     */
    function get label():String;
    function set label(value:String):void;
    
    /**
     *  Contains <code>true</code> if the item renderer 
     *  can show itself as selected.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     *  
     */
    function get selected():Boolean;
    function set selected(value:Boolean):void;

    /**
     *  Contains <code>true</code> if the item renderer 
     *  can show itself as focused. 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     *  
     */
    function get showsCaret():Boolean;
    function set showsCaret(value:Boolean):void;
}

}
