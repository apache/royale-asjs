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
package org.apache.royale.utils
{

    
    [ExcludeClass]
    COMPILE::SWF
    public class Language
    {
    }
    
    COMPILE::JS
    {
        import goog.bind;
        import goog.global;
        import goog.DEBUG;
    }
    
    /**
     * @royaleignoreimport goog.bind
     * @royaleignoreimport goog.global
     * @royalesuppressexport
     */
    COMPILE::JS
    public class Language
    {
        
        
        //--------------------------------------
        //   Static Property
        //--------------------------------------
        
        
        /**
         * Helper var for sortOn
         */
        static private var sortNames:Array;
        static private var sortNamesOne:Array = [];
        static private var muler:Number;
        static private var zeroStr:String = String.fromCharCode(0);
        
        //--------------------------------------
        //   Static Function
        //--------------------------------------
        
        /**
         * as()
         *
         * @param leftOperand The lefthand operand of the
         * binary as operator in AS3.
         * @param rightOperand The righthand operand of the
         * binary operator in AS3.
         * @param coercion The cast is a coercion,
         * throw exception if it fails.
         * @return Returns the lefthand operand if it is of the
         * type of the righthand operand, otherwise null.
         */
        static public function as(leftOperand: Object, rightOperand: Object, coercion:* ):Object
        {
            const itIs:Boolean = Language.is(leftOperand, rightOperand);
            
            if (!itIs && !!coercion){
                if (rightOperand.constructor === _synthType) {
                    return rightOperand['coerce'](leftOperand)
                }
                else if ([Boolean,Number,String].indexOf(rightOperand) != -1) {
                    return rightOperand(leftOperand);
                }
                else if (Object === rightOperand) {
                    return rightOperand(leftOperand).valueOf();
                }
                if (leftOperand == null) {
                    return null;
                }
                const leftType:String = '' + (leftOperand.ROYALE_CLASS_INFO ? leftOperand.ROYALE_CLASS_INFO.names[0].qName : String(leftOperand));
                const rightType:String = '' + (rightOperand.prototype && rightOperand.prototype.ROYALE_CLASS_INFO ? rightOperand.prototype.ROYALE_CLASS_INFO.names[0].qName: String(rightOperand));
                throw new TypeError('Error #1034: Type Coercion failed: cannot convert ' + leftType + ' to ' + rightType);
            }
            
            return itIs ? leftOperand : null;
        }
        
        /**
         * int()
         *
         * @param value The value to be cast.
         * @return {number}
         */
        static public function _int(value:Number):Number
        {
            return value >> 0;
        }
        
        /**
         * string()
         * @param value The value to be cast.
         * @return {string}
         */
        static public function string(value:*):String
        {
            if (value == null)
            {
                return null;
            }
            //toString() leads the compiler to emit type coercion,
            //and concatenation is generally faster than String()
            return "" + value;
        }
        
        /**
         * is()
         *
         * @param leftOperand The lefthand operand of the
         * binary as operator in AS3.
         * @param rightOperand The righthand operand of the
         * binary operator in AS3.
         * @return {boolean}
         */
        static public function is(leftOperand:Object, rightOperand: Object):Boolean
        {
            var superClass:Object;
            
            if (leftOperand == null || rightOperand == null)
                return false;
    
            //Distinguish between Array and synthetic Vectors ('implemented' as Array-ish)
            if (rightOperand === Array) {
                return (Array.isArray(leftOperand) && !(SYNTH_TAG_FIELD in leftOperand));
            }
            
            if (leftOperand instanceof rightOperand)
                return true;
            
            if (rightOperand === Object)
                return true; // every value is an Object in ActionScript except null and undefined (caught above)
            // A little faster to only call typeof once
            var theType:String = typeof leftOperand;
            //The following do not work for 'constructed' (e.g. new String('test')) Strings, Number or Booleans,
            //but those cases are caught using the instanceof check elsewhere
            if (theType === 'string')
                return rightOperand === String;
            
            if (theType === 'number')
            {
                if (rightOperand === Number) return true;
                //it is possible that rightOperand could be int or uint synthTypes... allow to proceed
                //to the _synthType check
            }
            
            if (theType === 'boolean')
                return rightOperand === Boolean;
    
            if (rightOperand.constructor === _synthType)
                return rightOperand['checkIs'](leftOperand);
            
            if (leftOperand.ROYALE_CLASS_INFO === undefined)
                return false; // could be a function but not an instance
            
            if (leftOperand.ROYALE_CLASS_INFO.interfaces)
            {
                if (checkInterfaces(leftOperand, rightOperand))
                {
                    return true;
                }
            }
            
            superClass = leftOperand.constructor.superClass_;
            
            if (superClass)
            {
                while (superClass && superClass.ROYALE_CLASS_INFO)
                {
                    if (superClass.ROYALE_CLASS_INFO.interfaces)
                    {
                        if (checkInterfaces(superClass, rightOperand))
                        {
                            return true;
                        }
                    }
                    superClass = superClass.constructor.superClass_;
                }
            }
            
            return false;
        }
        
        /**
         * Helper function for is()
         */
        private static function checkInterfaces(leftOperand:*, rightOperand:*):Boolean
        {
            var i:int, interfaces:Array;
            
            interfaces = leftOperand.ROYALE_CLASS_INFO.interfaces;
            for (i = interfaces.length - 1; i > -1; i--)
            {
                if (interfaces[i] === rightOperand)
                {
                    return true;
                }
                
                if (interfaces[i].prototype.ROYALE_CLASS_INFO.interfaces)
                {
                    var isit:Boolean = checkInterfaces(interfaces[i].prototype, rightOperand);
                    if (isit) return true;
                }
            }
            
            return false;
        }
        
        
        /**
         * @royaledebug
         */
        static public function trace(...rest):void
        {
            var theConsole:*;
            
            theConsole = goog.global.console;
            
            if (theConsole === undefined)
            {
                if (typeof window !== "undefined")
                {
                    theConsole = window.console;
                } else if (typeof console !== "undefined")
                {
                    theConsole = console;
                }
            }
            
            try
            {
                if (theConsole && theConsole.log)
                {
                    theConsole.log.apply(theConsole, rest);
                }
            } catch (e:Error)
            {
                // ignore; at least we tried ;-)
            }
        }
        
        /**
         * uint()
         *
         * @param value The value to be cast.
         * @return {number}
         */
        static public function uint(value:Number):Number
        {
            return value >>> 0;
        }
        
        /**
         * caches closures and returns the one closure
         *
         * @param fn The method on the instance.
         * @param object The instance.
         * @param boundMethodName The name to use to cache the closure.
         * @return The closure.
         *
         * @royaleignorecoercion Function
         */
        static public function closure(fn:Function, object:Object, boundMethodName:String):Function
        {
            if (object.hasOwnProperty(boundMethodName))
            {
                return object[boundMethodName] as Function;
            }
            var boundMethod:Function = goog.bind(fn, object);
            Object.defineProperty(object, boundMethodName, {
                value: boundMethod
            });
            return boundMethod;
        }
        
        /**
         * @param arr
         * @param names
         * @param opt
         *
         * @royaleignorecoercion Function
         */
        public static function sort(arr:Array, ...args):void
        {
            var compareFunction:Function = null;
            var opt:int = 0;
            if (args.length == 1)
            {
                if (typeof args[0] === "function")
                    compareFunction = args[0] as Function;
                else
                    opt = args[0];
            } else if (args.length == 2)
            {
                compareFunction = args[0] as Function;
                opt = args[1];
            }
            
            muler = (Array.DESCENDING & opt) > 0 ? -1 : 1;
            if (compareFunction)
                arr.sort(compareFunction);
            else if (opt & Array.NUMERIC)
            {
                arr.sort(compareAsNumber);
            } else if (opt & Array.CASEINSENSITIVE)
            {
                arr.sort(compareAsStringCaseinsensitive);
            } else
            {
                arr.sort(compareAsString);
            }
        }
        
        private static function compareAsStringCaseinsensitive(a:Object, b:Object):int
        {
            var v:int = (a || zeroStr).toString().toLowerCase().localeCompare((b || zeroStr).toString().toLowerCase());
            if (v != 0)
            {
                return v * muler;
            }
            return 0;
        }
        
        private static function compareAsString(a:Object, b:Object):int
        {
            var v:int = (a || zeroStr).toString().localeCompare((b || zeroStr).toString());
            if (v != 0)
            {
                return v * muler;
            }
            return 0;
        }
        
        private static function compareAsNumber(a:Object, b:Object):int
        {
            a = Number(a)
            b = Number(b)
            if (a > b)
            {
                return muler;
            } else if (a < b)
            {
                return -muler;
            }
            return 0;
        }
        
        /**
         * @param arr
         * @param names
         * @param opt
         * @royaleignorecoercion Array
         */
        public static function sortOn(arr:Array, names:Object, opt:Object = 0):Array
        {
            if (names is Array)
            {
                sortNames = names as Array;
            } else
            {
                sortNamesOne[0] = names;
                sortNames = sortNamesOne;
            }
            if (opt is Array)
            {
                var opt2:int = 0;
                for each(var o:int in opt)
                {
                    opt2 = opt2 | o;
                }
            } else
            {
                opt2 = /*opt as int*/ (int(opt) == opt) ? int(opt) : 0;
            }
            muler = (Array.DESCENDING & opt2) > 0 ? -1 : 1;
            var orig:Array;               
            if (opt2 & Array.RETURNINDEXEDARRAY)
            {
                orig = arr.slice();                
            }
            if (opt2 & Array.NUMERIC)
            {
                arr.sort(compareNumber);
            } else if (opt2 & Array.CASEINSENSITIVE)
            {
                arr.sort(compareStringCaseinsensitive);
            } else
            {
                arr.sort(compareString);
            }
            if (opt2 & Array.RETURNINDEXEDARRAY)
            {
                var retArr:Array = [];
                var n:int = arr.length;
                for (var i:int = 0; i < n; i++)
                {
                    var item:Object = orig[i];
                    retArr.push(arr.indexOf(item));
                }
                return retArr;
            }
            return arr;
        }
        
        private static function compareStringCaseinsensitive(a:Object, b:Object):int
        {
            for each(var n:String in sortNames)
            {
                var v:int = (a[n] || zeroStr).toString().toLowerCase().localeCompare((b[n] || zeroStr).toString().toLowerCase());
                if (v != 0)
                {
                    return v * muler;
                }
            }
            return 0;
        }
        
        private static function compareString(a:Object, b:Object):int
        {
            for each(var n:String in sortNames)
            {
                var v:int = (a[n] || zeroStr).toString().localeCompare((b[n] || zeroStr).toString());
                if (v != 0)
                {
                    return v * muler;
                }
            }
            return 0;
        }
        
        private static function compareNumber(a:Object, b:Object):int
        {
            for each(var n:String in sortNames)
            {
                if (a[n] > b[n])
                {
                    return muler;
                } else if (a[n] < b[n])
                {
                    return -muler;
                }
            }
            return 0;
        }
    
    
        /**
         * no export (allow dead code elimination if never used):
         */
        public static function resolveUncertain(val:*):*
        {
            if (val) {
                var c:Class = val.constructor;
                if (c == String || c == Number || c == Boolean || c.constructor == _synthType) val = val.valueOf();
            }
            return val;
        }
        
        private static var _synthType:Class;
    
        public static const SYNTH_TAG_FIELD:String = goog.DEBUG ? '_synthType' : '_s';
    
        public static const CHECK_INDEX:String = goog.DEBUG ? 'chkIdx' : '_ci';
    
    
        public static function isSynthType(def:Object):Boolean{
            return (_synthType && def && def.constructor == _synthType);
        }
    
        /**
         * Intended primarily for compiler-generated use only
         * Low level class factory for synthetic types (native AS3 top-level classes that are final and do not have corresponding classes in javascript).
         * Supports very light integration for emulation of related language level features, for construction, type-checking and coercion
         * by default: supports int, uint and Class
         * This Language method is only included in release build if it is used anywhere
         * Supports a 'plugin' style addition of extra types beyond the basic defaults
         *
         * @royalesuppressresolveuncertain true, _synthType
         * @royalesuppresscompleximplicitcoercion true
         *
         */
        public static function synthType(typeName:String, newDefinition:*):Class
        {
            //todo consider checking/using a fixed name reference to _synthType on goog.global as well - consider this for optimization in modules usage scenario
            if (!_synthType)
            {
                var rtFunc:* = Function;
                _synthType = rtFunc('return ' + 'function(b,c,d,e,n){var f=function(){var t=this;var a=Array.prototype.slice.call(arguments);a.push(t);t.type=f.type;t.value=f.construct.apply(t,a);return f.noWrap?t.value:t};f.type=b;f.toString=function(){return b};f.construct=c;f.checkIs=d;f.coerce=e;f.noWrap=!!n;var p=f.prototype;p.valueOf=function(){return this.value};p.constructor=f;f.constructor=arguments.callee;return f}')();
              //_synthType = rtFunc('return ' + 'function(type,construct,check,coerce,noWrap){var f=function(){var t=this;var args=Array.prototype.slice.call(arguments);args.push(t);t.type=f.type;t.value=f.construct.apply(t,args);return f.noWrap?t.value:t};f.type=type;f.construct=construct;f.checkIs=check;f.coerce=coerce;f.noWrap=!!noWrap;f.prototype.valueOf=function(){return this.value};f.prototype.constructor=f;f.constructor=arguments.callee;return f}')();
                Object.defineProperties(_synthType,
                    {
                        '_types': {
                            value: {}
                        }
                    }
                );
            }
            var typeStore:Object = _synthType['_types'];
            if (newDefinition)
            {
                typeStore[typeName] = new _synthType(typeName, newDefinition['construct'], newDefinition['checkIs'], newDefinition['coerce'], newDefinition['noWrap']);
            }
            
            var snythTypeInst:Class = typeStore[typeName];
            if (!snythTypeInst)
            {
                switch (typeName)
                {
                    case 'int':
                        snythTypeInst = typeStore['int'] = new _synthType('int', Language._int, function (v:Number):Boolean
                        {
                            return v >> 0 === v.valueOf()
                        }, Language._int); //unfortunately, noWrap is not a viable option here, because it is a primitive type
                        break;
                    case 'uint':
                        snythTypeInst = typeStore['uint'] = new _synthType('uint', Language.uint, function (v:Number):Boolean
                        {
                            return v >>> 0 === v.valueOf()
                        }, Language.uint); //unfortunately, noWrap is not a viable option here, because it is a primitive type
                        break;
                    case 'Class':
                        const excludeName:RegExp = /^name$|^name,|,name$|,name(?=,)/;
                        const isFunc:String  = Object.getOwnPropertyNames(function():void {}).join().replace(excludeName,'');
                        const classCheck:Function =  function (v:*):Boolean
                        {
                            return typeof v == 'function'
                                    && v.prototype
                                    && v.prototype['constructor'] == v
                                    && (v.prototype.ROYALE_CLASS_INFO || v.constructor == _synthType || v == Boolean || Object.getOwnPropertyNames(v).join().replace(excludeName,'') != isFunc )
                        };
                        snythTypeInst = typeStore['Class'] = new _synthType('Class',
                                function():void{throw new TypeError('Error #1115: Class is not a constructor.')},
                                classCheck,
                                function(v:*):*{if (v != null && !classCheck(v)) throw new TypeError('Error #1034: Type Coercion failed: cannot convert "'+ string(v) +'" to Class.') ; return v ? v : null });
                        break;
                    default:
                        throw new TypeError('unknown synthetic type:' + typeName);
                        break;
                }
            }
            return snythTypeInst;
        }
    
        /**
         * Intended primarily for compiler-generated use only
         * Adds Vector support via synthType
         * Acts like a class Factory for Vector subclasses as synthTypes, which provides correct type-checking behaviour
         * Uses cached lookups and 'plugin' style addition of synthTypes for each distinct requested Vector subclass type
         *
         * @royaleignorecoercion Array
         * @royalesuppresscompleximplicitcoercion true
         *
         */
        public static function synthVector(elementType:String):Class
        {
            var typeName:String = 'Vector';
            if (elementType !== null) typeName += '.<' + elementType + '>';
            const synth:Function = synthType;
            if (!_synthType || !_synthType['_types'][typeName])
            {
                
                //create a new synthType representing the parameterized type
                //provides a concrete example of the plugin/external definition approach for synthType:
                var type:Class = synth(typeName, {
                    'construct': function (size:int, fixed:Boolean, instance:Object):Array
                    {
                        const a:Array = arguments;
                        var l:Number = a.length;
                        instance = a[--l];
                        fixed = l == 2 ? a[--l] : false;
                        size = l == 1 ? a[0] : 0;
                        instance['type'] = typeName;
                        instance[VectorSupport.FIXED_LEN] = fixed ? size : -1;
                        return VectorSupport.arrayVector([], size, elementType, fixed, instance);
                    },
                    'checkIs': function (v:Array):Boolean
                    {
                        return VectorSupport.checkIsVector(v, typeName);
                    },
                    'coerce': function (source:*):Array
                    {
                        if (source && Array.isArray(source))
                        {
                            var arr:Array = source as Array;
                            return VectorSupport.checkIsVector(arr, typeName)
                                    ? arr
                                    : VectorSupport.arrayVector(arr.slice(), arr.length, elementType, false, null, false);
                        }
                        throw new TypeError('Error #1034: Type Coercion failed: cannot convert ' + source + ' to ' + typeName);
                    },
                    'noWrap': true
                });
                VectorSupport.langSynthType = _synthType;
                VectorSupport.vectorElementCoercion(elementType, type, false);
                VectorSupport.vectorElementDefault(elementType, type);
                type.prototype = Object.create(type.prototype);
                const baseVectorOverrides:Object = VectorSupport.getBaseOverrides();
                const localOverrides:Object ={
                    'length': {
                        'get': baseVectorOverrides.get_len,
                        'set':baseVectorOverrides.set_len
                    },
                    'toString': { value:baseVectorOverrides.toString },
                    'map': { value:baseVectorOverrides.map },
                    'splice': { value:baseVectorOverrides.splice },
                    'slice': { value:baseVectorOverrides.slice },
                    'concat': { value:baseVectorOverrides.concat },
                    'filter': { value:baseVectorOverrides.filter },
                    'insertAt': { value:baseVectorOverrides.uncheckedInsertAt },
                    'removeAt': { value:baseVectorOverrides.uncheckedRemoveAt },
                    'constructor': { value:type }
                };
                localOverrides[Language.CHECK_INDEX] = {value:baseVectorOverrides[Language.CHECK_INDEX]};
                localOverrides[VectorSupport.ELEMENT_TYPE] = { value: elementType };
                localOverrides['type'] = { value: typeName };
                localOverrides[VectorSupport.COERCE_ELEMENT] = { value: type[VectorSupport.COERCE_ELEMENT], configurable: true};
                localOverrides[VectorSupport.DEFAULT_VALUE] = {  value: type[VectorSupport.DEFAULT_VALUE] };
                Object.defineProperties(type.prototype, localOverrides)

            }
            return _synthType['_types'][typeName];
        }
        
        
        /**
         * A light wrapper around a Vector constructor call that has an untyped return type
         * (because the resulting type is unknown at compile time)
         * This could be used to create and return a default Vector instance
         *
         * @royaleignorecoercion Array
         * no export (allow dead code elimination if never used):
         */
        public static function Vector(size:int = 0, baseType:String = null, fixed:Boolean = false):*
        {
            var vectorClass:Class = synthVector(baseType);
            return new vectorClass(size, fixed) as Array;
        }
    
        /**
         * Support for legacy vectorEmulationClass=Array approach.
         *
         * no export (allow dead code elimination if never used):
         */
        public static function arrayAsVector(size:int = 0, baseType:String = null):Array
        {
            var arr:Array = [];
            var defValue:Object = null;
            if (baseType == "int" || baseType == "uint" || baseType == "Number") {
                defValue = 0;
            }
            else if (baseType == "String"){
                defValue = "";
            } else if (baseType == "Boolean"){
                defValue = false;
            }
            for (var i:int = 0; i < size; i++)
                    arr.push(defValue);
            return arr;
        }
        
    }
    
}

