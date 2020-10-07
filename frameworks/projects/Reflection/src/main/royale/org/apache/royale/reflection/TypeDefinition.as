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
package org.apache.royale.reflection
{
COMPILE::SWF {
    import flash.utils.describeType;
}
    
    /**
     *  The description of a Class or Interface
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    public class TypeDefinition extends DefinitionWithMetaData
	{


            //js storage support for class aliases
            COMPILE::JS
            private static var _aliasMappings:Object={};


            /**
             * @private
             * @param aliasName
             * @param classObject
             */
            COMPILE::JS
            internal static function registerClassAlias(aliasName:String, classObject:Class ) :void{
                var info:* = classObject.prototype.ROYALE_CLASS_INFO;
                if (!info && ExtraData.hasData(classObject)) {
                    info = ExtraData.getData(classObject)['ROYALE_CLASS_INFO'];
                }
                if (info) {
                    //a class may have more than one alias point to it, but only the most recently registered
                    //alias is retained for reflection (applying same approach as swf)
                    var alias:String = info.alias;
                    if (alias) {
                        if (alias == aliasName) {
                            if (_aliasMappings[aliasName] == classObject) return; //nothing to do
                        }
                    }
                    //check for alternate mapping, remove any alternative mapping
                    //from the other class's ROYALE_CLASS_INFO
                    var altClass:Class = _aliasMappings[aliasName];
                    if (altClass) {
                        var altInfo:* = altClass.prototype.ROYALE_CLASS_INFO;
                        if (!altInfo) altInfo = ExtraData.getData(altClass)['ROYALE_CLASS_INFO'];
                        if (altInfo){
                            delete altInfo.alias;
                        }
                    }
                    _aliasMappings[aliasName] = classObject;
                    info.alias = aliasName;

                } else throw new Error("registerClassAlias error: classObject is not Reflectable "+classObject);
            }


            /**
             * @private
             * @param aliasName
             * @return the class that is mapped to by the alias
             */
            COMPILE::JS
            internal static function getClassByAlias(aliasName:String):Class {
                return _aliasMappings[aliasName];
            }



        //special cases
        private static const SC:Array=['void','null','*',''];



        private static var _cache:Object;

        public static function get useCache():Boolean{
            return _cache != null;
        }

        public static function set useCache(value:Boolean):void{
            if (value) {
                if (!_cache) _cache = {};
            } else if (_cache) _cache = null;
        }


        /**
         * The static getDefinition method is the primary access to TypeDefinitions. Although the
         * constructor does not have a lock to prevent use (for performance reasons), using it directly
         * is discouraged.
         * @param name the qualified name of the definition,
         * @param rawData (optional) the reflection data if already available
         * @param clazz (optional) a class reference to store internally for performance of getClass method
         * @return a TypeDefinition representing the class or interface represented by the parameters
         */
        public static function getDefinition(name:String, rawData:Object = null, clazz:Class = null):TypeDefinition {
            if (rawData == null) return null;
            const def:TypeDefinition = internalGetDefinition(name, rawData);
            if (clazz) {
                def._class = clazz;
            }
            return def;
        }
        
        /**
         * The static getNativeDefinition method is a way to get a TypeDefinition for non-Royale types
		 * like String, etc.
         * @param name the qualified name of the definition,
         * @return a TypeDefinition representing the class or interface represented by the parameters
         */
        public static function getNativeDefinition(name:String):TypeDefinition {
            const def:TypeDefinition = internalGetDefinition(name);
            return def;
        }
        
        internal static function internalGetDefinition(name:String, rawData:Object = null):TypeDefinition{
            COMPILE::SWF {
                //normalize Vector naming
                if (name.indexOf('__AS3__.vec::') == 0) name = name.substr(13);
            }
            return _cache ? (_cache[name] || new TypeDefinition(name, rawData)) : new TypeDefinition(name, rawData);
        }

        /**
         * The static TypeDefinitions.getDefinition method is the primary access to TypeDefinitions. Although the
         * constructor does not have a lock to prevent use (for performance reasons), using it directly
         * is discouraged.
         * Most of the time you should retrieve TypeDefinitions with org.apache.royale.reflection.describeType()
         */
        public function TypeDefinition(name:String, rawData:Object = null)
        {
            COMPILE::SWF {
                //normalize Vector naming
                if (name.indexOf('__AS3__.vec::') == 0) name = name.substr(13);
            }
            if (_cache) _cache[name] = this;

			var c:int;
			COMPILE::SWF{
				c = name.indexOf("::");
				if (c > -1)
				{
					_packageName = name.substr(0, c);
					name = name.substr(c+2);
				}
				else
					_packageName = "";
                //this definition sets a flag for where to find the metadata:
                useFactory = true;
                
			}
			COMPILE::JS{
				c = name.lastIndexOf(".");
				if (c > -1 && name.indexOf('Vector.') != 0)
				{
					_packageName = name.substr(0, c);
					name = name.substr(c+1);
				}
				else
					_packageName = "";
			}
            _specialCase = _packageName == "" && SC.indexOf(name) != -1;
            super(name, rawData);
        }

        protected var _kind:String;
        /**
         * The type of definition this TypeDefinition describes
         * values can be "class", "interface", "unknown"
         * This can sometimes be different between swf and js
         * targets.
         */
        public function get kind():String{
            if (_kind) return _kind;

            COMPILE::SWF {
                var xml:XML = rawData as XML;
                if (xml) {
                    //double check we have the uppermost definition
                    if (xml.@isStatic!="true") _kind = "class";
                    var factory:XML = xml.factory[0];
                    //all classes have an extends class, except for Object
                    if (!factory || factory.extendsClass.length() || factory.@type=="Object") _kind="class";
                    else _kind="interface";
                }
            }

            COMPILE::JS {
                var data:Object = rawData;
                _kind = data.names[0].kind;
            }

            return _kind || "unknown";
        }

        /**
         * convenience check for whether this definition
         * represents a Class or instance of a Class
         */
        public function get isClass():Boolean{
            return (_kind || kind) == "class";
        }
        /**
         * convenience check for whether this definition
         * represents an interface
         */
        public function get isInterface():Boolean{
            return (_kind || kind) == "interface";
        }


        private var _specialCase:Boolean;

        protected var _packageName:String;
        /**
         * The package name for this TypeDefinition
         */
        public function get packageName():String
        {
            return _packageName;
        }
        /**
         * The qualified name for this TypeDefinition
         */
        public function get qualifiedName():String{
            if (_packageName.length) return _packageName + "." + _name;
            else return _name;
        }
        
        private var _class:Class;
        
        /**
         * convenience method to access the class definition from this TypeDefinition
         * @return the original class (or interface) described by this TypeDefinition
         * 
         * @royaleignorecoercion Class
         */
        public function getClass():Class{
            if (!_class)
                _class = getDefinitionByName(qualifiedName) as Class;
            return _class;
        }

        /**
         * @private
         */
        override protected function get rawData():Object
        {
            var def:Object;
            COMPILE::SWF {
                if (_rawData == null)
                {
                    if (_packageName.length)
                        def = getDefinitionByName(_packageName + "." + _name);
                    else def = getDefinitionByName(_name);
                    _rawData = flash.utils.describeType(def);

                }
            }

            COMPILE::JS{
                if (_rawData == null)
                {
                    if (_packageName.length)
                        def = getDefinitionByName(_packageName + "." + _name);
                    else def = getDefinitionByName(_name);
                    _rawData = def.prototype.ROYALE_CLASS_INFO;
                    if (_rawData == null) {
                        _rawData = ExtraData.hasData(def) ? ExtraData.getData(def)['ROYALE_CLASS_INFO'] : null;
                    }
                }
            }
            return _rawData;
        }

        /** class specific support */

        private var _constructorMethod:MethodDefinition;
        /**
         * A MethodDefinition representing the constructor for a "class" kind TypeDefinition
         * For an interface this returns null.
         */
        public function get constructorMethod():MethodDefinition{
            if ((_kind || kind) != "class") return null;
            COMPILE::SWF {
                if (!_constructorMethod) {
                    var source:XML = rawData.factory.constructor[0];//['constructor'][0];
                    var declaredBy:String = _packageName.length? _packageName+"::"+_name : _name;
                    var xmlName:String = _name.replace('<', '&lt;');
                    declaredBy = declaredBy.replace('<', '&lt;');
                    if (source ==null) {
                        //constructor with no params
                        _constructorMethod =
                                new MethodDefinition(_name, false, this, XML('<method name="'+xmlName+'" declaredBy="'+declaredBy+'" returnType="" />'));
                    } else {
                        var params:XMLList = source.parameter;
                        _constructorMethod=new MethodDefinition(_name, false, this, XML('<method name="'+xmlName+'" declaredBy="'+declaredBy+'" returnType="">'+params.toXMLString()+'</method>'))
                    }
                }
            }

            COMPILE::JS {
                if (!_constructorMethod) {
                    var temp:Array = getCollection("methods","instance",false);
                    var i:int=0, l:int=temp.length;
                    for (;i<l;i++) {
                        if (temp[i].name == _name) {
                            //trace('found constructor '+results[i].toString());
                            _constructorMethod = temp[i];
                            break;
                        }
                    }
                    if (!_constructorMethod) {
                        //constructor with no params
                        _constructorMethod =
                                new MethodDefinition(_name, false, this, { type: '', declaredBy: qualifiedName});

                    }
                }
            }

            return _constructorMethod;
        }
        
        
        private var _baseClasses:Array;
        /**
         * For a "class" kind TypeDefinition, this returns the TypeDefinitions
         * of the base classes (inheritance chain). This may differ between
         * javascript and flash platform targets for some classes.
         *  @royaleignorecoercion XML
         */
        public function get baseClasses():Array
        {

            var results:Array;
            if (_baseClasses) {
                results =_baseClasses.slice();
                if (!_cache) _baseClasses = null;
                return results;
            }
            if ((_kind || kind) != "class") return [];

            results = [];
            //handle special cases
            if (_specialCase) {
                if (_cache) {
                    _baseClasses = results;
                    results = results.slice();
                }
                return results;
            }
            
            COMPILE::SWF
            {
                var xml:XML = rawData as XML;
                var data:XMLList = xml.factory.extendsClass;
                var n:int = data.length();
                for (var i:int = 0; i < n; i++)
                {
                    var item:XML = data[i] as XML;
                    var qname:String = item.@type;
                    results.push(TypeDefinition.internalGetDefinition(qname));
                }
            }
            COMPILE::JS
            {
                var data:Object = rawData;
                var qname:String = data.names[0].qName;
                var def:Object = getDefinitionByName(qname);
                var superClass:Object = def.superClass_;
                if (!superClass) {
                    //todo: support for when superClass is not a royale 'class'
                } else while (superClass)
                {
                    if (superClass.ROYALE_CLASS_INFO !== undefined) {
                        qname = superClass.ROYALE_CLASS_INFO.names[0].qName;
                        results.push(TypeDefinition.internalGetDefinition(qname));
                        def = getDefinitionByName(qname);
                        superClass = def.superClass_;
                        //todo: support for when superClass is not a royale 'class'

                    } else {
                        //todo: support for when superClass is not a royale 'class'
                        superClass = null;
                    }
                }
            }
            
            if (_cache) {
                _baseClasses = results;
                results = results.slice();
            }
            return results;
        }

        private var _interfaces:Array;
        /**
         * returns the full set of interfaces that this class implements or that this
         * interface extends, depending on the 'kind' value ("interface" or "class")
         */
        public function get interfaces():Array
        {
            var results:Array;
            if (_interfaces) {
                results =_interfaces.slice();
                if (!_cache) _interfaces = null;
                return results;
            }
            results = [];
            //handle special cases
            if (_specialCase) {
                if (_cache) {
                    _interfaces = results;
                    results = results.slice();
                }
                return results;
            }
            
            COMPILE::SWF
            {
                var xml:XML = rawData as XML;
                var data:XMLList = xml.factory.implementsInterface;
                var n:int = data.length();
                for (var i:int = 0; i < n; i++)
                {
                    var item:XML = data[i] as XML;
                    var qname:String = item.@type;
                    results.push(TypeDefinition.internalGetDefinition(qname));
                }
            }
            COMPILE::JS
            {
                var data:* = rawData;
                var i:uint, n:int;
                if (data !== undefined)
                {
                    var collect:Array = data.interfaces ?  data.interfaces.slice() : [];
                    var qname:String = data.names[0].qName;
                    var def:Object = getDefinitionByName(qname);
                    if ((_kind || kind) == "interface") {
                        //collect.length can expand during the loop below
                        for (i = 0; i < collect.length; i++) {
                            collect.push.apply(collect, (collect[i].prototype.ROYALE_CLASS_INFO.interfaces || []));
                        }
                    } else {
                        var superClass:Object = def.superClass_;
                        while (superClass && superClass.ROYALE_CLASS_INFO !== undefined)
                        {
                            data = superClass.ROYALE_CLASS_INFO;
                            var latest:Array = data.interfaces;
                            if (latest) {
                                n = latest.length;
                                for (i=0;i<n;i++) if (collect.indexOf(latest[i])==-1) collect.push(latest[i]);
                            }
                            qname = data.names[0].qName;
                            def = getDefinitionByName(qname);
                            superClass = def.superClass_;
                        }
                    }
                    n = collect.length;
                    for (i=0;i<n;i++) {
                        var iface:Object = collect[i];
                        data = iface.prototype.ROYALE_CLASS_INFO;
                        results[i] = TypeDefinition.getDefinition(data.names[0].qName,data);
                    }
                }
            }

            if (_cache) {
                _interfaces = results;
                results = results.slice();
            }
            return results;
        }


        private var _staticVars:Array;

        /**
         * The static variables associated with a "class" kind TypeDefinition
         * An array of VariableDefinition instances
         */
        public function get staticVariables():Array
        {

            if ((_kind || kind) != "class") return [];
            var results:Array;
            if (_staticVars) {
                results =_staticVars.slice();
                if (!_cache) _staticVars = null;
                return results;
            }
            COMPILE::SWF {
                results = getCollection("variable","static");
            }
            COMPILE::JS
            {
                results = getCollection("variables","static",false);
            }
            if (_cache) {
                _staticVars = results;
                results = results.slice();
            }
            return results;
        }

        private var _staticAccessors:Array;
        /**
         * The static accessors associated with a "class" kind TypeDefinition
         * An array of AccessorDefinition instances
         */
        public function get staticAccessors():Array
        {

            if ((_kind || kind) != "class") return [];
            var results:Array;
            if (_staticAccessors) {
                results =_staticAccessors.slice();
                if (!_cache) _staticAccessors = null;
                return results;
            }
            COMPILE::SWF {
                results = getCollection("accessor","static");
            }
            COMPILE::JS
            {
                results = getCollection("accessors","static",false);
            }
            if (_cache) {
                _staticAccessors = results;
                results = results.slice();
            }
            return results;
        }


        private var _staticMethods:Array;
        /**
         * The static methods associated with a "class" kind TypeDefinition
         * An array of MethodDefinition instances
         */
        public function get staticMethods():Array
        {

            if ((_kind || kind) != "class") return [];
            var results:Array;
            if (_staticMethods) {
                results =_staticMethods.slice();
                if (!_cache) _staticMethods = null;
                return results;
            }
            COMPILE::SWF {
                results = getCollection("method","static");
            }
            COMPILE::JS
            {
                results = getCollection("methods","static",false);
            }
            if (_cache) {
                _staticMethods = results;
                results = results.slice();
            }
            return results;
        }




        private var _variables:Array;
        /**
         * The instance variables associated with a "class" kind TypeDefinition
         * An array of VariableDefinition instances
         */
        public function get variables():Array
        {

            var results:Array;
            if (_variables) {
                results =_variables.slice();
                if (!_cache) _variables = null;
                return results;
            }
            if ((_kind || kind) != "class") return [];
            //handle special cases
            if (_specialCase) {
                results = [];
                if (_cache) {
                    _variables = results = [];
                    results = results.slice();
                }
                return results;
            }
            
            COMPILE::SWF
            {
                results = getCollection("variable");
            }
            COMPILE::JS
            {
                results = getCollection("variables");
            }
            if (_cache) {
                _variables = results;
                results = results.slice();
            }
            return results;
        }
        
        private var _accessors:Array;
        /**
         * The instance accessors associated with a "class" kind TypeDefinition
         * An array of AccessorDefinition instances
         */
        public function get accessors():Array
        {
            var results:Array;
            if (_accessors) {
                results =_accessors.slice();
                if (!_cache) _accessors = null;
                return results;
            }


            //handle special cases
            if (_packageName=="" && SC.indexOf(name)!=-1) {
                results = [];
                if (_cache) {
                    _accessors = results;
                    results=results.slice();
                }
                return results;
            }
            
            COMPILE::SWF
            {
                results = getCollection("accessor");
            }
            COMPILE::JS
            {
                results = getCollection("accessors");
            }
            if (_cache) {
                _accessors = results;
                results = results.slice();
            }
            return results;
        }

        
        private var _methods:Array;
        /**
         * The instance methods associated with a "class" kind TypeDefinition
         * An array of MethodDefinition instances
         */
        public function get methods():Array
        {
            var results:Array;
            if (_methods) {
                results =_methods.slice();
                if (!_cache) _methods = null;
                return results;
            }


            //handle special cases
            if (_packageName=="" && SC.indexOf(name)!=-1) {
                results = [];
                if (_cache) {

                    _methods = results;
                    results=results.slice();
                }
                return results;
            }
            
            COMPILE::SWF
            {
                results = getCollection("method");
            }
            COMPILE::JS
            {
                results = getCollection("methods");
                //special case, remove constructor method:
                var i:uint=0, l:uint=results.length;
                for (;i<l;i++) {
                    if (results[i].name==this.name) {
                        //trace('found constructor '+results[i].toString());
                        _constructorMethod = results[i];
                        results.splice(i,1);
                        break;
                    }
                }
            }
            if (_cache) {
                _methods = results;
                results = results.slice();
            }
            return results;
        }



        COMPILE::SWF
        protected function getCollection(collection:String, type:String="instance"):Array{
            var lookups:Object = {
                variable : VariableDefinition,
                accessor : AccessorDefinition,
                method : MethodDefinition
            };
            var results:Array =[];
            var isStatic:Boolean = type=="static";
            var xml:XML = rawData as XML;
            var data:XMLList = isStatic? xml[collection] : xml.factory[collection];
            var n:int = data.length();
            var itemClass:Class = lookups[collection];
            for (var i:int = 0; i < n; i++)
            {
                var item:XML = data[i] as XML;
                var qname:String = item.@name;
                results[i]= new itemClass(qname,isStatic, this, item);
            }
            return results;
        }


        COMPILE::JS
        protected function getCollection(collection:String,  type:String="instance", resolve:Boolean = true):Array{
           var lookups:Object = {
               variables : VariableDefinition,
               accessors : AccessorDefinition,
               methods : MethodDefinition
           };
           if (!(collection in lookups)) throw new Error("ArgumentError: name must be a standard name [variables,accessors,methods]") ;
           var isStatic:Boolean =  type == "static";
           var results:Array = [];

           var data:Object = rawData;
           var qname:String = data.names[0].qName;
           var def:Object = getDefinitionByName(qname);
            
           const infoDataSource:Function =  def.prototype.ROYALE_REFLECTION_INFO || ExtraData.getData(qname)['ROYALE_REFLECTION_INFO'];
           var rdata:* =  infoDataSource();
           var itemClass:Class = lookups[collection];

           var l:int, i:int = 0;
           if (resolve) {
               if (isStatic) throw new Error("ArgumentError : resolve and static are not compatible");
               //get ancestor items, and record the names for overrides
               var oldNames:Array=[];
               var superClass:Object = def.superClass_;
               if (superClass) data = superClass.ROYALE_CLASS_INFO;
               else data = null;

               if (data) {
                   results = TypeDefinition.getDefinition(data.names[0].qName, data)[collection];
                   l=results.length;
                   for (i=0;i<l;i++) oldNames[i]=results[i].uri+"::"+results[i].name;
               } else results=[];
           }
           //get the local definitions
            if (rdata !== undefined)
            {
                var items:Object = rdata[collection] ? rdata[collection]() : null;
                if (items)
                {
                    for (var item:String in items)
                    {
                        var itemDef:Object = items[item];
                        if (isStatic) {
                            //we are looking for static members only
							if (item.charAt(0)=="|") results[i++] = new itemClass(item.substr(1), true, this, itemDef);
                        
                        } else {
                            //ignore statics here, because this is for instance members:
							if (item.charAt(0)=="|") continue;
                            
                            //instance member:
                            var itemClassDef:MemberDefinitionBase;
                            if (resolve) {
                                //resolve against older versions ("overrides")
                                var oldIdx:int = oldNames.indexOf(item);
                                if (oldIdx != -1) {
                                    //we have an override of an ancestor's definition, replace it
                                    //resolve access for accessors - combine readonly/writeOnly via ancestry to readwrite if applicable
                                    if (collection == 'accessors') {
                                        if (itemDef.access != 'readwrite') {
                                            var oldAccess:String = results[oldIdx].access;
                                            if (oldAccess == 'readwrite') itemDef.access = 'readwrite';
                                            else {
                                                if (itemDef.access != oldAccess) itemDef.access = 'readwrite';
                                            }
                                        }
                                    }
                                    results[oldIdx] = new itemClass(item, false, this, itemDef);
                                    continue;
                                }
                            }
                            itemClassDef = new itemClass(item, false, this, itemDef);
                            //add the new definition item to the collection
                            results[i++] = itemClassDef;
                        }
                    }
                }
            }
           return results;
        }

        /**
         * Used primarily for debugging purposes, this provides a string representation of this
         * TypeDefinition
         * @param includeDetail whether to output member definitions and other detailed information
         * @return a stringified representation of this TypeDefinition
         */
        public function toString(includeDetail:Boolean=false):String
        {
            var kind:String = this.kind;
            var s:String =  "Typedefinition: " + qualifiedName + ", kind:"+kind;
            if (includeDetail)
            {
                s += "\n";
                var meta:Array = metadata;
                var i:uint;
                var l:uint = meta.length;
                if (l) {
                    s += "\tmetadata:";
                    for (i=0;i<l;i++) {
                        s += "\n\t\t" + meta[i].toString().split("\n").join("\n\t\t");
                    }
                    s += "\n";
                }

                var collections:Array;
                if (kind == "class") {
                    var constructorDef:MethodDefinition = constructorMethod;
                    var construct:Array = constructorDef ? [constructorDef] :[];
                    collections = [ "constructor",      construct,
                                    "interfaces",       interfaces,
                                    "baseClasses",      baseClasses,
                                    "variables",        variables,
                                    "accessors",        accessors,
                                    "methods",          methods,
                                    "static variables", staticVariables,
                                    "static accessors", staticAccessors,
                                    "static methods",   staticMethods];
                } else {
                    if (kind == "interface") {
                        collections = [ "interfaces", interfaces,
                                        "accessors",accessors,
                                        "methods",methods];
                    }
                }
                if (collections) s += stringifyCollections(collections);
                else s += "\t{no detail available}"
            }
            return s;
        }

        /**
         * utility method to create friendly output of collections,
         * primarily for debugging purposes - used via toString(includeDetail=true)
         * @param collections array of alternating collection names and collections
         * @return stringified representation of the collections
         */
        protected function stringifyCollections(collections:Array):String
        {
            var s:String="";
            while (collections.length) {
                var collectionType:String = collections.shift();
                var collection:Array =collections.shift();
                s += collectionType+" :";
                if (!collection || !collection.length) {
                    s+= "\n\t{none}\n"
                } else {
                    s+="\n";
                    var outData:String = "\t";
                    var l:uint = collection.length;
                    while (l) {
                        l--;
                        outData += collection.shift().toString();
                        if (l) outData += "\n";
                    }
                    outData = outData.replace(/\n/g,"\n\t") + "\n";
                    s += outData;
                }
            }
            return s;
        }
    }
}
