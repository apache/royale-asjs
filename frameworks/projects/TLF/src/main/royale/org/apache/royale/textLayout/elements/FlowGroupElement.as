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
	import org.apache.royale.text.engine.ContentElement;
	import org.apache.royale.text.engine.GroupElement;
	import org.apache.royale.textLayout.compose.FlowDamageType;
	import org.apache.royale.textLayout.container.IContainerController;
	import org.apache.royale.textLayout.debug.assert;
	import org.apache.royale.textLayout.events.ModelChange;
	import org.apache.royale.textLayout.formats.FormatValue;
	import org.apache.royale.textLayout.formats.ITextLayoutFormat;

	[DefaultProperty("mxmlChildren")]
	/** 
	 * The FlowGroupElement class is the base class for FlowElement objects that can have an array of children. These classes include
	 * TextFlow, ParagraphElement, DivElement, and LinkElement.
	 *
	 * <p>You cannot create a FlowGroupElement object directly. Invoking <code>new FlowGroupElement()</code> throws an error 
	 * exception.</p>
	 *
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0
	 *
	 * @see DivElement
	 * @see LinkElement
	 * @see ParagraphElement
	 * @see TextFlow
	 */
	public class FlowGroupElement extends FlowElement implements IFlowGroupElement
	{
		/** children of the FlowGroupElement.  They must all be FlowElements. Depending on _numChildren either store a single child in _singleChild or multiple children in the array. */
		private var _childArray:Array;
		private var _singleChild:IFlowElement;
		private var _numChildren:int;

		/** Base class - invoking <code>new FlowGroupElement()</code> throws an error exception.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function FlowGroupElement()
		{
			_numChildren = 0;
		}

		override public function get className():String
		{
			return "FlowGroupElement";
		}

		/**
		 *  @private 
		 *  @royaleignorecoercion org.apache.royale.textLayout.elements.IFlowGroupElement
		 */
		public override function deepCopy(startPos:int = 0, endPos:int = -1):IFlowElement
		{
			if (endPos == -1)
				endPos = textLength;

			var retFlow:IFlowGroupElement = shallowCopy(startPos, endPos) as IFlowGroupElement;
			var newFlowElement:IFlowElement;
			for (var idx:int = 0; idx < _numChildren; idx++)
			{
				var child:IFlowElement = getChildAt(idx);
				if (((startPos - child.parentRelativeStart) < child.textLength) && ((endPos - child.parentRelativeStart) > 0))
				{
					// child is in Selected area
					newFlowElement = child.deepCopy(startPos - child.parentRelativeStart, endPos - child.parentRelativeStart);
					retFlow.replaceChildren(retFlow.numChildren, retFlow.numChildren, newFlowElement);
					if (retFlow.numChildren > 1)
					{
						var possiblyEmptyFlowElement:IFlowElement = retFlow.getChildAt(retFlow.numChildren - 2);
						if (possiblyEmptyFlowElement.textLength == 0)
						{
							retFlow.replaceChildren(retFlow.numChildren - 2, retFlow.numChildren - 1);
						}
					}
				}
			}
			return retFlow;
		}

		/* @private */
		public override function getText(relativeStart:int = 0, relativeEnd:int = -1, paragraphSeparator:String = "\n"):String
		{
			var text:String = super.getText();
			return FlowGroupHelper.getText(this, text, relativeStart, relativeEnd, paragraphSeparator);
		}

		// ****************************************
		// Begin TextLayoutFormat Related code
		// ****************************************
		/** @private */
		public override function formatChanged(notifyModelChanged:Boolean = true):void
		{
			super.formatChanged(notifyModelChanged);
			for (var idx:int = 0; idx < _numChildren; idx++)
			{
				var child:IFlowElement = getChildAt(idx);
				child.formatChanged(false);
			}
		}

		/** This gets called when an element has changed its style selection related attributes. This may happen because an
		 * ancestor element changed it attributes.
		 * @private 
		 */
		public override function styleSelectorChanged():void
		{
			super.styleSelectorChanged();
			formatChanged(false);
		}


		// ****************************************
		// End TLFFormat Related code
		// ****************************************
		// ****************************************
		// Begin import helper code
		// ****************************************
		[RichTextContent]
		/** 
		 * Appends an array of children to this object. Uses the <code>replaceChildren()</code> method to append each 
		 * element in the array. Intended for use during an mxml compiled import.
		 * 
		 * @throws TypeError if array element is not a FlowElement or String
		 * @param array - array of children to attach.  Each element of the array must be a FlowElement object or a String.
		 * @see FlowGroupElement#replaceChildren()
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 */
		public function get mxmlChildren():Array
		{
			return _numChildren == 0 ? null : (_numChildren == 1 ? [this._singleChild] : _childArray.slice() );
		}

		public function set mxmlChildren(array:Array):void
		{
			FlowGroupHelper.setMxmlChildren(this, array);
		}

		// ****************************************
		// End import helper code
		// ****************************************
		// ****************************************
		// Begin tree navigation code
		// ****************************************
		/** 
		 * Returns the number of FlowElement children that this FlowGroupElement object has.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function get numChildren():int
		{
			return _numChildren;
		}

		/** 
		 * Searches in children for the specified FlowElement object and returns its index position.
		 *
		 * @param child	The FlowElement object item to locate among the children.
		 * @return The index position of the specified chilc.  If <code>child</code> is not found, returns -1.
		 *  
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function getChildIndex(child:IFlowElement):int
		{
			var hi:int = _numChildren - 1;
			// one hole here - if child is null and this has no children then we'll return 0
			if (hi <= 0)
				return _singleChild == child ? 0 : -1;

			var lo:int = 0;
			while (lo <= hi)
			{
				var mid:int = Math.floor((lo + hi) / 2);
				var p:IFlowElement = _childArray[mid];
				if (p.parentRelativeStart == child.parentRelativeStart)
				{
					// during intermediate caluclations there are zero length elements lurking about
					if (p == child)
					{
						CONFIG::debug
						{
							assert(_childArray.indexOf(child) == mid, "Bad getChildIndex"); }
						return mid;
					}
					var testmid:int;
					if (p.textLength == 0)
					{
						// look forward for a match
						for (testmid = mid; testmid < _numChildren; testmid++)
						{
							p = _childArray[testmid];
							if (p == child)
							{
								CONFIG::debug
								{
									assert(_childArray.indexOf(child) == testmid, "Bad getChildIndex"); }
								return testmid;
							}
							if (p.textLength != 0)
								break;
						}
					}

					// look backwards
					while (mid > 0)
					{
						mid--;
						p = _childArray[mid];
						if (p == child)
						{
							CONFIG::debug
							{
								assert(_childArray.indexOf(child) == mid, "Bad getChildIndex"); }
							return mid;
						}
						if (p.textLength != 0)
							break;
					}
					CONFIG::debug
					{
						assert(_childArray.indexOf(child) == -1, "Bad getChildIndex"); }
					return -1;
				}
				if (p.parentRelativeStart < child.parentRelativeStart)
					lo = mid + 1;
				else
					hi = mid - 1;
			}
			CONFIG::debug
			{
				assert(_childArray.indexOf(child) == -1, "Bad getChildIndex"); }
			return -1;
		}

		/** 
		 * Returns the FlowElement child at the specified index.
		 * 
		 * @param index the position at which to find the FlowElement object.
		 *
		 * @return  the child FlowElement object at the specified position.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function getChildAt(index:int):IFlowElement
		{
			if (_numChildren > 1)
				return _childArray[index];
			return index == 0 ? _singleChild : null;
		}

		/** @private */
		public function getNextLeafHelper(limitElement:IFlowGroupElement, child:IFlowElement):IFlowLeafElement
		{
			var idx:int = getChildIndex(child);
			if (idx == -1)
				return null;	// bug?

			if (idx == _numChildren - 1)
			{
				if (limitElement == this || !parent)
					return null;

				return parent.getNextLeafHelper(limitElement, this);
			}

			var childFlowElement:IFlowElement = getChildAt(idx + 1);
			return (childFlowElement is IFlowLeafElement) ? IFlowLeafElement(childFlowElement) : FlowGroupElement(childFlowElement).getFirstLeaf();
		}

		/** @private */
		public function getPreviousLeafHelper(limitElement:IFlowGroupElement, child:IFlowElement):IFlowLeafElement
		{
			var idx:int = getChildIndex(child);
			if (idx == -1)
				return null;	// bug?

			if (idx == 0)
			{
				if (limitElement == this || !parent)
					return null;

				return parent.getPreviousLeafHelper(limitElement, this);
			}

			var childFlowElement:IFlowElement = getChildAt(idx - 1);
			return (childFlowElement is IFlowLeafElement) ? IFlowLeafElement(childFlowElement) : FlowGroupElement(childFlowElement).getLastLeaf();
		}

		/**
		 * Given a relative text position, find the leaf element that contains the position. 
		 *
		 * <p>Looks down the flow element hierarchy to find the IFlowLeafElement that 
		 * contains the specified position. The specified position 
		 * is relative to this FlowElement object.</p>
		 *
		 * @param relativePosition	relative text index to look up.
		 * @return	the leaf element containing the relative position.
		 *
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function findLeaf(relativePosition:int):IFlowLeafElement
		{
			var found:IFlowLeafElement = null;
			var childIdx:int = findChildIndexAtPosition(relativePosition);
			if (childIdx != -1)
			{
				// childIdx is index of the first child containing pos. Many of its following siblings
				// may also contain pos if their respective previous siblings are zero-length.
				// Check them all until a leaf containing pos is found.
				do
				{
					var child:IFlowElement = this.getChildAt(childIdx++);
					if (!child)
						break;

					var childRelativePos:int = relativePosition - child.parentRelativeStart;
					if (child is FlowGroupElement)
						found = IFlowGroupElement(child).findLeaf(childRelativePos);
					else
					{
						// if its not a FlowGroupElement than it must be a FlowLeafElement
						CONFIG::debug
						{
							assert(child is IFlowLeafElement, "Invalid child in FlowGroupElement.findLeaf"); }
						if (childRelativePos >= 0 && childRelativePos < child.textLength || (child.textLength == 0 && _numChildren == 1))
							found = IFlowLeafElement(child);
					}
				} while (!found && !child.textLength);
			}
			return found;
		}

		/**
		 * Given a relative text position, find the index of the first child FlowElement that contains the relative position. 
		 * More than one child can contain relative position because of zero length FlowElements.
		 *  
		 * <p>Examine the children to find the FlowElement that contains the relative position. The supplied relative position 
		 * is relative to this FlowElement.</p>
		 *
		 * @param relativePosition 	the position relative to this element
		 * @return 	index of first child element containing <code>relativePosition</code>
		 *
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function findChildIndexAtPosition(relativePosition:int):int
		{
			var lo:int = 0;
			var hi:int = _numChildren - 1;
			while (lo <= hi)
			{
				var mid:int = Math.floor((lo + hi) / 2);
				var child:IFlowElement = getChildAt(mid);
				if (child.parentRelativeStart <= relativePosition)
				{
					// always return the first zero length element in the list
					if (child.parentRelativeStart == relativePosition)
					{
						while (mid != 0)
						{
							child = getChildAt(mid - 1);
							if (child.textLength != 0)
								break;
							mid--;
						}
						return mid;
					}
					if (child.parentRelativeStart + child.textLength > relativePosition)
						return mid;
					lo = mid + 1;
				}
				else
					hi = mid - 1;
			}
			return -1;
		}

		/**
		 * Returns the first FlowLeafElement descendant of this group.
		 *
		 * @return the first FlowLeafElement object.
		 *
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function getFirstLeaf():IFlowLeafElement
		{
			if (_numChildren > 1)
			{
				for (var idx:int = 0; idx < _numChildren; idx++)
				{
					var child:IFlowElement = _childArray[idx];
					var leaf:IFlowLeafElement = (child is FlowGroupElement) ? FlowGroupElement(child).getFirstLeaf() : IFlowLeafElement(child);
					if (leaf)
						return leaf;
				}
				return null;
			}
			return _numChildren == 0 ? null : ((_singleChild is FlowGroupElement) ? FlowGroupElement(_singleChild).getFirstLeaf() : IFlowLeafElement(_singleChild));
		}

		/**
		 * Returns the last FlowLeafElement descendent of this group.
		 *
		 * @return the last FlowLeafElement object.
		 *
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function getLastLeaf():IFlowLeafElement
		{
			if (_numChildren > 1)
			{
				for (var idx:int = _numChildren; idx != 0; idx--)
				{
					var child:IFlowElement = _childArray[idx - 1];
					var leaf:IFlowLeafElement = (child is FlowGroupElement) ? FlowGroupElement(child).getLastLeaf() : IFlowLeafElement(child) ;
					if (leaf)
						return leaf;
				}
				return null;
			}
			return _numChildren == 0 ? null : ((_singleChild is FlowGroupElement) ? FlowGroupElement(_singleChild).getLastLeaf() : IFlowLeafElement(_singleChild));
		}

		/** @private */
		public override function getCharAtPosition(relativePosition:int):String
		{
			var leaf:IFlowLeafElement = findLeaf(relativePosition);
			return leaf ? leaf.getCharAtPosition(relativePosition - leaf.getElementRelativeStart(this)) : "";
		}

		/** @private apply func to all elements until func says stop */
		public override function applyFunctionToElements(func:Function):Boolean
		{
			if (func(this))
				return true;
			for (var idx:int = 0; idx < _numChildren; idx++)
			{
				if (getChildAt(idx).applyFunctionToElements(func))
					return true;
			}
			return false;
		}

		// ****************************************
		// End tree navigation code
		// ****************************************
		// ****************************************
		// Begin tree modification support code
		// ****************************************
		/** @private */
		public function removeBlockElement(child:IFlowElement, block:ContentElement):void
		{
			// when Image's are moved into ParagraphElement's this assertion should always fire
			CONFIG::debug
			{
				assert(child is InlineGraphicElement, "invalid call to removeBlockElement"); }
		}

		/** @private */
		public function insertBlockElement(child:IFlowElement, block:ContentElement):void
		{
			// when Image's are moved into ParagraphElement's this assertion should always fire
			CONFIG::debug
			{
				assert(child is InlineGraphicElement, "invalid call to insertBlockElement"); }
		}

		/** @private 
		 * True if there is a corresponding FTE data structure currently instantiated.
		 */
		public function hasBlockElement():Boolean
		{
			CONFIG::debug
			{
				assert(false, "invalid call to hasBlockElement"); }
			return false;
		}

		/** @private */
		public function createContentAsGroup(pos:int = 0):GroupElement
		{
			CONFIG::debug
			{
				assert(false, "invalid call to createContentAsGroup"); }
			return null;
		}

		/** @private This is only called from SpanElement.splitAtPosition */
		public function addChildAfterInternal(child:IFlowElement, newChild:IFlowElement):void
		{
			// this function was kept for efficiency purposes. It is used by splitForChange
			// which in turn is used by applyCharacterFormat, when changing the
			// attributes applied to characters.  In the end, the length of the document
			// will be the same. So, without this fnction, we would be creating a new
			// span, updating the lengths, and then removing a part of the span and updating
			// the lengths again (getting the same exact lengths we had before). This can be
			// inefficient. So, this function does everything addChildAfter does, without
			// updating the lengths. This is an internal function since the user really has
			// to know what they're doing and will not be exposed as a public API
			CONFIG::debug
			{
				assert(_numChildren != 0, "addChildAfter must have children"); }
			CONFIG::debug
			{
				assert(getChildIndex(child) != -1, "addChildAfter: before child must be in array"); }
			if (_numChildren > 1)
			{
				// TODO: binary search for indexOf child
				CONFIG::debug
				{
					assert(_childArray.indexOf(child) != -1, "Bad call to addChildAfterInternal"); }
				_childArray.splice(_childArray.indexOf(child) + 1, 0, newChild);
			}
			else
			{
				// not found returns above returns -1 so behave the same
				CONFIG::debug
				{
					assert(_singleChild == child, "Bad call to addChildAfterInternal"); }
				_childArray = [_singleChild, newChild];
				_singleChild = null;
			}
			_numChildren++;
			newChild.setParentAndRelativeStartOnly(this, child.parentRelativeEnd);
		}

		/**
		 * Helper for replaceChildren.  Determines if elem can legally be a child of this.
		 * @return true --> ok, false--> not a legal child
		 * @private 
		 */
		public function canOwnFlowElement(elem:IFlowElement):Boolean
		{
			return !(elem is ITextFlow) && !(elem is IFlowLeafElement) && !(elem is ISubParagraphGroupElementBase) && !(elem is IListItemElement) && !(elem is ITableElement);
		}

		/** @private */
		private static function getNestedArgCount(obj:Object):uint
		{
			return (obj is Array) ? obj.length : 1;
		}

		/** @private */
		private static function getNestedArg(obj:Object, index:uint):FlowElement
		{
			CONFIG::debug
			{
				assert(index < getNestedArgCount(obj), "bad index to getNestedArg"); }
			return ((obj is Array) ? obj[index] : obj) as FlowElement;
		}

		/**
		 * Replaces child elements in the group with the specified new elements. Use the <code>beginChildIndex</code> and
		 * <code>endChildIndex</code> parameters to govern the operation as follows:
		 * <p><ul>
		 * <li>To delete elements, do not pass any replacement elements.</li>
		 * <li>To insert elements, pass the same value for <code>beginChildIndex</code> and <code>endChildIndex</code>.  
		 * The new elements is inserted before the specified index.</li>
		 * <li>To append elements, pass <code>numChildren</code> for <code>beginChildIndex</code> and <code>endChildIndex</code>.</li>
		 * </ul></p>
		 * <p>Otherwise, this method replaces the specified elements, starting with the element at <code>beginChildIndex</code> 
		 * and up to but not including <code>endChildIndex</code>.</p>
		 * 
		 * @param beginChildIndex The index value for the start position of the replacement range in the children array.
		 * @param endChildIndex The index value following the end position of the replacement range in the children array.
		 * @param rest The elements to replace the specified range of elements. Can be a sequence containing flow elements or
		 * arrays or vectors thereof.
		 *	 
		 * @throws RangeError The <code>beginChildIndex</code> or <code>endChildIndex</code> specified is out of range.
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function replaceChildren(beginChildIndex:int, endChildIndex:int, ...rest):void
		{
			if (beginChildIndex > _numChildren || endChildIndex > _numChildren)
				throw RangeError(GlobalSettings.resourceStringFunction("badReplaceChildrenIndex"));

			var thisAbsStart:int = getAbsoluteStart();
			var absStartIdx:int = thisAbsStart + (beginChildIndex == _numChildren ? textLength : getChildAt(beginChildIndex).parentRelativeStart);
			var relStartIdx:int = beginChildIndex == _numChildren ? textLength : getChildAt(beginChildIndex).parentRelativeStart;

			// deletion phase
			if (beginChildIndex < endChildIndex)
			{
				var child:IFlowElement;	// scratch variable
				var len:int = 0;

				while (beginChildIndex < endChildIndex)
				{
					child = this.getChildAt(beginChildIndex);
					this.modelChanged(ModelChange.ELEMENT_REMOVAL, child, child.parentRelativeStart, child.textLength);
					child.removed();
					len += child.textLength;

					child.setParentAndRelativeStart(null, 0);
					if (_numChildren == 1)
					{
						_singleChild = null;
						_numChildren = 0;
					}
					else
					{
						_childArray.splice(beginChildIndex, 1);
						_numChildren--;
						if (_numChildren == 1)
						{
							_singleChild = _childArray[0];
							_childArray = null;
						}
					}
					endChildIndex--;
				}
				if (len)
				{
					// TODO: this code should move into updateLengths.  updateLengths needs a rewrite
					// as it assumes that any element that is removed has its length set to zero and updateLengths
					// is called on that element first.  replaceChildren doesn't do that - it just removes the element

					// until rewrite reuse endChildIndex and update start of all following elements
					while (endChildIndex < _numChildren)
					{
						child = getChildAt(endChildIndex);
						child.setParentRelativeStart(child.parentRelativeStart - len);
						endChildIndex++;
					}

					// update lengths
					updateLengths(absStartIdx, -len, true);

					deleteContainerText(relStartIdx + len, len);
				}
			}
			CONFIG::debug
			{
				assert(thisAbsStart == getAbsoluteStart(), "replaceChildren: Bad thisAbsStart"); }
			var childrenToAdd:int = 0;		// number of children to add
			var flatNewChildList:Array;		// stores number of children when > 1
			var newChildToAdd:IFlowElement;	// stores a single child to add - avoids creating an Array for the 99% case

			var newChild:IFlowElement; 		// scratch
			var idx:int;					// scratch

			for each (var obj:Object in rest)
			{
				if (!obj)
					continue;

				var numNestedArgs:int = getNestedArgCount(obj);
				for (idx = 0; idx < numNestedArgs; idx++)
				{
					newChild = getNestedArg(obj, idx);
					if (newChild)
					{
						var newChildParent:IFlowGroupElement = newChild.parent;
						if (newChildParent)
						{
							if (newChildParent == this)
							{
								// special handling in this case
								var childIndex:int = getChildIndex(newChild);
								newChildParent.removeChild(newChild);
								thisAbsStart = getAbsoluteStart();	// is it in the same flow?
								if (childIndex <= beginChildIndex)
								{
									beginChildIndex--;
									absStartIdx = thisAbsStart + (beginChildIndex == _numChildren ? textLength : getChildAt(beginChildIndex).parentRelativeStart);
									relStartIdx = beginChildIndex == _numChildren ? textLength : getChildAt(beginChildIndex).parentRelativeStart;
								}
							}
							else
							{
								newChildParent.removeChild(newChild);
								thisAbsStart = getAbsoluteStart();	// is it in the same flow?
								absStartIdx = thisAbsStart + (beginChildIndex == _numChildren ? textLength : getChildAt(beginChildIndex).parentRelativeStart);
								relStartIdx = beginChildIndex == _numChildren ? textLength : getChildAt(beginChildIndex).parentRelativeStart;
							}
						}

						if (!canOwnFlowElement(newChild))
						{
							throw new Error(GlobalSettings.resourceStringFunction("invalidChildType") + ". " + defaultTypeName + " cannot own " + newChild.defaultTypeName);
						}

						// manage as an array or a single child
						if (childrenToAdd == 0)
							newChildToAdd = newChild;
						else if (childrenToAdd == 1)
							flatNewChildList = [newChildToAdd, newChild];
						else
							flatNewChildList.push(newChild);
						childrenToAdd++;
					}
				}
			}

			if (childrenToAdd)
			{
				// TODO-9/18/2008-ideally, do the following in one shot, but insertBlockElement
				// called from setParentAndRelativeStart in the loop below has different behavior
				// based on the size of _children (zero vs. non-zero)
				// _children.splice(beginChildIndex,0,flatNewChildList);
				var addedTextLength:uint = 0;
				for (idx = 0; idx < childrenToAdd; idx++)
				{
					newChild = childrenToAdd == 1 ? newChildToAdd : flatNewChildList[idx];

					if (_numChildren == 0)
						_singleChild = newChild;
					else if (_numChildren > 1)
						_childArray.splice(beginChildIndex, 0, newChild);
					else
					{
						_childArray = beginChildIndex == 0 ? [newChild, _singleChild] : [_singleChild, newChild];
						_singleChild = null;
					}
					_numChildren++;
					newChild.setParentAndRelativeStart(this, relStartIdx + addedTextLength);
					addedTextLength += newChild.textLength;
					beginChildIndex++;	// points to the next slot
				}
				CONFIG::debug
				{
					assert(thisAbsStart == getAbsoluteStart(), "replaceChildren: Bad thisAbsStart"); }
				if (addedTextLength)
				{
					// update following elements - see comment above.
					// it would be best if this loop only ran once
					while (beginChildIndex < _numChildren)
					{
						child = getChildAt(beginChildIndex++);
						child.setParentRelativeStart(child.parentRelativeStart + addedTextLength);
					}
					updateLengths(absStartIdx, addedTextLength, true);
					var enclosingContainer:IContainerController = getEnclosingController(relStartIdx);
					if (enclosingContainer)
						enclosingContainer.setTextLength(enclosingContainer.textLength + addedTextLength);
				}
				for (idx = 0; idx < childrenToAdd; idx++)
				{
					newChild = childrenToAdd == 1 ? newChildToAdd : flatNewChildList[idx];
					this.modelChanged(ModelChange.ELEMENT_ADDED, newChild, newChild.parentRelativeStart, newChild.textLength);
				}
			}
			else
			{
				var tFlow:ITextFlow = getTextFlow();
				if (tFlow != null)
				{
					// beginChildIndex points to the next element
					// use scratch idx as "damageStart"
					if (beginChildIndex < _numChildren)
					{
						// first, look for the next element and damage the beginning.
						idx = thisAbsStart + getChildAt(beginChildIndex).parentRelativeStart;
					}
					else if (beginChildIndex > 1)
					{
						// damage the end of the previous element
						newChild = getChildAt(beginChildIndex - 1);
						idx = thisAbsStart + newChild.parentRelativeStart + newChild.textLength - 1;
					}
					else
					{
						// damage the very end of the textFlow
						idx = thisAbsStart;
						if (idx >= tFlow.textLength)
							idx--;
					}
					tFlow.damage(idx, 1, FlowDamageType.INVALID, false);
				}
			}
		}

		/** 
		 * Appends a child FlowElement object. The new child is added to the end of the children list.
		 * 
		 * @param child The child element to append.
		 *
		 * @return  the added child FlowElement 
		 * 
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function addChild(child:IFlowElement):IFlowElement
		{
			replaceChildren(_numChildren, _numChildren, child);
			return child;
		}

		/** 
		 * Adds a child FlowElement object at the specified index position.
		 *
		 * @param The index of the position at which to add the child element, with the first position being 0.
		 * @param child The child element to add.
		 * @throws RangeError The <code>index</code> is out of range.
		 *
		 * @return  the added child FlowElement 
		 *
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 *
		 */
		public function addChildAt(index:uint, child:IFlowElement):IFlowElement
		{
			replaceChildren(index, index, child);
			return child;
		}

		/** 
		 * Removes the specified child FlowElement object from the group.
		 *
		 * @param child The child element to remove.
		 * @throws ArgumentError The <code>child</code> is not found.
		 *
		 * @return  the removed child FlowElement object 
		 *
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 *
		 */
		public function removeChild(child:IFlowElement):IFlowElement
		{
			var index:int = getChildIndex(child);
			if (index == -1)
				throw new Error(GlobalSettings.resourceStringFunction("badRemoveChild"));

			removeChildAt(index);
			return child;
		}

		/** 
		 * Removes the child FlowElement object at the specified index position.
		 *
		 * @param index position at which to remove the child element.
		 * @throws RangeError The <code>index</code> is out of range.
		 *
		 * @return  the child FlowElement object removed from the specified position.
		 *
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function removeChildAt(index:uint):IFlowElement
		{
			var childToReplace:IFlowElement = getChildAt(index);
			replaceChildren(index, index + 1);
			return childToReplace;
		}

		/** 
		 * Splits this object at the position specified by the <code>childIndex</code> parameter. If this group element has 
		 * a parent, creates a shallow copy of this object and replaces its children with the elements up to the index. Moves 
		 * elements following <code>childIndex</code> into the copy.
		 * 
		 * @return the new FlowGroupElement object.
		 * @throws RangeError if <code>childIndex</code> is greater than the length of the children.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		public function splitAtIndex(childIndex:int):IFlowGroupElement
		{
			if (childIndex > _numChildren)
				throw RangeError(GlobalSettings.resourceStringFunction("invalidSplitAtIndex"));

			var newSibling:FlowGroupElement = shallowCopy() as FlowGroupElement;

			var numChildrenToMove:int = _numChildren - childIndex;
			if (numChildrenToMove == 1)
				newSibling.addChild(removeChildAt(childIndex));
			else if (numChildrenToMove != 0)
			{
				var childArray:Array = _childArray.slice(childIndex);
				this.replaceChildren(childIndex, _numChildren - 1);
				newSibling.replaceChildren(0, 0, childArray);
			}

			if (parent)
			{
				var myidx:int = parent.getChildIndex(this);
				parent.replaceChildren(myidx + 1, myidx + 1, newSibling);
			}

			// This causes errors in operations that assume zero children. Normalizing makes this assumption not valid.
			// newSibling.normalizeRange(0,newSibling.textLength);
			return newSibling;
		}

		/** 
		 * Splits this object at the position specified by the <code>relativePosition</code> parameter, where 
		 * the relative position is a relative text position in this element.
		 * 
		 * @throws RangeError if relativePosition is greater than textLength, or less than 0.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 * 
		 * @private
		 */
		public override function splitAtPosition(relativePosition:int):IFlowElement
		{
			// Creates a shallowCopy of this and adds it to parent after this.
			// Moves elements from characterIndex forward into the copy
			// returns the new shallowCopy
			if ((relativePosition < 0) || (relativePosition > textLength))
				throw RangeError(GlobalSettings.resourceStringFunction("invalidSplitAtPosition"));

			var curElementIdx:int;

			if (relativePosition == textLength)
				curElementIdx = _numChildren;
			else
			{
				curElementIdx = findChildIndexAtPosition(relativePosition);
				var curFlowElement:IFlowElement = getChildAt(curElementIdx);

				if (curFlowElement.parentRelativeStart != relativePosition)
				{
					curFlowElement.splitAtPosition(relativePosition - curFlowElement.parentRelativeStart);
					// increase by one. It's the new element that we want to move over.
					curElementIdx++;
				}
			}

			// increase by one. It's the new element that we want to move over.
			return splitAtIndex(curElementIdx);
		}

		/** @private */
		public override function normalizeRange(normalizeStart:uint, normalizeEnd:uint):void
		{
			var idx:int = findChildIndexAtPosition(normalizeStart);
			if (idx != -1 && idx < _numChildren)
			{
				// backup over zero length children
				var child:IFlowElement = getChildAt(idx);
				normalizeStart = normalizeStart - child.parentRelativeStart;

				CONFIG::debug
				{
					assert(normalizeStart >= 0, "bad normalizeStart in normalizeRange"); }
				for (;;)
				{
					// watch out for changes in the length of the child
					var origChildEnd:int = child.parentRelativeStart + child.textLength;
					child.normalizeRange(normalizeStart, normalizeEnd - child.parentRelativeStart);
					var newChildEnd:int = child.parentRelativeStart + child.textLength;
					normalizeEnd += newChildEnd - origChildEnd;	// adjust

					// no zero length children
					if (child.textLength == 0 && !child.bindableElement)
						replaceChildren(idx, idx + 1);
					else
						idx++;

					if (idx == _numChildren)
						break;

					// next child
					child = getChildAt(idx);

					if (child.parentRelativeStart > normalizeEnd)
						break;

					normalizeStart = 0;		// for the next child
				}
			}
		}

		/** @private */
		public override function applyWhiteSpaceCollapse(collapse:String):void
		{
			if (collapse == null)
				collapse = this.computedFormat.whiteSpaceCollapse;	// top of the cascade?
			else
			{
				var ffc:ITextLayoutFormat = this.formatForCascade;
				var wsc:* = ffc ? ffc.whiteSpaceCollapse : undefined;
				if (wsc !== undefined && wsc != FormatValue.INHERIT)
					collapse = wsc;
			}
			for (var idx:int = 0; idx < _numChildren;)
			{
				var child:IFlowElement = getChildAt(idx);
				child.applyWhiteSpaceCollapse(collapse);
				if (child.parent == this)	// check to see if child was removed (could have been
					++idx;
			}

			// If the element was added automatically, it may now have no content and needs to be removed
			// This can happen with whitespace between paragraphs that is added by set mxmlChildren
			if (textLength == 0 && impliedElement && parent != null)
				parent.removeChild(this);

			super.applyWhiteSpaceCollapse(collapse);
		}

		/** @private */
		public override function appendElementsForDelayedUpdate(tf:ITextFlow, changeType:String):void
		{
			for (var idx:int = 0; idx < _numChildren; idx++)
			{
				var child:IFlowElement = getChildAt(idx);
				child.appendElementsForDelayedUpdate(tf, changeType);
			}
		}
		// ****************************************
		// End tree modification support code
		// ****************************************
		// ****************************************
		// Begin debug support code
		// ****************************************
		/** @private */
		CONFIG::debug
		public override function debugCheckFlowElement(depth:int = 0, extraData:String = ""):int
		{
			var rslt:int = super.debugCheckFlowElement(depth, extraData);

			// debugging function that asserts if the flow element is in an invalid state
			var totalChildLength:int = 0;
			if (_numChildren)
			{
				for (var childIndex:int = 0; childIndex < _numChildren; ++childIndex)
				{
					var child:IFlowElement = getChildAt(childIndex);
					rslt += assert(child.parent == this, "child doesn't point to parent");

					// totalChildLength is relative offset to child
					rslt += assert(child.parentRelativeStart == totalChildLength, "child start offset wrong");
					rslt += child.debugCheckFlowElement(depth + 1);
					totalChildLength += child.textLength;
				}
			}
			else
			{
				// only spans may own text
				rslt += assert(this is ISpanElement || textLength == 0, "only spans may have text");
				totalChildLength = textLength;
			}
			assert(totalChildLength == textLength, "child total textLength wrong");
			return rslt;
		}
		// **************************************** 
		// End debug support code
		// ****************************************
	}
}
