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
package org.apache.flex.core
{
	public interface IRangeModel extends IBeadModel
	{
		function get maximum():Number;
		function set maximum(value:Number):void;
		
		function get minimum():Number;
		function set minimum(value:Number):void;

		function get snapInterval():Number;
		function set snapInterval(value:Number):void;

		function get stepSize():Number;
		function set stepSize(value:Number):void;

		function get value():Number;
		function set value(value:Number):void;
}
}