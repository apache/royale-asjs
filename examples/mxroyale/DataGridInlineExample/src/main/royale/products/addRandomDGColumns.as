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
package products {

    import mx.controls.dataGridClasses.DataGridColumn;

    public function addRandomDGColumns(base:Array, max:int=3 , force:int=-1):void {

        var rand:int = force == -1 ? 1 + uint(Math.random() * max) : force;
        var col:DataGridColumn = new DataGridColumn('Market Share');
        col.width = 120;
        col.dataField = 'marketShare';
        rand--;
        base.push(col);
        if (rand){
            col = new DataGridColumn('Product Group');
            col.width = 120;
            col.dataField = 'productGroup';
            base.push(col);
            rand--;

        }


        if (rand){
            col = new DataGridColumn('Budget');
            col.width = 120;
            col.dataField = 'budget';
            base.push(col);
            rand--;
        }

    }

}
