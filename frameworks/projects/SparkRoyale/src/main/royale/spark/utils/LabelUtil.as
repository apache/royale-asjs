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

package spark.utils
{

import  mx.core.FlexVersion;
    
/**
 *  The LabelUtil class is used by components to determine the correct
 *  text to display for their renderers or sub-parts. 
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
public class LabelUtil
{
    //include "../core/Version.as";
        
    //--------------------------------------------------------------------------
    //
    //  Class methods
    //
    //--------------------------------------------------------------------------

    /**
     *  A function used by components that support item renderers 
     *  to determine the correct text an item renderer should display for a data item. 
     *  If no <code>labelField</code> or <code>labelFunction</code> parameter 
     *  is specified, the <code>toString()</code> method of the data item  
     *  is called to return a String representation of the data item.
     *  
     *  <p>The <code>labelFunction</code> property takes a reference to a function. 
     *  The function takes a single argument which is the item in 
     *  the data provider and returns a String:</p>
     *  <pre>
     *  myLabelFunction(item:Object):String</pre>
     * 
     *  @param item The data item. Null items return the empty string. 
     * 
     *  @param labelField The field in the data item to return. If labelField is set 
     *  to an empty string (""), no field will be considered on the data item 
     *  to represent label.
     * 
     *  @param labelFunction A function that takes the data item 
     *  as a single parameter and returns a String. 
     * 
     *  @return A String representation for the data item 
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public static function itemToLabel(item:Object, labelField:String=null, 
        labelFunction:Function=null):String
    {
        if (labelFunction != null)
            return labelFunction(item);

        // early check for Strings
        if (item is String)
            return String(item);

        if (item is XML)
        {
            try
            {
                if (item[labelField].length() != 0)
                    item = item[labelField];
                //by popular demand, this is a default XML labelField
                //else if (item.@label.length() != 0)
                //  item = item.@label;
            }
            catch(e:Error)
            {
            }
        }
        else if (item is Object)
        {
            try
            {
                if (item[labelField] != null)
                    item = item[labelField];
            }
            catch(e:Error)
            {
            }
        }

        // late check for strings if item[labelField] was valid
        if (item is String)
            return String(item);

        // special case for empty labelField
        //if (labelField == "" && FlexVersion.compatibilityVersion >= FlexVersion.VERSION_4_5)
            //return "";
        
        try
        {
            if (item !== null)
                return item.toString();
        }
        catch(e:Error)
        {
        }

        return " ";
    }
}

}
