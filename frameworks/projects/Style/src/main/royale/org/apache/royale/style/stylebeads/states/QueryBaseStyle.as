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
package org.apache.royale.style.stylebeads.states
{
	import org.apache.royale.style.util.StyleManager;
	import org.apache.royale.style.util.ThemeManager;
	import org.apache.royale.style.util.CSSUnit;
	import org.apache.royale.style.stylebeads.IStyleBead;
	import org.apache.royale.style.stylebeads.ILeafStyleBead;
	import org.apache.royale.style.IStyleUIBase;
	import org.apache.royale.core.IStrand;

	public class QueryBaseStyle extends StyleStateBase
	{
		public function QueryBaseStyle()
		{
			super();
		}

		override public function get isGroup():Boolean
		{
			return true;
		}
		override public function get styleType():String
		{
			return querySelector;
		}

		/**
		 * @royaleignorecoercion org.apache.royale.style.stylebeads.ILeafStyleBead
		 */
		override public function decorateChildStyle(style:ILeafStyleBead, decorations:Array):void
		{
			style.parentQueryId = querySelector;
			if(parentStyle)
				parentStyle.decorateChildStyle(style, decorations);
		}

		/**
		 * Change in subclasses for other query types such as `container` or `supports`.
		 */
		protected var queryType:String = "media";
		/**
		 * TODO handle "not", etc. in here.
		 */
		public var queryPrefix:String = "";
		/**
		 * That part inside the parenthesis in a media query, for example, "(min-width: 500px)".
		 */
		protected var queryBody:String = "";
		protected var querySelector:String;

		/**
		 * @royaleignorecoercion org.apache.royale.core.IStrand
		 */
		public function get strand():IStrand
		{
			return _strand;
		}

		override public function set strand(value:IStrand):void
		{
			super.strand = value;
			if (value)
			{
				applyContainerStyles();
			}
		}

		protected function applyContainerStyles():void
		{
			// Subclasses can override to apply styles to the strand
		}
		
		protected function computeSize(value:*):String
		{
			if(value == null) return "";
			if(parseFloat(value) == value)
			{
				var pixelValue:Number = ThemeManager.instance.activeTheme.spacing * value;
				return CSSUnit.convert(pixelValue, CSSUnit.PX, unit) + unit;
			}
			return "" + value;
		}

		protected function computeBreakpoint(value:*):String
		{
			if(value == null) return "";
			var breakpoint:String = "" + value;
			switch(breakpoint.toLowerCase())
			{
				case "sm":
					return ThemeManager.instance.activeTheme.breakpointSM;
				case "md":
					return ThemeManager.instance.activeTheme.breakpointMD;
				case "lg":
					return ThemeManager.instance.activeTheme.breakpointLG;
				case "xl":
					return ThemeManager.instance.activeTheme.breakpointXL;
				case "2xl":
					return ThemeManager.instance.activeTheme.breakpoint2XL;
			}
			return computeSize(value);
		}

		protected function sanitizeIdentifier(value:String):String
		{
			return value.replace(/[\s\.\(\)\+\*\/\[\]]/g, "-").replace(/-+/g, "-");
		}
		
		override protected function preprocessStyle():void
		{
			if(StyleManager.hasQuery(querySelector))
			{
				return;
			}
			var parentId:String;
			var parent:IStyleBead = parentStyle;
			while(parent){
				if(parent is QueryBaseStyle)
				{
					parentId = (parent as QueryBaseStyle).querySelector;
					break;
				}
				parent = parent.parentStyle;
			}
			var rule:String = "@" + queryType + queryPrefix + " " + queryBody + " { }";
			StyleManager.addQuery(querySelector,rule, parentId);
		}

	}
}