import org.apache.royale.utils.Language;
import goog.DEBUG;
import goog.global;

COMPILE::JS
/**
 * @royalesuppressexport
 */
class VectorSupport {

    //Warning : code in this class is very dependent on non-generation of closures and possibly other 'quirks'
    //If you make any changes, please verify this against Vector unit tests, across different targets
    
    public static const fixedRangeError:String = 'Error #1126: Cannot change the length of a fixed Vector';

    public static const nonConstructorError:String = 'Error #1007: Instantiation attempted on a non-constructor.';

    public static var langSynthType:Object;
    

    public static const COERCE_ELEMENT:String = goog.DEBUG ? 'coerceElement' : 'cE';

    public static const DEFAULT_VALUE:String = goog.DEBUG ? 'defaultValue' : 'dV';

    public static const ELEMENT_TYPE:String = goog.DEBUG ? 'elementType' : 'eT';

    public static const FIXED_LEN:String = goog.DEBUG ? 'fixedLen' : 'fL';
    
    private static function indexRangerError(index:Number, limit:uint):String{
        return 'Error #1125: The index ' + index + ' is out of range ' + limit;
    }
    
    /**
     * internal use only: v should be an Array.
     */
    public static function checkIsVector(v:Object, typeName:String):Boolean
    {
        const base:Boolean = v && Language.SYNTH_TAG_FIELD in v;
        var ret:Boolean = base &&  v[Language.SYNTH_TAG_FIELD] instanceof langSynthType['_types'][typeName];
        if (!ret && base && typeName == "Vector.<*>") {
            // int, uint and Number Vectors do not also resolve to '*' typed Vectors, but all others do
            const elementType:String = v[Language.SYNTH_TAG_FIELD][ELEMENT_TYPE];
            ret = elementType != 'int' && elementType != 'uint' && elementType != 'Number';
        }
        return ret;
    }
   
