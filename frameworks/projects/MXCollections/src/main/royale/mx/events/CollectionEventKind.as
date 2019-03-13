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

package mx.events
{

/**
 *  The CollectionEventKind class contains constants for the valid values 
 *  of the mx.events.CollectionEvent class <code>kind</code> property.
 *  These constants indicate the kind of change that was made to the collection.
 *
 *  @see mx.events.CollectionEvent
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public final class CollectionEventKind
{
    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    /**
     *  Indicates that the collection added an item or items.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static const ADD:String = "add";

    /**
     *  Indicates that the item has moved from the position identified
     *  by the CollectionEvent <code>oldLocation</code> property to the 
	 *  position identified by the <code>location</code> property.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static const MOVE:String = "move";

    /**
     *  Indicates that the collection applied a sort, a filter, or both.
     *  This change can potentially be easier to handle than a RESET.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static const REFRESH:String = "refresh";

    /**
     *  Indicates that the collection removed an item or items.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static const REMOVE:String = "remove";

    /**
     *  Indicates that the item at the position identified by the 
     *  CollectionEvent <code>location</code> property has been replaced.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static const REPLACE:String = "replace";

    /**
    *  Indicates that the collection has internally expanded. 
    *  This event kind occurs when a branch opens in a 
	*  hierarchical collection, for example when a Tree control branch opens.
    *  
    *  @langversion 3.0
    *  @playerversion Flash 9
    *  @playerversion AIR 1.1
    *  @productversion Flex 3
    */
    public static const EXPAND:String = "expand";

    /**
     *  Indicates that the collection has changed so drastically that
     *  a reset is required.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static const RESET:String = "reset";

    /**
     *  Indicates that one or more items were updated within the collection.
     *  The affected item(s) 
     *  are stored in the <code>items</code> property.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static const UPDATE:String = "update";
}

}
