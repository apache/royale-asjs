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
package org.apache.royale.language
{
	COMPILE::JS
	{
		import XML; XML;
		import XMLList; XMLList;
        import org.apache.royale.debugging.notNull;
	}
    /**
     * @royaleignorecoercion XML
     * @royaleignorecoercion XMLList
     */
    COMPILE::JS
    public function toXMLList(value:*):XMLList
    {
        notNull(value);
        if(value is XMLList)
            return value as XMLList;
        if(value is XML)
            return new XMLList(value);
        // Anything other than bool, string or number should cause an error.
        switch(typeof value)
        {
            case "boolean":
            case "number":
            case "string":
                break;
            default:
                throw new Error("Incompatible type!");
        }
        return new XMLList(value);
    }
}