    public static function vectorElementDefault(elementType:String, synthVectorClass:Object ):Object {
        if (synthVectorClass[VectorSupport.DEFAULT_VALUE] !== undefined) return synthVectorClass[VectorSupport.DEFAULT_VALUE];
        const standardDefaults:Object = {
            'int': 0,
            'uint': 0,
            'Number': 0,
            'String': '',
            'Boolean': false
        };
        var defaultVal:Object = null;
        if (elementType in standardDefaults) {
            defaultVal = standardDefaults[elementType];
        }
        synthVectorClass[VectorSupport.DEFAULT_VALUE] = defaultVal;
        return defaultVal;
    }
    
    /**
     *
     * @royaleignorecoercion Function
     * @royalesuppresscompleximplicitcoercion true
     */
    public static function vectorElementCoercion(elementType:String, synthVectorClass:Object, deferred:Boolean):Function{
        if (synthVectorClass[VectorSupport.COERCE_ELEMENT]) return synthVectorClass[VectorSupport.COERCE_ELEMENT] as Function;
        const identity:Function = function(v:*):Object{return v === undefined ? null : v};
        const standardCoercions:Object = {
            'int': Language._int,
            'uint': Language.uint,
            'Number': Number,
            'String': Language.string,
            'Boolean': Boolean,
            "*": identity,
            "Object": identity
        };
        var coercion:Function
        if (elementType == 'Class') {
            coercion = Language.synthType('Class', null)['coerce'];
        }
        else coercion= standardCoercions[elementType] as Function;
        if (coercion == null) {
            if (elementType.indexOf('Vector.<') == 0) {
                coercion = function(v:Object):Object{ if (!(v === null || Language.synthVector(elementType.slice(8,-1))['checkIs'](v))) {throw new TypeError('Error #1034: Type Coercion failed: cannot convert ' + v + ' to '+ elementType)} else return v  };
            } else {
                var defer:Boolean = false;
                var parts:Array = elementType.split('.');
                var n:int = parts.length;
                var o:Class = goog.global;
                for (var i:int = 0; i < n; i++) {
                    o = o && o[parts[i]];
                    if (!o) {
                        if (deferred) throw new TypeError('missing dependency ' + elementType );
                        defer = true;
                        break;
                    }
                }
                if (defer) {
                    coercion = null;
                }
                else coercion = function(v:Object):Object{ return Language.as(v,o,true)};
            }
        }
        synthVectorClass[VectorSupport.COERCE_ELEMENT] = coercion;
        if (deferred) {
            //patch the prototype
            Object.defineProperty(synthVectorClass.prototype, VectorSupport.COERCE_ELEMENT, {value: coercion})
        }
        return coercion;
    }
    
