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
 *  The IRepeaterClient interface defines the APIs for components
 *  that can have multiple instances created by a Repeater.
 *  The IRepeaterClient interface is implemented by the UIComponent class
 *  and so is inherited by all Flex framework controls and containers.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public interface IRepeaterClient
{
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  instanceIndices
    //----------------------------------

    /**
     *  An Array that contains the indices required
     *  to reference the repeated component instance from its document. 
     *  This Array is empty unless the component
     *  is within one or more Repeaters.
     *  The first element corresponds to the outermost Repeater.
     *  For example, if the <code>id</code> is <code>"b"</code>
     *  and <code>instanceIndices</code> is <code>[ 2, 4 ]</code>,
     *  you would reference it on the document as <code>b[2][4]</code>.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get instanceIndices():Array;
    
    /**
     *  @private
     */
    function set instanceIndices(value:Array):void;
    
    //----------------------------------
    //  isDocument
    //----------------------------------

    /**
     *  @copy mx.core.UIComponent#isDocument
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get isDocument():Boolean;

    //----------------------------------
    //  repeaterIndices
    //----------------------------------

    /**
     *  An Array that contains the indices of the items in the data
     *  providers of the Repeaters that produced the component.
     *  The Array is empty unless the component is within one or more
     *  Repeaters.
     *  The first element corresponds to the outermost Repeater component.
     *  For example, if <code>repeaterIndices</code> is <code>[ 2, 4 ]</code>,
     *  the outer Repeater component used its <code>dataProvider[2]</code>
     *  data item and the inner Repeater component used its
     *  <code>dataProvider[4]</code> data item.
     *
     *  <p>This property differs from <code>instanceIndices</code>
     *  if the <code>startingIndex</code> of any of the Repeater components
     *  is non-zero.
     *  For example, even if a Repeater component starts at
     *  <code>dataProvider</code> item 4, the document reference of the first
     *  repeated component is <code>b[0]</code>, not <code>b[4]</code>.</p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get repeaterIndices():Array;
    
    /**
     *  @private
     */
    function set repeaterIndices(value:Array):void;

    //----------------------------------
    //  repeaters
    //----------------------------------

    /**
     *  An Array that contains any enclosing Repeaters of the component.
     *  The Array is empty unless the component is within one or more Repeaters.
     *  The first element corresponds to the outermost Repeater. 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function get repeaters():Array;
    
    /**
     *  @private
     */
    function set repeaters(value:Array):void;

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     *  Initializes the <code>instanceIndices</code>,
     *  <code>repeaterIndices</code>, and <code>repeaters</code> properties.
     *
     *  <p>This method is called by the Flex framework.
     *  Developers should not need to call it.</p>
     *  
     *  @param parent The parent Repeater that created this component.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    function initializeRepeaterArrays(parent:IRepeaterClient):void;
}

}
