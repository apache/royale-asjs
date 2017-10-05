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
     *  The IInputParser interface is the basic interface for parsing
     *  data from a server or database into an array of items.
     * 
     *  This interface is generally used in a LazyCollection.
     *  @see org.apache.royale.net.dataConverters.LazyCollection.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	public interface IInputParser
	{
        /**
         *  Take the input string (could be serialized data set,
         *  XML, or JSON) and return an array of serialized data
         *  items.
         * 
         *  @param s Serialized data set, XML or JSON.
         *  @return An Array of serialized data items.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		function parseItems(s:String):Array;
	}
}
