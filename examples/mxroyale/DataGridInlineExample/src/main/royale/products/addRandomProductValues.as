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



    public function addRandomProductValues(product:Product):void {
        //marketShare:Number
        product.marketShare = (50 + uint(Math.random() * 950))/1000;

        //marketShare:Number
        product.productGroup = productGroups[uint(Math.random()* productGroups.length)];

        //budget:Number 50K -> 1M
        product.budget = (50000 + uint(Math.random() * 20)*50000);

    }

}
var productGroups:Array =['Shooting Stars', 'Stable', 'Unproven', 'CashCows', 'MoneyPits'];