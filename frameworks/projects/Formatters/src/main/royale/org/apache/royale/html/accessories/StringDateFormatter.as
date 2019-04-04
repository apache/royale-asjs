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
package org.apache.royale.html.accessories
{
  import org.apache.royale.core.FormatBase;
  /**
   * Formats a date from a string
   * Because of the compleixities of date formatting, this formatter does not
   * differentiate between single digit formats and double digit formats for days and months.
   */
  public class StringDateFormatter extends SimpleDateFormatter
  {
    public function StringDateFormatter()
    {
      super();
    }
    /**
     * Formats the date.
     * If a String is passed in, the date string is formatted using the dateFormat.
     * If a Date is passed in, it formats the same as other Date formatters.
     */
    override public function format(value:Object):String
    {
      if(value is Date)
      {
        return super.format(value);
      }
      var str:String = value as String;
      var lastChar:String = str ? str[str.length-1] : "";
      str = str.replace(/[^0-9]/g,"");
      var result:String = "";
      var tokens:Array = dateFormat.split(_separator);
      var length:int = tokens.length;
      var part:String;
      var val:Number;
				
      for (var i:int = 0; i < length; i++) {
        if(!str)
          break;
        var token:String = tokens[i];
        switch (token) {
          case "YYYY":
            part = str.substr(0,4);
            str = str.substr(4);
            result += part;
            break;
          case "YY":
            part = str.substr(0,2);
            str = str.substr(2);
            result += part;
            break;
          case "M":
          case "MM":
            part = str.substr(0,2);
            val = Number(part);
            if(val > 12)// should be single digit
            {
              part = "0" + str.substr(0,1);
              str = str.substr(1);
            } else
            {
              // part is ok. We need to slice the str
              str = str.substr(2);
              //manually added separator. Add a 0.
              if(part.length == 1 && lastChar == _separator)
                part = "0" + part;
            }
            result += part;
            break;
          case "DD":
          case "D":
            part = str.substr(0,2);
            val = Number(part);
            if(val > 31)// should be single digit
            {
              part = "0" + str.substr(0,1);
              str = str.substr(1);
            } else
            {
              // part is ok. We need to slice the str
              str = str.substr(2);
              //manually added separator. Add a 0.
              if(part.length == 1 && lastChar == _separator)
                part = "0" + part;
            }
            result += part;
            break;
        }
        // if there's no more left, str is empty and no separator
        if ( (str || lastChar == _separator) && i <= length - 2) {
          result += _separator;
        }
      }

			return result;
    }
    // Some calendar systems can have a different value
    private var _maxMonths:Number = 12;
    private function isValidMonth(value:Number):Boolean
    {
      if(isNaN(value))
        return false;
      if(Math.round(value) != value)
        return false;
      if(value > _maxMonths)
        return false;

      return true;
    }
  }
}