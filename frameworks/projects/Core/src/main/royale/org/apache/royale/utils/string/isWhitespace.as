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
package org.apache.royale.utils.string
{
            /**
         *  Returns <code>true</code> if the specified string is
         *  a single space, tab, carriage return, newline, or formfeed character.
         *
         *  @return <code>true</code> if the specified string is
         *  a single space, tab, carriage return, newline, or formfeed character.
         *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
         *  @royalesuppressexport
         */
        public function isWhitespace(character:String):Boolean
        {
            switch (character)
            {
                case " ":
                case "\t":
                case "\r":
                case "\n":
                case "\f":
                    // non breaking space
                case "\u00A0":
                    // line seperator
                case "\u2028":
                    // paragraph seperator
                case "\u2029":
                    // ideographic space
                case "\u3000":
                    return true;
                    
                default:
                    return false;
            }
        }
}