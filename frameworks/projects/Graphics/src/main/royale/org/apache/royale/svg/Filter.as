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
	
	COMPILE::JS
	{
		import org.apache.royale.utils.UIDUtil;
		import org.apache.royale.graphics.utils.addSvgElementToElement;
		import org.apache.royale.events.IEventDispatcher;
	}
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IRenderedObject;
	import org.apache.royale.core.IStrand;
	[DefaultProperty("children")]

	/**
	 *  The Filter bead allows you to filter an SVG element. Filter elements should be added to the strand to achieve the desired effect.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.3
	 */
	public class Filter implements IBead
	{
		private var _strand:IStrand;
		private var _width:String = "200%";
		private var _height:String = "200%";
		private var _children:Array;
//		private var floodColor:uint;
		COMPILE::JS 
		{
			private var _filterElementWrapper:Element;
		}
		
		public function Filter()
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
		protected function filter():void
		{
//			if (!path)
//			{
//				return;
//			}
//			var element:DisplayObject = host.$displayObject as DisplayObject;
//			var mask:Sprite = new Sprite();
//			var g:Graphics = mask.graphics;
//			g.beginFill(0);
//			path.draw(g);
//			g.endFill();
//			// remove existing mask from display list
//			if (element.mask && element.mask.parent)
//			{
//				element.mask.parent.removeChild(element.mask);
//			}
//			// add new mask to display list
//			if (element.parent)
//			{
//				element.parent.addChild(mask);
//			}
//			// set mask
//			mask.x = element.x;
//			mask.y = element.y;
//			element.mask = mask;
		}
		/**
		 * @royaleignorecoercion Element
		 * @royaleignorecoercion org.apache.royale.svg.FilterElement
		 */
		COMPILE::JS
		protected function filter():void
		{
			var svgElement:Node = host.element as Element;
			var defs:Element = getChildNode(svgElement, "defs") as Element;
			_filterElementWrapper = getChildNode(defs, "filter") as Element;
			filterElementWrapper.id = "myFilter" + UIDUtil.createUID();
			filterElementWrapper.setAttribute("width", _width);
			filterElementWrapper.setAttribute("height", _height);
			// clean up existing filter
			host.element.style["filter"] = "url(#" + filterElementWrapper.id + ")";
			for (var i:int = 0; i < children.length; i++)
			{
				var filterElement:FilterElement = children[i] as FilterElement;
				filterElement.filterElementWrapper = filterElementWrapper;
				filterElement.build();
			}
		}
		/**
		 * @royaleignorecoercion Element
		 */
		COMPILE::JS
		private function getChildNode(node:Node, tagName:String):Node
		{
			if (!node.hasChildNodes())
			{
				return addSvgElementToElement(node as Element, tagName);
			}
			var childNodes:Object = node.childNodes;
			for (var i:int = 0; i < childNodes.length; i++)
			{
				if (childNodes[i].tagName == tagName)
				{
					return childNodes[i];
				}
					
			}
			return addSvgElementToElement(node as Element, tagName);
		}
		
		/**
		 *  @royaleignorecoercion org.apache.royale.core.IRenderedObject
		 */
		protected function get host():IRenderedObject
		{
			return _strand as IRenderedObject;
		}
		
		COMPILE::JS
		/**
		 *  This is the DOM element where filter elements get added
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.3
		 */
		public function get filterElementWrapper():Element
		{
			return _filterElementWrapper;
		}

		public function get children():Array 
		{
			return _children;
		}
		
		public function set children(value:Array):void 
		{
			_children = value;
		}
	}
}

