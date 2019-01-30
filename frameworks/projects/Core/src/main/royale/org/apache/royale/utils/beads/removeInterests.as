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
package org.apache.royale.utils.beads
{
    import org.apache.royale.core.IBead;

    /**
     * @royaleignorecoercion String
     * 
     */
    public function removeInterests(lookup:Object,bead:IBead):void
    {
        var interests:Array = bead.listInterests();
        for(var i:int=0;i<interests.length;i++)
        {
            var interestArr:Array = lookup[interests[i]];
            var interest:String = interests[i] as String;
            var index:int = interestArr.indexOf(bead);
            interestArr.splice(index,1);
        }
        
    }
}