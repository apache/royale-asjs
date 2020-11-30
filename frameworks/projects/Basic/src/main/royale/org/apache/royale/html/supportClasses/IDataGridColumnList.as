////////////////////////////////////////////////////////////////////////////////
//
//  Licensed to the Apache Software Foundation (ASF) under one or more
//  contributor license agreements.  See the NOTICE file distributed with
//  this work for additional information regarding copyright ownership.
//  The ASF licenses this file to You under the Apache License, Version 2.0
//  (the "Licens"); you may not use this file except in compliance with
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
package org.apache.royale.html.supportClasses
{
    import org.apache.royale.core.IList;
    import org.apache.royale.core.IStrand;
    import org.apache.royale.events.IEventDispatcher;

    /**
     *  The IDataGridColumnList interface is a marker interface for DataGrid Column Lists
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.3
     */
    public interface IDataGridColumnList extends IList, IStrand, IEventDispatcher
    {
        function set className(value:String):void;
        
        /**
         *  The property on the data item that the item renderer
         *  should renderer.
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		function get labelField():String;
        function set labelField(value:String):void;

        function set dataProvider(value:Object):void;
        function get selectedIndex():int;
        function set selectedIndex(value:int):void;
        function set id(value:String):void;
    }
}