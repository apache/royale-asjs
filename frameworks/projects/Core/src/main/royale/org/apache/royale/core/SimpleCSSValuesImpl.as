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
package org.apache.royale.core
{
    COMPILE::SWF
    {
        import flash.system.ApplicationDomain;
        import flash.utils.getDefinitionByName;
        import flash.utils.getQualifiedClassName;
        import flash.utils.getQualifiedSuperclassName;            
    }
	
    import org.apache.royale.core.styles.BorderStyles;
    import org.apache.royale.core.layout.EdgeData;
    import org.apache.royale.core.layout.LayoutData;
    import org.apache.royale.core.layout.MarginData;
	import org.apache.royale.events.EventDispatcher;
	import org.apache.royale.events.ValueChangeEvent;
	import org.apache.royale.events.ValueEvent;
	import org.apache.royale.geom.Rectangle;
	import org.apache.royale.utils.CSSUtils;
	import org.apache.royale.utils.string.splitAndTrim;
    
    /**
     *  The SimpleCSSValuesImpl class implements a minimal set of
     *  CSS lookup rules that is sufficient for most applications
	 *  and is easily implemented for SWFs.
     *  It does not support attribute selectors or descendant selectors
     *  or id selectors.  It will filter on a custom -royale-swf
     *  media query but not other media queries.  It can be
     *  replaced with other implementations that handle more complex
     *  selector lookups.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.8
     */
	public class SimpleCSSValuesImpl extends EventDispatcher implements IBorderPaddingMarginValuesImpl, ICSSImpl
	{

        private static const INHERIT:String = "inherit";
        private static const INDEX:String = "__index__";

        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         */
		public function SimpleCSSValuesImpl()
		{
			super();
		}
		
        private var mainClass:Object;
        
        // utility object used in the "generateCSSStyleDeclarations" method
        COMPILE::SWF
		protected var _conditionCombiners:Object;
        COMPILE::SWF
        protected function get conditionCombiners() : Object
        {
            if (!_conditionCombiners)
            {
                _conditionCombiners = {};
                _conditionCombiners["class"] = ".";
                _conditionCombiners["id"] = "#";
                _conditionCombiners["pseudo"] = ':';
            }
            return _conditionCombiners;
        }
        
        private var lastIndex:int = 0;

        // the index of the selector that had the property.
        // type selectors and global are given negative numbers
        // so that class selectors and id selectors win.  Id selectors
        // are given a value higher than the lastIndex so they
        // always win over classSelectors.  This is set by
        // each call to getStyle, so code that resolves shorthand
        // can store it and use it to compare against the shorthand
        // value to see which gets precedence.
        protected var foundIndex:int = 0;

        /**
         *  @copy org.apache.royale.core.IValuesImpl#init()
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         */
        COMPILE::SWF
        public function init(main:Object):void
        {
			var styleClassName:String;
            
			var c:Class;
			if (!values)
			{
				values = {};
	            mainClass = main;
                var mainClassName:String = getQualifiedClassName(mainClass);
				styleClassName = "_" + mainClassName + "_Styles";
				c = ApplicationDomain.currentDomain.getDefinition(styleClassName) as Class;
                generateCSSStyleDeclarations(c["factoryFunctions"], c["data"]);
			}
			c = main.constructor as Class;
            generateCSSStyleDeclarations(c["factoryFunctions"], c["data"]);
            if (hasEventListener("init"))
                dispatchEvent(new ValueEvent("init", c["fontFaces"]));
            
            var i:int = 1;
            while (true)
            {
                var ffName:String = "factoryFunctions" + i.toString();
                var ff:* = c[ffName];
                if (ff === undefined)
                    break;
                generateCSSStyleDeclarations(c[ffName], c["data" + i.toString()]);
                if (hasEventListener("init"))
                    dispatchEvent(new ValueEvent("init", c["fontFaces" + i.toString()]));
                i++;
            }
        }
        
        COMPILE::JS
        public function init(main:Object):void
        {
            var cssData:Array = main.cssData;
            var newValues:Object = values;

            mainClass = main;

            if (newValues == null)
                newValues = {};
            
            if (cssData) {
                var n:int = cssData.length;
                var i:int = 0;
                while (i < n)
                {
                    var numMQ:int = cssData[i++];
                    if (numMQ > 0)
                    {
                        // skip MediaQuery tests for now
                        i += numMQ;
                    }
                    var numSel:int = cssData[i++];
                    var propFn:Function = cssData[i + numSel];
                    var props:Object;
                    for (var j:int = 0; j < numSel; j++)
                    {
                        var selName:String = cssData[i++];
                        if (newValues[selName])
                        {
                            props = newValues[selName];
                            propFn.prototype = props;
                        }
                        newValues[selName] = new propFn();
                        newValues[selName][INDEX] = lastIndex++;
                    }
                    // skip the propFn
                    props = cssData[i++];
                }
            }
            
            values = newValues;
        }
        
        /**
         *  Process the encoded CSS data into data structures.  Usually not called
         *  directly by application developers.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         */
        COMPILE::SWF
        public function generateCSSStyleDeclarations(factoryFunctions:Object, arr:Array):void
        {
			if (factoryFunctions == null || arr == null)
				return;
			
            var declarationName:String = "";
            var segmentName:String = "";
            var n:int = arr.length;
            var i:int = 0;
            
            while (i < n)
            {
                var className:int = arr[i];
                if (className === CSSClass.CSSSelector)
                {
                    var selectorName:String = arr[++i];
                    segmentName = selectorName + segmentName;
                    if (declarationName != "")
                        declarationName += " ";
                    declarationName += segmentName;
                    segmentName = "";
                }
                else if (className === CSSClass.CSSCondition)
                {
					if (!conditionCombiners)
					{
						_conditionCombiners = {};
						conditionCombiners["class"] = ".";
						conditionCombiners["id"] = "#";
						conditionCombiners["pseudo"] = ':';    
					}
					var conditionType:String = arr[++i];
					var conditionName:String = arr[++i];
					segmentName = segmentName + conditionCombiners[conditionType] + conditionName;
                }
                else if (className === CSSClass.CSSStyleDeclaration)
                {
                    var factoryName:int = arr[++i]; // defaultFactory or factory
                    var defaultFactory:Boolean = factoryName === CSSFactory.DefaultFactory;
                    /*
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
                            if (factoryName === CSSFactory.Override)
                                newSelectors.push(style);
                        }
                    }
                    */
                    var mq:String = null;
                    var o:Object;
                    // peek ahead to see if there is a media query
                    if (i < n - 2 && arr[i + 1] === CSSClass.CSSMediaQuery)
                    {
                        mq = arr[i + 2];
                        i += 2;
                        declarationName = mq + "_" + declarationName;
                    }
                    var finalName:String;
                    var valuesFunction:Function;
                    var valuesObject:Object;
                    if (defaultFactory)
                    {
                        valuesFunction = factoryFunctions[declarationName];
                        valuesObject = new valuesFunction();
                    }
                    else
                    {
                        valuesFunction = factoryFunctions[declarationName];
                        valuesObject = new valuesFunction();
                    }
                    if (isValidStaticMediaQuery(mq))
                    {
                        finalName = fixNames(declarationName, mq);
                        o = values[finalName];
                        if (o == null)
                            values[finalName] = valuesObject;
                        else
                        {
                            valuesFunction["prototype"] = o;
                            values[finalName] = new valuesFunction();
                        }
                        values[finalName][INDEX] = lastIndex++;
                    }
                    declarationName = "";
                }
                i++;
            }
            
        }

        private function isValidStaticMediaQuery(mq:String):Boolean
        {
            if (mq == null)
                return true;
            
            if (mq == "-royale-swf")
                return true;
            
            // TODO: (aharui) other media query
            
            return false;
        }
        
        private function fixNames(s:String, mq:String):String
        {
            if (mq != null)
                s = s.substr(mq.length + 1); // 1 more for the hyphen
            
			if (s == "")
				return "*";
			
            var arr:Array = s.split(" ");
            var n:int = arr.length;
            for (var i:int = 0; i < n; i++)
            {
                var segmentName:String = arr[i];
				if (segmentName.charAt(0) == "#" || segmentName.charAt(0) == ".")
					continue;
				
                var c:int = segmentName.lastIndexOf(".");
                if (c > -1)	// it is 0 for class selectors
                {
                    segmentName = segmentName.substr(0, c) + "::" + segmentName.substr(c + 1);
                    arr[i] = segmentName;
                }
            }
            return arr.join(" ");
        }

        private function toCamelCase(value:String):String
        {
            var c:int = value.indexOf("-");
            while (c > -1)
            {
                value = value.substr(0, c) +
                    value.charAt(c + 1).toUpperCase() +
                    value.substr(c + 2);
                c = value.indexOf("-");
            }
            return value;
        }

        /**
         *  The map of values.  The format is not documented and it is not recommended
         *  to manipulate this structure directly.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         * 
         *  @royalesuppresspublicvarwarning
         */
        public var values:Object;
		
        /**
         *  @copy org.apache.royale.core.IValuesImpl#getValue()
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         *  @royaleignorecoercion org.apache.royale.core.IStyleableObject
         *  @royaleignorecoercion org.apache.royale.core.IChild
         */
		public function getValue(thisObject:Object, valueName:String, state:String = null, attrs:Object = null):*
		{
            valueName = toCamelCase(valueName);

            var value:*;
			var o:*;
			var className:String;
			var selectorName:String;
			
			if (thisObject is IStyleableObject)
			{
                var styleable:IStyleableObject = IStyleableObject(thisObject);
                // undefined in JS null in AS
                if (styleable.style != null)
                {
                    COMPILE::SWF
                    {
                        // guard to check for field avoiding need for try/catch
                        if (valueName in styleable.style) {
                            value = styleable.style[valueName];
                        }
                    }
                    COMPILE::JS
                    {
                        //sets to undefined if not present
                        value = styleable.style[valueName];
                    }
                    foundIndex = lastIndex * 2;
                    if (value === INHERIT)
                        return getInheritingValue(thisObject, valueName, state, attrs);
                    if (value !== undefined)
                        return value;
                }
                // undefined in JS null in AS
                if (styleable.id != null)
                {
                    o = values["#" + styleable.id];
                    if (o !== undefined)
                    {
                        foundIndex = o[INDEX] + lastIndex;
                        value = o[valueName];
                        if (value === INHERIT)
                            return getInheritingValue(thisObject, valueName, state, attrs);
                        if (value !== undefined)
                            return value;
                    }                    
                }
                // this className lookup is not true CSS.
                // it will take the property from the last className
                // in the list that specifies the property
                // but in real CSS we would use the value in
                // the last selector specified in the stylesheet,
                // the order in the class list does not matter,
                // only the order in the stylesheet
				var classNames:String = styleable.className;
                var classValue:*;
                // undefined in JS null in AS
                if (classNames != null)
                {
                    var classNameList:Array = classNames.split(" ");
                    for each (className in classNameList)
                    {
                        if (state != null)
                        {
                            selectorName = className + ":" + state;
                            o = values["." + selectorName];
                            if (o !== undefined)
                            {
                                foundIndex = o[INDEX];
                                value = o[valueName];
                                if (value === INHERIT)
                                    classValue = getInheritingValue(thisObject, valueName, state, attrs);
                                if (value !== undefined)
                                    classValue = value;
                            }
                        }
                        
                        o = values["." + className];
                        if (o !== undefined)
                        {
                            foundIndex = o[INDEX];
                            value = o[valueName];
                            if (value === INHERIT)
                                classValue = getInheritingValue(thisObject, valueName, state, attrs);
                            if (value !== undefined)
                                classValue = value;
                        }                        
                    }
                }
                if (classValue !== undefined)
                    return classValue;
			}
			
            o = values["*"];			
            if (o !== undefined)
            {
                foundIndex = lastIndex;
                value = o[valueName];
                if (value !== undefined)
                    return value;
            }
            
            COMPILE::SWF
            {
    			className = getQualifiedClassName(thisObject);
            }
            COMPILE::JS
            {
                className = thisObject.ROYALE_CLASS_INFO.names[0].qName;
            }
            var thisInstance:Object = thisObject;
			while (className != "Object")
			{
				if (state != null)
				{
					selectorName = className + ":" + state;
					o = values[selectorName];
					if (o !== undefined)
					{
                        foundIndex = 0 - o[INDEX];
						value = o[valueName];
                        if (value === INHERIT)
                            return getInheritingValue(thisObject, valueName, state, attrs);
						if (value !== undefined)
							return value;
					}
				}
				
	            o = values[className];
	            if (o !== undefined)
	            {
                    foundIndex = 0 - o[INDEX];
	                value = o[valueName];
                    if (value === INHERIT)
                        return getInheritingValue(thisObject, valueName, state, attrs);
	                if (value !== undefined)
	                    return value;
	            }
                COMPILE::SWF
                {
                    className = getQualifiedSuperclassName(thisInstance);
                    thisInstance = getDefinitionByName(className);                        
                }
                COMPILE::JS
                {
                    var constructorAsObject:Object = thisInstance["constructor"];
                    thisInstance = constructorAsObject.superClass_;
                    if (!thisInstance || !thisInstance.ROYALE_CLASS_INFO)
                        break;
                    
                    className = thisInstance.ROYALE_CLASS_INFO.names[0].qName;                    
                }
			}
            
            if (inheritingStyles[valueName] !== undefined &&
                thisObject is IChild)
            {
                var parentObject:Object = IChild(thisObject).parent;
                if (parentObject)
                    return getValue(parentObject, valueName, state, attrs);
            }
            
            foundIndex = 0 - lastIndex;
            o = values["global"];
            if (o !== undefined)
            {
                return o[valueName];
            }
			return undefined;
		}
		
        /**
         * @royaleignorecoercion org.apache.royale.core.IChild
         */
        private function getInheritingValue(thisObject:Object, valueName:String, state:String = null, attrs:Object = null):*
        {
            var value:*;
            if (thisObject is IChild)
            {
                var parentObject:Object = IChild(thisObject).parent;
                if (parentObject)
                {
                    value = getValue(parentObject, valueName, state, attrs);
                    if (value === INHERIT || value === undefined) {
                        return getInheritingValue(parentObject, valueName, state, attrs);
                    }
                    return value;
                }
                return undefined;
            }
            return INHERIT;
        }
        
        /**
         *  A method that stores a value to be shared with other objects.
         *  It is global, not per instance.  Fancier implementations
         *  may store shared values per-instance.
         * 
         *  @param thisObject An object associated with this value.  Thiis
         *                parameter is ignored.
         *  @param valueName The name or key of the value being stored.
         *  @param The value to be stored.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         */
		public function setValue(thisObject:Object, valueName:String, value:*):void
		{
            valueName = toCamelCase(valueName);
			var oldValue:Object = values[valueName];
			if (oldValue !== value)
			{
				values[valueName] = value;
				dispatchEvent(new ValueChangeEvent(ValueChangeEvent.VALUE_CHANGE, false, false, oldValue, value));
			}
		}
        
		/**
		 *  @copy org.apache.royale.core.IValuesImpl#newInstance()
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
		public function newInstance(thisObject:Object, valueName:String, state:String = null, attrs:Object = null):*
		{
			var c:Class = getValue(thisObject, valueName, state, attrs);
			if (c)
				return new c();
			return null;
		}
		
        /**
         *  @copy org.apache.royale.core.IValuesImpl#getInstance()
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         *  @royaleignorecoercion Function
         *  @royaleignorecoercion org.apache.royale.core.IDocument
         */
        public function getInstance(valueName:String):Object
        {
            var o:Object = values["global"];
            o = o[valueName];
            COMPILE::SWF
            {
                var i:Class = o as Class;                    
            }
            COMPILE::JS
            {
                var i:Function = null;
                if (typeof(o) == "function")
                    i = o as Function;
            }
            if (i)
            {
                o[valueName] = new i();
                var d:IDocument = o[valueName] as IDocument;
                if (d)
                    d.setDocument(mainClass);
            }
            return o;
        }
        
        /**
         *  @copy org.apache.royale.core.IValuesImpl#convertColor()
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         */
        public function convertColor(value:Object):uint
        {
            return CSSUtils.toColor(value);
        }
        
        /**
         *  @copy org.apache.royale.core.IValuesImpl#parseStyles()
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         */
        public function parseStyles(styles:String):Object
        {
            var obj:Object = {};
            var parts:Array = styles.split(";");
            for each (var part:String in parts)
            {
                var pieces:Array = splitAndTrim(part, ":");
                if (pieces.length < 2) continue;
                var valueName:String = pieces[0];
                valueName = toCamelCase(valueName);
                
                var value:String = pieces[1];
                if (value == "null")
                    obj[valueName] = null;
                else if (value == "true")
                    obj[valueName] = true;
                else if (value == "false")
                    obj[valueName] = false;
                else
                {
                    var n:Number = Number(value);
                    if (isNaN(n))
                    {
                        if (value.charAt(0) == "#" || value.indexOf("rgb") == 0)
                        {                     
                            COMPILE::SWF{
                                // in SWF we need int or uint values
                            obj[valueName] = CSSUtils.toColor(value);
                            }
                            COMPILE::JS
                            {
                                //In JS these values can be applied directly
                                obj[valueName] = value;
                            }
                        }
                        else
                        {
                            if (value.charAt(0) == "'")
                                value = value.substr(1, value.length - 2);
                            else if (value.charAt(0) == '"')
                                value = value.substr(1, value.length - 2);
                            obj[valueName] = value;
                        }
                    }
                    else
                        obj[valueName] = n;
                }
            }
            return obj;
        }
        
        /**
         *  @copy org.apache.royale.core.IValuesImpl#addRule()
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
		 *
		 *  @royaleignorecoercion HTMLStyleElement
		 *  @royaleignorecoercion CSSStyleSheet
		 *  @royaleignorecoercion uint
         */
        public function addRule(ruleName:String, ruleValues:Object):void
        {
            var asValues:Object = {};
            for (var valueName:String in ruleValues)
            {
                var v:* = ruleValues[valueName];
                valueName = toCamelCase(valueName);
                asValues[valueName] = v;
            }
            values[ruleName] = asValues;
			COMPILE::JS
			{
				if (!ss)
				{
					var styleElement:HTMLStyleElement = document.createElement('style') as HTMLStyleElement;
					document.head.appendChild(styleElement);
					ss = styleElement.sheet as CSSStyleSheet;
				}
				var cssString:String = ruleName + " {"
				for (var p:String in values)
				{
					var value:Object = values[p];
				    if (typeof(value) == 'function') continue;
					cssString += p + ": ";
					if (typeof(value) == 'number') {
                        value = processNumberStyle(p,value);
                	}
                	else if (p == 'backgroundImage') {
                    	if (p.indexOf('url') != 0)
                        	value = 'url(' + value + ')';
                	}
					cssString += value + ";";
					
				}
				cssString += "}";
				ss.insertRule(cssString, ss.cssRules.length);
			}
        }
        COMPILE::JS
        protected function processNumberStyle(prop:String,value:*):*{
            if (colorStyles[prop])
                return CSSUtils.attributeFromColor(value);
                
            return value + 'px';
        }
		
		COMPILE::JS
		private var ss:CSSStyleSheet;
        
        /**
         *  A map of inheriting styles 
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         */
        protected static const inheritingStyles:Object = {
            "color" : 1,
            "fontFamily" : 1,
            "fontSize" : 1,
            "fontStyle" : 1,
            "textAlign" : 1
        };

        /**
         * The styles that apply to each UI widget
         */
        COMPILE::JS
        private static const _perInstanceStyles:Object = {
            'backgroundColor': 1,
            'backgroundImage': 1,
            'color': 1,
            'fontFamily': 1,
            'fontWeight': 1,
            'fontSize': 1,
            'fontStyle': 1
        };
        COMPILE::JS
        protected function get perInstanceStyles() : Object
        {
            return SimpleCSSValuesImpl._perInstanceStyles;
        }
        
        
        /**
         * The styles that use color format #RRGGBB
         */
        COMPILE::JS
        private static const _colorStyles:Object = {
            'background' : 1, // if only a color is specified, otherwise value will be a string
            'backgroundColor': 1,
            'borderColor': 1,
            'color': 1
        };
        COMPILE::JS
        protected function get colorStyles() : Object
        {
            return SimpleCSSValuesImpl._colorStyles;
        }

        
        /**
         * The properties that enumerate that we skip
         */
        COMPILE::JS
        private static const _skipStyles:Object = {
            'constructor': 1
        };
        COMPILE::JS
        protected function get skipStyles() : Object
        {
            return SimpleCSSValuesImpl._skipStyles;
        }
        
        /**
         * @param thisObject The object to apply styles to;
         * @param styles The styles.
         * @royaleignorecoercion HTMLElement
         */
        COMPILE::JS
        public function applyStyles(thisObject:IUIBase, styles:Object):void
        {
            var styleList:Object = this.perInstanceStyles;
            var colorStyles:Object = this.colorStyles;
            var skipStyles:Object = this.skipStyles;
            var listObj:Object = styles;
            if (styles && styles.styleList)
                listObj = styles.styleList;
            for (var p:String in listObj) 
            {
                //if (styleList[p])
                if (skipStyles[p])
                    continue;
                var value:* = styles[p];
                if (value === undefined)
                    continue;
                if (typeof(value) == 'number') {
                    value = processNumberStyle(p,value);
                }
                else if (p == 'backgroundImage' && value.indexOf('url') != 0) {
                        value = 'url(' + value + ')';
                }
                (thisObject.element as HTMLElement).style[p] = value;
            }
        }
        
        COMPILE::JS
        private var computedStyles:CSSStyleDeclaration;
        
        /**
         *  Compute the width/thickness of the four border edges.
         *  
         *  @param object The object with style values.
         *  @param quick True to assume all four edges have the same widths.
         *  @return A Rectangle representing the four sides.
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         *  @royaleignorecoercion String
         */
        public function getBorderStyles(object:IUIBase, state:String = null):BorderStyles
        {
            var bs:BorderStyles = new BorderStyles();
            COMPILE::SWF
            {
                var border:Object = getValue(object, "border", state);
                var borderIndex:int = foundIndex;
                var borderWidth:Object = getValue(object, "border-width", state);
                var widthIndex:int = foundIndex;
                var borderStyle:Object = getValue(object, "border-style", state);
                var styleIndex:int = foundIndex;
                var borderColor:Object = getValue(object, "border-color", state);
                var colorIndex:int = foundIndex;
                if (borderStyle != null)
                    bs.style = borderStyle as String;
                else
                    bs.style = "none";
                if (borderColor != null)
                    bs.color = CSSUtils.toColor(borderColor);
                else
                    bs.color = 0;
                if (borderWidth != null)
                {
                    var borderOffset:Number;
                    if (borderWidth is String)
                        borderOffset = CSSUtils.toNumber(borderWidth as String, object.width);
                    else
                        borderOffset = Number(borderWidth);
                    if( isNaN(borderOffset) ) borderOffset = 0;            
                    bs.width = borderOffset;
                }
                else
                    bs.width = 0;
                // this code does not handle two things in the border shortcut, only 3 or 1
                if (border != null)
                {
                    if (border is Array)
                    {
                        if (borderIndex > widthIndex)
                            bs.width = CSSUtils.toNumber(String(border[0]), object.width);
                        
                        if (borderIndex > styleIndex)
                            bs.style = String(border[1]);
                        
                        if (borderIndex > colorIndex)
                            bs.color = CSSUtils.toColor(border[2]);
                    }
                    else
                        bs.style = border as String;
                }
                if (borderStyle == "none")
                    bs.width = 0;
            }
            COMPILE::JS
            {
                var madeit:Boolean;
                if (!computedStyles)
                {
                    computedStyles = getComputedStyle(object.element, state);
                    madeit = true;
                }
                bs.style = computedStyles["border-style"];  
                bs.width = CSSUtils.toNumber(computedStyles["border-width"]);  
                bs.color = CSSUtils.toColor(computedStyles["border-color"]);  
                if (madeit)
                    computedStyles = null;
            }
            return bs;
        }
        
        /**
         *  Compute the width/thickness of the four border edges.
         *  
         *  @param object The object with style values.
         *  @param quick True to assume all four edges have the same widths.
         *  @return A Rectangle representing the four sides.
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         */
        public function getBorderMetrics(object:IUIBase, state:String = null):EdgeData
        {
            var ed:EdgeData = new EdgeData();
            COMPILE::SWF
            {
                var border:Object = getValue(object, "border", state);
                var borderIndex:int = foundIndex;
                var borderWidth:Object = getValue(object, "border-width", state);
                var widthIndex:int = foundIndex;
                var borderStyle:Object = getValue(object, "border-style", state);
                var styleIndex:int = foundIndex;
                // this code does not handle two things in the border shortcut, only 3 or 1
                if (border != null)
                {
                    if (border is Array)
                    {
                        if (borderIndex > widthIndex)
                            borderWidth = CSSUtils.toNumber(String(border[0]), object.width);
                    
                        if (borderIndex > styleIndex)
                            borderStyle = String(border[2]);
                    }
                    else
                        borderStyle = border;
                }
                var borderOffset:Number = 0;
                if (borderStyle == "none" || borderStyle == null)
                    borderOffset = 0;
                else if (borderStyle != null && borderWidth != null)
                {
                    if (borderWidth is String)
                        borderOffset = CSSUtils.toNumber(borderWidth as String, object.width);
                    else
                        borderOffset = Number(borderWidth);
                    if( isNaN(borderOffset) ) borderOffset = 0;            
                }
                            
                ed.top = borderOffset;
                ed.left = borderOffset;
                ed.right = borderOffset;
                ed.bottom = borderOffset;
                var value:*;
                var values:Array;
                var n:int;
                value = getValue(object, "border-top");
                if (value != null)
                {
                    if (value is Array)
                        values = value as Array;
                    else
                        values = value.split(" ");
                    n = values.length;
                    ed.top = CSSUtils.toNumber(values[0]);
                }
                value = getValue(object, "border-left");
                if (value != null)
                {
                    if (value is Array)
                        values = value as Array;
                    else
                        values = value.split(" ");
                    n = values.length;
                    ed.left = CSSUtils.toNumber(values[0]);
                }
                value = getValue(object, "border-bottom");
                if (value != null)
                {
                    if (value is Array)
                        values = value as Array;
                    else
                        values = value.split(" ");
                    n = values.length;
                    ed.bottom = CSSUtils.toNumber(values[0]);
                }
                value = getValue(object, "border-right");
                if (value != null)
                {
                    if (value is Array)
                        values = value as Array;
                    else
                        values = value.split(" ");
                    n = values.length;
                    ed.right = CSSUtils.toNumber(values[0]);
                }
            }
            COMPILE::JS
            {
                var madeit:Boolean;
                if (!computedStyles)
                {
                    computedStyles = getComputedStyle(object.element, state);
                    madeit = true;
                }
                ed.left = CSSUtils.toNumber(computedStyles["border-left-width"]);  
                ed.right = CSSUtils.toNumber(computedStyles["border-right-width"]);  
                ed.top = CSSUtils.toNumber(computedStyles["border-top-width"]);  
                ed.bottom = CSSUtils.toNumber(computedStyles["border-bottom-width"]);
                if (madeit)
                    computedStyles = null;
            }
            return ed;
        }
        
        /**
         *  Compute the width/thickness of the four padding sides.
         *  
         *  @param object The object with style values.
         *  @return A Rectangle representing the padding on each of the four sides.
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         */
        public function getPaddingMetrics(object:IUIBase, hostWidth:Number = NaN, hostHeight:Number = NaN, state:String = null):EdgeData
        {
            var ed:EdgeData = new EdgeData();
            COMPILE::SWF
            {
                var paddingLeft:Object;
                var paddingTop:Object;
                var paddingRight:Object;
                var paddingBottom:Object;
                
                var padding:Object = getValue(object, "padding");
                paddingLeft = getValue(object, "padding-left");
                paddingTop = getValue(object, "padding-top");
                paddingRight = getValue(object, "padding-right");
                paddingBottom = getValue(object, "padding-bottom");
                ed.left = CSSUtils.getLeftValue(paddingLeft, padding, object.width);
                ed.top = CSSUtils.getTopValue(paddingTop, padding, object.height);
                ed.right = CSSUtils.getRightValue(paddingRight, padding, object.width);
                ed.bottom = CSSUtils.getBottomValue(paddingBottom, padding, object.height);
            }
            COMPILE::JS
            {
                var madeit:Boolean;
                if (!computedStyles)
                {
                    computedStyles = getComputedStyle(object.element, state);
                    madeit = true;
                }
                ed.left = CSSUtils.toNumber(computedStyles["padding-left"]);  
                ed.right = CSSUtils.toNumber(computedStyles["padding-right"]);  
                ed.top = CSSUtils.toNumber(computedStyles["padding-top"]);  
                ed.bottom = CSSUtils.toNumber(computedStyles["padding-bottom"]);
                if (madeit)
                    computedStyles = null;
            }
            return ed;
        }
        
        
        /**
         *  Combine padding and border.  Often used in non-containers.
         *  
         *  @param object The object with style values.
         *  @return A Rectangle representing the padding and border on each of the four sides.
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         */
        public function getBorderAndPaddingMetrics(object:IUIBase, hostWidth:Number = NaN, hostHeight:Number = NaN, state:String = null):EdgeData
        {
            COMPILE::JS
            {
                var madeit:Boolean;
                if (!computedStyles)
                {
                    computedStyles = getComputedStyle(object.element, state);
                    madeit = true;
                }
            }
            var borderMetrics:EdgeData = getBorderMetrics(object);
            var paddingMetrics:EdgeData = getPaddingMetrics(object);
            borderMetrics.left += paddingMetrics.left;
            borderMetrics.top += paddingMetrics.top;
            borderMetrics.right += paddingMetrics.right;
            borderMetrics.bottom += paddingMetrics.bottom;
            COMPILE::JS
            {
                if (madeit)
                    computedStyles = null;
            }
            return borderMetrics;
        }
        
        /**
         * Returns a MarginData for the given child.
         * 
         * @param child Object The element whose margins are required.
         * @param hostWidth Number The usable width dimension of the host.
         * @param hostHeight Number The usable height dimension of the host.
         * 
         * @return MarginData
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         *  @royaleignorecoercion String
         */
        public function getMargins(child:IUIBase, hostWidth:Number = NaN, hostHeight:Number = NaN, state:String = null):MarginData
        {
            var md:MarginData = new MarginData();
            
            COMPILE::SWF
            {
                var margin:Object = getValue(child, "margin");
                var marginLeft:Object = getValue(child, "margin-left");
                var marginTop:Object = getValue(child, "margin-top");
                var marginRight:Object = getValue(child, "margin-right");
                var marginBottom:Object = getValue(child, "margin-bottom");
                var ml:Number = CSSUtils.getLeftValue(marginLeft, margin, child.width);
                var mr:Number = CSSUtils.getRightValue(marginRight, margin, hostWidth);
                var mt:Number = CSSUtils.getTopValue(marginTop, margin, hostHeight);
                var mb:Number = CSSUtils.getBottomValue(marginBottom, margin, hostHeight);
                if (marginLeft == "auto")
                    ml = 0;
                if (marginRight == "auto")
                    mr = 0;
                if (margin == "auto")
                    ml = mr = mt = mb = 0;
                
                md.left = ml;
                md.right = mr;
                md.top = mt;
                md.bottom = mb;
                md.auto = (marginLeft == "auto" && marginRight == "auto") || margin == "auto";
            }
            COMPILE::JS
            {
                var madeit:Boolean;
                if (!computedStyles)
                {
                    computedStyles = getComputedStyle(child.element, state);
                    madeit = true;
                }
                var marginLeft:Object = computedStyles["margin-left"];
                var marginTop:Object = computedStyles["margin-right"];
                var marginRight:Object = computedStyles["margin-top"];
                var marginBottom:Object = computedStyles["margin-bottom"];
                md.left = marginLeft == "auto" ? 0: CSSUtils.toNumber(marginLeft as String);  
                md.right = marginRight == "auto" ? 0: CSSUtils.toNumber(marginRight as String);  
                md.top = marginTop == "auto" ? 0: CSSUtils.toNumber(marginTop as String);  
                md.bottom = marginBottom == "auto" ? 0: CSSUtils.toNumber(marginBottom as String);
                if (madeit)
                    computedStyles = null;
                md.auto = marginLeft == "auto" && marginRight == "auto";
            }
            return md;
        }
        
        /**
         * Returns an object containing the child's positioning values.
         * 
         * @param child Object The element whose positions are required.
         * 
         * @return Rectangle A structure of {top:Number, left:Number, bottom:Number, right:Number}
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         */
        public function getPositions(child:IUIBase, hostWidth:Number = NaN, hostHeight:Number = NaN, state:String = null):EdgeData
        {
            var data:EdgeData = new EdgeData();
            COMPILE::SWF
            {
                data.left = getValue(child, "left");
                data.right = getValue(child, "right");
                data.top = getValue(child, "top");
                data.bottom = getValue(child, "bottom");
            }
            COMPILE::JS
            {
                var css:CSSStyleDeclaration = getComputedStyle(child.element, state);
                data.left = CSSUtils.toNumber(css.left);
                data.right = CSSUtils.toNumber(css.right);
                data.top = CSSUtils.toNumber(css.top);
                data.bottom = CSSUtils.toNumber(css.bottom);
            }
            return data;
        }

        /**
         *  Combine padding and border.  Often used in non-containers.
         *  
         *  @param object The object with style values.
         *  @return A Rectangle representing the padding and border on each of the four sides.
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         */
        public function getBorderPaddingAndMargins(object:IUIBase, hostWidth:Number = NaN, hostHeight:Number = NaN, state:String = null):LayoutData
        {
            COMPILE::JS
            {
                computedStyles = getComputedStyle(object.element, state);
            }
            var out:LayoutData = new LayoutData();
            out.border = getBorderMetrics(object, state);
            out.padding = getPaddingMetrics(object, hostWidth, hostHeight, state);
            out.margins = getMargins(object, hostWidth, hostHeight, state);
            COMPILE::JS
            {
                computedStyles = null;
            }
            return out;

        }
	}
}

COMPILE::SWF
class CSSClass
{
    public static const CSSSelector:int = 0;
    public static const CSSCondition:int = 1;
    public static const CSSStyleDeclaration:int = 2;
    public static const CSSMediaQuery:int = 3;
}

COMPILE::SWF
class CSSFactory
{
    public static const DefaultFactory:int = 0;
    public static const Factory:int = 1;
    public static const Override:int = 2;
}

COMPILE::SWF
class CSSDataType
{
    public static const Native:int = 0;
    public static const Definition:int = 1;
}
