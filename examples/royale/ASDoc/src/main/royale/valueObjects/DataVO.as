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
package valueObjects
{
    public class DataVO
    {
        public function DataVO(params:Object)
        {
            baseClassname = params["baseClassname"] || "";
            if(params["baseInterfaceNames"])
                baseInterfaceNames = params["baseInterfaceNames"];

            if(params["events"])
                events = params["events"];
            
            if(params["members"])
                members = params["members"];
            
            qname = params["qname"] || "";

            if(params["tags"])
                tags = params["tags"];
                
            type = params["type"] || "";
        }
        public var baseClassname:String;
        public var baseInterfaceNames:Array;
        public var events:Array;
        public var members:Array;
        public var qname:String;
        public var tags:Array;
        public var type:String;
    }
}
