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
package org.apache.royale.textLayout.elements
{
	import org.apache.royale.text.engine.ITextBlock;

	public interface IParagraphElement extends IFlowGroupElement
	{
		function getTextBlock():ITextBlock;
		function getPreviousParagraph():IParagraphElement;
		function getNextParagraph():IParagraphElement;
		function getEffectiveDominantBaseline():String;
		function decInteractiveChildrenCount():void;
		function incInteractiveChildrenCount():void;
		function getEffectiveLeadingModel():String;
		function getTextBlockAbsoluteStart(textBlock:ITextBlock):int;
		function getTextBlocks():Vector.<ITextBlock>;
		function getTextBlockAtPosition(i:int):ITextBlock;
		function getEffectiveJustificationRule():String;
		function isInTable():Boolean;
		function releaseTextBlock(tb:ITextBlock = null):void;
		function findNextWordBoundary(curPos:int):int;
		function findPreviousWordBoundary(curPos:int):int;
		function ensureTerminatorAfterReplace():void;
		function createTextBlock():void;
		function updateTerminatorSpan(spanElement:ISpanElement, newSpan:ISpanElement):void;

		function get terminatorSpan():ISpanElement;

		function releaseLineCreationData():void;

		function hasInteractiveChildren():Boolean;

		function removeEmptyTerminator():void;
	}
}
