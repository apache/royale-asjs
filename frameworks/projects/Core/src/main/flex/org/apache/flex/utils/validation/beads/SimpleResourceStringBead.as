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
package org.apache.flex.utils.validation.beads
{
    import org.apache.flex.core.IBead;
    import org.apache.flex.core.IStrand;
    import org.apache.flex.events.Event;
    import org.apache.flex.core.Strand;

    public class SimpleResourceStringBead implements IBead
    {
        public function SimpleResourceStringBead()
        {
            
        }

        private var _strand:Strand;
        /**
         * @flexjsignorecoercion HTMLElement
         */
        public function set strand(value:IStrand):void
        {
            _strand = value as Strand;
            _strand.addEventListener("beadsAdded",applyResources);
        }
        private function applyResources(ev:Event):void
        {
            if(resources)
            {
                for(var x:String in resources)
                {
                    _strand[x] = resources[x];
                }
            }
        }
        public var resources:Object;
    }
}