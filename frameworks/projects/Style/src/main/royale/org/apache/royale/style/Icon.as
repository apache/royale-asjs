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
package org.apache.royale.style
{
	COMPILE::JS
	{
		import org.apache.royale.html.util.createSVG;
	}
	import org.apache.royale.debugging.assert;
	import org.apache.royale.utils.async.HttpRequestTask;

	/**
	 * The Icon class represents an SVG icon that can be used in the UI.
	 * It can be created with a name that corresponds to registered SVG markup in XML
	 * or with a path to an SVG file.
	 *
	 * The SVG markup is parsed and rendered as an icon in the UI.
	 *
	 * When using XML markup, the markup must be registered before the Icon object is added to its parent.
	 *
	 */
	public class Icon extends StyleUIBase implements IIcon
	{
		public function Icon(name:String = null)
		{
			super();
			typeNames = "Icon";
			if (name)
			{
				iconName = name;
			}
		}

		/**
		 * The name of the icon to use.
		 *
		 * This name should correspond to registered SVG markup in XML.
		 */
		public var iconName:String;
		private var _iconPath:String;

		/**
		 * The path to an SVG file that contains the markup for the icon.
		 */
		public function get iconPath():String
		{
			return _iconPath;
		}

		public function set iconPath(value:String):void
		{
			_iconPath = value;
		}
		override public function addedToParent():void
		{
			super.addedToParent();
			COMPILE::JS
			{
				if (_iconElement)
					return;

				assert(_registeredIcons.has(iconName) || iconPath, "Icon name or path must be provided");
				var markup:XML;
				if (_registeredIcons.has(iconName))
					markup = _registeredIcons.get (iconName);

				else if (_registeredIcons.has(iconPath))
					markup = _registeredIcons.get (iconPath);

				if (markup)
					parseMarkup(markup);
				else if (iconPath)
				{
					return loadMarkup();
				}
			}
		}
		private function loadMarkup():void
		{
			assert(iconPath, "Icon path must be provided");
			// TODO don't make the same request twice.
			new HttpRequestTask(iconPath).exec(function(task:HttpRequestTask):void
				{
					if (task.completed)
					{
						parseMarkup(new XML(task.resultString));
						// register the loaded markup for future use
					}
					// TODO do we want some kind of error handling here?
				});
		}
		COMPILE::JS
		private var _iconElement:SVGElement;

		COMPILE::JS
		public function get iconElement():SVGElement
		{
			return _iconElement;
		}
		private function parseMarkup(markup:XML):void
		{
			COMPILE::JS
			{
				if (_iconElement)
				{
					return;
				}
				_iconElement = createSVG("svg");
				walkMarkup(markup, _iconElement);
				element.appendChild(_iconElement);
			}
		}
		COMPILE::JS
		private function walkMarkup(parent:XML, parentElement:SVGElement):void
		{
			var attrs:Array = parent.getAttributeArray();
			for each (var attr:XML in attrs)
			{
				var attName:String = attr.localName();
				if (!getAttributes()[attName])
				{
					continue;
				}
				parentElement.setAttribute(attName, attr.getValue());
			}
			var children:Array = parent.getChildrenArray();
			for each (var child:XML in children)
			{
				var childName:String = child.localName();
				if (!getElements()[childName])
				{
					assert(false, "Unsupported SVG element: " + childName);
					continue;
				}
				var element:SVGElement = createSVG(childName);
				parentElement.appendChild(element);
				walkMarkup(child, element);
			}
		}
		COMPILE::JS
		private static var _registeredIcons:Map = new Map();

		/**
		 * Registers an icon with a name and SVG markup.
		 * The SVG markup should be a an XML object that represents the SVG path data for the icon.
		 *
		 * Use this for icons which should be loaded programmatically.
		 */
		public static function registerIcon(name:String, svgMarkup:XML):void
		{
			assert(name, "Icon name must be provided");
			assert(svgMarkup is XML, "SVG markup must be in XML format");

			COMPILE::JS
			{
				_registeredIcons.set (name, svgMarkup);
			}
		}
		public static function isRegistered(name:String):Boolean
		{
			COMPILE::JS
			{
				return _registeredIcons.has(name);
			}
			COMPILE::SWF
			{
				return false;
			}
		}
		private static function getAttributes():Object
		{
			if (!_attributes)
			{
				_attributes = {
						"width": 1, "height": 1, "viewBox": 1, "fill": 1, "stroke": 1, "stroke-width": 1, "stroke-linecap": 1, "stroke-linejoin": 1, "class": 1, "focusable": 1, "style": 1, "d": 1, "fill-rule": 1, "clip-rule": 1, "cx": 1, "cy": 1, "r": 1, "x1": 1, "y1": 1, "x2": 1, "y2": 1, "points": 1, "x": 1, "y": 1, "rx": 1, "ry": 1, "transform": 1, "opacity": 1, "role": 1, "aria-hidden": 1, "aria-label": 1
					};
			}
			return _attributes;
		}
		// TODO: Optimize the list of attrbutes and elements to only those that are needed for icons.
		// There is a very large list of all SVG attributes and elements.
		private static var _attributes:Object;
		private static function getElements():Object
		{
			if (!_elements)
			{
				_elements = {
						"svg": 1, "path": 1, "g": 1, "rect": 1, "circle": 1, "ellipse": 1, "line": 1, "polyline": 1, "polygon": 1, "defs": 1, "clipPath": 1, "title": 1, "mask": 1, "use": 1, "symbol": 1
					};
			}
			return _elements;
		}
		private static var _elements:Object;
	}
}