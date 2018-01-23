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
package org.apache.royale.textLayout.elements {
	import org.apache.royale.textLayout.compose.utils.StandardHelper;
	import org.apache.royale.textLayout.edit.SelectionFormat;
	import org.apache.royale.textLayout.formats.FormatValue;
	import org.apache.royale.textLayout.formats.IListMarkerFormat;
	import org.apache.royale.textLayout.formats.ITextLayoutFormat;
	import org.apache.royale.textLayout.formats.ListMarkerFormat;
	import org.apache.royale.textLayout.formats.TextDecoration;
	import org.apache.royale.textLayout.formats.TextLayoutFormat;

	

	
	/** 
	* The Configuration class is a primary point of integration between the Text Layout Framework and an application. You can 
	* include a Configuration object as a parameter to the <code>TextFlow()</code> constructor when you create a new TextFlow
	* instance. It allows the application to initially control how the Text Layout Framework behaves.
	* 
	* <p>The Configuration class allows you to specify initial, paragraph and container formats for the text flow 
	* through the <code>textFlowInitialFormat</code> property. It also allows you to specify initial format attributes for links, selection,
	* scrolling, and for handling the Tab and Enter keys.</p>
	*
	* @playerversion Flash 10
	* @playerversion AIR 1.5
	* @langversion 3.0
	* 
	* @see org.apache.royale.textLayout.formats.ITextLayoutFormat ITextLayoutFormat
	* @see org.apache.royale.textLayout.edit.SelectionFormat SelectionFormat
	* @see TextFlow
	*/
	
	public class Configuration implements IConfiguration
	{
		/** @private */
		static public function versionIsAtLeast(major:int,minor:int):Boolean
		{ 
//TODO do we need this?
			var versionData:Array = ["11","4","0"];//Capabilities.version.split(" ")[1].split(","); 
			return int(versionData[0]) > major || (int(versionData[0]) == major && int(versionData[1]) >= minor);
		}
		
		static public const DIFFERENCE:String = "difference";
		
		/** @private The player may disable the feature for older swfs.  */
	//	static public const playerEnablesArgoFeatures:Boolean = versionIsAtLeast(10,1); 
		
		/** @private The player may disable the feature for older swfs, so its not enough to check
		the Player version number, the SWF must also be marked as a version 11 SWF to use Spicy features.  */
		
		static public const SHIFT_RETURN_AS_HARD:int = 0;
		static public const SHIFT_RETURN_AS_HARD_IN_LIST:int = 1;
		static public const SHIFT_RETURN_AS_SOFT:int = 2;
		
		static public var defaultShiftEnterLevel:int = SHIFT_RETURN_AS_SOFT;
		
		/** If manageTabKey and manageEnterKey are false, the client must handle those keys on their own. */
		private var _manageTabKey:Boolean;
		private var _manageEnterKey:Boolean;
		
		private var _shiftEnterLevel:int = defaultShiftEnterLevel;
		
		private var _overflowPolicy:String;
		
		private var _enableAccessibility:Boolean;
		private var _releaseLineCreationData:Boolean;
		
		private var _defaultLinkNormalFormat:ITextLayoutFormat;
		private var _defaultLinkActiveFormat:ITextLayoutFormat;
		private var _defaultLinkHoverFormat:ITextLayoutFormat;
		
		private var _defaultListMarkerFormat:IListMarkerFormat;
		
		private var _textFlowInitialFormat:ITextLayoutFormat;
		
		private var _focusedSelectionFormat:SelectionFormat;
		private var _unfocusedSelectionFormat:SelectionFormat;
		private var _inactiveSelectionFormat:SelectionFormat;	
		
		// scrolling vars
		private var _scrollDragDelay:Number;
		private var _scrollDragPixels:Number;
		private var _scrollPagePercentage:Number;
		private var _scrollMouseWheelMultiplier:Number;
		
		private var _flowComposerClass:Class;
		private var _inlineGraphicResolverFunction:Function;
		private var _cursorFunction:Function;
		
		/** Constructor - creates a default configuration. 
		*
		* @param initializeWithDefaults Specifies whether to initialize the configuration with
		* the default values. Default is <code>true</code>. If set to <code>false</code>, initializes
		* without default values, thereby saving some objects. The <code>clone()</code> method sets this
		* to <code>false</code> and copies the properties from the original object.
		*
		* @playerversion Flash 10
		* @playerversion AIR 1.5
	 	* @langversion 3.0
	 	* 
		* @see org.apache.royale.textLayout.edit.SelectionFormat SelectionFormat
		* @see org.apache.royale.textLayout.compose.StandardFlowComposer StandardFlowComposer
		*/
		public function Configuration(initializeWithDefaults:Boolean = true)
		{
			if (initializeWithDefaults)
				initialize();
		}
		
		private function initialize():void
		{
			var scratchFormat:TextLayoutFormat;
	
			_manageTabKey = false;
			_manageEnterKey = true;
			_overflowPolicy = OverflowPolicy.FIT_DESCENDERS;
			_enableAccessibility = false;
			_releaseLineCreationData = false;
			
			_focusedSelectionFormat = new SelectionFormat(0xffffff, 1.0, DIFFERENCE);
			_unfocusedSelectionFormat = new SelectionFormat(0xffffff, 0, DIFFERENCE, 0xffffff, 0.0, DIFFERENCE, 0);
			_inactiveSelectionFormat  = _unfocusedSelectionFormat;
				
			scratchFormat = new TextLayoutFormat();
			scratchFormat.textDecoration = TextDecoration.UNDERLINE;
			scratchFormat.color = 0x0000FF;//default link color is blue
			_defaultLinkNormalFormat = scratchFormat;
			
			var listMarkerFormat:ListMarkerFormat = new ListMarkerFormat();
			listMarkerFormat.paragraphEndIndent = 4;
			_defaultListMarkerFormat = listMarkerFormat;
				
			scratchFormat = new TextLayoutFormat();
			scratchFormat.lineBreak = FormatValue.INHERIT;
			scratchFormat.paddingLeft = FormatValue.INHERIT;
			scratchFormat.paddingRight = FormatValue.INHERIT;
			scratchFormat.paddingTop = FormatValue.INHERIT;
			scratchFormat.paddingBottom = FormatValue.INHERIT;
			scratchFormat.marginLeft = FormatValue.INHERIT;
			scratchFormat.marginRight = FormatValue.INHERIT;
			scratchFormat.marginTop = FormatValue.INHERIT;
			scratchFormat.marginBottom = FormatValue.INHERIT;
			scratchFormat.borderLeftWidth = FormatValue.INHERIT;
			scratchFormat.borderRightWidth = FormatValue.INHERIT;
			scratchFormat.borderTopWidth = FormatValue.INHERIT;
			scratchFormat.borderBottomWidth = FormatValue.INHERIT;
			scratchFormat.verticalAlign = FormatValue.INHERIT;
			scratchFormat.columnCount = FormatValue.INHERIT;
			scratchFormat.columnCount = FormatValue.INHERIT;
			scratchFormat.columnGap = FormatValue.INHERIT;
			scratchFormat.columnWidth = FormatValue.INHERIT;
			_textFlowInitialFormat = scratchFormat;
					
			_scrollDragDelay = 35;
			_scrollDragPixels = 20;
			_scrollPagePercentage = 7.0/8.0;
			_scrollMouseWheelMultiplier = 20;
				
			_flowComposerClass = StandardHelper.getStandardClass();
		}
		
		private var _immutableClone:IConfiguration;
		
		/**
		 *  TextFlows are configured with an immutable clone of a Configuration.  Once a TextFlow is create it uses an immutable configuration.
		 *  @private
		 *  @royaleignorecoercion org.apache.royale.textLayout.elements.Configuration
		 */
		public function getImmutableClone():IConfiguration
		{
			if (!_immutableClone)
			{
				var clonedConifg:Configuration = clone() as Configuration;
				_immutableClone = clonedConifg;
				// an immutable clone is its own immutable clone
				clonedConifg._immutableClone = clonedConifg;
			}
			return _immutableClone; 
		}
		
		/** Creates a clone of the Configuration object.
		*
		* @playerversion Flash 10
		* @playerversion AIR 1.5
	 	* @langversion 3.0
	 	*/
		public function clone():IConfiguration
		{
			var config:Configuration = new Configuration(false);
			// must copy all values
			config.defaultLinkActiveFormat = defaultLinkActiveFormat;
			config.defaultLinkHoverFormat  = defaultLinkHoverFormat;
			config.defaultLinkNormalFormat = defaultLinkNormalFormat;
			config.defaultListMarkerFormat = defaultListMarkerFormat;
			config.textFlowInitialFormat = _textFlowInitialFormat;
			config.focusedSelectionFormat = _focusedSelectionFormat;
			config.unfocusedSelectionFormat = _unfocusedSelectionFormat;
			config.inactiveSelectionFormat = _inactiveSelectionFormat;
			
			config.manageTabKey = _manageTabKey;
			config.manageEnterKey = _manageEnterKey;
			config.overflowPolicy = _overflowPolicy;
			config.enableAccessibility = _enableAccessibility;
			config.releaseLineCreationData = _releaseLineCreationData;
			
			config.scrollDragDelay = _scrollDragDelay;
			config.scrollDragPixels = _scrollDragPixels;
			config.scrollPagePercentage = _scrollPagePercentage;
			config.scrollMouseWheelMultiplier = _scrollMouseWheelMultiplier;
			
			config.flowComposerClass = _flowComposerClass;
			config._inlineGraphicResolverFunction = _inlineGraphicResolverFunction;
			config._cursorFunction = _cursorFunction;
			return config; 
		}
		
		/** @copy IConfiguration#manageTabKey
		*
		* @playerversion Flash 10
		* @playerversion AIR 1.5
	 	* @langversion 3.0
		*/
		
		public function get manageTabKey():Boolean
		{ return _manageTabKey; }
		public function set manageTabKey(value:Boolean):void
		{ _manageTabKey = value; _immutableClone = null; }

		/** 
		* @copy IConfiguration#manageEnterKey
		*
		* @playerversion Flash 10
		* @playerversion AIR 1.5
	 	* @langversion 3.0
		*/
		
		public function get manageEnterKey():Boolean
		{ return _manageEnterKey; }
		public function set manageEnterKey(value:Boolean):void
		{ _manageEnterKey = value; _immutableClone = null; }
		
		/** 
		 * @copy IConfiguration#shiftEnterLevel
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		
		public function get shiftEnterLevel():int
		{ return _shiftEnterLevel; }
		public function set shiftEnterLevel(value:int):void
		{ _shiftEnterLevel = value; }
		
		/** 
		* @copy IConfiguration#overflowPolicy
		*
		* @playerversion Flash 10
		* @playerversion AIR 1.5
	 	* @langversion 3.0
	 	*
		* @see OverflowPolicy
		*/

		public function get overflowPolicy():String
		{ 	return _overflowPolicy; }
		public function set overflowPolicy(value:String):void
		{ 	_overflowPolicy = value; }
				
		/** 
		* @copy IConfiguration#defaultLinkNormalFormat
		*
		* @playerversion Flash 10
		* @playerversion AIR 1.5
	 	* @langversion 3.0
	 	*
		* @see FlowElement#linkNormalFormat
		* @see org.apache.royale.textLayout.formats.ITextLayoutFormat ITextLayoutFormat
		* @see LinkElement
		*/
		
		public function get defaultLinkNormalFormat():ITextLayoutFormat
		{ return _defaultLinkNormalFormat; }
		public function set defaultLinkNormalFormat(value:ITextLayoutFormat):void
		{ _defaultLinkNormalFormat = value; _immutableClone = null; }

		/** 
		 * @copy IConfiguration#defaultListMarkerFormat
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 *
		 * @see FlowElement#listMarkerFormat
		 * @see org.apache.royale.textLayout.formats.IListMarkerFormat IListMarkerFormat
		 * @see LinkElement
		 */
		
		public function get defaultListMarkerFormat():IListMarkerFormat
		{ return _defaultListMarkerFormat; }
		public function set defaultListMarkerFormat(value:IListMarkerFormat):void
		{ _defaultListMarkerFormat = value; _immutableClone = null; }
		
		/** 
		* @copy IConfiguration#defaultLinkHoverFormat  
		*
		* @playerversion Flash 10
		* @playerversion AIR 1.5
	 	* @langversion 3.0
	 	*
		* @see  FlowElement#linkHoverFormat
		* @see org.apache.royale.textLayout.formats.ITextLayoutFormat ITextLayoutFormat
		* @see LinkElement
		*/
		
		public function get defaultLinkHoverFormat():ITextLayoutFormat
		{ return _defaultLinkHoverFormat; }	
		public function set defaultLinkHoverFormat(value:ITextLayoutFormat):void
		{ _defaultLinkHoverFormat = value; _immutableClone = null; }
			
		/** 
		* @copy IConfiguration#defaultLinkActiveFormat
		*
		* @playerversion Flash 10
		* @playerversion AIR 1.5
	 	* @langversion 3.0
	 	*
		* @see FlowElement#linkActiveFormat 
		* @see org.apache.royale.textLayout.formats.ITextLayoutFormat ITextLayoutFormat
		* @see LinkElement
		*/
		
		public function get defaultLinkActiveFormat():ITextLayoutFormat
		{ return _defaultLinkActiveFormat; }
		public function set defaultLinkActiveFormat(value:ITextLayoutFormat):void
		{ _defaultLinkActiveFormat = value; _immutableClone = null; }
		
		/** 
		* @copy IConfiguration#textFlowInitialFormat
		*
		* @playerversion Flash 10
		* @playerversion AIR 1.5
	 	* @langversion 3.0
	 	*
		* @see TextFlow
		* @see org.apache.royale.textLayout.formats.ITextLayoutFormat ITextLayoutFormat
		*/
		
		public function get textFlowInitialFormat():ITextLayoutFormat
		{ return _textFlowInitialFormat; }
		public function set textFlowInitialFormat(value:ITextLayoutFormat):void
		{ _textFlowInitialFormat = value; _immutableClone = null; }
		

		
		/** 
		* @copy IConfiguration#focusedSelectionFormat 
		*
		* @playerversion Flash 10
		* @playerversion AIR 1.5
	 	* @langversion 3.0
	 	*
	 	* @see org.apache.royale.textLayout.edit.SelectionFormat SelectionFormat
		* @see org.apache.royale.textLayout.edit.SelectionManager#focusedSelectionFormat SelectionManager.focusedSelectionFormat
		* @see TextFlow
		*/
		
		public function get focusedSelectionFormat():SelectionFormat
		{ return _focusedSelectionFormat; }
		public function set focusedSelectionFormat(value:SelectionFormat):void
		{	if (value != null)
			{	
				_focusedSelectionFormat = value; 
				_immutableClone = null;
			} 
		}
		
		/** 
		* @copy IConfiguration#unfocusedSelectionFormat
		*
		* @playerversion Flash 10
		* @playerversion AIR 1.5
	 	* @langversion 3.0
	 	*
	 	* @see org.apache.royale.textLayout.edit.SelectionFormat SelectionFormat
		* @see org.apache.royale.textLayout.edit.SelectionManager#unfocusedSelectionFormat SelectionManager.unfocusedSelectionFormat
		* @see TextFlow
		*/
		
		public function get unfocusedSelectionFormat():SelectionFormat
		{ return _unfocusedSelectionFormat; }
		public function set unfocusedSelectionFormat(value:SelectionFormat):void
		{	if (value != null)
			{	
				_unfocusedSelectionFormat = value; 
				_immutableClone = null;
			} 
		}		
		
		/** 
		* @copy IConfiguration#inactiveSelectionFormat
		*
		* @playerversion Flash 10
		* @playerversion AIR 1.5
	 	* @langversion 3.0
	 	*
	 	* @see org.apache.royale.textLayout.edit.SelectionFormat SelectionFormat
		* @see org.apache.royale.textLayout.edit.SelectionManager#inactiveSelectionFormat SelectionManager.inactiveSelectionFormat
		* @see TextFlow
		*/
		
		public function get inactiveSelectionFormat():SelectionFormat
		{ return _inactiveSelectionFormat; }
		public function set inactiveSelectionFormat(value:SelectionFormat):void
		{	
			if (value != null)
			{
				_inactiveSelectionFormat = value; 
				_immutableClone = null; 
			}
		}												
		
		/** 
		* @copy IConfiguration#scrollDragDelay
		*
		* @playerversion Flash 10
		* @playerversion AIR 1.5
	 	* @langversion 3.0
		*/
		
		public function get scrollDragDelay():Number
		{ return _scrollDragDelay; }
		public function set scrollDragDelay(value:Number):void
		{
			if (value > 0) {
				_scrollDragDelay = value;
				_immutableClone = null;
			}
		}
		
		/** 
		* @copy IConfiguration#scrollDragPixels
		*
		* @playerversion Flash 10
		* @playerversion AIR 1.5
	 	* @langversion 3.0
		*/
		
		public function get scrollDragPixels():Number
		{ return _scrollDragPixels; }
		public function set scrollDragPixels(value:Number):void
		{
			if (value > 0) {
				_scrollDragPixels = value;
				_immutableClone = null;
			}
		}

		/**
		* @copy IConfiguration#scrollPagePercentage
		*
		* @playerversion Flash 10
		* @playerversion AIR 1.5
	 	* @langversion 3.0
		*/
		
		public function get scrollPagePercentage(): Number
		{ return _scrollPagePercentage; }
		public function set scrollPagePercentage(value:Number):void
		{
			if (value > 0) {
				_scrollPagePercentage = value;
				_immutableClone = null;
			}
		}
		
		/** 
		* @copy IConfiguration#scrollMouseWheelMultiplier
		*
		* @playerversion Flash 10
		* @playerversion AIR 1.5
	 	* @langversion 3.0
		*/
		
		public function get scrollMouseWheelMultiplier(): Number
		{ return _scrollMouseWheelMultiplier; }
		public function set scrollMouseWheelMultiplier(value:Number):void
		{
			if (value > 0) {
				_scrollMouseWheelMultiplier = value;
				_immutableClone = null;
			}
		}
		
		/** 
		* @copy IConfiguration#flowComposerClass
		*
		* @playerversion Flash 10
		* @playerversion AIR 1.5
	 	* @langversion 3.0
	 	*
	 	* @see org.apache.royale.textLayout.compose.StandardFlowComposer StandardFlowComposer
		* @see org.apache.royale.textLayout.elements.TextFlow TextFlow
		*/
		
		public function get flowComposerClass(): Class
		{ return _flowComposerClass; }
		public function set flowComposerClass(value:Class):void
		{
			_flowComposerClass = value;
			_immutableClone = null;
		}
	
		/** 
		* @copy IConfiguration#enableAccessibility
		*
		* @playerversion Flash 10
		* @playerversion AIR 1.5
	 	* @langversion 3.0
	 	*
	 	* @see TextFlow
		*/
		
		public function get enableAccessibility():Boolean
		{ return _enableAccessibility; }
		public function set enableAccessibility(value:Boolean):void
		{
			_enableAccessibility = value;
			_immutableClone = null;
		}
		
		/** 
		* @copy IConfiguration#releaseLineCreationData
		* 
		* @playerversion Flash 10
		* @playerversion AIR 1.5
		* @langversion 3.0
		*
		* @see org.apache.royale.textLayout.compose.StandardFlowComposer StandardFlowComposer
		* @see org.apache.royale.text.engine.TextBlock#releaseLineCreationData() TextBlock.releaseLineCreationData()
		*/
		
		public function get releaseLineCreationData():Boolean
		{ return _releaseLineCreationData; }
		public function set releaseLineCreationData(value:Boolean):void
		{
			_releaseLineCreationData = value;
			_immutableClone = null;
		}

		private static var _defaultConfiguration:IConfiguration;
		public static function get defaultConfiguration():IConfiguration{
			if(_defaultConfiguration == null)
				_defaultConfiguration = new Configuration();
			
			return _defaultConfiguration;
		}
		public static function set defaultConfiguration(value:IConfiguration):void{
			_defaultConfiguration = value;
		}
		
		/** Returns true if the ActionScript text engine was built with debugging code enabled. @private */
		static public function get debugCodeEnabled():Boolean
		{
			CONFIG::debug   { return true; }
			CONFIG::release { return false; }
		}
		
		/** 
		* @copy IConfiguration#inlineGraphicResolverFunction
		* 
		* @playerversion Flash 10
		* @playerversion AIR 1.5
		* @langversion 3.0
		*
		* @see org.apache.royale.textLayout.elements.InlineGraphicElement InlineGraphicElement
		*/		
		public function get inlineGraphicResolverFunction():Function
		{ 
			return _inlineGraphicResolverFunction; 
		}
		public function set inlineGraphicResolverFunction(value:Function):void
		{
			_inlineGraphicResolverFunction = value;
			_immutableClone = null;
		}
		
		/** 
		 * @copy IConfiguration#cursorFunction
		 * 
		 * @playerversion Flash 10.2
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 *
		 */		
		public function get cursorFunction():Function
		{ 
			return _cursorFunction; 
		}
		public function set cursorFunction(value:Function):void
		{
			_cursorFunction = value;
			_immutableClone = null;
		}
		
		
		
		/** @private */
		static public function getCursorString(config:IConfiguration, cursorString:String):String
		{
			return config.cursorFunction == null ? cursorString : config.cursorFunction(cursorString);
		}
		
	}
}
