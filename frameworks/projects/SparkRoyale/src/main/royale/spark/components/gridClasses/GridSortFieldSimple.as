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
    import mx.utils.ObjectUtil;

    import spark.collections.SortField;

    public class GridSortFieldSimple extends SortField {
        private var _column:GridColumn;

        public function GridSortFieldSimple(column:GridColumn, name:String = null, descending:Boolean = false, numeric:Object = null, sortCompareType:String = null, customCompareFunction:Function = null)
        {
            _column = column;
            super(name, descending, numeric, sortCompareType, customCompareFunction);
        }

        public function get column():GridColumn
        {
            return _column;
        }

        override protected function getSortFieldValue(obj:Object):*
        {
            var unformattedValue:* = ObjectUtil.getValue(obj, [name]);
            return column && column.formatter ? column.formatter.format(unformattedValue) : unformattedValue;
        }
    }
}
