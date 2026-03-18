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
	abstract public class StyleBeadBase extends Bead implements IStyleBead
	{
		public function StyleBeadBase()
		{
			super();
		}
		/**
		 *  @royalesuppresspublicvarwarning
		 */
		public var styles:Array = [];

		/**
		 * Decorator style beads should override this method to apply their decoration to child styles.
		 */
		public function getLeaves():Array
		{
			assert(styles && styles.length > 0, "Non-leaf style beads must have child styles");
			preprocessStyle();
			var retVal:Array = [];
			for each(var style:IStyleBead in styles)
			{
				style.parentStyle = this;
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
		abstract public function decorateChildStyle(style:ILeafStyleBead, decorations:Array):void;
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
			
			var selectorVal:String = "" + value;
			var ruleVal:String = selectorVal;
			switch(selectorVal)
			{
				case "transparent":
				case "currentColor":
				case "inherit":
				case "none":
					break;
				case "black":
					ruleVal = "#000";
					break;
				case "white":
					ruleVal = "#fff";
					break;
				default:
					// assert(CSSLookup.has(selectorVal), "Invalid color value: " + value);
					if(CSSLookup.has(selectorVal))
						ruleVal = CSSLookup.getProperty(selectorVal);
					else
					{
						var color:ColorSwatch = ColorSwatch.fromSpecifier(selectorVal);
						ruleVal = color.colorValue;
					}
					break;
			}
			return new StyleData(selectorVal, ruleVal,value);
		}
	}
}