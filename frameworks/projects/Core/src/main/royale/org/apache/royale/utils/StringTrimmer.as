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
package org.apache.royale.utils
{

	/**
	 *  The StringTrimmer class is a collection of static functions that provide utility
	 *  features for trimming whitespace off Strings.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class StringTrimmer
	{
		/**
		 * @private
		 */
		public function StringTrimmer()
		{
			throw new Error("StringTrimmer should not be instantiated.");
		}
		
        /**
         *  Removes all whitespace characters from the beginning and end
         *  of the specified string.
         *
         *  @param str The String whose whitespace should be trimmed. 
         *
         *  @return Updated String where whitespace was removed from the 
         *  beginning and end. 
         *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
         */
		COMPILE::SWF
        public static function trim(str:String):String
        {
            if (str == null) return '';
            
            var startIndex:int = 0;
            while (isWhitespace(str.charAt(startIndex)))
                ++startIndex;
            
            var endIndex:int = str.length - 1;
            while (isWhitespace(str.charAt(endIndex)))
                --endIndex;
            
            if (endIndex >= startIndex)
                return str.slice(startIndex, endIndex + 1);
            else
                return "";
        }
		
		COMPILE::JS
		public static function trim(str:String):String
		{
			if (str == null) return '';
			return str.trim();
		}

        /**
         *  Removes all whitespace characters from the beginning and end
         *  of each element in an Array, where the Array is stored as a String. 
         *
         *  @param value The String whose whitespace should be trimmed. 
         *
         *  @param separator The String that delimits each Array element in the string.
         *
         *  @return Array where whitespace was removed from the 
         *  beginning and end of each element. 
         *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
         */
        public static function splitAndTrim(value:String, delimiter:String):Array
        {
            if (value != "" && value != null)
            {
                var items:Array = value.split(delimiter);
                
                var len:int = items.length;
                for (var i:int = 0; i < len; i++)
                {
                    items[i] = StringTrimmer.trim(items[i]);
                }
                return items;
            }
            
            return [];
        }
        
        /**
         *  Removes all whitespace characters from the beginning and end
         *  of each element in an Array, where the Array is stored as a String. 
         *
         *  @param value The String whose whitespace should be trimmed. 
         *
         *  @param separator The String that delimits each Array element in the string.
         *
         *  @return Updated String where whitespace was removed from the 
         *  beginning and end of each element. 
         *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
         */
        public static function trimArrayElements(value:String, delimiter:String):String
        {
            if (value != "" && value != null)
            {
                var items:Array = splitAndTrim(value, delimiter);
                if (items.length > 0)
                {
                    value = items.join(delimiter);
                }
            }
            
            return value;
        }
        
        /**
         *  Returns <code>true</code> if the specified string is
         *  a single space, tab, carriage return, newline, or formfeed character.
         *
         *  @param str The String that is is being queried. 
         *
         *  @return <code>true</code> if the specified string is
         *  a single space, tab, carriage return, newline, or formfeed character.
         *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
         */
        public static function isWhitespace(character:String):Boolean
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
}
