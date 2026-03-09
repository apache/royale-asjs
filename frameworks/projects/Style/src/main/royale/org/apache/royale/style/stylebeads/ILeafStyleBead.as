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
package org.apache.royale.style.stylebeads
{
	public interface ILeafStyleBead extends IStyleBead
	{
		function get value():*;
		function set value(value:*):void;
		function getSelector():String;
		function getRule():String;
		function get selectorBase():String;
		function get styleType():String;
		function get parentQueryId():String;
		function get unit():String;
		function set unit(value:String):void;
		function get selectorPrefix():String;
		function set selectorPrefix(value:String):void;
		function get rulePrefix():String;
		function set rulePrefix(value:String):void;
		function get ruleSuffix():String;
		function set ruleSuffix(value:String):void;


	}
}