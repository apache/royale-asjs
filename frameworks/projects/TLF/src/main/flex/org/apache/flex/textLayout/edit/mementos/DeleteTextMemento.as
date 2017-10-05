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
package org.apache.royale.textLayout.edit.mementos {
	import org.apache.royale.textLayout.elements.FlowElement;
	import org.apache.royale.textLayout.elements.IFlowElement;
	import org.apache.royale.textLayout.elements.IFlowGroupElement;
	import org.apache.royale.textLayout.elements.ITextFlow;
	import org.apache.royale.textLayout.elements.IFlowLeafElement;
	import org.apache.royale.textLayout.edit.ElementMark;
	import org.apache.royale.textLayout.edit.IMemento;

// Use this for operations that undo using copy & paste
/**
 * @royaleignorecoercion org.apache.royale.textLayout.elements.IFlowGroupElement
 */
public class DeleteTextMemento extends BaseMemento implements IMemento
{
	private var _commonRootMark:ElementMark;
	private var _startChildIndex:int;
	private var _endChildIndex:int;
	private var _originalChildren:Array;
	private var _absoluteStart:int;
		
	protected var scrapChildren:Array;
	protected var replaceCount:int;

	public function DeleteTextMemento(textFlow:ITextFlow, absoluteStart:int, absoluteEnd:int)
	{
		super(textFlow);
		
		// Find the lowest possible common root that contains both start and end, and is at least one paragraph
		// We move the common root to the paragraph level so that we don't have to worry on undo about spans that have merged.
		var startLeaf:IFlowLeafElement = textFlow.findLeaf(absoluteStart);
		//var cRoot:IFlowGroupElement = startLeaf.parent;
		var cRoot:IFlowGroupElement = startLeaf.getParagraph().parent;
		while (cRoot && cRoot.parent && (cRoot.getAbsoluteStart() + cRoot.textLength < absoluteEnd || (cRoot.getAbsoluteStart() == absoluteStart && cRoot.getAbsoluteStart() + cRoot.textLength == absoluteEnd)))
			cRoot = cRoot.parent;
		
		// Find even element boundaries smallest amount that contains the entire range
		if (cRoot)
		{
			var rootStart:int = cRoot.getAbsoluteStart();
			_startChildIndex = cRoot.findChildIndexAtPosition(absoluteStart - rootStart);
			_endChildIndex = cRoot.findChildIndexAtPosition(absoluteEnd - rootStart - 1);
			if (_endChildIndex < 0)
				_endChildIndex = cRoot.numChildren - 1;
			
			var startChild:IFlowElement = cRoot.getChildAt(_startChildIndex);
			var absoluteStartAdjusted:int = startChild.getAbsoluteStart();
			var endChild:IFlowElement = cRoot.getChildAt(_endChildIndex);
			var absoluteEndAdjusted:int = endChild.getAbsoluteStart() + endChild.textLength;

			// Set how many elements we expect to replace on undo. Although the delete does a merge at the end if a CR was deleted, the merge
			// (if there was one) will have been undone before DeleteTextMemento.undo() is called. 
			// Basic rule is that if there was content before the delete range in the common root, then there will be an element after the delete
			// with that content that should get replaced. Likewise for if there's content after the delete range in the common root. The exception
			// to the rule is if the common root is a grandparent of the range to be deleted, then there will be just one element getting replaced.
			replaceCount = 0;		// how many original (post-do) elements we're replacing
			if (_startChildIndex == _endChildIndex)
			{
				if (absoluteStartAdjusted < absoluteStart || absoluteEndAdjusted > absoluteEnd)	// if we're deleting the entire element, nothing to replace
					replaceCount = 1;
			}
			else
			{
				if (absoluteStartAdjusted < absoluteStart)
					replaceCount++;
				if (absoluteEndAdjusted > absoluteEnd)
					replaceCount++;
			}

			var scrapRoot:IFlowGroupElement = cRoot.deepCopy(absoluteStartAdjusted - rootStart, absoluteEndAdjusted - rootStart) as IFlowGroupElement;
			scrapChildren = scrapRoot.mxmlChildren;
		}
		
		_commonRootMark = new ElementMark(cRoot, 0);
		_absoluteStart = absoluteStart;
	}
		
	public function undo():*
	{ 
		var root:IFlowGroupElement = commonRoot;
		
		// Save off the original children for later redo
		_originalChildren = [];
		for (var childIndex:int = _startChildIndex; childIndex < _startChildIndex + replaceCount; ++childIndex)
			_originalChildren.push(root.getChildAt(childIndex));
		
		// Make copies of the scrapChildren, and add the copies to the main flow
		var addToFlow:Array = [];
		for each (var element:FlowElement in scrapChildren)
			addToFlow.push(element.deepCopy());
		root.replaceChildren(_startChildIndex, _startChildIndex + replaceCount, addToFlow);
	}
	
	public function redo():*
	{ 
		commonRoot.replaceChildren(_startChildIndex, _startChildIndex + scrapChildren.length, _originalChildren);
	}
	
	/**
	 * @royaleignorecoercion org.apache.royale.textLayout.elements.IFlowGroupElement
	 */
	public function get commonRoot():IFlowGroupElement
	{
		return _commonRootMark.findElement(_textFlow) as IFlowGroupElement;
	}
	
}
}
