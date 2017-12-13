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
     *  The IValuesImpl interface is the basic interface for the subsystem that
     *  provides default values to components.  The most common implementation implements
     *  a simple version of CSS and uses data structures compiled from CSS files.
     *  
     *  @see org.apache.royale.core.SimpleCSSValuesImpl
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	public interface IValuesImpl
	{
        /**
         *  Returns a value for a given object based on a property name,
         *  and optionally, the current state, and a set of property value pairs.
         *
         *  @param thisObject The object to get the value for.
         *  @param valueName The name of a property. e.g. fontFamily, color, etc.
         *  @param state The name of a state. e.g. hovered, visited
         *  @param attrs A map of property value pairs that may affect the returned value.
         *  @return A value or undefined
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		function getValue(thisObject:Object, valueName:String, state:String = null, attrs:Object = null):*;

		/**
		 *  Returns a new instance based on the value for a given object based on a property name,
		 *  and optionally, the current state, and a set of property value pairs.  This is a way
		 *  to avoid using the Class type in AS code.
		 *
		 *  @param thisObject The object to get the value for.
		 *  @param valueName The name of a property. e.g. fontFamily, color, etc.
		 *  @param state The name of a state. e.g. hovered, visited
		 *  @param attrs A map of property value pairs that may affect the returned value.
		 *  @return A value or undefined
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		function newInstance(thisObject:Object, valueName:String, state:String = null, attrs:Object = null):*;

		/**
         *  Returns a shared instance, instantiating the shared instance if
         *  it doesn't exist.  Often used to share "managers"
         *
         *  @param valueName The name of a shared instance.  Often, the fully
         *  qualified class name is used.
         *  @return The shared instance.
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        function getInstance(valueName:String):Object;
        
        /**
         *  MXML Documents that support &lt;fx:Style&gt; blocks should call
         *  init to install the styles for each instance.
         *
         *  @param mainClass An instance that may have styles from an &lt;fx:Style&gt; block.
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        function init(mainClass:Object):void;

        /**
         *  Converts a color value into a uint.
         *
         *  @param value A string for a color.  Typically it is
         *  a color value like #ffffff or "red" in some cases.
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        function convertColor(value:Object):uint;

        /**
         *  Converts an HTML-like style format into an object.
         *
         *  @param value A string, such as "color:red;fontSize:10px".
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        function parseStyles(value:String):Object;
        
        /**
         *  Add a style rule like a class selector.
         *
         *  @param ruleName The name of the rule like '.myClassSelector'.
         *  @param values Name/value pairs.
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        function addRule(ruleName:String, values:Object):void;

        /**
         *  Applies a set of styles to an instance.  This is used
         *  by implementations that wrap internal elements to
         *  propagate styles to the right internal elements.
         *
         *  @param instance An instance to apply styles to.
         *  @param styles An Object map of styles to apply.
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        COMPILE::JS
        function applyStyles(instance:IUIBase, styles:Object):void;
        
    }
}
