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
package org.apache.flex.textLayout.elements {
	import org.apache.flex.text.engine.TextElement;
	import org.apache.flex.text.engine.FontMetrics;
	import org.apache.flex.geom.Rectangle;
	import org.apache.flex.text.engine.ITextLine;
	import org.apache.flex.textLayout.compose.ISWFContext;

	public interface IFlowLeafElement extends IFlowElement {
		function getNextLeaf(elem : IFlowGroupElement = null) : IFlowLeafElement;

		function getCSSInlineBox(bp : String, textLine : ITextLine, para : IParagraphElement = null, swfContext : ISWFContext = null) : Rectangle;
		function getEffectiveLineHeight(bp : String) : Number;
		function getComputedFontMetrics() : FontMetrics;
		function getPreviousLeaf(elem : IFlowGroupElement = null) : IFlowLeafElement;
		function getEffectiveFontSize() : Number;
		function get text():String;
		function quickInitializeForSplit(sibling:FlowLeafElement,newSpanLength:int,newSpanTextElement:TextElement):void;
	}
}