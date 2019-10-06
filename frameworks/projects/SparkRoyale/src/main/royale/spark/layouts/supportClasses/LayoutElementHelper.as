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

package spark.layouts.supportClasses
{
import mx.utils.StringUtil;

[ExcludeClass]

/**
 *  @private
 *  The LayoutElementHelper class is for internal use only.
 *  TODO (egeorgie): move to a more general place, this is not specific to the LayoutElementHelper
 */
public class LayoutElementHelper
{
//    include "../../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Class methods
    //
    //--------------------------------------------------------------------------

    /**
     *  @return Returns <code>val</code> clamped to the range of
     *  <code>min</code> or <code>max</code>.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public static function pinBetween(val:Number, min:Number, max:Number):Number
    {
        return Math.min(max, Math.max(min, val));
    }

    /**
     *  @return returns the number for the passed in constraint value. Constraint value
     *  can be a Number, or a string in the format "col1:10".
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public static function parseConstraintValue(value:Object):Number
    {
        if (value is Number)
            return Number(value);
        
        var str:String = value as String;
        if (!str)
            return NaN;
        
        var result:Array = parseConstraintExp(str);
        return result[0];
    }

    /**
     *  @private
     *  Parses a constraint expression, like left="col1:10" 
     *  so that an array is returned where the first value is
     *  the offset (ie: 10) and the second value is 
     *  the boundary (ie: "col1")
     *  @param result :  optional Array to save an Array memory allocation
     */
    public static function parseConstraintExp(val:Object, result:Array=null):Array
    {
        // number
        if (val is Number) {
            if(result == null) {
                return [val as Number, null];
            }
            else {
                result[0] = val as Number;
                result[1] = null;
                return result;
            }
        }
       // null
        if (!val) {
            if(result == null) {
                return [NaN, null];
            }
            else {
                result[0] = NaN;
                result[1] = null;
                return result;
            }
        }

        // String case  : 2 sub-cases, number of constraint
        var tmp:String = String(val);
        var colonPos:int = tmp.indexOf(":");
        
        // If the val was a String object representing a single number (i.e. "100"),
        // then we'll hit this case:
        if(colonPos == -1) {
            return [StringUtil.trim(tmp)];
        }
        
        // Return [offset, boundary]
        if(result == null) {
            result =[];
        }
        
        //here we do not use StringUtil in order to avoid unnecessary memory allocations
        var startIndex:int = 0;
        while (StringUtil.isWhitespace(tmp.charAt(startIndex))) {
            ++startIndex;
        }
        
        var endIndex:int = tmp.length - 1;
        while (StringUtil.isWhitespace(tmp.charAt(endIndex) )) {
            --endIndex;
        }
        
        var endIndexPart1:int = colonPos-1;
        while (StringUtil.isWhitespace(tmp.charAt(endIndexPart1))) {
            --endIndexPart1;
        }
        
        var startIndexPart2:int = colonPos+1;
        while (StringUtil.isWhitespace(tmp.charAt(startIndexPart2))) {
            ++startIndexPart2;
        }
        
        result[0] = tmp.substring(startIndexPart2, endIndex+1);
        result[1] = tmp.substring(startIndex, endIndexPart1+1);
        
        return result;
    }



}

}
