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
	import org.apache.royale.core.UIBase;
	import org.apache.royale.core.CSSClassList;
	import org.apache.royale.debugging.assert;
	import org.apache.royale.style.IStyleSkin;
	import org.apache.royale.style.stylebeads.ILeafStyleBead;
	import org.apache.royale.style.stylebeads.IStyleBead;
	import org.apache.royale.style.util.StyleManager;
	import org.apache.royale.style.util.ThemeManager;
	import org.apache.royale.utils.loadBeadFromValuesManager;

	COMPILE::JS
	{
		import org.apache.royale.html.util.addElementToWrapper;
		import org.apache.royale.core.WrappedHTMLElement;
	}

	/**
	 *  The StyleUIBase class is the base class for all UI components that support styles.
	 *  It provides a common implementation for handling styles and applying them to the component.
	 *	@langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.13
	 */
	public class StyleUIBase extends UIBase
	{
		/**
		 *  Constructor.
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.13
		 */
		public function StyleUIBase()
		{
			super();
			classList = new CSSClassList();
			utilityList = new CSSClassList();
		}
		protected var classList:CSSClassList;
		protected var utilityList:CSSClassList;

		/**
		 * TODO: Add support for cascading theming.
		 */
		public function get theme():String
		{
			return ThemeManager.instance.current;
		}

		/**
		 *  
		 *  @langversion 3.0
		 *  @productversion Royale 0.9.13
		 * 
		 *  @royalesuppresspublicvarwarning
		 */
		public var styleBeads:Array;

		protected var _styleBeads:Vector.<IStyleBead>;
		/**
		 * @royaleignorecoercion org.apache.royale.style.stylebeads.IStyleBead
		 */
		public function addStyleBead(bead:IStyleBead):void
		{
			COMPILE::JS
			{
				assert(bead != null, "bead cannot be null");
				if(!styleTypes)
					styleTypes = new Set();
				
				var leaves:Array = bead.getLeaves();
				for each(var leaf:ILeafStyleBead in leaves)
				{
					assert(leaf.isLeaf, "getLeaves() should only return leaf style beads");
					/**
					 * Only add the first found leaf for each style type.
					 * This is to prevent duplicate styles from being added to the style sheet
					 * and enables proper handling of styling overrides.
					 */
					if(styleTypes.has(leaf.styleType))
						continue;
					styleTypes.add(leaf.styleType);
					leaf.strand = this;
					_styleBeads.push(leaf);
				}
				refreshStyles();
			}
		}
		COMPILE::JS
		private var styleTypes:Set;
		private var _stylesLoaded:Boolean;
		override protected function loadBeads():void
		{
			super.loadBeads();
			if(styleBeads)
			{
				for each(var bead:IStyleBead in styleBeads)
					addStyleBead(bead);
			}
			styleBeads = null;
			applySkin();
			_stylesLoaded = true;
			refreshStyles();
		}
		public function getStyleBeadsByType(type:Class):Array
		{
			var retVal:Array = [];
			for each(var bead:IStyleBead in _styleBeads)
			{
				if(bead is type)
					retVal.push(bead);
			}
			return retVal;
		}
		private var _skin:IStyleSkin;

		public function get skin():IStyleSkin
		{
			return _skin;
		}

		public function set skin(value:IStyleSkin):void
		{
			_skin = value;
			if(_stylesLoaded)
			{
				addBead(value);
			}
		}
		private function applySkin():void
		{
			if(skin)
			{
				addBead(skin);
			}
			else
			{
				_skin = loadBeadFromValuesManager(IStyleSkin, "iStyleSkin", this) as IStyleSkin;				
			}
		}

		protected function refreshStyles():void
		{
			COMPILE::JS
			{
				utilityList.clear();
				for each (var styleBead:ILeafStyleBead in _styleBeads)
				{
					applyStyle(styleBead);
				}
				computeFinalClassNames();
			}
		}
		protected function applyStyle(styleBead:ILeafStyleBead):void
		{
			var selector:String = styleBead.selector;
			utilityList.add(selector);
			if (!StyleManager.hasStyle(selector))
			{
				if(styleBead.parentQueryId)
					StyleManager.addGroupedRule(styleBead.parentQueryId, selector, styleBead.rule);
				else
					StyleManager.addStyle(selector, styleBead.rule);
			}
		}
		public function toggleClass(classNameVal:String, add:Boolean):void
		{
			COMPILE::JS
			{
				add ? classList.add(classNameVal) : classList.remove(classNameVal);
				setClassName(computeFinalClassNames());
			}
		}
		COMPILE::JS
		override protected function computeFinalClassNames():String
		{
			return (utilityList.compute() + classList.compute() + super.computeFinalClassNames()).trim();
		}
		public function setStyle(property:String, value:Object):void
		{
			COMPILE::JS
			{
				element.style[property] = value;
			}
		}

		public function setAttribute(name:String, value:*):void
		{
			COMPILE::JS
			{
				element.setAttribute(name, value);
			}
		}
		public function getAttribute(name:String):*
		{
			COMPILE::JS
			{
				return element.getAttribute(name);
			}
			COMPILE::SWF
			{
				return "";
			}
		}
		public function removeAttribute(name:String):void
		{
			COMPILE::JS
			{
				element.removeAttribute(name);
			}
		}
		COMPILE::SWF
		private var _autofocus:Boolean;

		public function get autofocus():Boolean
		{
			COMPILE::SWF
			{
				return _autofocus;
			}
			COMPILE::JS
			{
				return element["autofocus"];
			}
		}

		public function set autofocus(value:Boolean):void
		{
			COMPILE::SWF
			{
				_autofocus = value;
			}
			COMPILE::JS
			{
				element["autofocus"] = value;
			}
		}
		public function focus():void
		{
			COMPILE::JS
			{
				element.focus();
			}
		}
		protected var _tabFocusable:Boolean;

		public function get tabFocusable():Boolean
		{
			return _tabFocusable;
		}

		public function set tabFocusable(value:Boolean):void
		{
			_tabFocusable = value;
			if (value)
			{
				setAttribute("tabindex", 0);
			}
			else
			{
				removeAttribute("tabindex");
			}
		}

		/**
		 * Returns the tag name to use for this component.
		 *
		 * Subclasses should override this method to specify a different tag.
		 */
		protected function getTag():String
		{
			return "div";
		}

		COMPILE::JS
		override protected function createElement():WrappedHTMLElement
		{
			return addElementToWrapper(this, getTag());
		}
	}
}