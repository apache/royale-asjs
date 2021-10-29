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

package mx.formatters
{

/**
 *  The SwitchSymbolFormatter class is a utility class that you can use 
 *  when creating custom formatters.
 *  This class performs a substitution by replacing placeholder characters
 *  in one String with numbers from a second String.
 *  
 *  <p>For example, you specify the following information
 *  to the SwitchSymbolFormatter class:</p>
 *
 *  <p>Format String: "The SocialSecurity number is: ###-##-####"</p>
 *  <p>Input String: "123456789"</p>
 *  
 *  <p>The SwitchSymbolFormatter class parses the format String and replaces
 *  each placeholder character, by default the number character (#), 
 *  with a number from the input String in the order in which
 *  the numbers are specified in the input String.
 *  You can define a different placeholder symbol by passing it
 *  to the constructor when you instantiate a SwitchSymbolFormatter object.</p>
 *  
 *  <p>The output String created by the SwitchSymbolFormatter class
 *  from these two Strings is the following:</p>
 * 
 *  <p>"The SocialSecurity number is: 123-45-6789"</p>
 *  
 *  <p>The pattern can contain any characters as long as they are constant
 *  for all values of the numeric portion of the String.
 *  However, the value for formatting must be numeric.</p>
 *  
 *  <p>The number of digits supplied in the source value must match
 *  the number of digits defined in the pattern String.
 *  This is the responsibility of the script calling the
 *  SwitchSymbolFormatter object.</p>
 *  
 *  @includeExample examples/SwitchSymbolFormatterExample.mxml
 *  
 *  @see mx.formatters.PhoneFormatter
 *  @access private
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.3
 */
public class SwitchSymbolFormatter
{
    //include "../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     *
     *  @param numberSymbol Character to use as the pattern character.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    public function SwitchSymbolFormatter(numberSymbol:String = "#")
    {
        super();

        this.numberSymbol = numberSymbol;
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    private var numberSymbol:String;
    
    /**
     *  @private
     */
    private var isValid:Boolean = true;

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     *  Creates a new String by formatting the source String
     *  using the format pattern.
     *
     *  @param format String that defines the user-requested pattern including.
     *
     *  @param source Valid number sequence
     *  (alpha characters are allowed if needed).
     *
     *  @return Formatted String.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
     public function formatValue(format:String, source:Object):String
    {
        var numStr:String = "";

        var uStrIndx:int = 0;
        
        var n:int = format.length;
        for (var i:int = 0; i < n; i++)
        {
            var letter:String = format.charAt(i);
            if (letter == numberSymbol)
                numStr += String(source).charAt(uStrIndx++);
            else
                numStr += format.charAt(i);
        }
        
        return numStr;
    }
}

}