    /**
     * internal use only. arr should be an Array
     * @royaleignorecoercion Array
     * @royaleignorecoercion Function
     */
    private static function coerceElements(arr:Object, size:uint, tag:Object):Error{
        var coercion:Function = tag[COERCE_ELEMENT] as Function;
        if (coercion == null) {
            coercion = VectorSupport.vectorElementCoercion(tag[ELEMENT_TYPE], tag.constructor, true);
        }
        var err:Error;
        for (var i:int = 0; i < size; i++)
        {
            var original:* = (arr as Array)[i];
            //observed: undefined gets coerced to null even on * typed Vectors...
            if (original === undefined) original = null;
            try{
                arr[i] = coercion(original);
            } catch(e:Error) {
                //avm does this anyway:
                const defValue:Object = tag[DEFAULT_VALUE];
                array_fill(arr as Array, defValue,i);
                err = e;
                break;
            }
        }
        return err;
    }
    
    /**
     * @royaleignorecoercion Function
     */
    public static function arrayVector(arr:Array, size:int, basetype:String,fixed:Boolean , tag:Object, construct:Boolean = true):Array
    {
        size = size >>>0;
        if (basetype == null)
        {
            throw new TypeError(nonConstructorError);
        }
        
        tagVectorArray(arr, basetype, fixed, tag);
        if (!tag) tag = arr[Language.SYNTH_TAG_FIELD];
        if (size)
        {
            if (construct)
            {
                arr.length = size;
                const defValue:Object = tag[DEFAULT_VALUE];
                array_fill(arr, defValue,0);
            } else
            { //coerce
                const err:Error = coerceElements(arr, size, tag);
                if (err) throw new (err.constructor)(err.message);
            }
        }
        return arr;
    }
    /**
     * @royalesuppressclosure
     * @royalesuppresscompleximplicitcoercion true
     */    
    public static function tagVectorArray(array:Array, elementType:String, fixed:Boolean, inst:Object):Array
    {
        const vectorType:String ='Vector.<' + elementType + '>';
        const synthVectorClass:Class = inst ? inst.constructor : langSynthType['_types'][vectorType];
        if (!inst) inst = new synthVectorClass()[Language.SYNTH_TAG_FIELD];
        inst.value = array;
        //IE11 does not support Object.assign
        const blend:Function = Object.assign || function(target:Object, source:Object):Object{ for (var field:String in source) {target[field] = source[field]} return target};
        //enumerable is false by default
        const props:Object = {
            'fixed': {
                'get' : function():Boolean{return inst[FIXED_LEN] > -1},
                'set' : function(v:Boolean):void{
                    if (inst[FIXED_LEN] > -1 != v) {
                        inst[FIXED_LEN]= (v ? array.length : -1);
                        Object.defineProperties(array,getMutationTypeSafetyOverrides(v));
                    }
                }
            },
            'splice': {
                value: inst.splice
            },
            'slice': {
                value: inst.slice
            },
            'concat': {
                value: inst.concat
            },
            'map': {
                value: inst.map
            },
            'filter': {
                value: inst.filter
            },
            'toString':{
                value: inst.toString
            },
            'constructor': {
                value: inst.constructor
            }
        };
        props[Language.CHECK_INDEX] = {
            value: inst[Language.CHECK_INDEX]
        };
        props[Language.SYNTH_TAG_FIELD] = {
            value: inst
        };
        blend(props, getMutationTypeSafetyOverrides(fixed));
        Object.defineProperties (array, props);
        return array;
    }
    
    
    /**
     * Fills the array from a start point (defaults to zero) to its end with the specified value
     */
    private static function array_fill(arr:Array, value:Object, start:uint):Array{
        if (arr['fill']) {
            return arr['fill'](value, start);
        } else {
            //IE11 support
            var i:uint = start>>>0;
            const l:uint = arr.length;
            while (i<l) {
                arr[i] = value;
                i++;
            }
        }
        return arr;
    }
    
