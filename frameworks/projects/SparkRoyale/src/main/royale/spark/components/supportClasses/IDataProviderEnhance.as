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

package spark.components.supportClasses
{

    // import flash.events.IEventDispatcher;
	import org.apache.royale.events.IEventDispatcher;
    import mx.collections.IList;
    import spark.components.supportClasses.RegExPatterns;


    /**
    *  Adds functionality to list driven components.
    *
    *  @langversion 3.0
    *  @playerversion Flash 11.1
    *  @playerversion AIR 3.4
    *  @productversion Flex 4.10
    */
    public interface IDataProviderEnhance extends IEventDispatcher
    {
        //--------------------------------------------------------------------------------
        //
        //  Variables
        //
        //--------------------------------------------------------------------------------


        //--------------------------------------------------------------------------------
        //
        //  Getters / Setters
        //
        //--------------------------------------------------------------------------------

        /**
        *  Returns if the selectedIndex is equal to the first row.
        *
        *  @langversion 3.0
        *  @playerversion Flash 11.1
        *  @playerversion AIR 3.4
        *  @productversion Flex 4.10
        */
        function get isFirstRow():Boolean;


        /**
        *  Returns if the selectedIndex is equal to the last row.
        *
        *  @langversion 3.0
        *  @playerversion Flash 11.1
        *  @playerversion AIR 3.4
        *  @productversion Flex 4.10
        */
        function get isLastRow():Boolean;


        //--------------------------------------------------------------------------------
        //
        //  Methods
        //
        //--------------------------------------------------------------------------------

        /**
        *  This will search through a dataprovider checking the given field and for the given value and return the index for the match.
        *  It can start the find from a given startingIndex;
        *
        *  @langversion 3.0
        *  @playerversion Flash 11.1
        *  @playerversion AIR 3.4
        *  @productversion Flex 4.10
        */
        function findRowIndex(field:String, value:String, startingIndex:int = 0, patternType:String = RegExPatterns.EXACT):int;


        /**
        *  This will search through a dataprovider checking the given field and for the given values and return an array of indexes that matched.
        *
        *  @langversion 3.0
        *  @playerversion Flash 11.1
        *  @playerversion AIR 3.4
        *  @productversion Flex 4.10
        */
        function findRowIndices(field:String, values:Array, patternType:String = RegExPatterns.EXACT):Array;


        /**
        *  Changes the selectedIndex to the first row of the dataProvider.
        *
        *  @langversion 3.0
        *  @playerversion Flash 11.1
        *  @playerversion AIR 3.4
        *  @productversion Flex 4.10
        */
        function moveIndexFirstRow():void;


        /**
        *  Changes the selectedIndex to the last row of the dataProvider.
        *
        *  @langversion 3.0
        *  @playerversion Flash 11.1
        *  @playerversion AIR 3.4
        *  @productversion Flex 4.10
        */
        function moveIndexLastRow():void;


        /**
        *  Changes the selectedIndex to the next row of the dataProvider.  If there isn't a current selectedIndex, it silently returns.
        *  If the selectedIndex is on the first row, it does not wrap around.  However the <code>isFirstRow</code> property returns true.
        *
        *  @langversion 3.0
        *  @playerversion Flash 11.1
        *  @playerversion AIR 3.4
        *  @productversion Flex 4.10
        */
        function moveIndexNextRow():void;


        /**
        *  Changes the selectedIndex to the previous row of the dataProvider.  If there isn't a current selectedIndex, it silently returns.
        *  If the selectedIndex is on the last row, it does not wrap around.  However the <code>isLastRow</code> property returns true.
        *
        *  @langversion 3.0
        *  @playerversion Flash 11.1
        *  @playerversion AIR 3.4
        *  @productversion Flex 4.10
        */
        function moveIndexPreviousRow():void;


        /**
        *  This will search through a dataprovider checking the given field and will set the selectedIndex to a matching value.
        *  It can start the search from the startingIndex;
        *
        *  @langversion 3.0
        *  @playerversion Flash 11.1
        *  @playerversion AIR 3.4
        *  @productversion Flex 4.10
        *
        */
        function moveIndexFindRow(field:String, value:String, startingIndex:int = 0, patternType:String = RegExPatterns.EXACT):Boolean;

    }
}
