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
package org.apache.royale.textLayout.factory
{
	import org.apache.royale.geom.Rectangle;
	import org.apache.royale.textLayout.compose.ISWFContext;
	import org.apache.royale.textLayout.elements.IBackgroundManager;
	import org.apache.royale.textLayout.formats.ITextLayoutFormat;
	public interface INumberLineFactory extends IStringTextLineFactory
	{
		function set compositionBounds(compositionBounds:Rectangle):void;
		function set swfContext(swfContext:ISWFContext):void;
		function set listStylePosition(listStylePosition:String):void;
		function get listStylePosition():String;
		function set paragraphFormat(paragraphFormat:ITextLayoutFormat):void;
		function set textFlowFormat(textFlowFormat:ITextLayoutFormat):void;
		function set markerFormat(val:ITextLayoutFormat):void;
		function set text(text:String):void;
		function createTextLines(arg:Function):void;
		function clearBackgroundManager():void;
		function get backgroundManager():IBackgroundManager;
	}
}
