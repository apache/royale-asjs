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
package org.apache.royale.text.engine {
	import org.apache.royale.utils.BinaryData;
	/**
	 * @author harbs
	 */
	public interface IFont
	{
		function get family():String;
		function get style():String;
		function get isLoaded():Boolean;
		function get fontMetrics():FontMetrics;
		//These callbacks should feed the IFont into the function
		function onLoad(callback:Function):void;
		function onError(calback:Function):void;
		//TODO once Promise is implemented on the SWF side
		//function loaded():Promise;
		function load(url:String):void;
		function loadFromBinary(data:BinaryData):void;
	}
}
