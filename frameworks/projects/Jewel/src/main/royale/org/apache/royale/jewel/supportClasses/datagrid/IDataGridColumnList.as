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
package org.apache.royale.jewel.supportClasses.datagrid
{
    import org.apache.royale.core.IListWithPresentationModel;
    import org.apache.royale.html.supportClasses.IDataGridColumnList;
    import org.apache.royale.jewel.DataGrid;
    import org.apache.royale.utils.IEmphasis;

    /**
     *  The Jewel IDataGridColumnList interface is a marker interface for Jewel DataGrid Column Lists
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.7
     */
    public interface IDataGridColumnList extends org.apache.royale.html.supportClasses.IDataGridColumnList, IEmphasis, IListWithPresentationModel
    {
        function get rollOverIndex():int;
        function set rollOverIndex(value:int):void;

        /**
		 *  Pointer back to the DataGrid that owns this column List
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 */
		function get datagrid():DataGrid;
		function set datagrid(value:DataGrid):void;

        /**
         *  The DataGridColumn for this list
         *  
         *
         *  @toplevel
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.10.0
         */
		function get columnInfo():IDataGridColumn;
		function set columnInfo(value:IDataGridColumn):void;
    }
}