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

        var labelField:String;
        var value:String;

        if (obj["labelField"]) 
        {
            labelField = obj["labelField"];
            value = "" + data[labelField];
            COMPILE::JS
            {
                // support XML data in JS (in libraries without access to XML class)
                if (value == "undefined")
                {
                    if (labelField.charAt(0) == '@')
                    {
                        var fal:* = data["attribute"];
                        if (fal && typeof(fal) === "function")
                            value = fal(labelField);
                    }
                    else
                    {
                        var fcl:* = data["child"];
                        if (fcl && typeof(fcl) === "function")
                            value = fcl(labelField).toString();
                    }
                }
            }
            return value;
        }

        if (obj["dataField"]) 
        {
            labelField = obj["dataField"];
            value = "" + data[labelField];
            COMPILE::JS
            {
                // support XML data in JS (in libraries without access to XML class)
                if (value == "undefined")
                {
                    if (labelField.charAt(0) == '@')
                    {
                        var fad:* = data["attribute"];
                        if (fad && typeof(fad) === "function")
                            value = fad(labelField);
                    }
                    else
                    {
                        var fcd:* = data["child"];
                        if (fcd && typeof(fcd) === "function")
                            value = fcd(labelField).toString();
                    }
                }
            }
            return value;
        }

        value = data["label"];
        if (value != null)
            return value;

        return "" + data;
    }
}
