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

package mx.utils
{

/**
 *  The StringUtil utility class is an all-static class with methods for
 *  working with String objects within Flex.
 *  You do not create instances of StringUtil;
 *  instead you call methods such as 
 *  the <code>StringUtil.substitute()</code> method.  
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.3
 */
public class StringUtil
{
/*     include "../core/Version.as";
 */
    //--------------------------------------------------------------------------
    //
    //  Class methods
    //
    //--------------------------------------------------------------------------

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
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
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
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    public static function trimArrayElements(value:String, delimiter:String):String
    {
        if (value != "" && value != null)
        {
            var items:Array = value.split(delimiter);
            
            var len:int = items.length;
            for (var i:int = 0; i < len; i++)
            {
                items[i] = StringUtil.trim(items[i]);
            }
            
            if (len > 0)
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
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
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

    /**
     *  Substitutes "{n}" tokens within the specified string
     *  with the respective arguments passed in.
	 * 
	 *  Note that this uses String.replace and "$" can have special
	 *  meaning in the argument strings escape by using "$$".
     *
     *  @param str The string to make substitutions in.
     *  This string can contain special tokens of the form
     *  <code>{n}</code>, where <code>n</code> is a zero based index,
     *  that will be replaced with the additional parameters
     *  found at that index if specified.
     *
     *  @param rest Additional parameters that can be substituted
     *  in the <code>str</code> parameter at each <code>{n}</code>
     *  location, where <code>n</code> is an integer (zero based)
     *  index value into the array of values specified.
     *  If the first parameter is an array this array will be used as
     *  a parameter list.
     *  This allows reuse of this routine in other methods that want to
     *  use the ... rest signature.
     *  For example <pre>
     *     public function myTracer(str:String, ... rest):void
     *     { 
     *         label.text += StringUtil.substitute(str, rest) + "\n";
     *     } </pre>
     *
     *  @return New string with all of the <code>{n}</code> tokens
     *  replaced with the respective arguments specified.
     *
     *  @example
     *
     *  var str:String = "here is some info '{0}' and {1}";
     *  trace(StringUtil.substitute(str, 15.4, true));
     *
     *  // this will output the following string:
     *  // "here is some info '15.4' and true"
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    public static function substitute(str:String, ... rest):String
    {
        if (str == null) return '';
        
        // Replace all of the parameters in the msg string.
        var len:uint = rest.length;
        var args:Array;
        if (len == 1 && rest[0] is Array)
        {
            args = rest[0] as Array;
            len = args.length;
        }
        else
        {
            args = rest;
        }
        
        for (var i:int = 0; i < len; i++)
        {
            str = str.replace(new RegExp("\\{"+i+"\\}", "g"), args[i]);
        }

        return str;
    }

    /**
     *  Returns a string consisting of a specified string
     *  concatenated with itself a specified number of times.
     *
     *  @param str The string to be repeated.
     *
     *  @param n The repeat count.
     *
     *  @return The repeated string.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4.1
     */
    public static function repeat(str:String, n:int):String
    {
        if (n == 0)
            return "";

        var s:String = str;
        for (var i:int = 1; i < n; i++)
        {
            s += str;
        }
        return s;
    }

    /**
     *  Removes "unallowed" characters from a string.
     *  A "restriction string" such as <code>"A-Z0-9"</code>
     *  is used to specify which characters are allowed.
     *  This method uses the same logic as the <code>restrict</code>
     *  property of TextField.
     *
     *  @param str The input string.
     *
     *  @param restrict The restriction string.
     *
     *  @return The input string, minus any characters
     *  that are not allowed by the restriction string.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4.1
     */
    public static function restrict(str:String, restrict:String):String
    {
        // A null 'restrict' string means all characters are allowed.
        if (restrict == null)
            return str;
            
        // An empty 'restrict' string means no characters are allowed.
        if (restrict == "")
            return "";
            
        // Otherwise, we need to test each character in 'str'
        // to determine whether the 'restrict' string allows it.
        var charCodes:Array = [];
        
        var n:int = str.length;
        for (var i:int = 0; i < n; i++)
        {
            var charCode:uint = str.charCodeAt(i);
            if (testCharacter(charCode, restrict))
                charCodes.push(charCode);
        }
        
        return String.fromCharCode.apply(null, charCodes);
    }
                            
    /**
     *  @private
     *  Helper method used by restrict() to test each character
     *  in the input string against the restriction string.
     *  The logic in this method implements the same algorithm
     *  as in TextField's 'restrict' property (which is quirky,
     *  such as how it handles a '-' at the beginning of the
     *  restriction string).
     */
    private static function testCharacter(charCode:uint,
                                          restrict:String):Boolean
    {
        var allowIt:Boolean = false;
        
        var inBackSlash:Boolean = false;
        var inRange:Boolean = false;
        var setFlag:Boolean = true;
        var lastCode:uint = 0;
                        
        var n:int = restrict.length;
        var code:uint;
        
        if (n > 0)
        {
            code = restrict.charCodeAt(0);
            if (code == 94) // caret
                allowIt = true;
        }
        
        for (var i:int = 0; i < n; i++)
        {
            code = restrict.charCodeAt(i)
            
            var acceptCode:Boolean = false;
            if (!inBackSlash)
            {
                if (code == 45) // hyphen
                    inRange = true;
                else if (code == 94) // caret
                    setFlag = !setFlag;
                else if (code == 92) // backslash
                    inBackSlash = true;
                else
                    acceptCode = true;
            }
            else
            {
                acceptCode = true;
                inBackSlash = false;
            }
            
            if (acceptCode)
            {
                if (inRange)
                {
                    if (lastCode <= charCode && charCode <= code)
                        allowIt = setFlag;
                    inRange = false;
                    lastCode = 0;
                }
                else
                {
                    if (charCode == code)
                        allowIt = setFlag;
                    lastCode = code;
                }
            }
        }
        
        return allowIt;
    }
}

}
