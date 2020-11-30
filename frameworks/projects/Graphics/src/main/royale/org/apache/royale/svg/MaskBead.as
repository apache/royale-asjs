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
package org.apache.royale.svg
{
	
	import org.apache.royale.core.ITransformHost;
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IRenderedObject;
	import org.apache.royale.core.IStrand;

	COMPILE::SWF {
		import flash.display.Graphics;
		import flash.display.Sprite;
		import flash.display.DisplayObject;
	}

	COMPILE::JS
	{
		import org.apache.royale.utils.UIDUtil;
		import org.apache.royale.core.IUIBase;
		import org.apache.royale.core.WrappedHTMLElement;
		import org.apache.royale.core.IRenderedObject;
	}
	/**
	 *  The MaskBead transforms an IUIBase element into a mask definition
	 *  and contains methods to attach an existing element to this mask definition.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9
	 */
	public class MaskBead implements IBead
	{
		private var _strand:IStrand;
		private var document:Object;
		private var maskElementId:String;
		
		public function MaskBead()
		{
		}
		
		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  @royaleignorecoercion Element
		 *  @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 *  @royaleignorecoercion org.apache.royale.core.IRenderedObject
		 *  @royaleignorecoercion org.apache.royale.core.IUIBase
		 */		
		public function set strand(value:IStrand):void
		{
			COMPILE::JS 
			{
				_strand = value;
				var currentPositioner:Element = (value as IRenderedObject).element as Element;
				var newPositioner:Element = createChildNode(currentPositioner, "defs") as Element;
				newPositioner = createChildNode(newPositioner, "mask") as Element;
				maskElementId = newPositioner.id = "myMask" + UIDUtil.createUID();
				(value as IUIBase).positioner = newPositioner as WrappedHTMLElement;
				// this helps retains width and height
				newPositioner.setAttribute('style', currentPositioner.getAttribute('style'));
				// move children to new positioner
				var childNodes:Object = currentPositioner.childNodes;
				for (var i:int = 0; i < childNodes.length; i++)
				{
					var childNode:Element = childNodes[i] as Element;
					if (childNode.tagName != "defs")
					{
						newPositioner.appendChild(childNode);
					}
				}
			}
		}
		
		COMPILE::JS
		private function createChildNode(parent:Node, tagName:String):Node
		{
			var svgNs:String = "http://www.w3.org/2000/svg";
			var element:Node = window.document.createElementNS(svgNs, tagName);
			parent.appendChild(element);
			return element;
		}
		/**
		 *  @royaleignorecoercion org.apache.royale.core.IRenderedObject
		 */
		public function get host():IRenderedObject
		{
			return _strand as IRenderedObject;
		}

		COMPILE::SWF 
		public function unmaskElement(renderedObject:IRenderedObject):void
		{
			renderedObject.$displayObject.mask = null;
		}

		COMPILE::SWF 
		public function maskElement(renderedObject:IRenderedObject):void
		{
			renderedObject.$displayObject.x = host.$displayObject.x;
			renderedObject.$displayObject.y = host.$displayObject.y;
			renderedObject.$displayObject.mask = host.$displayObject;
		}

		COMPILE::JS 
		public function unmaskElement(transformHost:ITransformHost):void
		{
			transformHost.transformElement.setAttribute("mask", "");
		}

		COMPILE::JS 
		public function maskElement(transformHost:ITransformHost):void
		{
			transformHost.transformElement.setAttribute("mask", "url(#" + maskElementId + ")");
		}
	}
}

