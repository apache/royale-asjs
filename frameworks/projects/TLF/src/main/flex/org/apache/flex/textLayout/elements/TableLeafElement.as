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
	import org.apache.flex.textLayout.elements.utils.GeometricElementUtils;
	import org.apache.flex.text.engine.ElementFormat;
	import org.apache.flex.text.engine.ITextLine;
	import org.apache.flex.text.engine.TextElement;
	import org.apache.flex.textLayout.compose.IFlowComposer;
	import org.apache.flex.textLayout.compose.ISWFContext;
	import org.apache.flex.textLayout.compose.SWFContext;
	import org.apache.flex.textLayout.debug.Debugging;
	import org.apache.flex.textLayout.formats.ITextLayoutFormat;

	public class TableLeafElement extends FlowLeafElement implements ITableLeafElement
	{
		private var _table:TableElement;
		public function TableLeafElement(table:TableElement)
		{
			super();
			_table = table;
		}
		override public function get className():String{
			return "TableLeafElement";
		}

		/** @private */
		override public function createContentElement():void
		{
			// not sure if this makes sense...
			if (_blockElement)
				return;
			
			computedFormat;	// BEFORE creating the element
			var flowComposer:IFlowComposer = getTextFlow().flowComposer;
			var swfContext:ISWFContext = flowComposer && flowComposer.swfContext ? flowComposer.swfContext : SWFContext.globalSWFContext;

			var format:ElementFormat = GeometricElementUtils.computeElementFormatHelper (_table.computedFormat, _table.getParagraph(), swfContext); 
			_blockElement = new TextElement(_text,format);
			CONFIG::debug { Debugging.traceFTECall(_blockElement,null,"new TextElement()"); }
			CONFIG::debug { Debugging.traceFTEAssign(_blockElement, "text", _text); }
			super.createContentElement();

		}

		/** @private */
		override protected function get abstract():Boolean
		{ return false; }		
		
		/** @private */
		public override function get defaultTypeName():String
		{ return "table"; }
		
		/** @private */
		public override function get text():String
		{
			return String.fromCharCode(0x16);
		}
		
		/** @private */
		public override function getText(relativeStart:int=0, relativeEnd:int=-1, paragraphSeparator:String="\n"):String
		{
			return _table.getText(relativeStart, relativeEnd, paragraphSeparator);
		}
		
		/** @private */
		public override function normalizeRange(normalizeStart:uint,normalizeEnd:uint):void
		{
			// not sure what to do here (see SpanElement)...
			super.normalizeRange(normalizeStart,normalizeEnd);
		}
		
		/** @private */
		public override function mergeToPreviousIfPossible():Boolean
		{
			// not sure what to do here (see SpanElement)...
			return false;
		}
		
		public override function getNextLeaf(limitElement:IFlowGroupElement=null):IFlowLeafElement
		{
			return _table.getNextLeafHelper(limitElement,this);
		}
		
		public override function getPreviousLeaf(limitElement:IFlowGroupElement=null):IFlowLeafElement
		{
			return _table.getPreviousLeafHelper(limitElement,this);
		}
		/** @private */
		public override function getCharAtPosition(relativePosition:int):String
		{
			return getText(relativePosition,relativePosition);
		}
		public override function get computedFormat():ITextLayoutFormat
		{
			return _table.computedFormat;
		}
		public override function get textLength():int
		{
			return _table.textLength;
		}

		override public function get parent():IFlowGroupElement
		{ 
			return _table; 
		}

		override public function getTextFlow():ITextFlow
		{
			return _table.getTextFlow();
		}
		
		override public function getParagraph():IParagraphElement
		{
			return _table.getParagraph();
		}
		
		override public function getElementRelativeStart(ancestorElement:IFlowElement):int
		{
			return _table.getElementRelativeStart(ancestorElement);
		}

	}
}
