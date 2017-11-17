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
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.textLayout.formats.ITextLayoutFormat;

	public interface IFlowElement extends ITextLayoutFormat
	{
		function getText(relativeStart:int = 0, relativeEnd:int = -1, paragraphSeparator:String = "\n"):String;

		function getAncestorWithContainer():IContainerFormattedElement;
		function getPrivateStyle(styleName:String):*;
		function formatChanged(notifyModelChanged:Boolean = true):void;
		function setStyle(styleProp:String, newValue:*):void;
		function getEffectivePaddingLeft():Number;
		function getEffectivePaddingRight():Number;
		function getEffectivePaddingTop():Number;
		function getEffectivePaddingBottom():Number;
		function getEffectiveBorderLeftWidth():Number;
		function getEffectiveBorderRightWidth():Number;
		function getEffectiveBorderTopWidth():Number;
		function getEffectiveBorderBottomWidth():Number;
		function getEffectiveMarginLeft():Number;
		function getEffectiveMarginRight():Number;
		function getEffectiveMarginTop():Number;
		function getEffectiveMarginBottom():Number;
		function getAbsoluteStart():int;
		function getElementRelativeStart(ancestorElement:IFlowElement):int;
		function getTextFlow():ITextFlow;
		function getParagraph():IParagraphElement;
		function getParentCellElement():ITableCellElement;
		function getParentByType(elementType:String):IFlowElement;
		function getPreviousSibling():IFlowElement;
		function getNextSibling():IFlowElement;
		function getCharAtPosition(relativePosition:int):String;
		function getCharCodeAtPosition(relativePosition:int):int;
		function get className():String;
		function get userStyles():Object;
		function get coreStyles():Object;
		function get styles():Object;
		function get bindableElement():Boolean;
		function get parent():IFlowGroupElement;
		function get textLength():int;
		function get parentRelativeStart():int;
		function get parentRelativeEnd():int;
		function get id():String;
		function get typeName():String;
		function get defaultTypeName():String;
		function get impliedElement():Boolean;
		function get formatForCascade():ITextLayoutFormat;
		function get computedFormat():ITextLayoutFormat;
		function set userStyles(styles:Object):void;
		function set bindableElement(value:Boolean):void;
		function getUserStyleWorker(styleProp:String):*;
		function set id(val:String):void;
		function modelChanged(changeType:String, element:IFlowElement, changeStart:int, changeLen:int, needNormalize:Boolean = true, bumpGeneration:Boolean = true):void;
		function set typeName(val:String):void;
		function set impliedElement(value:Boolean):void;
		function set tracking(trackingValue:Object):void;
		function splitAtPosition(i:int):IFlowElement;

		// TODO add this back in after the compiler is fixed
		// function set styleName(styleNameValue:*):void;
		function set format(format:ITextLayoutFormat):void;
		function get format():ITextLayoutFormat;
		function hasActiveEventMirror():Boolean;
		function deepCopy(relativeStart:int = 0, relativeEnd:int = -1):IFlowElement;
		function shallowCopy(relativeStart:int = 0, relativeEnd:int = -1):IFlowElement;
		function normalizeRange(normalizeStart:uint, normalizeEnd:uint):void;
		function quickCloneTextLayoutFormat(sibling:IFlowElement):void;
		function applyFunctionToElements(func:Function):Boolean;
		function removed():void;
		function setParentAndRelativeStart(newParent:IFlowGroupElement, newStart:int):void;
		function setParentAndRelativeStartOnly(newParent:IFlowGroupElement, newStart:int):void;
		function setParentRelativeStart(newStart:int):void;
		function applyWhiteSpaceCollapse(collapse:String):void;
		function appendElementsForDelayedUpdate(tf:ITextFlow, changeType:String):void;
		function updateRange(len:int):void;
		function releaseContentElement():void;
		function createContentElement():void;
		function updateLengths(startIdx:int, len:int, updateLines:Boolean):void;
		function setStylesInternal(styles:Object):void;
		CONFIG::debug function get name():String;
		CONFIG::debug function debugCheckFlowElement(depth:int = 0, extraData:String = ""):int;
		function mergeToPreviousIfPossible():Boolean;
		function set backgroundAlpha(backgroundAlphaValue:*):void;
		function set backgroundColor(backgroundColorValue:*):void;
		function getEventMirror():IEventDispatcher;
		function set listMarkerFormat(listMarkerFormat:*):void;
		function calculateComputedFormat():ITextLayoutFormat;
		function set fontSize(value:*):void;
		function set xScale(value:*):void;
		function set yScale(value:*):void;
		function set columnWidth(columnWidthValue:*):void;
	}
}
