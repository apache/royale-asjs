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
package org.apache.royale.textLayout.container
{
	import org.apache.royale.core.IParentIUIBase;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.geom.Matrix;
	import org.apache.royale.geom.Point;
	import org.apache.royale.geom.Rectangle;
	import org.apache.royale.text.engine.ITextLine;
	import org.apache.royale.textLayout.compose.FloatCompositionData;
	import org.apache.royale.textLayout.compose.IFlowComposer;
	import org.apache.royale.textLayout.compose.ITextFlowLine;
	import org.apache.royale.textLayout.compose.ITextFlowTableBlock;
	import org.apache.royale.textLayout.edit.ISelectionManager;
	import org.apache.royale.textLayout.edit.SelectionFormat;
	import org.apache.royale.textLayout.elements.CellCoordinates;
	import org.apache.royale.textLayout.elements.IContainerFormattedElement;
	import org.apache.royale.textLayout.elements.ITextFlow;
	import org.apache.royale.textLayout.elements.TableBlockContainer;
	import org.apache.royale.textLayout.formats.ITextLayoutFormat;
	import org.apache.royale.utils.ObjectMap;

	public interface IContainerController
	{
		function get columnState():ColumnState;
		function get columnCount():*;
		function clearFloatsAt(absolutePosition:int):void;
		function getFloatAtPosition(absolutePosition:int):FloatCompositionData;
		function get numFloats():int;
		function clearSelectionShapes():void;
		function get horizontalScrollPosition():Number;
		function get verticalScrollPosition():Number;
		function get compositionWidth():Number;
		function get compositionHeight():Number;
		function get container():IParentIUIBase;
		function get absoluteStart():int;
		function get measureWidth():Boolean;
		function get measureHeight():Boolean;
		function addCellSelectionShapes(color:uint, tableBlock:ITextFlowTableBlock, startCoords:CellCoordinates, endCoords:CellCoordinates):void;
		function get textLength():int;
		function addComposedTableBlock(block:TableBlockContainer):void;
		function clearCompositionResults():void;
		function get interactiveObjects():ObjectMap;
		function autoScrollIfNecessary(mouseX:int, mouseY:int):void;
		function scrollToRange(activePosition:int, anchorPosition:int):void;
		function get computedFormat():ITextLayoutFormat;
		function get flowComposer():IFlowComposer;
		function setTextLength(i:int):void;
		function get contentWidth():Number;
		function set horizontalScrollPosition(horizontalScrollPosition:Number):void;
		function set verticalScrollPosition(verticalScrollPosition:Number):void;
		function get contentHeight():Number;
		function get rootElement():IContainerFormattedElement;
		function get verticalScrollPolicy():String;
		function get horizontalScrollPolicy():String;
		function get format():ITextLayoutFormat;
		function set format(format:ITextLayoutFormat):void;
		function addSelectionShapes(selFormat:SelectionFormat, selectionAbsoluteStart:int, selectionAbsoluteEnd:int):void;
		function getContentBounds():Rectangle;
		function getTotalPaddingLeft():Number;
		function getTotalPaddingTop():Number;
		function getTotalPaddingRight():Number;
		function getTotalPaddingBottom():Number;
		function findCellAtPosition(localPoint:Point):CellCoordinates;
		function setContentBounds(contentLeft:Number, contentTop:Number, contentWidth:Number, contentHeight:Number):void;
		function clearComposedLines(absoluteStart:int):void;
		function set finalParcelStart(finalParcelStart:int):void;
		function get oldInteractiveObjects():Array;
		function getFloatAt(floatIndex:int):FloatCompositionData;
		function findFloatIndexAtOrAfter(absoluteStart:int):int;
		function findFloatIndexAfter(i:int):int;
		function get textFlow():ITextFlow;
		function get composedLines():Array;
		function setFocus():void;
		function formatChanged(notifyModelChanged:Boolean = true):void;
		function setRootElement(value:IContainerFormattedElement):void;
		function dispose():void;
		function interactionManagerChanged(newInteractionManager:ISelectionManager):void;
		function updateCompositionShapes():void;
		function getLastVisibleLine():ITextFlowLine;
		function set shapesInvalid(shapesInvalid:Boolean):void;
		function get shapesInvalid():Boolean;
		function addComposedLine(textLine:ITextLine):void;
		function addFloatAt(absolutePosition:int, float:IUIBase, floatType:String, x:Number, y:Number, alpha:Number, matrix:Matrix, depth:Number, knockOutWidth:Number, columnIndex:int, parent:IParentIUIBase):void
		function testLineVisible(blockProgression:String, controllerVisibleBoundsXTW:int, controllerVisibleBoundsYTW:int, controllerVisibleBoundsWidthTW:int, controllerVisibleBoundsHeightTW:int, curLine:ITextFlowLine, textLine:ITextLine):*;
		function get contentTop():Number;
		function get contentLeft():Number;
		function setTextLengthOnly(i:int):void;
		function set paddingTop(paddingTop:*):void;
		function set paddingBottom(paddingBottom:*):void;
		function set paddingLeft(paddingLeft:*):void;
		function set paddingRight(paddingRight:*):void;
		function setCompositionSize(width:Number, compositionHeight:Number):void;
		function getBackgroundShape():IUIBase;
		function set verticalScrollPolicy(verticalScrollPolicy:String):void;
		function set horizontalScrollPolicy(horizontalScrollPolicy:String):void;
		function drawPointSelection(selFormat:SelectionFormat, x:Number, y:Number, width:Number, height:Number):void;

	}
}
