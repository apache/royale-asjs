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
package org.apache.royale.style.stylebeads
{
	import org.apache.royale.core.Bead;
	import org.apache.royale.style.IStyleUIBase;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.debugging.assert;
	import org.apache.royale.style.util.CSSLookup;
	import org.apache.royale.style.util.StyleData;
	import org.apache.royale.style.colors.ColorSwatch;
	import org.apache.royale.utils.StringUtil;
	
	[DefaultProperty("styles")]
	/**
	 * The base class for all style beads.
	 * Style beads can have parents and childrem, but only leaf style beads can have values.
	 * Leaf style beads are the actual styles that generate CSS rules. 
	 * Non-leaf style beads are used to decorate the leaf selectors and rules.
	 * Query style beads are used to generate media queries and other conditional rules.
	 * Query style beads will self-generate the correct grouping which the leaf styles beads are added to.
	 * Query styles beads can be nested in each other to generate nested grouping.
	 * Leaf style beads cannot have children.
	 */
	public class StyleBeadBase extends Bead implements IStyleBead
	{
		public function StyleBeadBase()
		{
			super();
		}
		/**
		 *  @royalesuppresspublicvarwarning
		 */
		public var styles:Array = [];
		public function get styleType():String
		{
			return null;
		}
		/**
		 * Decorator style beads should override this method to apply their decoration to child styles.
		 */
		public function getLeaves():Array
		{
			if (!isLeaf && (!styles || styles.length == 0))
			{
				// If we don't have children, we can't gather leaves.
				// This can happen if a LeafDecorator is used as a selector source for HasState/NotState.
				return [];
			}
			preprocessStyle();
			return gatherLeaves(this);
		}
		/**
		 * @royaleignorecoercion org.apache.royale.style.stylebeads.ILeafStyleBead
		 */
		protected function gatherLeaves(parentStyle:IStyleBead):Array
		{
			var retVal:Array = [];
			for each(var style:IStyleBead in styles)
			{
				style.parentStyle = parentStyle;
				if(style is ILeafStyleBead)
					(style as ILeafStyleBead).unit = unit;
				else if (style is StyleBeadBase)
					(style as StyleBeadBase).unit = unit;

				if(style.isLeaf)
				{
					retVal.push(style);
					var leaf:ILeafStyleBead = style as ILeafStyleBead;
					if(!leaf.isDecorated())
						decorateChildStyle(leaf, []);
				}
				else
					retVal = retVal.concat(style.getLeaves());
			}
			return retVal;
		}
		/**
		 * Override this method in subclasses to make sure the style is normalized
		 * so cascading the styles works correctly.
		 * 
		 * This is most significant in query ("@"") styles which are nested.
		 */
		protected function preprocessStyle():void
		{

		}
		public function addStyleBead(bead:IStyleBead):void
		{
			if(!styles)
				styles = [];
			styles.push(bead);
		}
		private var _parentStyle:IStyleBead;

		public function get parentStyle():IStyleBead
		{
			return _parentStyle;
		}

		public function set parentStyle(value:IStyleBead):void
		{
			_parentStyle = value;
		}
		public function get ruleDecorator():String
		{
			return null;
		}
		private var _unit:String = "rem";
		/**
		 * @copy org.apache.royale.style.stylebeads.ILeafStyleBead#unit
		 */
		public function get unit():String
		{
			return _unit;
		}

		public function set unit(value:String):void
		{
			_unit = value;
			if (styles)
			{
				for each(var style:IStyleBead in styles)
				{
					if(style is ILeafStyleBead)
						(style as ILeafStyleBead).unit = value;
					else if (style is StyleBeadBase)
						(style as StyleBeadBase).unit = value;
				}
			}
		}
		public function decorateChildStyle(style:ILeafStyleBead, decorations:Array):void
		{

		}
		public function get isLeaf():Boolean
		{
			return false;
		}
		public function get isGroup():Boolean
		{
			return false;
		}

		protected function validateColor(value:*,supportsNone:Boolean):StyleData
		{
			if(!supportsNone && value == "none")
				assert(false, "Invalid color value: " + value);
			
			if(value === 0)
				value = "black";
			else if(value == 16777215)
				value = "white";
			var selectorVal:String = "" + value;
			var ruleVal:String = selectorVal;

			if (selectorVal.indexOf("color-mix(") == 0)
			{
				ruleVal = resolveColorMix(selectorVal);
				return new StyleData(selectorVal.replace(/\s+/g, "-").replace(/\(/g, "-").replace(/\)/g, "").replace(/,/g, "-").replace(/%/g, "pc"), ruleVal, value);
			}

			ruleVal = resolveColor(selectorVal);
			return new StyleData(selectorVal, ruleVal,value);
		}

		private function resolveColor(color:String):String
		{
			switch(color)
			{
				case "transparent":
				case "currentColor":
				case "inherit":
				case "none":
					return color;
				case "black":
					return "#000";
				case "white":
					return "#fff";
				default:
					if(CSSLookup.has(color))
						return CSSLookup.getProperty(color);
					else if (color.indexOf("-") != -1)
					{
						var swatch:ColorSwatch = ColorSwatch.fromSpecifier(color, false);
						return swatch.colorValue;
					}
					break;
			}
			return color;
		}

		private function resolveColorMix(value:String):String
		{
			// color-mix(in srgb, blue 50%, white)
			var content:String = value.substring(10, value.length - 1);
			var parts:Array = content.split(",");
			var ret:String = "color-mix(" + parts[0]; // in srgb
			for (var i:int = 1; i < parts.length; i++)
			{
				var part:String = StringUtil.trim(parts[i]);
				var colorPart:Array = part.split(/\s+/);
				var color:String = colorPart[0];
				var resolved:String = resolveColor(color);
				ret += ", " + resolved;
				if (colorPart.length > 1)
					ret += " " + colorPart[1];
			}
			ret += ")";
			return ret;
		}
	}
}