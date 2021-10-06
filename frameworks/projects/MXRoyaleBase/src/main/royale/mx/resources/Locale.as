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

package mx.resources
{

import mx.managers.ISystemManager;

/**
 *  The Locale class can be used to parse a locale String such as <code>"en_US_MAC"</code>
 *  into its three parts: a language code, a country code, and a variant.
 *
 *  <p>The localization APIs in the IResourceManager and IResourceBundle
 *  interfaces use locale Strings rather than Locale instances,
 *  so this class is seldom used in an application.</p>
 *
 *  @see mx.resources.IResourceBundle
 *  @see mx.resources.IResourceManager
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class Locale
{
//    include "../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Class variables
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    private static var currentLocale:Locale;

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     *
     *  @param localeString A 1-, 2-, or 3-part locale String,
     *  such as <code>"en"</code>, <code>"en_US"</code>, or <code>"en_US_MAC"</code>.
     *  The parts are separated by underscore characters.
     *  The first part is a two-letter lowercase language code
     *  as defined by ISO-639, such as <code>"en"</code> for English.
     *  The second part is a two-letter uppercase country code
     *  as defined by ISO-3166, such as <code>"US"</code> for the United States.
     *  The third part is a variant String, which can be used 
     *  to optionally distinguish multiple locales for the same language and country.
     *  It is sometimes used to indicate the operating system
     *  that the locale should be used with, such as <code>"MAC"</code>, <code>"WIN"</code>, or <code>"UNIX"</code>.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function Locale(localeString:String)
    {
        super();

        this.localeString = localeString;
        
        var parts:Array = localeString.split("_");
        
        if (parts.length > 0)
            _language = parts[0];
        
        if (parts.length > 1)
            _country = parts[1];
        
        if (parts.length > 2)
            _variant = parts.slice(2).join("_");
    }
    
    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    private var localeString:String;

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  language
    //----------------------------------
            
    /**
     *  @private
     *  Storage for the language property.
     */
    private var _language:String;

    [Inspectable(category="General", defaultValue="null")]
    
    /**
     *  The language code of this Locale instance. [Read-Only]
     *
     *  <pre>
     *  var locale:Locale = new Locale("en_US_MAC");
     *  trace(locale.language); // outputs "en"
     *  </pre>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */      
    public function get language():String
    {
        return _language;
    }
       
    //----------------------------------
    //  country
    //----------------------------------
            
    /**
     *  @private
     *  Storage for the country property.
     */
    private var _country:String;

    [Inspectable(category="General", defaultValue="null")]

    /**
     *  The country code of this Locale instance. [Read-Only]
     *
     *  <pre>
     *  var locale:Locale = new Locale("en_US_MAC");
     *  trace(locale.country); // outputs "US"
     *  </pre>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */      
    public function get country():String
    {
        return _country
    }

    //----------------------------------
    //  variant
    //----------------------------------
                
    /**
     *  @private
     *  Storage for the variant property.
     */
    private var _variant:String;

    [Inspectable(category="General", defaultValue="null")]
    
    /**
     *  The variant part of this Locale instance. [Read-Only]
     *
     *  <pre>
     *  var locale:Locale = new Locale("en_US_MAC");
     *  trace(locale.variant); // outputs "MAC"
     *  </pre>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */      
    public function get variant():String
    {
        return _variant;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     *  Returns the locale String that was used to construct
     *  this Locale instance. For example:
     *
     *  <pre>
     *  var locale:Locale = new Locale("en_US_MAC");
     *  trace(locale.toString()); // outputs "en_US_MAC"
     *  </pre>
     *
     *  @return Returns the locale String that was used to
     *  construct this Locale instance.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */   
    public function toString():String
    {
        return localeString;
    }
}

}
