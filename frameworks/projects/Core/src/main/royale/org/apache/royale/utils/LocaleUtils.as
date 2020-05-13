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
	 *  The LocaleUtils class is an all-static class with methods for
	 *  getting informatiojn about the locale.
	 *  You do not create instances of LocaleUtils;
	 *  instead you call methods such as 
	 *  the <code>LocaleUtils.getLocale()</code> method.  
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Royale 1.0.0
	 *  @productversion Royale 0.0
	 */
    public class LocaleUtils
    {
        COMPILE::SWF
        {
            import flash.system.Capabilities;
        }
        public function LocaleUtils ()
        {
        }

        /**
         * Gets the locale of the operating system.
         */
        public static function getLocale():String
        {
            COMPILE::SWF
            {
                if(!_localeName)
                {
                    _localeName = Capabilities.language;
                }
                return _localeName;
            }

            COMPILE::JS
            {
                if(!_localeName)
                {
                    if (navigator.languages && navigator.languages.length) {
                        _localeName = navigator.languages[0];
                    } else {
                        _localeName = navigator.language || navigator['userLanguage'] || navigator['browserLanguage'] || 'en';
                    }
                }
                return _localeName;
            }
        }
        
        private static var _localeName:String;
    }
}
