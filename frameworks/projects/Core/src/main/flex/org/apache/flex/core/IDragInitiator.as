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
     *  The IDragInitiator interface is the basic interface for the object that
     *  wants to know if a drop was accepted in a drag/drop operation.
     * 
     *  There are two methods instead of the usual one because in some scenarios
     *  the drag initiator needs to prepare the data before it gets dropped.
     *  For example, in a tree control, dragging from one node to another, 
     *  the tree should un-parent the node before it is moved to the
     *  new parent node, so the tree would un-parent the node in acceptingDrop.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	public interface IDragInitiator
	{
        /**
         *  This method is called to notify the dragInitiator
         *  that you want to accept a drop.
         *
         *  @param type The type of drop accepted.  Allowed
         *  values are in org.apache.royale.core.DropType.
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		function acceptingDrop(dropTarget:Object, type:String):void

        /**
         *  This method is called to notify the dragInitiator
         *  that you have accepted the drop.
         *
         *  @param type The type of drop accepted.  Allowed
         *  values are in org.apache.royale.core.DropType.
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        function acceptedDrop(dropTarget:Object, type:String):void

    }
}