    //The instance methods of this class are primarily a source for runtime patching of 'Vector-like' Arrays
    //The class uses @royalesuppressclosure to avoid the royale compiler generating closures and therefore references to 'this'
    //in the local methods can become references to the Array instance itself in its patched methods
    //with the exception of the get_len and set_len methods where 'this' refers to the instance of the 'synthType' tag
    //attached to the  Array that is considered 'Vector-like'
    
    private static var _instance:VectorSupport;
    private static var _baseObject:Object;
    /**
     
     * prevent closure generation for the method references:
     * @royalesuppressclosure
     */
    public static function getBaseOverrides():Object{
        if (_baseObject) return _baseObject;
        _instance = new VectorSupport();
        _baseObject = {};
        var inst:VectorSupport = _instance;
        _baseObject.toString = inst.toString;
        _baseObject.map = inst.map;
        _baseObject.splice = inst.splice;
        _baseObject.slice = inst.slice;
        _baseObject.concat = inst.concat;
        _baseObject.filter = inst.filter;
        _baseObject.uncheckedInsertAt = inst.uncheckedInsertAt;
        _baseObject.uncheckedRemoveAt = inst.uncheckedRemoveAt;
        _baseObject.get_len = inst.get_len;
        _baseObject.set_len = inst.set_len;
        _baseObject[Language.CHECK_INDEX] = inst.chkIdx;
        return _baseObject;
    }
    
