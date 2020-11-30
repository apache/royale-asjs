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
package org.apache.royale.core
{
    /**
     *  The IParent interface is the basic interface for a 
     *  component that contains subcomponents, including the
     *  application class.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    public interface IParent
	{
        /**
         *  Add a component to the parent.
         * 
         *  @param c The subcomponent to add.
         *  @param dispatchEvent Whether to dispatch an event after adding the child.
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        function addElement(c:IChild, dispatchEvent:Boolean = true):void;

        /**
         *  Add a component to the parent at the specified index.
         * 
         *  @param c The subcomponent to add.
         *  @param c The index where the subcomponent should be added.
         *  @param dispatchEvent Whether to dispatch an event after adding the child.
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        function addElementAt(c:IChild, index:int, dispatchEvent:Boolean = true):void;
        
        /**
         *  Gets the index of this subcomponent.
         * 
         *  @param c The subcomponent to retrieve the index.
         *  @return The index (zero-based).
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        function getElementIndex(c:IChild):int;

        /**
         *  Remove a component from the parent.
         * 
         *  @param c The subcomponent to remove.
         *  @param dispatchEvent Whether to dispatch an event after removing the child.
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
       function removeElement(c:IChild, dispatchEvent:Boolean = true):void;
       
       /**
        *  The number of elements in the parent.
        * 
        *  @langversion 3.0
        *  @playerversion Flash 10.2
        *  @playerversion AIR 2.6
        *  @productversion Royale 0.0
        */
       function get numElements():int;

       /**
        *  Get a component from the parent at specified index.
        * 
        *  @param c The index of the subcomponent.
        * 
        *  @langversion 3.0
        *  @playerversion Flash 10.2
        *  @playerversion AIR 2.6
        *  @productversion Royale 0.0
        */
       function getElementAt(index:int):IChild;

    }
}
