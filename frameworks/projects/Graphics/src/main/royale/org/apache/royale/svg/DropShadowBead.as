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
	 *  The DropShadowBead bead allows you to filter
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class DropShadowBead implements IBead
	{
		private var _strand:IStrand;
		private var _dx:Number = 0;
		private var _dy:Number = 0;
		private var _stdDeviation:Number = 0;
		private var _width:String = "200%";
		private var _height:String = "200%";
		
		public function DropShadowBead()
		{
		}
		
		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.3
		 */		
		public function set strand(value:IStrand):void
		{
			_strand = value;
			filter();
		}
		
		COMPILE::SWF
		private function filter():void
		{
			// TODO
		}
		/**
		 * @royaleignorecoercion Element
		 * @royaleignorecoercion Object
		 */
		COMPILE::JS
		private function filter():void
		{
			var svgElement:Node = host.element as Element;
			var defs:Element = getChildNode(svgElement, "defs") as Element;
			var filter:Element = getChildNode(defs, "filter") as Element;
			filter.id = "myDropShadow" + UIDUtil.createUID();
			filter.setAttribute("width", _width);
			filter.setAttribute("height", _height);
			// clean up existing filter
			if (filter.hasChildNodes())
			{
				var childNodes:Object = filter.childNodes;
				for (var i:int = 0; i < childNodes.length; i++)
				{
					filter.removeChild(childNodes[i]);
				}
			}
			// create offset
			var offset:Element = createChildNode(filter, "feOffset") as Element;
			offset.setAttribute("dx", dx);
			offset.setAttribute("dy", dy);
			offset.setAttribute("in", "SourceAlpha");
			offset.setAttribute("result", "offsetResult");
			// create blur
			var blur:Element = createChildNode(filter, "feGaussianBlur") as Element;
			blur.setAttribute("stdDeviation", stdDeviation);
			blur.setAttribute("result", "blurResult");
			// create blend
			var blend:Element = createChildNode(filter, "feBlend") as Element;
			blend.setAttribute("in", "SourceGraphic");
			blend.setAttribute("in2", "blurResult");
			blend.setAttribute("mode", "normal");
			// apply filter
			host.element.style["filter"] = "url(#" + filter.id + ")";
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
		
		public function get host():IRenderedObject
		{
			return _strand as IRenderedObject;
		}
		
		public function get stdDeviation():Number
		{
			return _stdDeviation;
		}

		public function set stdDeviation(value:Number):void
		{
			_stdDeviation = value;
		}

		public function get dx():Number
		{
			return _dx;
		}

		public function set dx(value:Number):void
		{
			_dx = value;
		}

		public function get dy():Number
		{
			return _dy;
		}

		public function set dy(value:Number):void
		{
			_dy = value;
		}

	}
}

