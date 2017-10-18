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
package org.apache.royale.textLayout.elements {
	import org.apache.royale.text.engine.GroupElement;
	import org.apache.royale.text.engine.ContentElement;
	public interface IFlowGroupElement extends IFlowElement {
		function findLeaf(childRelativePos : int) : IFlowLeafElement;
		function getFirstLeaf() : IFlowLeafElement;
		function getLastLeaf() : IFlowLeafElement;
		function findChildIndexAtPosition(begStart : int) : int;
		function getChildAt(begChildIdx : int) : IFlowElement;
		function getChildIndex(child:IFlowElement):int

		function get numChildren() : int;

		function addChildAt(index:uint, elem:IFlowElement):IFlowElement;
		function splitAtIndex(childIdx : int) : IFlowGroupElement;
		function replaceChildren(beginChildIndex:int, endChildIndex:int, ...rest):void;
		function get mxmlChildren():Array;

		function set mxmlChildren(array : Array) : void;

		function addChild(child : IFlowElement) : IFlowElement;
		function removeChild(child:IFlowElement):IFlowElement;
		function removeChildAt(index:uint):IFlowElement;
		function hasBlockElement():Boolean;
		function insertBlockElement(child:IFlowElement, block:ContentElement):void;
		function removeBlockElement(child:IFlowElement, block:ContentElement):void;
		function canOwnFlowElement(elem:IFlowElement):Boolean;
		function getNextLeafHelper(limitElement:IFlowGroupElement,child:IFlowElement):IFlowLeafElement;
		function getPreviousLeafHelper(limitElement:IFlowGroupElement,child:IFlowElement):IFlowLeafElement;
		function createContentAsGroup(pos:int=0):GroupElement;
		function addChildAfterInternal(child:IFlowElement, newChild:IFlowElement):void;
		
	}
}
