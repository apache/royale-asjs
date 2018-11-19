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
package spark.core
{

/**
 *  The IGraphicElementContainer is the minimal contract for a container class to 
 *  support <code>IGraphicElement</code> children.
 *
 *  <p>Typically instead of directly implementing this interface, a developer
 *  would sub-class Group which already implements the IGraphicElementContainer interface.</p>
 *  
 *  @see spark.core.IGraphicElement
 *
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 2.0
 *  @productversion Flex 4.5
 */
public interface IGraphicElementContainer
{
    /**
     *  Notify the host component that an element layer has changed.
     *
     *  <p>The <code>IGraphicElementContainer</code> must re-evaluates the sequences of 
     *  graphic elements with shared DisplayObjects and may need to re-assign the 
     *  DisplayObjects and redraw the sequences as a result.</p>
     * 
     *  <p>Typically the host will perform this in its 
     *  <code>validateProperties()</code> method.</p>
     *
     *  @param element The element that has changed size.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.0
     *  @productversion Flex 4.5
     */
    function invalidateGraphicElementSharing(element:IGraphicElement):void

    /**
     *  Notify the host component that an element changed and needs to validate properties.
     * 
     *  <p>The <code>IGraphicElementContainer</code> must call the <code>validateProperties()</code>
     *  method on the IGraphicElement to give it a chance to commit its properties.</p>
     * 
     *  <p>Typically the host will validate the elements' properties in its
     *  <code>validateProperties()</code> method.</p>
     *
     *  @param element The element that has changed.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.0
     *  @productversion Flex 4.5
     */
    function invalidateGraphicElementProperties(element:IGraphicElement):void;
    
    /**
     *  Notify the host component that an element size has changed.
     * 
     *  <p>The <code>IGraphicElementContainer</code> must call the <code>validateSize()</code>
     *  method on the IGraphicElement to give it a chance to validate its size.</p>
     * 
     *  <p>Typically the host will validate the elements' size in its
     *  <code>validateSize()</code> method.</p>
     *
     *  @param element The element that has changed size.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.0
     *  @productversion Flex 4.5
     */
    function invalidateGraphicElementSize(element:IGraphicElement):void;
    
    /**
     *  Notify the host component that an element has changed and needs to be redrawn.
     * 
     *  <p>The <code>IGraphicElementContainer</code> must call the <code>validateDisplayList()</code>
     *  method on the IGraphicElement to give it a chance to redraw.</p>
     * 
     *  <p>Typically the host will validate the elements' display lists in its
     *  <code>validateDisplayList()</code> method.</p>
     *
     *  @param element The element that has changed.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.0
     *  @productversion Flex 4.5
     */
    function invalidateGraphicElementDisplayList(element:IGraphicElement):void;
}
}