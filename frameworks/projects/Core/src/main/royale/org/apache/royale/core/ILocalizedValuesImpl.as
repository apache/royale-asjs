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
package org.apache.royale.core
{
    /**
     *  The ILocalizedValuesImpl interface is the basic interface for the subsystem that
     *  provides localized values to components.  In Royale, different interfaces and
	 *  implementations will handle different aspects of localization.  For example,
	 *  implementations of this interface returns strings and possibly other values
	 *  stored in the application, whereas a different interface will tackle date
	 *  formatting, yet another may take on date parsing, because, per the 
	 *  pay-as-you-go (PAYG) principle, applications don't need to carry every
	 *  localization feature if they don't need them.
     *  
     *  @see org.apache.royale.core.SimpleLocalizedValuesImpl
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	public interface ILocalizedValuesImpl extends IBead
	{
        /**
         *  Returns a value for a given object based on a property name,
         *  and optionally, the current state, and a set of property value pairs.
         *
         *  @param bundleName The name of a property bundle.
         *  @param key The name of a value in the bundle
         *  @return A value or undefined
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		function getValue(bundleName:String, key:String):*;

		/**
		 *  Determines the locale(s) to use for getting the values.
		 *
		 *  @param locales A comma delimited list of locales.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		function set localeChain(locales:String):void;
        
    }
}
