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
	import org.apache.royale.style.stylebeads.layout.Display;
	import org.apache.royale.style.stylebeads.flexgrid.FlexGrow;
	import org.apache.royale.style.stylebeads.flexgrid.FlexShrink;
	import org.apache.royale.style.stylebeads.layout.Position;
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
	public class StyleUIBase extends UIBase implements IStyleUIBase
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

		private var _unit:String = "rem";
		[Inspectable(category="General", enumeration="px,em,rem", defaultValue="rem")]
		public function get unit():String
		{
			return _unit;
		}

		public function set unit(value:String):void
		{
			_unit = value;
		}

		private var _size:String = "md";
		/**
		 * The size is set as "t-shirt sizing" using a string value.
		 * The actual styles for each size value are determined by the skin and style beads used.
		 * 
		 * Most components have four possible sizes, but specific components may choose to support a different set of sizes as needed.
		 */
		[Inspectable(category="General", enumeration="sm,md,lg,xl", defaultValue="md")]
		public function get size():String
		{
			return _size;
		}

		public function set size(value:String):void
		{
			_size = value;
		}

		/**
		 *  
		 *  @langversion 3.0
		 *  @productversion Royale 0.9.13
		 * 
		 *  @royalesuppresspublicvarwarning
		 */
		public var styleBeads:Array;

		protected var _styleBeads:Vector.<IStyleBead> = new Vector.<IStyleBead>();
		/**
		 * @royaleignorecoercion org.apache.royale.style.stylebeads.IStyleBead
		 */
		public function addStyleBead(bead:IStyleBead):void
		{
			assert(bead != null, "bead cannot be null");
			COMPILE::JS
			{
				addStyleInternal(bead, false);
			}
		}
		COMPILE::JS
		private function addStyleInternal(bead:IStyleBead, overrideExisting:Boolean):void
		{
			if(!styleTypes)
				styleTypes = new Map();
			
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
				{
					if(overrideExisting)
						(styleTypes.get(leaf.styleType) as ILeafStyleBead).value = leaf.value;

					continue;
				}
				styleTypes.set(leaf.styleType, leaf);
				leaf.strand = this;
				_styleBeads.push(leaf);
			}
		}
		COMPILE::JS
		private var styleTypes:Map;
		protected var _stylesLoaded:Boolean;
		override protected function loadBeads():void
		{
			super.loadBeads();
			if(styleBeads)
			{
				for each(var bead:IStyleBead in styleBeads)
					addStyleBead(bead);
			}
			refreshSuspended = true;
			styleBeads = null;
			_stylesLoaded = true;
			if(!_skin)
				_skin = loadBeadFromValuesManager(IStyleSkin, "iStyleSkin", this) as IStyleSkin;				
			
			if(_skin)
			{
				addBead(_skin);
				applySkin();
			}
			refreshSuspended = false;
			refreshStyles();
		}
		/**
		 * Sets styles on the component using an array of style beads.
		 * Use this for applying styles to an existing component that already has a skin applied.
		 * 
		 * To change existing applied styles, set overrideExisting to true.
		 * This will change the values of existing styles beads to the new ones provided in the styles array.
			 *
		 * @langversion 3.0
		 * @productversion Royale 0.9.13
		 */
		public function setStyles(styles:Array, overrideExisting:Boolean = false):void
		{
			COMPILE::JS
			{
				for each(var style:IStyleBead in styles)
				{
					addStyleInternal(style, overrideExisting);
				}
				refreshStyles();
			}
		}
		/**
		 * @royaleignorecoercion org.apache.royale.style.stylebeads.ILeafStyleBead
		 */
		public function getStyleBeadByType(type:Class):ILeafStyleBead
		{
			var style:ILeafStyleBead = new type() as ILeafStyleBead;
			assert(style is ILeafStyleBead, "Only leaf style beads can be retrieved by type");
			COMPILE::JS
			{
				var styleType:String = style.styleType;
				if(styleTypes.has(styleType))
				{
					return styleTypes.get(styleType);
				}
				addStyleBead(style);
			}
			return style;
		}
		/**
		 * Setters and Getters for common HTML attributes that can be set on any component.
		 * Style beads are used and automatically createded if they don't yet exist.
		 */
		private var _displayStyle:String;
		[Inspectable(category="General", enumeration="inline,block,inline-block,flow-root,flex,inline-flex,grid,inline-grid,contents,table,inline-table,table-caption,table-cell,table-column,table-column-group,table-footer-group,table-header-group,table-row-group,table-row,list-item,none", defaultValue="inline")]
		public function get displayStyle():String
		{
			return _displayStyle;
		}

		public function set displayStyle(value:String):void
		{
			_displayStyle = value;
			getStyleBeadByType(Display).value = value;
		}
		private var _positionStyle:String;
		[Inspectable(category="General", enumeration="static,fixed,absolute,relative,sticky", defaultValue="absolute")]
		public function get positionStyle():String
		{
			return _positionStyle;
		}

		public function set positionStyle(value:String):void
		{
			_positionStyle = value;
			getStyleBeadByType(Position).value = value;
		}
		private var _flexGrow:Number;

		public function get flexGrow():Number
		{
			return _flexGrow;
		}

		public function set flexGrow(value:Number):void
		{
			_flexGrow = value;
			getStyleBeadByType(FlexGrow).value = value;
		}
		private var _flexShrink:Number;

		public function get flexShrink():Number
		{
			return _flexShrink;
		}

		public function set flexShrink(value:Number):void
		{
			_flexShrink = value;
			getStyleBeadByType(FlexShrink).value = value;
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
				assert(getBeadByType(IStyleSkin) == null, "skins cannot be replaced once loaded");
				refreshSuspended = true;
				addBead(value);
				applySkin();
				refreshSuspended = false;
				refreshStyles();
			}
		}
		/**
		 * Skins have style beads and properties which can be applied in two ways:
		 * 1. When the skin is added as a bead, the strand setter can apply the styles in the skin code.
		 * 2. The applySkin method can be called to apply the styles after the skin is added.
		 *    This is useful if there's a need to optimize the styling in a way whereit's not appropriate
		 *    to make parts of the component publically available as StyleUIBase instances.
		 * 
		 * Override this method in subclasses as needed.
		 * 
		 * @langversion 3.0
		 * @productversion Royale 0.9.13
		 * 
		 */
		protected function applySkin():void
		{
			// default implementation does nothing
		}
		/**
		 * Used to prevent multiple setting of the style classes when internally setting styles and skins
		 */
		private var refreshSuspended:Boolean;
		protected function refreshStyles():void
		{
			if(refreshSuspended)
				return;
			COMPILE::JS
			{
				utilityList.clear();
				for each (var styleBead:ILeafStyleBead in _styleBeads)
				{
					applyStyle(styleBead);
				}
				setClassName(computeFinalClassNames());
			}
		}
		protected function applyStyle(styleBead:ILeafStyleBead):void
		{
			var selector:String = styleBead.getSelector();
			utilityList.add(selector);
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
		COMPILE::JS
		protected function newElement(tag:String,className:String = null):HTMLElement{
			var element:HTMLElement = document.createElement(tag) as HTMLElement;
			if(className){
				element.className = className;
			}
			return element;
		}
	}
}