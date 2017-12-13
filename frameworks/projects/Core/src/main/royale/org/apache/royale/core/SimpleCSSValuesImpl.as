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
	
	import org.apache.royale.events.EventDispatcher;
	import org.apache.royale.events.ValueChangeEvent;
	import org.apache.royale.events.ValueEvent;
	import org.apache.royale.utils.CSSUtils;
    import org.apache.royale.utils.StringUtil;
    
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
     *  @productversion Royale 0.0
     */
	public class SimpleCSSValuesImpl extends EventDispatcher implements IValuesImpl, ICSSImpl
	{

        private static const INHERIT:String = "inherit";

        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function SimpleCSSValuesImpl()
		{
			super();
		}
		
        private var mainClass:Object;
        
		private var conditionCombiners:Object;

        /**
         *  @copy org.apache.royale.core.IValuesImpl#init()
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
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
         *  @productversion Royale 0.0
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
						conditionCombiners = {};
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

        /**
         *  The map of values.  The format is not documented and it is not recommended
         *  to manipulate this structure directly.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public var values:Object;
		
        /**
         *  @copy org.apache.royale.core.IValuesImpl#getValue()
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function getValue(thisObject:Object, valueName:String, state:String = null, attrs:Object = null):*
		{
            var c:int = valueName.indexOf("-");
            while (c > -1)
            {
                valueName = valueName.substr(0, c) +
                    valueName.charAt(c + 1).toUpperCase() +
                    valueName.substr(c + 2);
                c = valueName.indexOf("-");
            }

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
                        value = o[valueName];
                        if (value === INHERIT)
                            return getInheritingValue(thisObject, valueName, state, attrs);
                        if (value !== undefined)
                            return value;
                    }                    
                }
				var classNames:String = styleable.className;
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
                                value = o[valueName];
                                if (value === INHERIT)
                                    return getInheritingValue(thisObject, valueName, state, attrs);
                                if (value !== undefined)
                                    return value;
                            }
                        }
                        
                        o = values["." + className];
                        if (o !== undefined)
                        {
                            value = o[valueName];
                            if (value === INHERIT)
                                return getInheritingValue(thisObject, valueName, state, attrs);
                            if (value !== undefined)
                                return value;
                        }                        
                    }
                }
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
            
            o = values["global"];
            if (o !== undefined)
            {
    			value = o[valueName];
    			if (value !== undefined)
    				return value;
            }
			o = values["*"];			
			if (o !== undefined)
			{
				return o[valueName];
			}
			return undefined;
		}
		
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
         *  @productversion Royale 0.0
         */
		public function setValue(thisObject:Object, valueName:String, value:*):void
		{
            var c:int = valueName.indexOf("-");
            while (c > -1)
            {
                valueName = valueName.substr(0, c) +
                    valueName.charAt(c + 1).toUpperCase() +
                    valueName.substr(c + 2);
                c = valueName.indexOf("-");
            }
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
		 *  @productversion Royale 0.0
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
         *  @productversion Royale 0.0
         *  @royaleignorecoercion Function
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
         *  @productversion Royale 0.0
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
         *  @productversion Royale 0.0
         */
        public function parseStyles(styles:String):Object
        {
            var obj:Object = {};
            var parts:Array = styles.split(";");
            for each (var part:String in parts)
            {
                var pieces:Array = StringUtil.splitAndTrim(part, ":");
                if (pieces.length < 2) continue;
                var valueName:String = pieces[0];
                var c:int = valueName.indexOf("-");
	            while (c != -1)
	            {
	                valueName = valueName.substr(0, c) +
	                    valueName.charAt(c + 1).toUpperCase() +
	                    valueName.substr(c + 2);
	                c = valueName.indexOf("-");
	            }
                
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
                            obj[valueName] = CSSUtils.toColor(value);
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
         *  @productversion Royale 0.0
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
                var c:int = valueName.indexOf("-");
                while (c > -1)
                {
                    valueName = valueName.substr(0, c) +
                        valueName.charAt(c + 1).toUpperCase() +
                        valueName.substr(c + 2);
                    c = valueName.indexOf("-");
                }
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
                    	if (colorStyles[p])
                        	value = CSSUtils.attributeFromColor(value as uint);
                    	else
                        	value = value.toString() + 'px';
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
		private var ss:CSSStyleSheet;
        
        /**
         *  A map of inheriting styles 
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public static const inheritingStyles:Object = {
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
        public static const perInstanceStyles:Object = {
            'backgroundColor': 1,
            'backgroundImage': 1,
            'color': 1,
            'fontFamily': 1,
            'fontWeight': 1,
            'fontSize': 1,
            'fontStyle': 1
        };
        
        
        /**
         * The styles that use color format #RRGGBB
         */
        COMPILE::JS
        public static const colorStyles:Object = {
            'backgroundColor': 1,
            'borderColor': 1,
            'color': 1
        };

        
        /**
         * The properties that enumerate that we skip
         */
        COMPILE::JS
        public static const skipStyles:Object = {
            'constructor': 1
        };
        
        

        /**
         * @param thisObject The object to apply styles to;
         * @param styles The styles.
         * @royaleignorecoercion HTMLElement
         */
        COMPILE::JS
        public function applyStyles(thisObject:IUIBase, styles:Object):void
        {
            var styleList:Object = SimpleCSSValuesImpl.perInstanceStyles;
            var colorStyles:Object = SimpleCSSValuesImpl.colorStyles;
            var skipStyles:Object = SimpleCSSValuesImpl.skipStyles;
            var listObj:Object = styles;
            if (styles.styleList)
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
                    if (colorStyles[p])
                        value = CSSUtils.attributeFromColor(value);
                    else
                        value = value.toString() + 'px';
                }
                else if (p == 'backgroundImage' && p.indexOf('url') != 0) {
                        value = 'url(' + value + ')';
                }
                (thisObject.element as HTMLElement).style[p] = value;
            }
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
