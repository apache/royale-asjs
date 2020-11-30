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
	
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IRenderedObject;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.graphics.PathBuilder;

	COMPILE::SWF {
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	}

		COMPILE::JS
		{
			import org.apache.royale.utils.UIDUtil;
		}
	/**
	 *  The ClipBead bead allows you to clip
	 *  a graphic Shape using a an arbitrary graphic path.
	 *  The clipping path is defined in the path property
	 *  using a PathBuilder object. This Bead will not
	 *  work on the JS on components which are not implemented
	 *  using SVG.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class ClipBead implements IBead
	{
		private var _strand:IStrand;
		private var _path:PathBuilder;
		private var document:Object;
		
		public function ClipBead()
		{
		}
		
		public function get path():PathBuilder
		{
			return _path;
		}
		
		public function set path(value:PathBuilder):void
		{
			_path = value;
			clip();
		}
		
		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */		
		public function set strand(value:IStrand):void
		{
			_strand = value;
			if (path)
			{
				clip();
			}
		}
		
		COMPILE::SWF
		private function clip():void
		{
			if (!path)
			{
				return;
			}
			var element:DisplayObject = host.$displayObject as DisplayObject;
			var mask:Sprite = new Sprite();
			var g:Graphics = mask.graphics;
			g.beginFill(0);
			path.draw(g);
			g.endFill();
			// remove existing mask from display list
			if (element.mask && element.mask.parent)
			{
				element.mask.parent.removeChild(element.mask);
			}
			// add new mask to display list
			if (element.parent)
			{
				element.parent.addChild(mask);
			}
			// set mask
			mask.x = element.x;
			mask.y = element.y;
			element.mask = mask;
		}
		/**
		 * @royaleignorecoercion Element
		 * @royaleignorecoercion Object
		 */
		COMPILE::JS
		private function clip():void
		{
			if (!path || !host)
			{
				return;
			}
			var svgElement:Node = host.element as Element;
			var defs:Element = getChildNode(svgElement, "defs") as Element;
			var clipPath:Element = getChildNode(defs, "clipPath") as Element;
			clipPath.id = "myClip" + UIDUtil.createUID();
			// clean up existing clip paths
			if (clipPath.hasChildNodes())
			{
				var childNodes:Object = clipPath.childNodes;
				for (var i:int = 0; i < childNodes.length; i++)
				{
					clipPath.removeChild(childNodes[i]);
				}
			}
			// create pathNode
			var pathNode:Element = createChildNode(clipPath, "path") as Element;
			pathNode.setAttribute("d", path.getPathString());
			// set style 
			host.element.style["clipPath"] = "url(#" + clipPath.id + ")";
		}
		
		COMPILE::JS
		private function getChildNode(node:Node, tagName:String):Node
		{
			if (!node.hasChildNodes())
			{
				return createChildNode(node, tagName);
			}
			var childNodes:Object = node.childNodes;
			for (var i:int = 0; i < childNodes.length; i++)
			{
				if (childNodes[i].tagName == tagName)
				{
					return childNodes[i];
				}
					
			}
			return createChildNode(node, tagName);
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
		
	}
}

