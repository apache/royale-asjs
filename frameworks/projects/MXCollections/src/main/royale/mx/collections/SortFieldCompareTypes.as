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

package mx.collections
{

    /**
    *  The SortFieldCompareTypes class defines the valid constant values for the 
    *  <code>sortCompareType</code> property of the <code>SortField</code> and <code>GridColumn</code>.
    * 
    *  <p>Designed to be used from a DataGrids column, but can be referenced directly on the <code>SortField</code></p>
    *  
    *  <p>Use the constants in ActionsScript, as the following example shows:</p>
    *  <pre>
    *    column.sortCompareType = SortFieldCompareTypes.NUMERIC;
    *  </pre>
    *
    *  <p>In MXML, use the String value of the constants, as the following example shows:</p>
    *  <pre>
    *    &lt;s:GridColumn sortCompareType="numeric" /&gt; 
    *  </pre>
    * 
    *  
    *  @langversion 3.0
    *  @playerversion Flash 11.8
    *  @playerversion AIR 3.8
    *  @productversion Flex 4.11
    */
    public final class SortFieldCompareTypes
    {
        /**
        *  Constructor.
        * 
        *  @langversion 3.0
        *  @playerversion Flash 11.1
        *  @playerversion AIR 3.4
        *  @productversion Flex 4.10
        */
        public function SortFieldCompareTypes()
        {
        }

        //----------------------------------------
        //  Class constants
        //----------------------------------------

        /**
        *  Represents the dateCompare inside a SortField.
        * 
        *  @langversion 3.0
        *  @playerversion Flash 11.8
        *  @playerversion AIR 3.8
        *  @productversion Flex 4.11
        */
        public static const DATE:String = "date";


        /**
        *  Represents the nullCompare inside a SortField.
        * 
        *  @langversion 3.0
        *  @playerversion Flash 11.8
        *  @playerversion AIR 3.8
        *  @productversion Flex 4.11
        */
        public static const NULL:String = "null";


        /**
        *  Represents the numericCompare inside a SortField.  This also is used for boolean comparisons.
        * 
        *  @langversion 3.0
        *  @playerversion Flash 11.8
        *  @playerversion AIR 3.8
        *  @productversion Flex 4.11
        */
        public static const NUMERIC:String = "numeric";


        /**
        *  Represents the stringCompare inside a SortField.
        * 
        *  @langversion 3.0
        *  @playerversion Flash 11.8
        *  @playerversion AIR 3.8
        *  @productversion Flex 4.11
        */
        public static const STRING:String = "string";


        /**
        *  Represents the xmlCompare inside a SortField.
        * 
        *  @langversion 3.0
        *  @playerversion Flash 11.8
        *  @playerversion AIR 3.8
        *  @productversion Flex 4.11
        */
        public static const XML:String = "xml";
    }
}