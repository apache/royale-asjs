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
package org.apache.royale.textLayout.elements
{


    
    /** Configuration that applies to all TextFlow objects.
     * @playerversion Flash 10
     * @playerversion AIR 1.5
     */
    public class GlobalSettings 
    {
        /** 
        * Specifies the callback used for font mapping.
        * The callback takes a <code>org.apache.royale.text.engine.FontDescription</code> object and updates it as needed.
        * 
        * After setting a new font mapping callback, or changing the behavior of the exisiting font mapping callback, 
        * the client must explicitly call <code>org.apache.royale.textLayout.elements.TextFlow.invalidateAllFormats</code> for each impacted text flow.
        * This ensures that whenever a leaf element in the text flow is next recomposed, the FontDescription applied to it is recalculated, and the the callback is invoked. 
        * 
        * @see org.apache.royale.text.engine.FontDescription FontDescription
        * @see TextFlow.invalidateAllFormats invalidateAllFormats
        * 
        * @playerversion Flash 10
        * @playerversion AIR 1.5
        * @langversion 3.0
        */
        public static function get fontMapperFunction():Function
        { 
            return _fontMapperFunction; 
        }
        public static function set fontMapperFunction(val:Function):void
        {
            _fontMapperFunction = val;
        }
        
        private static var _fontMapperFunction:Function;
        
        /** Controls whether the text will be visible to a search engine indexer. Defaults to <code>true</code>.
         * 
         * @playerversion Flash 10
         * @playerversion AIR 1.5
         * @langversion 3.0
         */
        public static function get enableSearch():Boolean
        {
            return _enableSearch;
        }
        public static function set enableSearch(value:Boolean):void
        {
            _enableSearch = value;
        }
        
        private static var _enableSearch:Boolean = true;
    
        /** 
         * Specifies the callback used for changing the FontLookup based on swfcontext.  The function will be called each time an ElementFormat is computed.
         * It gives the client the opportunity to modify the FontLookup setting.  The function is called with two parameters an ISWFContext and an ITextLayoutFormat.
         * It must return a valid FontLookup.
         * 
         * @see org.apache.royale.textLayout.compose.ISWFContext
         * @see org.apache.royale.textLayout.formats.ITextLayoutFormat
         * @see org.apache.royale.text.engine.ElementFormat
         * @see org.apache.royale.text.engine.FontLookup
         * 
         * @playerversion Flash 10
         * @playerversion AIR 1.5
         * @langversion 3.0
         */
        public static function get resolveFontLookupFunction():Function
        { 
            return _resolveFontLookupFunction; 
        }
        public static function set resolveFontLookupFunction(val:Function):void
        {
            _resolveFontLookupFunction = val;
        }
        private static var _resolveFontLookupFunction:Function;
        
        /** Function that takes two parameters, a resource id and an optional array of parameters to substitute into the string.
         * The string is of form "Content {0} more content {1}".  The parameters are read from the optional array and substituted for the bracketed substrings.
         * TLF provides a default implementation with
         * default strings.  Clients may replace this function with their own implementation for localization.
         * 
         * @playerversion Flash 10
         * @playerversion AIR 1.5
         * @langversion 3.0
         */
        public static function get resourceStringFunction():Function
        { 
            return _resourceStringFunction; 
        }
        public static function set resourceStringFunction(val:Function):void
        {
            _resourceStringFunction = val;
        }
        
        private static var _resourceStringFunction:Function = defaultResourceStringFunction;
        
        /** @private */
        
        private static const resourceDict:Object = 
        {
            "missingStringResource":          "No string for resource {0}",
            // core errors
            "invalidFlowElementConstruct":    "Attempted construct of invalid FlowElement subclass",
            "invalidSplitAtPosition":         "Invalid parameter to splitAtPosition",
            "badMXMLChildrenArgument":        "Bad element of type {0} passed to mxmlChildren",
            "badReplaceChildrenIndex":        "Out of range index to FlowGroupElement.replaceChildren",
            "invalidChildType":               "NewElement not of a type that this can be parent of",
            "badRemoveChild":                 "Child to remove not found",
            "invalidSplitAtIndex":            "Invalid parameter to splitAtIndex",
            "badShallowCopyRange":            "Bad range in shallowCopy",
            "badSurrogatePairCopy":           "Copying only half of a surrogate pair in SpanElement.shallowCopy",
            "invalidReplaceTextPositions":    "Invalid positions passed to SpanElement.replaceText",
            "invalidSurrogatePairSplit":      "Invalid splitting of a surrogate pair",
            "badPropertyValue":               "Property {0} value {1} is out of range",
            // selection/editing
            "illegalOperation":               "Illegal attempt to execute {0} operation",
            // shared import errors
            "unexpectedXMLElementInSpan":     "Unexpected element {0} within a span",
            "unexpectedNamespace":            "Unexpected namespace {0}",
            "unknownElement":                 "Unknown element {0}",
            "unknownAttribute":               "Attribute {0} not permitted in element {1}",
            // html format import errors
            "malformedTag":                   "Malformed tag {0}",
            "malformedMarkup":                "Malformed markup {0}",
            // textlayoutformat import errors
            "missingTextFlow":                "No TextFlow to parse",
            "expectedExactlyOneTextLayoutFormat": "Expected one and only one TextLayoutFormat in {0}",    
            "expectedExactlyOneListMarkerFormat": "Expected one and only one ListMarkerFormat in {0}",
            "unsupportedVersion":         "Version {0} is unsupported",
            // shared import/export errors
            "unsupportedProperty":            "Property {0} is unsupported"
        };
        
        /** @private */
        public static function defaultResourceStringFunction(resourceName:String, parameters:Array = null):String
        {
            var value:String = String(resourceDict[resourceName]);
            
            if (value == null)
            {
                value = String(resourceDict["missingStringResource"]);
                parameters = [ resourceName ];
            }
            
            if (parameters)
                value = substitute(value, parameters);
            
            return value;
        }
        
        /** @private */
        public static function substitute(str:String, ... rest):String
        {
            if (str == null) 
                return '';
            
            // Replace all of the parameters in the msg string.
            var len:uint = rest.length;
            var args:Array;
            if (len == 1 && rest[0] is Array)
            {
                args = rest[0] as Array;
                len = args.length;
            }
            else
            {
                args = rest;
            }
            
            for (var i:int = 0; i < len; i++)
            {
                str = str.replace(new RegExp("\\{"+i+"\\}", "g"), args[i]);
            }
            
            return str;
        }
        

        private static var _enableDefaultTabStops:Boolean = false;
        /** 
         * @private Player versions prior to 10.1 do not set up any default tabStops. As a workaround, if enableDefaultTabs
         * is true, TLF will set up default tabStops in the case where there are no tabs defined.
         * 
         */     
        public static function get enableDefaultTabStops():Boolean
        {
            return _enableDefaultTabStops;
        }
        /** 
         * @private 
         */         
        public static function set enableDefaultTabStops(val:Boolean):void
        {
            _enableDefaultTabStops = val;
        }
		
		private static var _alwaysCalculateWhitespaceBounds:Boolean = false;
		/** 
		 * @private If this is true, we will always calculate whitespace width in line bounds.
		 * if this is false, we will see if lineBreak="explicit" or when the logical width is NaN, 
		 * the content bounds includes the spaces at the end of the line. With lineBreak="toFit" 
		 * the spaces are not included. 
		 * 
		 */     
		public static function get alwaysCalculateWhitespaceBounds():Boolean
		{
			return _alwaysCalculateWhitespaceBounds;
		}
		/** 
		 * @private 
		 */         
		public static function set alwaysCalculateWhitespaceBounds(val:Boolean):void
		{
			_alwaysCalculateWhitespaceBounds = val;
		}
		
		//		static public const playerEnablesSpicyFeatures:Boolean = versionIsAtLeast(10,2) && (new Sprite).hasOwnProperty("needsSoftKeyboard"); 
//		static public const hasTouchScreen:Boolean = playerEnablesArgoFeatures && Capabilities["touchScreenType"] != "none";

//TODO make these meaningful. How???
		static public const playerEnablesSpicyFeatures:Boolean = false; 
		static public const hasTouchScreen:Boolean = false;
		
    }
}
