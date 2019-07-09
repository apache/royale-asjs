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

package mx.styles
{

/*
import flash.display.DisplayObject;
import flash.display.LoaderInfo;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;
import flash.events.TimerEvent;
import flash.system.ApplicationDomain;
import flash.system.SecurityDomain;
import flash.utils.Timer;
import flash.utils.describeType;
*/
    
import mx.core.FlexVersion;
import mx.core.IFlexModuleFactory;
import mx.core.mx_internal;
import mx.events.ModuleEvent;
import mx.managers.ISystemManager;
import mx.managers.SystemManagerGlobals;
import mx.modules.IModuleInfo;
import mx.modules.ModuleManager;
import mx.styles.IStyleManager2;
//import mx.styles.IStyleModule;
//import mx.utils.MediaQueryParser;

use namespace mx_internal;

import org.apache.royale.events.EventDispatcher;
    
[ExcludeClass]

//[ResourceBundle("styles")]

[Mixin]

/**
 *  @private
 */
public class StyleManagerImpl extends EventDispatcher implements IStyleManager2
{
//	include "../core/Version.as";
	
	//--------------------------------------------------------------------------
	//
	//  Class constants
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//
	//  Class variables
	//
	//--------------------------------------------------------------------------
	/**
	 *  @private
	 */
	private static var instance:IStyleManager2;
	
	//--------------------------------------------------------------------------
	//
	//  Class methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 *  @private
	 */
	public static function init(fbs:IFlexModuleFactory):void
	{
		var styleDataClassName:String = fbs.info()["styleDataClassName"];
		if (styleDataClassName)
		{
			var sm:StyleManagerImpl = fbs.getImplementation("mx.styles::IStyleManager2") as StyleManagerImpl;
			if (!sm)
				sm = new StyleManagerImpl(fbs);
			
			var styleDataClass:Class = fbs.info()["currentDomain"].getDefinition(styleDataClassName);
			var styleNames:Array = styleDataClass["inheritingStyles"];
			for each (var s:String in styleNames)
			{
				sm.registerInheritingStyle(s);
			}
			generateCSSStyleDeclarations(sm, styleDataClass["factoryFunctions"], styleDataClass["data"]);
			sm.initProtoChainRoots();
		}
	}
	
	public static function generateCSSStyleDeclarations(styleManager:StyleManagerImpl, factoryFunctions:Object, data:Array, newSelectors:Array = null, overrideMap:Object = null):void
	{
        trace("generateCSSStyleDeclarations not implemented");
        /*
		var arr:Array = data;
		
		var conditions:Array = null;
		var condition:CSSCondition = null;
		var selector:CSSSelector = null;
		var style:CSSStyleDeclaration;
		var declarationName:String = "";
		var segmentName:String = "";
		var effects:Array;
		
		var mergedStyle:CSSStyleDeclaration;
		
		var conditionCombiners:Object = {};
		conditionCombiners[CSSConditionKind.CLASS] = ".";
		conditionCombiners[CSSConditionKind.ID] = "#";
		conditionCombiners[CSSConditionKind.PSEUDO] = ':';    
		var n:int = arr.length;
		for (var i:int = 0; i < n; i++)
		{
			var className:int = arr[i];
			if (className == CSSClass.CSSSelector)
			{
				var selectorName:String = arr[++i];
				selector = new CSSSelector(selectorName, conditions, selector);
				segmentName = selectorName + segmentName;
				if (declarationName != "")
					declarationName += " ";
				declarationName += segmentName;
				segmentName = "";
				conditions = null;
			}
			else if (className == CSSClass.CSSCondition)
			{
				if (!conditions)
					conditions = [];
				var conditionType:String = arr[++i];
				var conditionName:String = arr[++i];
				condition = new CSSCondition(conditionType, conditionName);
				conditions.push(condition);
				segmentName = segmentName + conditionCombiners[conditionType] + conditionName;
			}
			else if (className == CSSClass.CSSStyleDeclaration)
			{
				var factoryName:int = arr[++i]; // defaultFactory or factory
				var defaultFactory:Boolean = factoryName == CSSFactory.DefaultFactory;
				if (defaultFactory)
				{
					mergedStyle = styleManager.getMergedStyleDeclaration(declarationName);
					style = new CSSStyleDeclaration(selector, styleManager, mergedStyle == null);
				}
				else
				{
					style = styleManager.getStyleDeclaration(declarationName);
					if (!style)
					{
						style = new CSSStyleDeclaration(selector, styleManager, mergedStyle == null);
						if (factoryName == CSSFactory.Override)
							newSelectors.push(style);
					}
				}
				if (defaultFactory)
				{
					if (style.defaultFactory == null)
						style.defaultFactory = factoryFunctions[declarationName];
				}
				else
				{
					if (factoryName == CSSFactory.Factory)
					{
						if (style.factory == null)
							style.factory = factoryFunctions[declarationName];
					}
					else
					{
						// apply overrides from CSS StyleModule
						var moduleStyles:Object = new factoryFunctions[declarationName];
						for (var styleProp:String in moduleStyles)
						{
							style.setLocalStyle(styleProp, moduleStyles[styleProp]);
							if (!overrideMap[declarationName])
								overrideMap[declarationName] = [];
							overrideMap[declarationName].push(styleProp);
						}
					}
				}
				if (defaultFactory && mergedStyle != null && 
					(mergedStyle.defaultFactory == null ||
						compareFactories(new style.defaultFactory(), new mergedStyle.defaultFactory())))
				{
					styleManager.setStyleDeclaration(style.mx_internal::selectorString, style, false);
				}
				selector = null;
				conditions = null;
				declarationName = "";
				mergedStyle = null;
			}
		}
        */
	}
	
	private static var propList1:Vector.<String> = new Vector.<String>();
	private static var propList2:Vector.<String> = new Vector.<String>();
	
	/**
	 *  @private
	 */
	private static function compareFactories(obj1:Object, obj2:Object):int
	{
		propList1.length = propList2.length = 0;
		for (var p:String in obj1)
			propList1.push(p);
		
		for (p in obj2)
			propList2.push(p);
		
		if (propList1.length != propList2.length)
			return 1;
		
		for each (p in propList1)
		{
			if (obj1[p] !== obj2[p])
				return 1;
		}
		
		return 0;
	}
	
	/**
	 *  @private
	 */
	public static function getInstance():IStyleManager2
	{
		if (!instance)
		{
			// In Flex 4 each application/module creates its own style manager.
			// There will be no style manager if the application/module was compiled for 
			// Flex 3 compatibility. In that case create there will be no instance 
			// associated with the top-level application so create a new instance.
			instance = IStyleManager2(IFlexModuleFactory(SystemManagerGlobals.topLevelSystemManagers[0]).
				getImplementation("mx.styles::IStyleManager2"));
			
			if (!instance)
				instance = new StyleManagerImpl(SystemManagerGlobals.topLevelSystemManagers[0]);
		}
		
		return instance;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 *  @private
	 * 
	 *  @param moduleFactory The module factory that is creating this instance. May not be null.
	 */
	public function StyleManagerImpl(moduleFactory:IFlexModuleFactory = null)
	{
		super();
		
		if (!moduleFactory) return;
		
		this.moduleFactory = moduleFactory;
        /*
		this.moduleFactory.registerImplementation("mx.styles::IStyleManager2", this);
		
		// get our parent styleManager
		if (moduleFactory is DisplayObject)
		{
			var request:Request = new Request(Request.GET_PARENT_FLEX_MODULE_FACTORY_REQUEST);
			DisplayObject(moduleFactory).dispatchEvent(request); 
			var parentModuleFactory:IFlexModuleFactory = request.value as IFlexModuleFactory;
			if (parentModuleFactory)
			{
				_parent = IStyleManager2(parentModuleFactory.
					getImplementation("mx.styles::IStyleManager2"));
				if (_parent is IEventDispatcher)
				{
					IEventDispatcher(_parent).addEventListener(FlexChangeEvent.STYLE_MANAGER_CHANGE, styleManagerChangeHandler, false, 0, true);
				}
			}
			
		}
        */
	}
	
	//--------------------------------------------------------------------------
	//
	//  Variables
	//
	//--------------------------------------------------------------------------
	
	/**
	 *  @private
	 *  Used to assign the selectorIndex in CSSStyleDeclaration so we can track
	 *  the order they were added to the StyleManager.  
	 *  MatchStyleDeclarations has to return the declarations in the order 
	 *  they were declared
	 */ 
	private var selectorIndex:int = 0;
	
	/**
	 *  @private
	 */
	//private var mqp:MediaQueryParser;
	
	/**
	 *  @private
	 *  Set of inheriting non-color styles.
	 *  This is not the complete set from CSS.
	 *  Some of the omitted we don't support at all,
	 *  others may be added later as needed.
	 *  The <code>isInheritingTextFormatStyle()</code> method queries this set.
	 */
	private var inheritingTextFormatStyles:Object =
		{
			align: true,
			bold: true,
			color: true,
			font: true,
			indent: true,
			italic: true,
			size: true
		};
	
	/**
	 *  @private
	 *  Set of styles for which setStyle() causes
	 *  invalidateSize() to be called on the component.
	 *  The method registerSizeInvalidatingStyle() adds to this set
	 *  and isSizeInvalidatingStyle() queries this set.
	 */
	private var sizeInvalidatingStyles:Object =
		{
			alignmentBaseline: true,
			baselineShift: true,
			blockProgression: true,
			borderStyle: true,
			borderThickness: true,
			breakOpportunity : true,
			cffHinting: true,
			columnCount: true,
			columnGap: true,
			columnWidth: true,
			digitCase: true,
			digitWidth: true,
			direction: true,
			dominantBaseline: true,
			firstBaselineOffset: true,
			fontAntiAliasType: true,
			fontFamily: true,
			fontGridFitType: true,
			fontLookup: true,
			fontSharpness: true,
			fontSize: true,
			fontStyle: true,
			fontThickness: true,
			fontWeight: true,
			headerHeight: true,
			horizontalAlign: true,
			horizontalGap: true,
			justificationRule: true,
			justificationStyle: true,
			kerning: true,
			leading: true,
			leadingModel: true,
			letterSpacing: true,
			ligatureLevel: true,
			lineBreak: true,
			lineHeight: true,
			lineThrough: true,
			listAutoPadding: true,
			listStylePosition: true,
			listStyleType: true,
			locale: true,
			marginBottom: true,
			marginLeft: true,
			marginRight: true,
			marginTop: true,
			paddingBottom: true,
			paddingLeft: true,
			paddingRight: true,
			paddingTop: true,
			paragraphEndIndent: true,
			paragraphStartIndent: true,
			paragraphSpaceAfter: true,
			paragraphSpaceBefore: true,            
			renderingMode: true,
			strokeWidth: true,
			tabHeight: true,
			tabWidth: true,
			tabStops: true,
			textAlign: true,
			textAlignLast: true,
			textDecoration: true,
			textIndent: true,
			textJustify: true,
			textRotation: true,
			tracking: true,
			trackingLeft: true,
			trackingRight: true,
			typographicCase: true,
			verticalAlign: true,
			verticalGap: true,
			wordSpacing:true,
			whitespaceCollapse: true
		}
	
	/**
	 *  @private
	 *  Set of styles for which setStyle() causes
	 *  invalidateSize() to be called on the component's parent.
	 *  The method registerParentSizeInvalidatingStyle() adds to this set
	 *  and isParentSizeInvalidatingStyle() queries this set.
	 */
	private var parentSizeInvalidatingStyles:Object =
		{
			baseline: true,
			bottom: true,
			horizontalCenter: true,
			left: true,
			right: true,
			top: true,
			verticalCenter: true
		}
	
	/**
	 *  @private
	 *  Set of styles for which setStyle() causes
	 *  invalidateDisplayList() to be called on the component's parent.
	 *  The method registerParentDisplayListInvalidatingStyle() adds to this set
	 *  and isParentDisplayListInvalidatingStyle() queries this set.
	 */
	private var parentDisplayListInvalidatingStyles:Object =
		{
			baseline: true,
			bottom: true,
			horizontalCenter: true,
			left: true,
			right: true,
			top: true,
			verticalCenter: true
		}
	
	/**
	 *  @private
	 *  Set of color names.
	 *  The method registerColorName() adds to this set
	 *  and isColorName() queries this set.
	 *  All color names in this set are lowercase in order to support
	 *  case-insensitive mapping in the StyleManager methods getColorName(),
	 *  getColorNames(), registerColorName(), and isColorName().
	 *  We handle color names at runtime in a case-insensitive way
	 *  because the MXML compiler does this at compile time,
	 *  in conformance with the CSS spec.
	 */
	private var colorNames:Object =
		{
			transparent: "transparent",
			black: 0x000000,
			blue: 0x0000FF,
			green: 0x008000,
			gray: 0x808080,
			silver: 0xC0C0C0,
			lime: 0x00FF00,
			olive: 0x808000,
			white: 0xFFFFFF,
			yellow: 0xFFFF00,
			maroon: 0x800000,
			navy: 0x000080,
			red: 0xFF0000,
			purple: 0x800080,
			teal: 0x008080,
			fuchsia: 0xFF00FF,
			aqua: 0x00FFFF,
			magenta: 0xFF00FF,
			cyan: 0x00FFFF,
			orange: 0xFFA500,
			darkgrey: 0xA9A9A9,
			brown: 0xA52A2A,
			tan: 0xD2B48C,
			lightgrey: 0xD3D3D3,
			darkgreen: 0x006400,
			
			// IMPORTANT: Theme colors must also be updated
			// in the Flex compiler's CSS parser
			// (in \src\java\macromedia\css\Descriptor.java)
			// and possibly other places as well. Grep for them!
			halogreen: 0x80FF4D,
			haloblue: 0x009DFF,
			haloorange: 0xFFB600,
			halosilver: 0xAECAD9
		};
	
	/**
	 *  @private
	 *  Whether any advanced selectors have been registered with this style
	 *  manager.
	 */ 
	private var _hasAdvancedSelectors:Boolean;
	
	/**
	 *  @private
	 *  A map of CSS pseudo states. If a pseudo selector exists for a
	 *  particular state name, it is likely that styles need to be recalculated.
	 */ 
	private var _pseudoCSSStates:Object;
	
	/**
	 *  @private
	 *  A map of CSS selectors -- such as "global", "Button", and ".bigRed" --
	 *  to CSSStyleDeclarations.
	 *  This collection is accessed via getStyleDeclaration(),
	 *  setStyleDeclaration(), and clearStyleDeclaration().
	 */
	private var _selectors:Object = {};
	
	/**
	 *  @private
	 */
	private var styleModules:Object = {};
	
	/**
	 *  @private
	 *  A map of selector "subjects" to an ordered map of selector Strings and
	 *  their associated CSSStyleDeclarations.
	 *  The subject is the right most simple type selector in a potential chain
	 *  of selectors.
	 */ 
	private var _subjects:Object = {};
	
	/**
	 *  @private
	 *  Used for accessing localized Error messages.
	 */
	//private var resourceManager:IResourceManager =
	//	ResourceManager.getInstance();
	
	/**
	 *  @private
	 *  Cache merged styles between this and parent.
	 */
	private var mergedInheritingStylesCache:Object;
	
	/**
	 *  @private
	 *  This style manager's flex module factory.
	 */
	private var moduleFactory:IFlexModuleFactory;
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  parent
	//----------------------------------
	
	/**
	 *  @private
	 */    
	private var _parent:IStyleManager2;
	
	/**
	 *  @private
	 *   
	 *  The style manager that is the parent of this StyleManager.
	 *  
	 *  @return the parent StyleManager or null if this is the top-level StyleManager.
	 */
	public function get parent():IStyleManager2
	{
		return _parent;
	}
	
	//----------------------------------
	//  qualifiedTypeSelectors
	//----------------------------------
	
	/**
	 *  @private
	 */
	private static var _qualifiedTypeSelectors:Boolean = true;
	
	public function get qualifiedTypeSelectors():Boolean
	{
        /*
		if (FlexVersion.compatibilityVersion < FlexVersion.VERSION_4_0)
			return false;
		*/
        
		if (_qualifiedTypeSelectors)
			return _qualifiedTypeSelectors;
		
        /*
		if (parent)
			return parent.qualifiedTypeSelectors;
		*/
        
		return false;
	}
	
	public function set qualifiedTypeSelectors(value:Boolean):void
	{
		_qualifiedTypeSelectors = value;
	}
	
	//----------------------------------
	//  stylesRoot
	//----------------------------------
	
	/**
	 *  @private
	 */
	private var _stylesRoot:Object;
	
	/**
	 *  @private
	 *  The root of all proto chains used for looking up styles.
	 *  This object is initialized once by initProtoChainRoots() and
	 *  then updated by calls to setStyle() on the global CSSStyleDeclaration.
	 *  It is accessed by code that needs to construct proto chains,
	 *  such as the initProtoChain() method of UIComponent.
	 */
	public function get stylesRoot():Object
	{
		return _stylesRoot;
	}
	public function set stylesRoot(value:Object):void
	{
		_stylesRoot = value;
	}
	
	//----------------------------------
	//  inheritingStyles
	//----------------------------------
	
	/**
	 *  @private
	 */
	private var _inheritingStyles:Object = {};
	
	/**
	 *  @private
	 *  Set of inheriting non-color styles.
	 *  This is not the complete set from CSS.
	 *  Some of the omitted we don't support at all,
	 *  others may be added later as needed.
	 *  The method registerInheritingStyle() adds to this set
	 *  and isInheritingStyle() queries this set.
	 */
	public function get inheritingStyles():Object
	{
		if (mergedInheritingStylesCache)
			return mergedInheritingStylesCache;
		
		var mergedStyles:Object = _inheritingStyles;
		
        /*
		if (parent)
		{
			var otherStyles:Object = parent.inheritingStyles;
			
			for (var obj:Object in otherStyles)
			{
				if (mergedStyles[obj] === undefined)
					mergedStyles[obj] = otherStyles[obj];
			}
		}
		*/
        
		mergedInheritingStylesCache = mergedStyles;
		
		return mergedStyles;
	}
	
	public function set inheritingStyles(value:Object):void
	{
		_inheritingStyles = value;
		mergedInheritingStylesCache = null;
		
        /*
		if (hasEventListener(FlexChangeEvent.STYLE_MANAGER_CHANGE))
			dispatchInheritingStylesChangeEvent();
        */
	}
	
	//----------------------------------
	//  typeHierarchyCache
	//----------------------------------
	
	/**
	 *  @private
	 */
	private var _typeHierarchyCache:Object;
	
	/**
	 *  @private
	 */
	public function get typeHierarchyCache():Object
	{
		if (_typeHierarchyCache == null)
			_typeHierarchyCache = {};
		
		return _typeHierarchyCache;
	}
	
	/**
	 * @private
	 */ 
	public function set typeHierarchyCache(value:Object):void
	{
		_typeHierarchyCache = value;
	}
	
	//----------------------------------
	//  typeSelectorCache
	//----------------------------------
	
	/**
	 *  @private
	 */
	private var _typeSelectorCache:Object;
	
	/**
	 *  @private
	 */
	public function get typeSelectorCache():Object
	{
		if (_typeSelectorCache == null)
			_typeSelectorCache = {};
		
		return _typeSelectorCache;
	}
	
	/**
	 * @private
	 */ 
	public function set typeSelectorCache(value:Object):void
	{
		_typeSelectorCache = value;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 *  @private
	 *  This method is called by code autogenerated by the MXML compiler,
	 *  after StyleManager.styles is popuplated with CSSStyleDeclarations.
	 */
	public function initProtoChainRoots():void
	{
        trace("initProtoChainRoots not implemented");
        /*
		if (!stylesRoot)
		{
			var style:CSSStyleDeclaration = getMergedStyleDeclaration("global");
			if (style != null)
			{
				stylesRoot = style.addStyleToProtoChain({}, null);
			}
		}
        */
	}
	
	/**
	 *  Returns an array of strings of all CSS selectors registered with the StyleManager.
	 *  Pass items in this array to the getStyleDeclaration function to get the corresponding CSSStyleDeclaration.
	 *  Note that class selectors are prepended with a period.
	 *  
	 *  @return An array of all of the selectors
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */ 
	public function get selectors():Array
	{
		var theSelectors:Array = [];
		for (var i:String in _selectors)
			theSelectors.push(i);
		
        /*
		if (parent)
		{
			var otherSelectors:Array = parent.selectors;
			for (i in otherSelectors)
				theSelectors.push(i);
		}
		*/
        
		return theSelectors;
	}
	
	/**
	 *  Determines whether any of the selectors registered with the style
	 *  manager have been advanced selectors (descendant selector, id selector,
	 *  non-global class selector, pseudo selector).
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 4
	 */ 
	public function hasAdvancedSelectors():Boolean
	{
		if (_hasAdvancedSelectors)
			return true;
		
        /*
		if (parent)
			return parent.hasAdvancedSelectors();
		*/
		return false;
	}
	
	/**
	 * @private
	 * Determines whether at least one pseudo-condition has been specified for
	 * the given state.
	 */ 
	public function hasPseudoCondition(cssState:String):Boolean
	{
		if (_pseudoCSSStates != null && _pseudoCSSStates[cssState] != null)
			return true;
		
        /*
		if (parent)
			return parent.hasPseudoCondition(cssState);
		*/
		return false;
	}
	
	private static var propNames:Array = ["class", "id", "pseudo", "unconditional"];
	
	/**
	 *  Retrieve all style declarations applicable to this subject. The subject
	 *  is the right most simple type selector in a selector chain. Returns a 
	 *  map of selectors with four properties: class for class selectors,
	 *  id for id selectors, pseudo for pseudo selectors and unconditional
	 *  for selectors without conditions
	 * 
	 * 
	 *  @param subject The subject of the style declaration's selector.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 4
	 */ 
	public function getStyleDeclarations(subject:String):Object
	{
        trace("getStyleDeclarations not implemented");

        /*
		// For Flex 3 and earlier, if we were passed a subject with a package
		// name, such as "mx.controls.Button", strip off the package name
		// leaving just "Button" and look for that subject.
		if (FlexVersion.compatibilityVersion < FlexVersion.VERSION_4_0)
		{
			if (subject.charAt(0) != ".")
			{
				var index:int = subject.lastIndexOf(".");
				if (index != -1)
					subject = subject.substr(index + 1);
			}
		}
		
		// NOTE: It's important the parent declarations come before this style
		// manager's styles because the order here is the order they are added to the 
		// prototype chain.
		var theSubjects:Object = null;
		
		if (parent)
			theSubjects = parent.getStyleDeclarations(subject);
		
		var subjectsObject:Object = _subjects[subject];
		if (!theSubjects)
		{
			if (subjectsObject)
				theSubjects = subjectsObject;
		}
		else if (subjectsObject)
		{    
			var mergedSubjects:Object = {};
			for each (var prop:String in propNames)
			{
				mergedSubjects[prop] = subjectsObject[prop];
			}
			mergedSubjects.parent = theSubjects;
			theSubjects = mergedSubjects;
		}
		
		return theSubjects;
        */
        return null;
	}
	
	private function isUnique(element:*, index:int, arr:Array):Boolean {
		return (arr.indexOf(element) >= 0);
	}
	
	/**
	 *  Gets the CSSStyleDeclaration object that stores the rules
	 *  for the specified CSS selector.
	 *
	 *  <p>If the <code>selector</code> parameter starts with a period (.),
	 *  the returned CSSStyleDeclaration is a class selector and applies only to those instances
	 *  whose <code>styleName</code> property specifies that selector
	 *  (not including the period).
	 *  For example, the class selector <code>".bigMargins"</code>
	 *  applies to any UIComponent whose <code>styleName</code>
	 *  is <code>"bigMargins"</code>.</p>
	 *
	 *  <p>If the <code>selector</code> parameter does not start with a period,
	 *  the returned CSSStyleDeclaration is a type selector and applies to all instances
	 *  of that type.
	 *  For example, the type selector <code>"Button"</code>
	 *  applies to all instances of Button and its subclasses.</p>
	 *
	 *  <p>The <code>global</code> selector is similar to a type selector
	 *  and does not start with a period.</p>
	 *
	 *  @param selector The name of the CSS selector.
	 *
	 *  @return The style declaration whose name matches the <code>selector</code> property.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function getStyleDeclaration(selector:String):CSSStyleDeclaration
	{
        /*
		// For Flex 3 and earlier, if we were passed a selector with a package
		// name, such as "mx.controls.Button", strip off the package name
		// leaving just "Button" and look for that type selector.
		if (FlexVersion.compatibilityVersion < FlexVersion.VERSION_4_0)
		{
			if (selector.charAt(0) != ".")
			{
				var index:int = selector.lastIndexOf(".");
				if (index != -1)
					selector = selector.substr(index + 1);
			}
		}
		
		return _selectors[selector];
        */
        if (_selectors[selector] == null)
        {
            var styles:CSSStyleDeclaration = new CSSStyleDeclaration();
            styles.name = selector;
            _selectors[selector] = styles;
        }
        return _selectors[selector];
	}
	
	/** 
	 * Gets a CSSStyleDeclaration object that stores the rules 
	 * for the specified CSS selector. The CSSStyleDeclaration object is the created by merging
	 * the properties of the specified CSS selector of this style manager with all of the parent
	 * style managers.
	 * 
	 * <p>
	 * If this style manager contains a style declaration for the given selector, its style properties
	 * will be updated with properties from the parent style manager's merged style declaration. If
	 * this style manager does not have a style declaration for a given selector, the parent's merged
	 * style declaration will be set into this style manager depending on the value of the <code>
	 * setSelector</code> parameter.
	 * </p>
	 * 
	 * <p>If the <code>selector</code> parameter starts with a period (.), 
	 * the returned CSSStyleDeclaration is a class selector and applies only to those instances 
	 * whose <code>styleName</code> property specifies that selector 
	 * (not including the period). 
	 * For example, the class selector <code>".bigMargins"</code> 
	 * applies to any UIComponent whose <code>styleName</code> 
	 * is <code>"bigMargins"</code>.</p> 
	 * 
	 * <p>If the <code>selector</code> parameter does not start with a period, 
	 * the returned CSSStyleDeclaration is a type selector and applies to all instances 
	 * of that type. 
	 * For example, the type selector <code>"Button"</code> 
	 * applies to all instances of Button and its subclasses.</p> 
	 * 
	 * <p>The <code>global</code> selector is similar to a type selector 
	 * and does not start with a period.</p> 
	 * 
	 * @param selector The name of the CSS selector. 
	 * @param localOnly Controls whether the returned style declaration is the result of merging  
	 * the properties of this and any parent style managers or if the style declaration is only 
	 * from this style manager. 
	 * 
	 * @return The style declaration whose name matches the <code>selector</code> property. 
	 *  
	 * @langversion 3.0 
	 * @playerversion Flash 9 
	 * @playerversion AIR 1.1 
	 * @productversion Flex 4 
	 */     
	public function getMergedStyleDeclaration(selector:String):CSSStyleDeclaration
	{
        trace("getMergedStyleDeclaration not implemented");
        /*
		var style:CSSStyleDeclaration = getStyleDeclaration(selector);
		var parentStyle:CSSStyleDeclaration = null;
		
		// If we have a parent, get its style and merge them with our style.
		if (parent)
			parentStyle = parent.getMergedStyleDeclaration(selector);
		
		if (style || parentStyle)
		{
			style = new CSSMergedStyleDeclaration(style, parentStyle, 
				style ? style.selectorString : parentStyle.selectorString, this, false);
		}
		
		return style;
        */
        return null;
	}
	
	/**
	 *  Sets the CSSStyleDeclaration object that stores the rules
	 *  for the specified CSS selector.
	 *
	 *  <p>If the <code>selector</code> parameter starts with a period (.),
	 *  the specified selector is a class selector and applies only to those instances
	 *  whose <code>styleName</code> property specifies that selector
	 *  (not including the period).
	 *  For example, the class selector <code>".bigMargins"</code>
	 *  applies to any UIComponent whose <code>styleName</code>
	 *  is <code>"bigMargins"</code>.</p>
	 *
	 *  <p>If the <code>selector</code> parameter does not start with a period,
	 *  the specified selector is a "type selector" and applies to all instances
	 *  of that type.
	 *  For example, the type selector <code>"Button"</code>
	 *  applies to all instances of Button and its subclasses.</p>
	 *
	 *  <p>The <code>global</code> selector is similar to a type selector
	 *  and does not start with a period.</p>
	 *
	 *  <p>Note that the provided selector will update the selector and subject
	 *  of the styleDeclaration to keep them in sync.</p>
	 * 
	 *  @param selector The name of the CSS selector.
	 *  @param styleDeclaration The new style declaration.
	 *  @param update Set to <code>true</code> to force an immediate update of the styles.
	 *  Set to <code>false</code> to avoid an immediate update of the styles in the application.
	 *  The styles will be updated the next time this method or the <code>clearStyleDeclaration()</code> method
	 *  is called with the <code>update</code> property set to <code>true</code>.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function setStyleDeclaration(selector:String,
										styleDeclaration:CSSStyleDeclaration,
										update:Boolean):void
	{
        /*
		// For Flex 3 and earlier, if we were passed a selector with a package
		// name, such as "mx.controls.Button", strip off the package name
		// leaving just "Button" and look for that type selector.
		if (FlexVersion.compatibilityVersion < FlexVersion.VERSION_4_0)
		{
			if (selector.charAt(0) != ".")
			{
				var index:int = selector.lastIndexOf(".");
				if (index != -1)
					selector = selector.substr(index + 1);
			}
		}
		
		// Populate the selectors Array for this style declaration
		styleDeclaration.selectorRefCount++;
		styleDeclaration.selectorIndex = selectorIndex++;
		_selectors[selector] = styleDeclaration;
		
		// We also index by subject to help match advanced selectors
		var subject:String = styleDeclaration.subject;
		if (selector)
		{
			if (!styleDeclaration.subject)
			{
				// If the styleDeclaration does not yet have a subject we
				// update its selector to keep it in sync with the provided
				// selector.
				styleDeclaration.selectorString = selector;
				subject = styleDeclaration.subject;
			}
			else if (selector != styleDeclaration.selectorString)
			{
				// The styleDeclaration does not match the provided selector, so
				// we ignore the subject on the styleDeclaration and try to
				// determine the subject from the selector
				var firstChar:String = selector.charAt(0); 
				if (firstChar == "." || firstChar == ":" || firstChar == "#")
				{
					subject = "*";
				}
				else
				{
					// TODO: Support parsing Advanced CSS selectors for a 
					// subject...
					subject = selector;
				}
				
				// Finally, we update the styleDeclaration's selector to keep
				// it in sync with the provided selector.
				styleDeclaration.selectorString = selector;
			}
		}
		
		if (subject != null)
		{
			// determine the kind of selector and add it to the appropriate 
			// bin of selectors for this subject
			var kind:String = styleDeclaration.selector.conditions ? 
				styleDeclaration.selector.conditions[0].kind : 
				"unconditional";
			var declarations:Object = _subjects[subject];
			if (declarations == null)
			{
				declarations = {};
				declarations[kind] = [styleDeclaration];
				_subjects[subject] = declarations;
			}
			else
			{
				var declarationList:Array = declarations[kind] as Array;
				if (declarationList == null)
					declarations[kind] = [styleDeclaration];   
				else
					declarationList.push(styleDeclaration);
			}
		}
		
		// Also remember subjects that have pseudo-selectors to optimize
		// styles during component state changes.
		var pseudoCondition:String = styleDeclaration.getPseudoCondition();
		if (pseudoCondition != null)
		{
			if (_pseudoCSSStates == null)
				_pseudoCSSStates = {};
			
			_pseudoCSSStates[pseudoCondition] = true;
		}
		
		// Record whether this is an advanced selector so that style declaration
		// look up can be optimized for when no advanced selectors have been
		// declared
		if (styleDeclaration.isAdvanced())
			_hasAdvancedSelectors = true;
		
		// Flush cache and start over.
		if (_typeSelectorCache)
			_typeSelectorCache = {};
		
		if (update)
			styleDeclarationsChanged();
        */
        _selectors[selector] = styleDeclaration;
	}
	
	/**
	 *  Clears the CSSStyleDeclaration object that stores the rules
	 *  for the specified CSS selector.
	 *
	 *  <p>If the specified selector is a class selector (for example, ".bigMargins" or ".myStyle"),
	 *  you must be sure to start the
	 *  <code>selector</code> property with a period (.).</p>
	 *
	 *  <p>If the specified selector is a type selector (for example, "Button"), do not start the
	 *  <code>selector</code> property with a period.</p>
	 *
	 *  <p>The <code>global</code> selector is similar to a type selector
	 *  and does not start with a period.</p>
	 *
	 *  @param selector The name of the CSS selector to clear.
	 *  @param update Set to <code>true</code> to force an immediate update of the styles.
	 *  Set to <code>false</code> to avoid an immediate update of the styles in the application.
	 *  The styles will be updated the next time this method or the <code>setStyleDeclaration()</code> method is
	 *  called with the <code>update</code> property set to <code>true</code>.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function clearStyleDeclaration(selector:String,
										  update:Boolean):void
	{
        trace("clearStyleDeclaration not implemented");
        /*
		var styleDeclaration:CSSStyleDeclaration =
			getStyleDeclaration(selector);
		
		if (styleDeclaration && styleDeclaration.selectorRefCount > 0)
			styleDeclaration.selectorRefCount--;
		
		// Clear out legacy selectors map
		delete _selectors[selector];
		
		// Clear out matching decls from our selectors stored by subject
		var decls:Array;
		var i:int;
		var decl:CSSStyleDeclaration;
		
		if (styleDeclaration && styleDeclaration.subject)
		{
			decls = _subjects[styleDeclaration.subject] as Array;
			if (decls)
			{
				// Work from the back of the array so we can remove elements
				// as we go.
				for (i = decls.length - 1; i >= 0; i--)
				{
					decl = decls[i];
					if (decl && decl.selectorString == selector)
					{
						if (decls.length == 1)
							delete _subjects[styleDeclaration.subject];
						else
							decls.splice(i, 1);
					}
				}
			}
		}
		else
		{
			// Without a subject, we start searching all declarations for this
			// selector, clear out matching selectors if found and then assume
			// this we can limit our search to this subject and stop looking.
			var matchingSubject:Boolean = false;
			for each (decls in _subjects)
			{
				if (decls)
				{
					// Work from the back of the array so we can remove elements
					// as we go.
					for (i = decls.length - 1; i >= 0; i--)
					{
						decl = decls[i];
						if (decl && decl.selectorString == selector)
						{
							matchingSubject = true;
							if (decls.length == 1)
								delete _subjects[decl.subject];
							else
								decls.splice(i, 1);
						}
					}
					
					if (matchingSubject)
						break;
				}
			}
		}
		
		if (update)
			styleDeclarationsChanged();
        */
	}
	
	/**
	 *  @private
	 *  After an entire selector is added, replaced, or removed,
	 *  this method updates all the DisplayList trees.
	 */
	public function styleDeclarationsChanged():void
	{
        trace("styleDeclarationsChanged not implemented");
		//var sms:Array /* of SystemManager */ =
		//	SystemManagerGlobals.topLevelSystemManagers;
		//var n:int = sms.length;
        /*
		for (var i:int = 0; i < n; i++)
		{
			// Type as Object to avoid dependency on SystemManager or WindowedSystemManager
			var sm:ISystemManager = sms[i];
			var cm:Object = sm.getImplementation("mx.managers::ISystemManagerChildManager");
			Object(cm).regenerateStyleCache(true);
			Object(cm).notifyStyleChangeInChildren(null, true);
		}
        */
	}
	
	/**
	 *  Adds to the list of styles that can inherit values
	 *  from their parents.
	 *
	 *  <p><b>Note:</b> Ensure that you avoid using duplicate style names, as name
	 *  collisions can result in decreased performance if a style that is
	 *  already used becomes inheriting.</p>
	 *
	 *  @param styleName The name of the style that is added to the list of styles that can inherit values.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function registerInheritingStyle(styleName:String):void
	{
		if (_inheritingStyles[styleName] != true)
		{
			_inheritingStyles[styleName] = true;
			mergedInheritingStylesCache = null;
			
            /*
			if (hasEventListener(FlexChangeEvent.STYLE_MANAGER_CHANGE))
				dispatchInheritingStylesChangeEvent();
            */
		}
	}
	
	/**
	 *  Tests to see if a style is inheriting.
	 *
	 *  @param styleName The name of the style that you test to see if it is inheriting.
	 *
	 *  @return Returns <code>true</code> if the specified style is inheriting.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function isInheritingStyle(styleName:String):Boolean
	{
		if (mergedInheritingStylesCache)
			return mergedInheritingStylesCache[styleName] == true;
		
		if (_inheritingStyles[styleName] == true)
			return true;
		
        /*
		if (parent && parent.isInheritingStyle(styleName))
			return true;
		*/
        
		return false;
	}
	
	/**
	 *  Test to see if a TextFormat style is inheriting.
	 *
	 *  @param styleName The name of the style that you test to see if it is inheriting.
	 *
	 *  @return Returns <code>true</code> if the specified TextFormat style
	 *  is inheriting.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function isInheritingTextFormatStyle(styleName:String):Boolean
	{
		if (inheritingTextFormatStyles[styleName] == true)
			return true;
		
        /*
		if (parent && parent.isInheritingTextFormatStyle(styleName))
			return true;
		*/
        
		return false;
	}
	
	/**
	 *  Adds to the list of styles which may affect the measured size
	 *  of the component.
	 *  When one of these styles is set with <code>setStyle()</code>,
	 *  the <code>invalidateSize()</code> method is automatically called on the component
	 *  to make its measured size get recalculated later.
	 *
	 *  @param styleName The name of the style that you add to the list.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function registerSizeInvalidatingStyle(styleName:String):void
	{
		sizeInvalidatingStyles[styleName] = true;
	}
	
	/**
	 *  Tests to see if a style changes the size of a component.
	 *
	 *  <p>When one of these styles is set with the <code>setStyle()</code> method,
	 *  the <code>invalidateSize()</code> method is automatically called on the component
	 *  to make its measured size get recalculated later.</p>
	 *
	 *  @param styleName The name of the style to test.
	 *
	 *  @return Returns <code>true</code> if the specified style is one
	 *  which may affect the measured size of the component.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function isSizeInvalidatingStyle(styleName:String):Boolean
	{
		if (sizeInvalidatingStyles[styleName] == true)
			return true;
		
        /*
		if (parent && parent.isSizeInvalidatingStyle(styleName))
			return true;
		*/
        
		return false;
	}
	
	/**
	 *  Adds to the list of styles which may affect the measured size
	 *  of the component's parent container.
	 *  <p>When one of these styles is set with <code>setStyle()</code>,
	 *  the <code>invalidateSize()</code> method is automatically called on the component's
	 *  parent container to make its measured size get recalculated
	 *  later.</p>
	 *
	 *  @param styleName The name of the style to register.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function registerParentSizeInvalidatingStyle(styleName:String):void
	{
		parentSizeInvalidatingStyles[styleName] = true;
	}
	
	/**
	 *  Tests to see if the style changes the size of the component's parent container.
	 *
	 *  <p>When one of these styles is set with <code>setStyle()</code>,
	 *  the <code>invalidateSize()</code> method is automatically called on the component's
	 *  parent container to make its measured size get recalculated
	 *  later.</p>
	 *
	 *  @param styleName The name of the style to test.
	 *
	 *  @return Returns <code>true</code> if the specified style is one
	 *  which may affect the measured size of the component's
	 *  parent container.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function isParentSizeInvalidatingStyle(styleName:String):Boolean
	{
		if (parentSizeInvalidatingStyles[styleName] == true)
			return true;

        /*
		if (parent && parent.isParentSizeInvalidatingStyle(styleName))
			return true;
		*/
        
		return false;
	}
	
	/**
	 *  Adds to the list of styles which may affect the appearance
	 *  or layout of the component's parent container.
	 *  When one of these styles is set with <code>setStyle()</code>,
	 *  the <code>invalidateDisplayList()</code> method is auomatically called on the component's
	 *  parent container to make it redraw and/or relayout its children.
	 *
	 *  @param styleName The name of the style to register.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function registerParentDisplayListInvalidatingStyle(
		styleName:String):void
	{
		parentDisplayListInvalidatingStyles[styleName] = true;
	}
	
	/**
	 *  Tests to see if this style affects the component's parent container in
	 *  such a way as to require that the parent container redraws itself when this style changes.
	 *
	 *  <p>When one of these styles is set with <code>setStyle()</code>,
	 *  the <code>invalidateDisplayList()</code> method is auomatically called on the component's
	 *  parent container to make it redraw and/or relayout its children.</p>
	 *
	 *  @param styleName The name of the style to test.
	 *
	 *  @return Returns <code>true</code> if the specified style is one
	 *  which may affect the appearance or layout of the component's
	 *  parent container.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function isParentDisplayListInvalidatingStyle(
		styleName:String):Boolean
	{
		if (parentDisplayListInvalidatingStyles[styleName] == true)
			return true;
		
        /*
		if (parent && parent.isParentDisplayListInvalidatingStyle(styleName))
			return true;
		*/
        
		return false;
	}
	
	/**
	 *  Adds a color name to the list of aliases for colors.
	 *
	 *  @param colorName The name of the color to add to the list; for example, "blue".
	 *  If you later access this color name, the value is not case-sensitive.
	 *
	 *  @param colorValue Color value, for example, 0x0000FF.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function registerColorName(colorName:String, colorValue:uint):void
	{
		colorNames[colorName.toLowerCase()] = colorValue;
	}
	
	/**
	 *  Tests to see if the given String is an alias for a color value. For example,
	 *  by default, the String "blue" is an alias for 0x0000FF.
	 *
	 *  @param colorName The color name to test. This parameter is not case-sensitive.
	 *
	 *  @return Returns <code>true</code> if <code>colorName</code> is an alias
	 *  for a color.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function isColorName(colorName:String):Boolean
	{
		if (colorNames[colorName.toLowerCase()] !== undefined)
			return true;
		
        /*
		if (parent && parent.isColorName(colorName))
			return true;
		*/
        
		return false;
	}
	
	/**
	 *  Returns the numeric RGB color value that corresponds to the
	 *  specified color string.
	 *  The color string can be either a case-insensitive color name
	 *  such as <code>"red"</code>, <code>"Blue"</code>, or
	 *  <code>"haloGreen"</code>, a hexadecimal value such as 0xFF0000, or a #-hexadecimal String
	 *  such as <code>"#FF0000"</code>.
	 *
	 *  <p>This method returns a uint, such as 4521830, that represents a color. You can convert
	 *  this uint to a hexadecimal value by passing the numeric base (in this case, 16), to
	 *  the uint class's <code>toString()</code> method, as the following example shows:</p>
	 *  <pre>
	 *  import mx.styles.StyleManager;
	 *  private function getNewColorName():void {
	 *      StyleManager.registerColorName("soylentGreen",0x44FF66);
	 *      trace(StyleManager.getColorName("soylentGreen").toString(16));
	 *  }
	 *  </pre>
	 *
	 *  @param colorName The color name.
	 *
	 *  @return Returns a uint that represents the color value or <code>NOT_A_COLOR</code>
	 *  if the value of the <code>colorName</code> property is not an alias for a color.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function getColorName(colorName:Object):uint
	{
		var n:Number;
		
		if (colorName is String)
		{
			if (colorName.charAt(0) == "#")
			{
				// Map "#77EE11" to 0x77EE11
				n = Number("0x" + colorName.slice(1));
				return isNaN(n) ? StyleManager.NOT_A_COLOR : uint(n);
			}
			
			if (colorName.charAt(1) == "x" && colorName.charAt(0) == '0')
			{
				// Map "#77EE11" to 0x77EE11
				n = Number(colorName);
				return isNaN(n) ? StyleManager.NOT_A_COLOR : uint(n);
			}
			
			// Map "red" or "Red" to 0xFF0000;
			// Map "haloGreen" or "HaLoGrEeN" to 0x46FF00.
			var c:* = colorNames[colorName.toLowerCase()];
            /*
			if (c === undefined)
			{
				// If not found then try our parent
				if (parent)
					c = parent.getColorName(colorName);
			}
            */
			
			if (c === undefined)
				return StyleManager.NOT_A_COLOR;                
			
			return uint(c);
		}
		
		return uint(colorName);
	}
	
	/**
	 *  Converts each element of the colors Array from a color name
	 *  to a numeric RGB color value.
	 *  Each color String can be either a case-insensitive color name
	 *  such as <code>"red"</code>, <code>"Blue"</code>, or
	 *  <code>"haloGreen"</code>, a hexadecimal value such as 0xFF0000, or a #-hexadecimal String
	 *  such as <code>"#FF0000"</code>..
	 *
	 *  @param colors An Array of color names.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function getColorNames(colors:Array /* of Number or String */):void
	{
		if (!colors)
			return;
		
		var n:int = colors.length;
		for (var i:int = 0; i < n; i++)
		{
			if ((colors[i] != null) && isNaN(colors[i]))
			{
				var colorNumber:uint = getColorName(colors[i]);
				if (colorNumber != StyleManager.NOT_A_COLOR)
					colors[i] = colorNumber;
			}
		}
	}
	
	/**
	 *  Determines if a specified parameter is a valid style property. For example:
	 *
	 *  <pre>
	 *  trace(StyleManager.isValidStyleValue(myButton.getStyle("color")).toString());
	 *  </pre>
	 *
	 *  <p>This can be useful because some styles can be set to values
	 *  such as 0, <code>NaN</code>,
	 *  the empty String (<code>""</code>), or <code>null</code>, which can
	 *  cause an <code>if (value)</code> test to fail.</p>
	 *
	 *  @param value The style property to test.
	 *
	 *  @return If you pass the value returned by a <code>getStyle()</code> method call
	 *  to this method, it returns <code>true</code> if the style
	 *  was set and <code>false</code> if it was not set.
	 *
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function isValidStyleValue(value:*):Boolean
	{
		// By convention, we don't allow style values to be undefined,
		// so we can check for this as the "not set" value.
		if (value !== undefined)
			return true;
		
        /*
		if (parent)
			return parent.isValidStyleValue(value);
		*/
        
		return false;
	}
	
	/**
	 *  @private
	public function loadStyleDeclarations(
		url:String, update:Boolean = true,
		trustContent:Boolean = false,
		applicationDomain:ApplicationDomain = null,
		securityDomain:SecurityDomain = null):
		IEventDispatcher
	{
		return loadStyleDeclarations2(url, update, applicationDomain, securityDomain);
	}
	 */
	
	/**
	 *  Loads a style SWF.
	 *
	 *  @param url Location of the style SWF.
	 *
	 *  @param update If true, all the DisplayList trees will be updated.
	 *         The default is true.
	 *
	 *  @return An IEventDispatcher implementation that supports
	 *          StyleEvent.PROGRESS, StyleEvent.COMPLETE, and
	 *          StyleEvent.ERROR.
	 *
	 *  @see flash.system.SecurityDomain
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	public function loadStyleDeclarations2(
		url:String, update:Boolean = true,
		applicationDomain:ApplicationDomain = null,
		securityDomain:SecurityDomain = null):
		IEventDispatcher
	{
		var module:IModuleInfo = ModuleManager.getModule(url);
		var thisStyleManager:IStyleManager2 = this;
		
		var readyHandler:Function = function(moduleEvent:ModuleEvent):void
		{
			var styleModule:IStyleModule = IStyleModule(moduleEvent.module.factory.create());
			
			// Register the style module to use this style manager.
			moduleEvent.module.factory.registerImplementation("mx.styles::IStyleManager2", thisStyleManager);
			styleModule.setStyleDeclarations(thisStyleManager);
			styleModules[moduleEvent.module.url].styleModule = styleModule;
			if (update)
				styleDeclarationsChanged();
		};
		
		module.addEventListener(ModuleEvent.READY, readyHandler,
			false, 0, true);
		
		var styleEventDispatcher:StyleEventDispatcher =
			new StyleEventDispatcher(module);
		
		var errorHandler:Function = function(moduleEvent:ModuleEvent):void
		{
			var errorText:String = resourceManager.getString(
				"styles", "unableToLoad", [ moduleEvent.errorText, url ]);
			
			if (styleEventDispatcher.willTrigger(StyleEvent.ERROR))
			{
				var styleEvent:StyleEvent = new StyleEvent(
					StyleEvent.ERROR, moduleEvent.bubbles, moduleEvent.cancelable);
				styleEvent.bytesLoaded = 0;
				styleEvent.bytesTotal = 0;
				styleEvent.errorText = errorText;
				styleEventDispatcher.dispatchEvent(styleEvent);
			}
			else
			{
				throw new Error(errorText);
			}
		};
		
		module.addEventListener(ModuleEvent.ERROR, errorHandler,
			false, 0, true);
		
		styleModules[url] =
			new StyleModuleInfo(module, readyHandler, errorHandler);
		
		// This Timer gives the loadStyleDeclarations() caller a chance
		// to add event listeners to the return value, before the module
		// is loaded.
		var timer:Timer = new Timer(0);
		var timerHandler:Function = function(event:TimerEvent):void
		{
			timer.removeEventListener(TimerEvent.TIMER, timerHandler);
			timer.stop();
			module.load(applicationDomain, securityDomain, null, moduleFactory);
		};
		
		timer.addEventListener(TimerEvent.TIMER, timerHandler, false, 0, true);
		
		timer.start();
		
		return styleEventDispatcher;
	}
	 */
	
	/**
	 *  Unloads a style SWF.
	 *
	 *  @param url Location of the style SWF.
	 *
	 *  @param update If true, all the DisplayList trees will be updated.
	 *         The default is true.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	public function unloadStyleDeclarations(
		url:String, update:Boolean = true):void
	{
		var styleModuleInfo:StyleModuleInfo = styleModules[url];
		if (styleModuleInfo)
		{
			styleModuleInfo.styleModule.unload();
			
			var module:IModuleInfo = styleModuleInfo.module;
			module.unload();
			
			module.removeEventListener(ModuleEvent.READY,
				styleModuleInfo.readyHandler);
			module.removeEventListener(ModuleEvent.ERROR,
				styleModuleInfo.errorHandler);
			
			styleModules[url] = null;
		}
		
		if (update)
			styleDeclarationsChanged();
	}
	 */
	
	
	/**
	 *  @private
	private function dispatchInheritingStylesChangeEvent():void
	{
		var event:Event = new FlexChangeEvent(FlexChangeEvent.STYLE_MANAGER_CHANGE, 
			false, false, {property: "inheritingStyles"});
		dispatchEvent(event);
	}
	 */  
	
	/**
	 *  @private
	 */  
	public function acceptMediaList(value:String):Boolean
	{
        /*
		if (!mqp)
		{
			mqp = MediaQueryParser.instance;
			if (!mqp)
			{
				mqp = new MediaQueryParser(moduleFactory);
				MediaQueryParser.instance = mqp;
			}
		}
		return mqp.parse(value);
        */
        return false;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Event handlers
	//
	//--------------------------------------------------------------------------
	
    /*
	private function styleManagerChangeHandler(event:FlexChangeEvent):void
	{
		if (!event.data)
			return;     // invalid message
		
		var property:String = event.data["property"];
		
		if (property == "inheritingStyles")
		{
			mergedInheritingStylesCache = null;
		}
		
		if (hasEventListener(FlexChangeEvent.STYLE_MANAGER_CHANGE))
			dispatchEvent(event);
	}
    */
}
	
}

