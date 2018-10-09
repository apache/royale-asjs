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

package spark.components.supportClasses
{
    /**
    *  This provides a means to standardize certain common regex patterns and functionality.
    *  
    *  <p>Use the constants in ActionsScript, as the following example shows: </p>
    *  <pre>
    *    createRegExp("my search value", RegExPatterns.CONTAINS):RegExp
    *  </pre>
    *  
    *  @langversion 3.0
    *  @playerversion Flash 11.1
    *  @playerversion AIR 3.4
    *  @productversion Flex 4.10
    */
    public final class RegExPatterns
    {
        /**
        *  Constructor.
        * 
        *  @langversion 3.0
        *  @playerversion Flash 11.1
        *  @playerversion AIR 3.4
        *  @productversion Flex 4.10
        */
        public function RegExPatterns()
        {
        }


        //--------------------------------------------------------------------------------
        //
        //  Static Const Variables
        //
        //--------------------------------------------------------------------------------

        /**
        *  Specifies the use of a regex pattern matching the end with a given value.
        * 
        *  @langversion 3.0
        *  @playerversion Flash 11.1
        *  @playerversion AIR 3.4
        *  @productversion Flex 4.10
        */
        public static const CONTAINS:String = "contains";


        /**
        *  Specifies the use of a regex pattern matching the end with a given value.
        * 
        *  @langversion 3.0
        *  @playerversion Flash 11.1
        *  @playerversion AIR 3.4
        *  @productversion Flex 4.10
        */
        public static const ENDS_WITH:String = "endsWith";


        /**
        *  Specifies the use of a regex pattern matching exacly to a given value.
        * 
        *  @langversion 3.0
        *  @playerversion Flash 11.1
        *  @playerversion AIR 3.4
        *  @productversion Flex 4.10
        */
        public static const EXACT:String = "exact";


        /**
        *  Specifies the use of a regex pattern match that does not contain a given value.
        * 
        *  @langversion 3.0
        *  @playerversion Flash 11.1
        *  @playerversion AIR 3.4
        *  @productversion Flex 4.10
        */
        public static const NOT:String = "not";


        /**
        *  Specifies the use of a regex pattern match that specifies must have at least 1 character matching.
        * 
        *  @langversion 3.0
        *  @playerversion Flash 11.1
        *  @playerversion AIR 3.4
        *  @productversion Flex 4.10
        */
        public static const NOT_EMPTY:String = "notEmpty";


        /**
        *  Specifies the use of a regex pattern matching the beginging with a given value.
        * 
        *  @langversion 3.0
        *  @playerversion Flash 11.1
        *  @playerversion AIR 3.4
        *  @productversion Flex 4.10
        */
        public static const STARTS_WITH:String = "startsWith";


        //--------------------------------------------------------------------------------
        //
        //  Static Methods
        //
        //--------------------------------------------------------------------------------

        /**
        *  Creates a new RegEx pattern based on a given value and a selected pattern Type.
        *
        *  @param patternValue Is the value that will be assembled into the RegEx type.
        *  @param patternType Is the type of regen pattern matching to be performed.
        *
        *  @return Returns a <code>RegExp</code> with a formatted RegEx pattern.
        *
        *  @langversion 3.0
        *  @playerversion Flash 11.1
        *  @playerversion AIR 3.4
        *  @productversion Flex 4.10
        */
        static public function createRegExp(patternValue:String, patternType:String = CONTAINS):RegExp
        {
            return new RegExp(createPatternString(patternValue, patternType), "i");
        }


        /**
        *  Creates a new string based RegEx pattern based on a given value and a selected pattern Type.
        *
        *  @param patternValue Is the value that will be assembled into the RegEx type.
        *  @param patternType Is the type of regen pattern matching to be performed.
        *
        *  @return Returns a string with a formatted RegEx pattern.
        *
        *  @langversion 3.0
        *  @playerversion Flash 11.1
        *  @playerversion AIR 3.4
        *  @productversion Flex 4.10
        */
        static public function createPatternString(patternValue:String, patternType:String = CONTAINS):String
        {
            var combinedPattern:String = "";

            switch (patternType)
            {
                case ENDS_WITH:
                {
                    combinedPattern = "" + patternValue + "$";

                    break;
                }


                case EXACT:
                {
                    combinedPattern = "^" + patternValue + "$";

                    break;
                }


                case NOT:
                {
                    combinedPattern = "^((?!" + patternValue + ").)*$";

                    break;
                }


                case NOT_EMPTY:
                {
                    combinedPattern = "^." + patternValue + "{1,}$";

                    break;
                }


                case STARTS_WITH:
                {
                    combinedPattern = "^" + patternValue + "";

                    break;
                }


                //Default pattern will be contains to catch all invalid patternTypes.
                case CONTAINS:
                default:
                {
                    combinedPattern = "" + patternValue + "";

                    break;
                }
            }


            return combinedPattern;
        }

    }
}