    private static var _nonFixedTypeSafetyOverrides:Object;
    private static var _fixedTypeSafetyOverrides:Object;
    /**
     * @royalesuppressclosure
     */
    public static function getMutationTypeSafetyOverrides(fixed:Boolean):Object{
        if (_nonFixedTypeSafetyOverrides) return fixed ? _fixedTypeSafetyOverrides : _nonFixedTypeSafetyOverrides;
        var inst:VectorSupport = _instance;
        _nonFixedTypeSafetyOverrides = {
            'pop': {
                value:Array.prototype.pop,
                configurable: true
            },
            'push': {
                value:inst.push,
                configurable: true
            },
            'shift': {
                value:Array.prototype.shift,
                configurable: true
            },
            'unshift': {
                value:inst.unshift,
                configurable: true
            },
            'insertAt': {
                value:inst.insertAt,
                configurable: true
            },
            'removeAt': {
                value:inst.removeAt,
                configurable: true
            }
        };
        const error:Object = {
            value:inst.throwRangeError,
            configurable: true
        };
        _fixedTypeSafetyOverrides ={
            'pop': error,
            'push': error,
            'shift': error,
            'unshift': error,
            'insertAt': error,
            'removeAt': error
        };
        return fixed ? _fixedTypeSafetyOverrides : _nonFixedTypeSafetyOverrides;
    }
   
