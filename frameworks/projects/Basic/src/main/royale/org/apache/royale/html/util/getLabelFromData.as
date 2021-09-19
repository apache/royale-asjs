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
package org.apache.royale.html.util
{

    /**
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.3
     * Utility function to get a label string from a value object
     */
    public function getLabelFromData(obj:Object,data:Object):String
    {
        // slightly more code, but we bail early if it's a string which is often
        if (data is String) return "" + data;
        if(!data) return "";

        if (obj["labelField"]) return "" + data[obj["labelField"]];
        if (obj["dataField"]) return "" + data[obj["dataField"]];
        var label:String = data["label"];
        if(label != null){
            return label;
        }
        return "" + data;

    }
}
