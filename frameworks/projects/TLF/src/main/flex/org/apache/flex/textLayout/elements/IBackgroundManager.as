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
	import org.apache.royale.textLayout.elements.IFlowElement;
	import org.apache.royale.geom.Rectangle;
	import org.apache.royale.textLayout.container.IContainerController;
	import org.apache.royale.text.engine.ITextLine;
	import org.apache.royale.textLayout.elements.IFlowLeafElement;
	import org.apache.royale.textLayout.compose.ITextFlowLine;
	import org.apache.royale.textLayout.elements.ITextFlow;
	import org.apache.royale.graphics.IGraphicShape;

	public interface IBackgroundManager
	{
		function clearBlockRecord():void;

		function addBlockRect(elem:IFlowElement, r:Rectangle, cc:IContainerController = null, style:String = null):void;

		function addBlockElement(elem:IFlowElement):void;

		function addRect(tl:ITextLine, fle:IFlowLeafElement, r:Rectangle, color:uint, alpha:Number):void;

		function addNumberLine(tl:ITextLine, numberLine:ITextLine):void;

		function finalizeLine(line:ITextFlowLine):void;

		function getEntry(line:ITextLine):*;

		function drawAllRects(textFlow:ITextFlow, bgShape:IGraphicShape, constrainWidth:Number, constrainHeight:Number):void;

		function removeLineFromCache(tl:ITextLine):void;

		function onUpdateComplete(controller:IContainerController):void;

		function getShapeRectArray():Array;
	}
}
