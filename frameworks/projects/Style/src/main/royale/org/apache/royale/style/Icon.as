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
	public class Icon extends StyleUIBase
	{
		public function Icon(name:String = null)
		{
			super();
			typeNames = "Icon";
			if(name)
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
		private var markup:XML;
		override public function addedToParent():void
		{
			super.addedToParent();
			COMPILE::JS
			{
				if(iconElement)
				{
					return;
				}
				assert(markup || _registeredIcons.has(iconName) || _registeredIcons.has(iconPath), "Icon name must be provided");
				if(!markup)
				{
					if(_registeredIcons.has(iconName))
					{
						markup = _registeredIcons.get(iconName);
					}
					else if(_registeredIcons.has(iconPath))
					{
						markup = _registeredIcons.get(iconPath);
					}
				}
				if(markup)
					parseMarkup();
				else if(iconPath)
				{
					return loadMarkup();
				}
			}
		}
		private function loadMarkup():void
		{
			assert(iconPath, "Icon path must be provided");
			new HttpRequestTask(iconPath).exec(function(task:HttpRequestTask):void
			{
				if(task.completed)
				{
					var data:String = task.data as String;
					markup = new XML(data);
					parseMarkup();
				}
				//TODO do we want some kind of error handling here?
			});
		}
		COMPILE::JS
		private var iconElement:SVGElement;
		private function parseMarkup():void
		{
			COMPILE::JS
			{
				if(iconElement)
				{
					return;
				}
				iconElement = createSVG("svg");
				walkMarkup(markup, iconElement);
			}
		}
		COMPILE::JS
		private function walkMarkup(parent:XML, parentElement:SVGElement):void
		{
			var attrs:Array = parent.getAttributeArray();
			for each(var attr:XML in attrs)
			{
				var attName:String = attr.localName();
				if(!getBasicAttributes()[attName])
				{
					continue;
				}
				parentElement.setAttribute(attName, attr.getValue());
			}
			var children:Array = parent.getChildrenArray();
			for each(var child:XML in children)
			{
				var childName:String = child.localName();
				if(!getBasicElements()[childName])
				{
					continue;
				}
				if(!getOtherElements()[childName])
				{
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
				_registeredIcons.set(name, svgMarkup);
			}
		}
		private static function getBasicAttributes():Object
		{
			if(!_basicAttributes)
			{
				_basicAttributes = {
					"viewBox":1,"fill":1,"stroke":1,"d":1,"x":1,"y":1,"width":1,"height":1
				};
			}
			return _basicAttributes;
		}
		// TODO: Optimize the list of attrbutes and elements to only those that are needed for icons. 
		// There is a very large list of all SVG attributes and elements.
		private static var _basicAttributes:Object;
		private static var _restAttributes:Object;
		private static function getOtherAttributes():Object
		{
			if(!_restAttributes)
			{
				_restAttributes = {
					"cx":1,"cy":1,"r":1,"rx":1,"ry":1,"points":1,"x1":1,"y1":1,"x2":1,"y2":1,"transform":1,"offset":1,"in":1,"type":1,"values":1,"keyTimes":1,"dur":1,"repeatCount":1,"attributeName":1,"from":1,"to":1,"by":1,"begin":1,"end":1,"restart":1,"calcMode":1,"keySplines":1,"additive":1,"accumulate":1,"attributeType":1,"stop-color":1,"stop-opacity":1,"gradientUnits":1,"gradientTransform":1,"spreadMethod":1,"preserveAspectRatio":1,"role":1,"stdDeviation":1,"edgeMode":1,"in2":1,"result":1,"primitiveUnits":1,"kernelMatrix":1,"kernelUnitLength":1,"surfaceScale":1,"specularConstant":1,"specularExponent":1,"lighting-color":1
				};
			}
			return _restAttributes;
		}
		private static function getBasicElements():Object
		{
			if(!_basicElements)
			{
				_basicElements = {
					"svg":1,"path":1,"g":1,"rect":1,"circle":1,"ellipse":1,"line":1,"polyline":1,"polygon":1,"text":1,"tspan":1,"textPath":1,"use":1,"defs":1
				};
			}
			return _basicElements;
		}
		private static var _basicElements:Object;
		private static function getOtherElements():Object
		{
			if(!_restElements)
			{
				_restElements = {
					"marker":1,"pattern":1,"mask":1,"clipPath":1,"filter":1,"feGaussianBlur":1,"feOffset":1,"feBlend":1,"feColorMatrix":1,"feComponentTransfer":1,"feComposite":1,"feConvolveMatrix":1,"feDiffuseLighting":1,"feDisplacementMap":1,"feFlood":1,"feImage":1,"feMerge":1,"feMorphology":1,"feSpecularLighting":1,"feTile":1,"feTurbulence":1,"animate":1,"animateMotion":1,"animateTransform":1,"mpath":1,"set":1,"altGlyph":1,"altGlyphDef":1,"altGlyphItem":1,"glyph":1,"glyphRef":1,"marker":1,"color-profile":1,"cursor":1,"view":1,"symbol":1,"switch":1
				};
			}
			return _restElements;
		}
		private static var _restElements:Object;
	}
}