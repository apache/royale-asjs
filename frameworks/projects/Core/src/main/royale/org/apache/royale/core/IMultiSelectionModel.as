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
     *  The IMultiSelectionModel interface describes the minimum set of properties
     *  available to control that let the user select one or more items from within a
     *  set of items in a dataProvider.  A more sophisticated model would
     *  support multiple selection.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.7
     */
	public interface IMultiSelectionModel extends IDataProviderModel
	{
        /**
         *  The indices of the selected items in the
         *  dataProvider.  Null can
         *  have specific meanings but generally means
         *  that no item is selected because the
         *  user has typed in a custom entry or has
         *  yet to make a choice.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.7
         */
        function get selectedIndices():Array;
        function set selectedIndices(value:Array):void;
        
        /**
         *  The data items selected in the
         *  dataProvider.  null usually means
         *  that the user has not selected any value
         *  and has typed in a custom entry.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.7
         */
        function get selectedItems():Array;
        function set selectedItems(value:Array):void;

	}
}
