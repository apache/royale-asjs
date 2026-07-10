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
package org.apache.royale.style
{
		import org.apache.royale.core.IUIBase;
		import org.apache.royale.style.stylebeads.IStyleBead;

		/**
		 *  The IStyleUIBase interface defines the contract for all UI components that support styles.
		 *  It provides a common set of methods and properties for handling style classes and applying them to the component.
		 *	@langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 1.0.0
		 */
	public interface IStyleUIBase extends IUIBase
	{
		function toggleClass(classNameVal:String,add:Boolean):void;
		function addStyleBead(bead:IStyleBead):void;
		function setStyles(styles:Array, overrideExisting:Boolean = false):void;
		function stylesChanged():void;
		function setStyle(property:String, value:Object):void;
		function toggleAttribute(name:String, value:Boolean):void;
		function setAttribute(name:String, value:*):void;
		function getAttribute(name:String):*;
		function removeAttribute(name:String):void;
		function get theme():String;
		function set theme(value:String):void;
		function get skin():IStyleSkin;
		function get unit():String;
		function set unit(value:String):void;
		function get size():String;
		function set size(value:String):void;
		/**
		 * support for component classes that provide a wrapper element tagged with this style class (null if not applicable)
		 */
		function getWrapperStyle():String;
	}
}