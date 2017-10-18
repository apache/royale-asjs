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
package org.apache.royale.text.engine
{
	import org.apache.royale.text.engine.ITextFactory;
	import org.apache.royale.text.engine.ContentElement;

	public interface ITextBlock
	{
		function get applyNonLinearFontScaling():Boolean;
		function set applyNonLinearFontScaling(value:Boolean):void;
		function get baselineFontDescription():FontDescription;
		function set baselineFontDescription(value:FontDescription):void;
		function get baselineFontSize():Number;
		function set baselineFontSize(value:Number):void;
		function get baselineZero():String;
		function set baselineZero(value:String):void;
		function get bidiLevel():int;
		function set bidiLevel(value:int):void;
		function get content():ContentElement;
		function set content(value:ContentElement):void;
		function get firstInvalidLine():ITextLine;
		function set firstInvalidLine(value:ITextLine):void;
		function get firstLine():ITextLine;
		function set firstLine(value:ITextLine):void;
		function get lastLine():ITextLine;
		function set lastLine(value:ITextLine):void;
		function get lineRotation():String;
		function set lineRotation(value:String):void;
		function get tabStops():Vector.<TabStop>;
		function set tabStops(value:Vector.<TabStop>):void;
		function get textJustifier():TextJustifier;
		function set textJustifier(value:TextJustifier):void;
		function get textLineCreationResult():String;
		function set textLineCreationResult(value:String):void;
		function get userData():*;
		function set userData(value:*):void;

		function get textFactory():ITextFactory;

		function createTextLine(previousLine:ITextLine = null, width:Number = 1000000, lineOffset:Number = 0.0, fitSomething:Boolean = false):ITextLine;
		function dump():String;
		function findNextAtomBoundary(afterCharIndex:int):int
		function findNextWordBoundary(afterCharIndex:int):int;
		function findPreviousAtomBoundary(beforeCharIndex:int):int;
		function findPreviousWordBoundary(beforeCharIndex:int):int;
		function getTextLineAtCharIndex(charIndex:int):ITextLine;
		function recreateTextLine(textLine:ITextLine, previousLine:ITextLine = null, width:Number = 1000000, lineOffset:Number = 0.0, fitSomething:Boolean = false):ITextLine;
		function releaseLineCreationData():void;
		function releaseLines(firstLine:ITextLine, lastLine:ITextLine):void;

		function getRelativeStart(element:ContentElement):int;

	}
}
