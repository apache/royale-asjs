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
package org.apache.flex.core
{
	import flash.system.ApplicationDomain;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getQualifiedSuperclassName;
	
	import org.apache.flex.events.EventDispatcher;
	import org.apache.flex.events.ValueChangeEvent;
	
    /**
     *  The SimpleCSSValuesImpl class implements a minimal set of
     *  CSS lookup rules that is sufficient for most applications.
     *  It does not support attribute selectors or descendant selectors
     *  or id selectors.  It will filter on a custom -flex-flash
     *  media query but not other media queries.  It can be
     *  replaced with other implementations that handle more complex
     *  selector lookups.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
	public class SimpleCSSValuesImpl extends EventDispatcher implements IValuesImpl
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function SimpleCSSValuesImpl()
		{
			super();
		}
		
        private var mainClass:Object;
        
		private var conditionCombiners:Object;

        /**
         *  @copy org.apache.flex.core.IValuesImpl#init
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public function init(mainClass:Object):void
        {
			var styleClassName:String;
			var c:Class;
			if (!values)
			{
				values = {};
	            this.mainClass = mainClass;
	            var mainClassName:String = getQualifiedClassName(mainClass);
				styleClassName = "_" + mainClassName + "_Styles";
				c = ApplicationDomain.currentDomain.getDefinition(styleClassName) as Class;
			}
			else
			{
				c = mainClass.constructor as Class;
			}
            generateCSSStyleDeclarations(c["factoryFunctions"], c["data"]);
        }
        
        /**
         *  Process the encoded CSS data into data structures.  Usually not called
         *  directly by application developers.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public function generateCSSStyleDeclarations(factoryFunctions:Object, arr:Array):void
        {
			if (factoryFunctions == null)
				return;
			if (arr == null)
				return;
			
            var declarationName:String = "";
            var segmentName:String = "";
            var n:int = arr.length;
            for (var i:int = 0; i < n; i++)
            {
                var className:int = arr[i];
                if (className == CSSClass.CSSSelector)
                {
                    var selectorName:String = arr[++i];
                    segmentName = selectorName + segmentName;
                    if (declarationName != "")
                        declarationName += " ";
                    declarationName += segmentName;
                    segmentName = "";
                }
                else if (className == CSSClass.CSSCondition)
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
                else if (className == CSSClass.CSSStyleDeclaration)
                {
                    var factoryName:int = arr[++i]; // defaultFactory or factory
                    var defaultFactory:Boolean = factoryName == CSSFactory.DefaultFactory;
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
                            if (factoryName == CSSFactory.Override)
                                newSelectors.push(style);
                        }
                    }
                    */
                    var mq:String = null;
                    var o:Object;
                    if (i < n - 2)
                    {
                        // peek ahead to see if there is a media query
                        if (arr[i + 1] == CSSClass.CSSMediaQuery)
                        {
                            mq = arr[i + 2];
                            i += 2;
                            declarationName = mq + "_" + declarationName;
                        }
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
                            valuesFunction.prototype = o;
                            values[finalName] = new valuesFunction();
                        }
                    }
                    declarationName = "";
                }
            }
            
        }

        private function isValidStaticMediaQuery(mq:String):Boolean
        {
            if (mq == null)
                return true;
            
            if (mq == "-flex-flash")
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
         *  @productversion FlexJS 0.0
         */
        public var values:Object;
		
        /**
         *  @copy org.apache.flex.core.IValuesImpl#getValue
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function getValue(thisObject:Object, valueName:String, state:String = null, attrs:Object = null):*
		{
            var c:int = valueName.indexOf("-");
            while (c != -1)
            {
                valueName = valueName.substr(0, c) +
                    valueName.charAt(c + 1).toUpperCase() +
                    valueName.substr(c + 2);
                c = valueName.indexOf("-");
            }

            var value:*;
			var o:Object;
			var className:String;
			var selectorName:String;
			
			if ("className" in thisObject)
			{
				className = thisObject.className;
				if (state)
				{
					selectorName = className + ":" + state;
					o = values["." + selectorName];
					if (o)
					{
						value = o[valueName];
						if (value !== undefined)
							return value;
					}
				}
				
				o = values["." + className];
				if (o)
				{
					value = o[valueName];
					if (value !== undefined)
						return value;
				}
			}
			
			className = getQualifiedClassName(thisObject);
			while (className != "Object")
			{
				if (state)
				{
					selectorName = className + ":" + state;
					o = values[selectorName];
					if (o)
					{
						value = o[valueName];
						if (value !== undefined)
							return value;
					}
				}
				
	            o = values[className];
	            if (o)
	            {
	                value = o[valueName];
	                if (value !== undefined)
	                    return value;
	            }
				className = getQualifiedSuperclassName(thisObject);
				thisObject = getDefinitionByName(className);
			}
            o = values["global"];
            if (o)
            {
    			value = o[valueName];
    			if (value !== undefined)
    				return value;
            }
			o = values["*"];			
			if(o)
			{
				return o[valueName];
			}
			return null;
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
         *  @productversion FlexJS 0.0
         */
		public function setValue(thisObject:Object, valueName:String, value:*):void
		{
            var c:int = valueName.indexOf("-");
            while (c != -1)
            {
                valueName = valueName.substr(0, c) +
                    valueName.charAt(c + 1).toUpperCase() +
                    valueName..substr(c + 2);
                c = valueName.indexOf("-");
            }
			var oldValue:Object = values[valueName];
			if (oldValue != value)
			{
				values[valueName] = value;
				dispatchEvent(new ValueChangeEvent(ValueChangeEvent.VALUE_CHANGE, false, false, oldValue, value));
			}
		}
        
        /**
         *  @copy org.apache.flex.core.IValuesImpl#getInstance
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public function getInstance(valueName:String):Object
        {
            var o:Object = values["global"];
            if (o is Class)
            {
                o[valueName] = new o[valueName]();
                if (o[valueName] is IDocument)
                    o[valueName].setDocument(mainClass);
            }
            return o[valueName];
        }
	}
}

class CSSClass
{
    public static const CSSSelector:int = 0;
    public static const CSSCondition:int = 1;
    public static const CSSStyleDeclaration:int = 2;
    public static const CSSMediaQuery:int = 3;
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
