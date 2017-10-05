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
package org.apache.royale.textLayout.compose
{
	import org.apache.royale.core.IParentIUIBase;
	import org.apache.royale.geom.Rectangle;
	import org.apache.royale.graphics.ICompoundGraphic;
	import org.apache.royale.text.engine.ITextBlock;
	import org.apache.royale.text.engine.ITextLine;
	import org.apache.royale.textLayout.container.IContainerController;
	import org.apache.royale.textLayout.edit.SelectionFormat;
	import org.apache.royale.textLayout.elements.IFlowLeafElement;
	import org.apache.royale.textLayout.elements.IParagraphElement;
	import org.apache.royale.textLayout.formats.ITextLayoutFormat;
	
	public interface ITextFlowLine extends IVerticalJustificationLine
	{
		function get composable():Boolean;//TextFlowTableBlocks are not composable
		function initialize(paragraph:IParagraphElement, outerTargetWidth:Number = 0, lineOffset:Number = 0, absoluteStart:int = 0, numChars:int = 0, textLine:ITextLine = null):void;
		function get heightTW():int;
		function get outerTargetWidthTW():int;
		function get ascentTW():int;
		function get targetWidthTW():int;
		function get textHeightTW():int;
		function get lineOffsetTW():int;
		function get lineExtentTW():int;
		function get hasGraphicElement():Boolean;
		function get hasNumberLine():Boolean;
		function get numberLinePosition():Number;
		function set numberLinePosition(position:Number):void;
		function get textHeight():Number ;
		function get xTW():int;
		function get yTW():int;
		function setXYAndHeight(lineX:Number,lineY:Number,lineHeight:Number):void;
		function get location():int;
		function get controller():IContainerController;
		function get columnIndex():int;
		function setController(cont:IContainerController,colNumber:int):void;
		function get lineOffset():Number;
		function get paragraph():IParagraphElement;
		function get absoluteStart():int;
		function setAbsoluteStart(val:int):void;
		function get textBlockStart():int;
		function get textLength():int;
		function setTextLength(val:int):void;
		function get spaceBefore():Number;
		function get spaceAfter():Number;
		function get outerTargetWidth():Number;
		function set outerTargetWidth(val:Number):void;
		function get targetWidth():Number;
		function getBounds():Rectangle;
		function get validity():String;
		function get unjustifiedTextWidth():Number;
		function get lineExtent():Number;
		function set lineExtent(value:Number):void;
		function get accumulatedLineExtent():Number;
		function set accumulatedLineExtent(value:Number):void;
		function get accumulatedMinimumStart():Number;
		function set accumulatedMinimumStart(value:Number):void;
		function get alignment():String;
		function set alignment(value:String):void;
		function isDamaged():Boolean;
		function clearDamage():void;
		function damage(damageType:String):void;
		function testLineVisible(wmode:String, x:int, y:int, w:int, h:int):int;
		function oldTestLineVisible(wmode:String, x:int, y:int, w:int, h:int):Boolean;
		function cacheLineBounds(wmode:String, bndsx:Number, bndsy:Number, bndsw:Number, bndsh:Number):void;
		function hasLineBounds():Boolean;
		function get textLineExists():Boolean;
		function peekTextLine():ITextLine;
		function getTextLine(forceValid:Boolean = false):ITextLine;
		function recreateTextLine(textBlock:ITextBlock, previousLine:ITextLine):ITextLine;
		function createShape(bp:String, textLine:ITextLine):void;
		function createAdornments(blockProgression:String,elem:IFlowLeafElement,elemStart:int, textLine:ITextLine, numberLine:ITextLine):void;
		function getLineLeading(bp:String,elem:IFlowLeafElement,elemStart:int):Number;
		function getLineTypographicAscent(elem:IFlowLeafElement,elemStart:int,textLine:ITextLine):Number;
		function getCSSLineBox(bp:String, elem:IFlowLeafElement, elemStart:int, swfContext:ISWFContext, effectiveListMarkerFormat:ITextLayoutFormat=null, numberLine:ITextLine=null):Rectangle;
		function calculateSelectionBounds(textLine:ITextLine, rectArray:Array, begIdx:int, endIdx:int, blockProgression:String, heightAndAdj:Array):void;
		function getRomanSelectionHeightAndVerticalAdjustment (prevLine:ITextFlowLine, nextLine:ITextFlowLine):Array;
		function convertLineRectToContainer(rect:Rectangle, constrainShape:Boolean):void;
		function hiliteBlockSelection(selObj:ICompoundGraphic, selFormat:SelectionFormat, container:IParentIUIBase, begIdx:int,endIdx:int, prevLine:ITextFlowLine, nextLine:ITextFlowLine):void;
		function hilitePointSelection(selFormat:SelectionFormat, idx:int, container:IParentIUIBase, prevLine:ITextFlowLine, nextLine:ITextFlowLine):void;
		function computePointSelectionRectangle(idx:int, container:IParentIUIBase, prevLine:ITextFlowLine, nextLine:ITextFlowLine, constrainSelRect:Boolean):Rectangle;
		function selectionWillIntersectScrollRect(scrollRect:Rectangle, begIdx:int, endIdx:int, prevLine:ITextFlowLine, nextLine:ITextFlowLine):int;

		function get adornCount():int ;

	}
}