import org.apache.royale.events.EventDispatcher;
import mx.events.ModuleEvent;
//import mx.events.StyleEvent;
import mx.modules.IModuleInfo;
//import mx.styles.IStyleModule;

////////////////////////////////////////////////////////////////////////////////
//
//  Helper class: StyleEventDispatcher
//
////////////////////////////////////////////////////////////////////////////////

/**
 *  @private
 */
class StyleEventDispatcher extends EventDispatcher
{
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 *  Constructor
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function StyleEventDispatcher(moduleInfo:IModuleInfo)
	{
		super();

        /*
		moduleInfo.addEventListener(
			ModuleEvent.PROGRESS, moduleInfo_progressHandler, false, 0, true);
		
		moduleInfo.addEventListener(
			ModuleEvent.READY, moduleInfo_readyHandler, false, 0, true);
        */
	}
	
	//--------------------------------------------------------------------------
	//
	//  Event handlers
	//
	//--------------------------------------------------------------------------
	
	/**
	 *  @private
	private function moduleInfo_progressHandler(event:ModuleEvent):void
	{
		var styleEvent:StyleEvent = new StyleEvent(
			StyleEvent.PROGRESS, event.bubbles, event.cancelable);
		styleEvent.bytesLoaded = event.bytesLoaded;
		styleEvent.bytesTotal = event.bytesTotal;
		dispatchEvent(styleEvent);
	}
	 */
	
