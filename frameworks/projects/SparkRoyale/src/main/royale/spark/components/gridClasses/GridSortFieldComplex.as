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

package spark.components.gridClasses {

    import spark.collections.ComplexSortField;
    import mx.utils.ObjectUtil;

    [ExcludeClass]

    /**
     *  A subclass of SortField used by DataGrid and GridColumn to keep track
     *  of complex dataFields when trying to reverse the sort.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public class GridSortFieldComplex extends ComplexSortField {
        private var _column:GridColumn;

        /**
         *  Constructor.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10
         *  @playerversion AIR 2.5
         *  @productversion Flex 4.5
         */

        public function GridSortFieldComplex(column:GridColumn, name:String = null, descending:Boolean = false, numeric:Object = null, sortCompareType:String = null, customCompareFunction:Function = null)
        {
            _column = column;
            super(name, descending, numeric, sortCompareType, customCompareFunction);
        }


        override protected function getSortFieldValue(obj:Object):*
        {
            var unformattedValue:* = ObjectUtil.getValue(obj, nameParts);
            return column && column.formatter ? column.formatter.format(unformattedValue) : unformattedValue;
        }

        //--------------------------------------------------------------------------
        //
        //  Properties
        //
        //--------------------------------------------------------------------------

        public function get column():GridColumn
        {
            return _column;
        }
    }
}