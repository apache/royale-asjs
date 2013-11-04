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
	import flash.utils.getQualifiedClassName;
	import flash.utils.getQualifiedSuperclassName;
	import flash.utils.getDefinitionByName;
	
	import org.apache.flex.events.ValueChangeEvent;
	import org.apache.flex.events.EventDispatcher;
	
	public class SimpleCSSValuesImpl extends EventDispatcher implements IValuesImpl
	{
		public function SimpleCSSValuesImpl()
		{
			super();
		}
		
        private var mainClass:Object;
        
		private var conditionCombiners:Object;

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
				var className:String = getQualifiedClassName(mainClass);
				c = ApplicationDomain.currentDomain.getDefinition(className) as Class;
			}
            generateCSSStyleDeclarations(c["factoryFunctions"], c["data"]);
        }
        
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
                    var finalName:String;
                    var valuesFunction:Function;
                    var valuesObject:Object;
                    if (defaultFactory)
                    {
                        valuesFunction = factoryFunctions[declarationName];
                        valuesObject = new valuesFunction();
                        finalName = fixNames(declarationName);
                        values[finalName] = valuesObject;
                    }
                    else
                    {
                        valuesFunction = factoryFunctions[declarationName];
                        valuesObject = new valuesFunction();
                        var o:Object = values[declarationName];
                        finalName = fixNames(declarationName);
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

        private function fixNames(s:String):String
        {
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

        public var values:Object;
		
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
			return o[valueName];
		}
		
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