	/**
	 *  @private
	private function moduleInfo_readyHandler(event:ModuleEvent):void
	{
		var styleEvent:StyleEvent = new StyleEvent(StyleEvent.COMPLETE);
		styleEvent.bytesLoaded = event.bytesLoaded;
		styleEvent.bytesTotal = event.bytesTotal;
		dispatchEvent(styleEvent);
	}
	 */
}

////////////////////////////////////////////////////////////////////////////////
//
//  Helper class: StyleModuleInfo
//
////////////////////////////////////////////////////////////////////////////////

/**
 *  @private
class StyleModuleInfo
{
 */
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 *  Constructor
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	public function StyleModuleInfo(module:IModuleInfo,
									readyHandler:Function,
									errorHandler:Function)
	{
		super();
		
		this.module = module;
		this.readyHandler = readyHandler;
		this.errorHandler = errorHandler;
	}
	 */
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  errorHandler
	//----------------------------------
	
	/**
	 *  @private
	public var errorHandler:Function;
	 */
	
	//----------------------------------
	//  readyHandler
	//----------------------------------
	
	/**
	 *  @private
	public var readyHandler:Function;
	 */
	
	//----------------------------------
	//  styleModule
	//----------------------------------
	
	/**
	 *  @private
	public var styleModule:IStyleModule;
	 */
	
	//----------------------------------
	//  module
	//----------------------------------
	
	/**
	 *  @private
	public var module:IModuleInfo
}
	 */

class CSSClass
{
	public static const CSSSelector:int = 0;
	public static const CSSCondition:int = 1;
	public static const CSSStyleDeclaration:int = 2;
}

class CSSFactory
{
	public static const DefaultFactory:int = 0;
	public static const Factory:int = 1;
	public static const Override:int = 2;
}

class CSSDataType
{
	public static const Native:int = 0;
	public static const Definition:int = 1;
}