    public function  toString():String{
        return Array.prototype.map.call(this, String).toString();
    }
    /**
     * @royaleignorecoercion Array
     */
    public function map(callback:Function):* {
        var inst:Object= this[Language.SYNTH_TAG_FIELD]; return tagVectorArray(Array.prototype.map.call(this, function(item:Object, index:int, source:*):Object{return inst[COERCE_ELEMENT](callback(item,index,source))}) as Array, inst[ELEMENT_TYPE],false,null);
    }
    /**
     * @royaleignorecoercion Array
     */
    public function splice():* {
        var a:Array = Array.prototype.slice.call(arguments) as Array;var inst:Object= this[Language.SYNTH_TAG_FIELD]; var ret:Array = Array.prototype.splice.apply(this, a) as Array; if (inst[FIXED_LEN] > -1) inst[FIXED_LEN] = this['length']; return tagVectorArray(ret, inst[ELEMENT_TYPE], false, null);
    }
    
    /**
     * @royaleignorecoercion Array
     */
    public function slice():* {
        var a:Array = Array.prototype.slice.call(arguments) as Array;var inst:Object= this[Language.SYNTH_TAG_FIELD]; var ret:Array = Array.prototype.slice.apply(this, a) as Array; return tagVectorArray(ret, inst[ELEMENT_TYPE], false, null);
    }
    
