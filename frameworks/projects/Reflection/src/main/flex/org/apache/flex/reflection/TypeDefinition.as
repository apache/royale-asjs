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
package org.apache.flex.reflection
{
    
    /**
     *  The description of a Class or Interface
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
    public class TypeDefinition extends DefinitionWithMetaData
	{
        public function TypeDefinition(name:String, rawData:Object = null)
        {
            var c:int = name.indexOf("::");
            if (c > -1)
            {
                _packageName = name.substring(0, c);
                name = name.substring(c+2);
            }
            else
                _packageName = "";
            super(name, rawData);
        }
        
        private var _packageName:String;
        
        public function get packageName():String
        {
            return _packageName;
        }        
        
        override protected function get rawData():Object
        {
            if (_rawData == null)
            {
                var def:Object = getDefinitionByName(packageName + "::" + name);
                COMPILE::SWF
                {
                    _rawData = describeType(def);                        
                }
                COMPILE::JS
                {
                    _rawData = def.prototype.FLEXJS_CLASS_INFO;
                }
            }
            return _rawData;
        }
		
		public function get dynamic():Boolean
		{
			COMPILE::SWF
			{
				return Boolean(rawData.@dynamic);
			}
			COMPILE::JS
			{
				var data:Object = rawData;
				var name:String = data.names[0].qName;
				var def:Object = getDefinitionByName(name);
				var rdata:* = def.prototype.FLEXJS_REFLECTION_INFO();
				if (rdata !== undefined)
				{
					return Boolean(rdata.dynamic);
				}
				return false;
			}
					
		}        
		
        /**
         *  @flexjsignorecoercion XML 
         */
        public function get baseClasses():Array
        {
            var results:Array = [];
            
            COMPILE::SWF
            {
                var xml:XML = rawData as XML;
                var data:XMLList = xml.extendsClass;
                var n:int = data.length();
                for (var i:int = 0; i < n; i++)
                {
                    var item:XML = data[i] as XML;
                    var qname:String = item.@type;
                    results.push(new TypeDefinition(qname));
                }
            }
            COMPILE::JS
            {
                var data:Object = rawData;
                var name:String = data.names[0].qName;
                var def:Object = getDefinitionByName(name);
                var prototype:Object = def.prototype;
                while (prototype.FLEXJS_CLASS_INFO !== undefined)
                {
                    name = prototype.FLEXJS_CLASS_INFO.names[0].qName;
                    results.push(new TypeDefinition(name));
                    def = getDefinitionByName(name);
                    prototype = def.prototype;
                }
            }
            return results;
        }
        
        public function get interfaces():Array
        {
            var results:Array = [];
            
            COMPILE::SWF
            {
                var xml:XML = rawData as XML;
                var data:XMLList = xml.implementsInterface;
                var n:int = data.length();
                for (var i:int = 0; i < n; i++)
                {
                    var item:XML = data[i] as XML;
                    var qname:String = item.@type;
                    results.push(new TypeDefinition(qname));
                }
            }
            COMPILE::JS
            {
                var data:* = rawData;
                var name:String = data.names[0].qName;
                var def:Object = getDefinitionByName(name);
                var prototype:Object = def.prototype;
                while (data !== undefined)
                {
                    var interfaces:Array = data.interfaces;
                    if (interfaces)
                    {
                        var n:int = interfaces.length;
                        for each (var s:String in interfaces)
                            results.push(new TypeDefinition(s));
                    }
                    name = data.names[0].qName;
                    results.push(new TypeDefinition(name));
                    def = getDefinitionByName(name);
                    prototype = def.prototype;
                    data = prototype.FLEXJS_CLASS_INFO;
                }
            }
            return results;            
        }
        
        public function get variables():Array
        {
            var results:Array = [];
            
            COMPILE::SWF
            {
                var xml:XML = rawData as XML;
                var data:XMLList = xml.variable;
                var n:int = data.length();
                for (var i:int = 0; i < n; i++)
                {
                    var item:XML = data[i] as XML;
                    var qname:String = item.@name;
                    results.push(new VariableDefinition(qname, item));
                }
            }
            COMPILE::JS
            {
                var data:Object = rawData;
                var name:String = data.names[0].qName;
                var def:Object = getDefinitionByName(name);
                var rdata:* = def.prototype.FLEXJS_REFLECTION_INFO();
                if (rdata !== undefined)
                {
                    var variables:Object = rdata.variables();
                    if (variables)
                    {
                        for (var v:String in variables)
                        {
                            var varDef:Object = variables[v];
                            results.push(new VariableDefinition(v, varDef));
                        }
                    }
                }
            }
            return results;        
        }
        
        public function get accessors():Array
        {
            var results:Array = [];
            
            COMPILE::SWF
            {
                var xml:XML = rawData as XML;
                var data:XMLList = xml.accessor;
                var n:int = data.length();
                for (var i:int = 0; i < n; i++)
                {
                    var item:XML = data[i] as XML;
                    var qname:String = item.@name;
                    results.push(new MethodDefinition(qname, item.@declaredBy, item));
                }
            }
            COMPILE::JS
            {
                var data:Object = rawData;
                var name:String = data.names[0].qName;
                var def:Object = getDefinitionByName(name);
                var rdata:* = def.prototype.FLEXJS_REFLECTION_INFO();
                if (rdata !== undefined)
                {
                    var accessors:Object = rdata.accessors();
                    if (accessors)
                    {
                        for (var prop:String in accessors)
                        {
                             var propDef:Object = accessors[prop];
                             results.push(new MethodDefinition(prop, propDef.declaredBy, propDef));
                        }
                    }
                }
            }
            return results;            
        }
        
        public function get methods():Array
        {
            var results:Array = [];
            
            COMPILE::SWF
            {
                var xml:XML = rawData as XML;
                var data:XMLList = xml.method;
                var n:int = data.length();
                for (var i:int = 0; i < n; i++)
                {
                    var item:XML = data[i] as XML;
                    var qname:String = item.@name;
                    results.push(new MethodDefinition(qname, item.@declaredBy, item));
                }
            }
            COMPILE::JS
            {
                var data:Object = rawData;
                var name:String = data.names[0].qName;
                var def:Object = getDefinitionByName(name);
                var rdata:* = def.prototype.FLEXJS_REFLECTION_INFO();
                if (rdata !== undefined)
                {
                    var methods:Object = rdata.methods();
                    if (methods)
                    {
                        for (var fn:String in methods)
                        {
                            var fnDef:Object = methods[fn];
                            results.push(new MethodDefinition(fn, fnDef.declaredBy, fnDef));
                        }
                    }
                }
            }
            return results;            
        }
           
    }
}
