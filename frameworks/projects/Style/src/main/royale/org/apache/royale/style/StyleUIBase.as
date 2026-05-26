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
	 *  @productversion Royale 1.0.0
	 */
	public class StyleUIBase extends UIBase implements IStyleUIBase
	{
		
		/**
		 *  The default class name used for the top-level wrapper element when useWrapperStyle is true.
		 *  This allows child elements to be styled based on the state of the parent (e.g., .style-group[data-disabled] .child).
		 */
		public static const GROUP_WRAPPER_STYLE:String = 'style-group';
		
		
		/**
		 *  Constructor.
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 1.0.0
		 */
		public function StyleUIBase()
		{
			super();
			classList = new CSSClassList();
			utilityList = new CSSClassList();
		}
		
		/**
		 *  If true, the component will add a default "group" class to its top-level element.
		 *  This is useful for complex components that need to style their internal elements 
		 *  based on the component's top level state.
		 *  
		 *  By default, it uses GROUP_WRAPPER_STYLE ('style-group').
		 *  Subclasses can override getWrapperStyle() to provide a more specific name.
		 */
		protected var useWrapperStyle:Boolean;
		
		protected var classList:CSSClassList;
		protected var utilityList:CSSClassList;

		/**
		 * TODO: Add support for cascading theming.
		 */
		private var _theme:String = ThemeManager.instance.current;
		public function set theme(value:String):void
		{
			_theme = value;
		}
		public function get theme():String
		{
			return _theme;
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
		[Inspectable(category="General", enumeration="xs,sm,md,lg,xl", defaultValue="md")]
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
		 *  @productversion Royale 1.0.0
		 * 
		 *  @royalesuppresspublicvarwarning
		 */
		public var styleBeads:Array;

		protected var _styleBeads:Array = [];
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
		/**
		 * @royaleignorecoercion org.apache.royale.style.stylebeads.ILeafStyleBead
		 */
		COMPILE::JS
		private function addStyleInternal(bead:IStyleBead, overrideExisting:Boolean):void
		{
			if(bead.isLeaf)
				return addLeafStyleBead(bead as ILeafStyleBead, overrideExisting);

			var leaves:Array = bead.getLeaves();
			for each(var leaf:ILeafStyleBead in leaves)
			{
				assert(leaf.isLeaf, "getLeaves() should only return leaf style beads");
				addLeafStyleBead(leaf, overrideExisting);
			}
		}
		COMPILE::JS
		private function addLeafStyleBead(leaf:ILeafStyleBead,overrideExisting:Boolean):void
		{
			if(!styleTypes)
				styleTypes = new Map();
			
			if(styleTypes.has(leaf.styleType))
			{
				if(overrideExisting)
					(styleTypes.get(leaf.styleType) as ILeafStyleBead).value = leaf.value;

				return;
			}
			
			styleTypes.set(leaf.styleType, leaf);
			leaf.strand = this;
			_styleBeads.push(leaf);
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
			else {
				COMPILE::JS{
					if (!_beads || _beads.indexOf(_skin) == -1) addBead(_skin);
				}
				COMPILE::SWF{
					//it seems that _beads is protected in js and private in swf.... see above
					addBead(_skin);
				}
			}
			
			if(_skin)
			{
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
				if(styleTypes && styleTypes.has(styleType))
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
		 * @productversion Royale 1.0.0
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
			var wrapperStyle:String = getWrapperStyle();
			return (wrapperStyle ? wrapperStyle + ' ' : '') + (utilityList.compute() + classList.compute() + super.computeFinalClassNames()).trim();
		}
		public function setStyle(property:String, value:Object):void
		{
			COMPILE::JS
			{
				element.style[property] = value;
			}
		}
		
		/**
		 * set a style property (var) on the current element
		 * @param propertyName
		 * @param value
		 * 
		 * @royaleignorecoercion String
		 */
		public function setStyleProperty(propertyName:String,value:Object):void{
			assert(propertyName && propertyName.indexOf('--') == 0, 'bad property name, must start with "--"')
			COMPILE::JS
			{
				element.style.setProperty(propertyName,value as String);
			}
		}
		
		
		public function toggleAttribute(name:String, value:Boolean):void
		{
			COMPILE::JS
			{
				if(value)
					element.setAttribute(name, "");
				else
					element.removeAttribute(name);
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
		 *  Returns the class name to be used on the top-level element for this component instance
		 *  to enable group-based styling for children.
		 *  
		 *  In a skin, this provides access to the wrapper style being used by the component. 
		 *  It helps with namespacing Style components and makes it easier to target child elements.
		 *  
		 *  If the subclass sets useWrapperStyle to true in its constructor, the generic 
		 *  GROUP_WRAPPER_STYLE ('style-group') will be used by default. 
		 *  
		 *  Subclasses can override this method to return a specific class (e.g., 'checkbox') 
		 *  for better semantics and higher CSS specificity.
		 *  
		 *  @return the class name to be used on the top-level element, or null if none.
		 */
		public function getWrapperStyle():String{
			return useWrapperStyle ? GROUP_WRAPPER_STYLE : null;
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