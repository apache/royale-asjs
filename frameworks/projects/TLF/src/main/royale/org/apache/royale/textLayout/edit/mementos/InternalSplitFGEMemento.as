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
	import org.apache.royale.reflection.getQualifiedClassName;
	import org.apache.royale.textLayout.elements.IFlowLeafElement;
	import org.apache.royale.textLayout.debug.assert;
	import org.apache.royale.textLayout.elements.IParagraphElement;
	import org.apache.royale.textLayout.elements.IFlowGroupElement;
	import org.apache.royale.textLayout.elements.IFlowElement;
	import org.apache.royale.textLayout.elements.ISubParagraphGroupElementBase;
	import org.apache.royale.textLayout.elements.ITextFlow;
	import org.apache.royale.textLayout.elements.FlowGroupElement;
	import org.apache.royale.textLayout.edit.ElementMark;
	import org.apache.royale.textLayout.edit.IMemento;

	public class InternalSplitFGEMemento extends BaseMemento implements IMemento
{
	private var _target:ElementMark;
	private var _undoTarget:ElementMark;
	private var _newSibling:FlowGroupElement;
	private var _skipUndo:Boolean;
	
	public function InternalSplitFGEMemento(textFlow:ITextFlow, target:ElementMark, undoTarget:ElementMark, newSibling:FlowGroupElement)
	{ 
		super(textFlow); 
		_target = target;
		_undoTarget = undoTarget;
		_newSibling = newSibling;
		_skipUndo = (newSibling is ISubParagraphGroupElementBase);
	}
	
	public function get newSibling():FlowGroupElement
	{
		return _newSibling;
	}
	
	static public function perform(textFlow:ITextFlow, elemToSplit:IFlowElement, relativePosition:int, createMemento:Boolean):*
	{
		var target:ElementMark = new ElementMark(elemToSplit,relativePosition);
		var newSib:FlowGroupElement = performInternal(textFlow, target);

		if (createMemento)
		{
			var undoTarget:ElementMark = new ElementMark(newSib,0);
			return new InternalSplitFGEMemento(textFlow, target, undoTarget, newSib);
		}
		else
			return newSib;
	}
	
	/**
	 * @royaleignorecoercion org.apache.royale.textLayout.elements.IFlowGroupElement
	 */
	static public function performInternal(textFlow:ITextFlow, target:ElementMark):*
	{
		var targetElement:IFlowGroupElement = target.findElement(textFlow) as IFlowGroupElement;
		var childIdx:int = target.elemStart == targetElement.textLength ? targetElement.numChildren-1 : targetElement.findChildIndexAtPosition(target.elemStart);
		var child:IFlowElement = targetElement.getChildAt(childIdx);
		var newSib:IFlowGroupElement;
		if (child.parentRelativeStart == target.elemStart)
			newSib = targetElement.splitAtIndex(childIdx);
		else
			newSib = targetElement.splitAtPosition(target.elemStart) as IFlowGroupElement;
		
		if (targetElement is IParagraphElement)
		{
			if (targetElement.textLength <= 1)
			{
				targetElement.normalizeRange(0,targetElement.textLength);
				targetElement.getLastLeaf().quickCloneTextLayoutFormat(newSib.getFirstLeaf());
			}
			else if (newSib.textLength <= 1)
			{
				newSib.normalizeRange(0,newSib.textLength);
				newSib.getFirstLeaf().quickCloneTextLayoutFormat(targetElement.getLastLeaf());
			}
		}
		// debugCheckTextFlow("After InternalSplitFGEMemento.perform");
		
		return newSib;
		
	}
	
	/**
	 * @royaleignorecoercion org.apache.royale.textLayout.elements.IFlowGroupElement
	 */
	public function undo():*
	{ 
		// debugCheckTextFlow("Before InternalSplitFGEMemento.undo");
		if (_skipUndo)
			return;
		
		var target:IFlowGroupElement = _undoTarget.findElement(_textFlow) as IFlowGroupElement;
		// move all children of target into previoussibling and delete target
		CONFIG::debug { assert(target != null,"Missing IFlowGroupElement from undoTarget"); }
		var prevSibling:IFlowGroupElement = target.getPreviousSibling() as IFlowGroupElement;
		CONFIG::debug { assert(getQualifiedClassName(target) == getQualifiedClassName(prevSibling),"Mismatched class in InternalSplitFGEMemento"); }

		target.parent.removeChild(target);
		var lastLeaf:IFlowLeafElement = prevSibling.getLastLeaf();
		prevSibling.replaceChildren(prevSibling.numChildren,prevSibling.numChildren,target.mxmlChildren);
		
		// paragraphs only - watch out for trailing empty spans that need to be removed
		// Harbs 12-24-14 Added check that lastLeaf still exists in the paragraph
		if (prevSibling is IParagraphElement && lastLeaf.parent && lastLeaf.textLength == 0)
			prevSibling.removeChild(lastLeaf);
		
		// debugCheckTextFlow("After InternalSplitFGEMemento.undo");
	}
	
	public function redo():*
	{ return performInternal(_textFlow, _target ); }
}

}
