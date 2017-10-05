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
package org.apache.royale.collections.parsers
{
    /**
     *  The JSONInputParser class parses a JSON structure
     *  into an array of JSON sub-structures.  It assumes
     *  the input JSON format is an array without sub-arrays.
     *  A more complex parser might be needed for more complex
     *  JSON structures.  
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	public class JSONInputParser implements IInputParser
	{        
        /**
         *  @copy org.apache.royale.net.IInputParser#parseItems
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */        
		public function parseItems(s:String):Array
        {
            var c:int = s.indexOf("[");
            if (c != -1)
            {
                var c2:int = s.lastIndexOf("]");
                s = s.substring(c + 1, c2);
            }
            return s.split("},");
        }
	}
}