    /**
     * @royaleignorecoercion Array
     */
    public function filter():* {
        var a:Array = Array.prototype.slice.call(arguments) as Array;var inst:Object= this[Language.SYNTH_TAG_FIELD]; var ret:Array = Array.prototype.filter.apply(this, a) as Array; return tagVectorArray(ret, inst[ELEMENT_TYPE], false, null);
    }
    
    /**
     * @royaleignorecoercion Array
     * @royaleignorecoercion String
     */
    public function concat():* {
        var a:Array = Array.prototype.slice.call(arguments) as Array;var inst:Object = this[Language.SYNTH_TAG_FIELD];
        var l:uint = a.length;
        for (var i:int = 0; i<l; i++) {
            var contender:Array = a[i] as Array;
            if (!checkIsVector(contender, inst['type'] as String)) {
                throw new TypeError('Error #1034: Type Coercion failed: cannot convert ' + contender[Language.SYNTH_TAG_FIELD]['type'] + ' to ' + inst['type']);
            }
        }
        var ret:Array = Array.prototype.concat.apply(this, a) as Array;
        return tagVectorArray(ret,inst[ELEMENT_TYPE], false, null);
    }

    public function uncheckedInsertAt(index:Number,item:*):* {
        return Array.prototype.splice.call(this, index, 0, item);
    }

    public function uncheckedRemoveAt(index:Number):* {
        return Array.prototype.splice.call(this, index, 1)[0];
    }

    public function get_len():Number{
        //'this' inside here is the synthType instance. It has a value property that refers to the
        //Array instance that it 'tags'
        return this['value'].length
    }
    /**
     * @royaleignorecoercion Array
     */
    public function set_len(value:Number):void{
        //'this' here is the synthType instance. It has a value property that refers to the
        //Array instance that it 'tags'
        if (this[FIXED_LEN] != -1) {
            throw new RangeError(fixedRangeError)
        } else {
            var oldLen:Number = this['value'].length;
            this['value'].length = value;
            if (oldLen < value) {
                array_fill(this['value'] as Array, this[DEFAULT_VALUE], oldLen);
            }
        }
    }
    
    //fixed-length vector-like array overrides
    /**
     * @royaleignorecoercion Array
     */
    public function push(v:*):* {
        var a:Array = Array.prototype.slice.call(arguments) as Array;
        const err:Error = coerceElements(a, a.length, this[Language.SYNTH_TAG_FIELD]);
        var len:uint = Array.prototype.push.apply(this,a);
        if (err) throw new (err.constructor)(err.message);
        return len;
    }
    /**
     * @royaleignorecoercion Array
     */
    public function unshift(v:*):* {
        var a:Array = Array.prototype.slice.call(arguments) as Array;
        const err:Error = coerceElements(a, a.length, this[Language.SYNTH_TAG_FIELD]);
        var len:uint = Array.prototype.unshift.apply(this,a);
        if (err) throw new (err.constructor)(err.message);
        return len;
    }

    public function insertAt(index:int, item:*):void {
        this[Language.SYNTH_TAG_FIELD]['insertAt'].call(this,index,item);
    }

    public function removeAt(index:int):Object {
        const idx:int = index < 0 ? Math.max(this['length'] + index, 0) : index;
        if (idx >= this['length']) throw new RangeError(indexRangerError(index, this['length']));
        return this[Language.SYNTH_TAG_FIELD]['removeAt'].call(this, idx);
    }

    public function throwRangeError():void{
        throw new RangeError(fixedRangeError);
    }
    

    public function chkIdx(index:Number):Number {
        var limit:Number = this[Language.SYNTH_TAG_FIELD][FIXED_LEN];
        var fail:Boolean = index >>> 0 !== index; //fail if not a uint value (also covers negative value range check)
        fail ||= ((limit == -1) ? (index > (limit = this['length'])) : (index >= limit)); //fail if not below length limit (possibly fixed)
        if (fail) {
            throw new RangeError(indexRangerError(index, limit));
        }
        return index;
    }
    
}
