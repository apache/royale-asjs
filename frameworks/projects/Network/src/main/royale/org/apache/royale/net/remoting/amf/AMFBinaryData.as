////////////////////////////////////////////////////////////////////////////////
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
////////////////////////////////////////////////////////////////////////////////
/***
 * Based on the
 * AMF JavaScript library by Emil Malinov https://github.com/emilkm/amfjs
 */
package org.apache.royale.net.remoting.amf {
	import org.apache.royale.reflection.getAliasByClass;
	import org.apache.royale.reflection.getClassByAlias;
	import org.apache.royale.net.utils.IDataInput;
	import org.apache.royale.net.utils.IDataOutput;
	import org.apache.royale.utils.BinaryData;
	
	/**
	 *  A version of BinaryData specific to AMF.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion BlazeDS 4
	 *  @productversion LCDS 3
	 *
	 *  @royalesuppresspublicvarwarning
	 */
	public class AMFBinaryData implements IDataInput, IDataOutput {
		//--------------------------------------------------------------------------
		//
		// Class Constants
		//
		//--------------------------------------------------------------------------
		
		private static var _debug:Boolean = false;
		
		public static function get DEBUG():Boolean {
			return _debug;
		}
		
		public static function set DEBUG(value:Boolean):void {
			_debug = value;
		}
		
		public static const CLASS_ALIAS:String = "_explicitType";
		
		public static const EMPTY_STRING:String = "";
		public static const NULL_STRING:String = "null";
		
		public static const AMF0_OBJECT_ENCODING:int = 0;
		
		public static const AMF0_NUMBER:int = 0;
		public static const AMF0_BOOLEAN:int = 1;
		public static const AMF0_STRING:int = 2;
		public static const AMF0_OBJECT:int = 3;
		public static const AMF0_MOVIECLIP:int = 4;
		public static const AMF0_NULL:int = 5;
		public static const AMF0_UNDEFINED:int = 6;
		public static const AMF0_REFERENCE:int = 7;
		public static const AMF0_MIXEDARRAY:int = 8; //ECMAArray
		public static const AMF0_OBJECTEND:int = 9;
		public static const AMF0_ARRAY:int = 10; //StrictArray
		public static const AMF0_DATE:int = 11;
		public static const AMF0_LONGSTRING:int = 12;
		public static const AMF0_UNSUPPORTED:int = 13;
		public static const AMF0_RECORDSET:int = 14;
		public static const AMF0_XMLDOCUMENT:int = 15;
		public static const AMF0_TYPEDOBJECT:int = 16;
		public static const AMF0_AMF3:int = 17;
		
		public static const AMF3_OBJECT_ENCODING:int = 3;
		
		public static const AMF3_UNDEFINED:int = 0;
		public static const AMF3_NULL:int = 1;
		public static const AMF3_BOOLEAN_FALSE:int = 2;
		public static const AMF3_BOOLEAN_TRUE:int = 3;
		public static const AMF3_INTEGER:int = 4;
		public static const AMF3_DOUBLE:int = 5;
		public static const AMF3_STRING:int = 6;
		public static const AMF3_XMLDOCUMENT:int = 7;
		public static const AMF3_DATE:int = 8;
		public static const AMF3_ARRAY:int = 9;
		public static const AMF3_OBJECT:int = 10;
		public static const AMF3_XML:int = 11;
		public static const AMF3_BYTEARRAY:int = 12;
		public static const AMF3_VECTOR_INT:int = 13;
		public static const AMF3_VECTOR_UINT:int = 14;
		public static const AMF3_VECTOR_DOUBLE:int = 15;
		public static const AMF3_VECTOR_OBJECT:int = 16;
		public static const AMF3_DICTIONARY:int = 17;
		
		
		public static const UNKNOWN_CONTENT_LENGTH:int = 1;
		
		public static const UINT29_MASK:int = 536870911;
		public static const INT28_MAX_VALUE:int = 268435455;
		public static const INT28_MIN_VALUE:int = -268435456;
		public static const UINT_MAX_VALUE:uint = 4294967295;
		public static const UINT_MIN_VALUE:uint = 0;
		
		
		public static const POW_2_20:Number = Math.pow(2, 20);
		public static const POW_2_52:Number = Math.pow(2, 52);
		public static const POW_2_52N:Number = Math.pow(2, -52);
		
		
		public static var writeArrayCollectionReadArrayList:Boolean = true;
		public static var addAliasInfoToAnonymousObjects:Boolean = false;
		
		//--------------------------------------------------------------------------
		//
		// Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructs an uninitialized AMFBinaryData.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion BlazeDS 4
		 *  @productversion LCDS 3
		 */
		public function AMFBinaryData(data:Array = null) {
			// TODO: (aharui) try to share code with BinaryData.
			// BinaryData has different methods and also
			// has ENDIAN code which AMF doesn't seem to need.
			super();
			if (data) {
				this.data = data;
			}
			
		}
		
		//--------------------------------------------------------------------------
		//
		// Variables
		//
		//--------------------------------------------------------------------------
		
		public var treatUnderscoresAsPrivateFields:Boolean = false;
		
		public var data:Array = [];
		
		private var objects:Array = [];
		
		private var traits:Object = {};
		
		private var strings:Object = {};
		
		private var stringCount:uint = 0;
		private var traitCount:uint = 0;
		private var objectCount:uint = 0;
		
		public var pos:uint = 0;
		
		public function write(v:uint):void {
			data.push(v);
		}
		
		public function writeShort(v:uint):void {
			write((v >>> 8) & 255);
			write((v >>> 0) & 255);
		}
		
		public function writeUTF(v:String, asAmf:Boolean = false):uint {
			var bytearr:Array = [];
			var strlen:uint = v.length;
			var utflen:uint = 0;
			
			for (var i:uint = 0; i < strlen; i++) {
				var c1:uint = v.charCodeAt(i);
				//var enc = null;
				
				if (c1 < 128) {
					utflen++;
					bytearr.push(c1);
					//end++;
				} else if (c1 > 127 && c1 < 2048) {
					utflen += 2;
					bytearr.push(192 | (c1 >> 6));
					if (asAmf)
						bytearr.push(128 | ((c1 >> 0) & 63));
					else
						bytearr.push(128 | (c1 & 63));
				} else if ((c1 & 0xF800) !== 0xD800) {
					utflen += 3;
					bytearr.push(224 | (c1 >> 12));
					bytearr.push(128 | ((c1 >> 6) & 63));
					if (asAmf)
						bytearr.push(128 | ((c1 >> 0) & 63));
					else
						bytearr.push(128 | (c1 & 63));
				} else {
					utflen += 4;
					if ((c1 & 0xFC00) !== 0xD800) {
						throw new RangeError('Unmatched trail surrogate at ' + i);
					}
					var c2:uint = v.charCodeAt(++i);
					if ((c2 & 0xFC00) !== 0xDC00) {
						throw new RangeError('Unmatched lead surrogate at ' + (i - 1));
					}
					c1 = ((c1 & 0x3FF) << 10) + (c2 & 0x3FF) + 0x10000;
					bytearr.push(240 | (c1 >> 18));
					bytearr.push(128 | ((c1 >> 12) & 63));
					bytearr.push((c1 >> 6) & 63);
					if (asAmf)
						bytearr.push(128 | ((c1 >> 0) & 63));
					else
						bytearr.push(128 | (c1 & 63));
				}
			}
			
			if (asAmf)
				writeUInt29((utflen << 1) | 1);
			else {
				bytearr.unshift(utflen & 255);
				bytearr.unshift((utflen >>> 8) & 255);
			}
			
			writeAll(bytearr);
			return asAmf ? utflen : utflen + 2;
		}
		
		public function writeUInt29(v:uint):void {
			if (v < 128) {
				this.write(v);
			} else if (v < 16384) {
				this.write(((v >> 7) & 127) | 128);
				this.write(v & 127);
			} else if (v < 2097152) {
				this.write(((v >> 14) & 127) | 128);
				this.write(((v >> 7) & 127) | 128);
				this.write(v & 127);
			} else if (v < 0x40000000) {
				this.write(((v >> 22) & 127) | 128);
				this.write(((v >> 15) & 127) | 128);
				this.write(((v >> 8) & 127) | 128);
				this.write(v & 255);
			} else {
				throw "Integer out of range: " + v;
			}
		}
		
		public function writeAll(bytes:Array):void {
			for (var i:uint = 0; i < bytes.length; i++) {
				this.write(bytes[i]);
			}
		}
		
		public function writeBoolean(v:Boolean):void {
			this.write(v ? 1 : 0);
		}
		
		public function writeInt(v:int):void {
			this.write((v >>> 24) & 255);
			this.write((v >>> 16) & 255);
			this.write((v >>> 8) & 255);
			this.write((v >>> 0) & 255);
		}
		
		public function writeUInt32(v:int):void {
			v < 0 && (v = -(v ^ UINT_MAX_VALUE) - 1);
			v &= UINT_MAX_VALUE;
			this.write((v >>> 24) & 255);
			this.write((v >>> 16) & 255);
			this.write((v >>> 8) & 255);
			this.write((v & 255));
		}
		
		private function getDouble(v:Number):Array {
			var r:Array = [0, 0];
			if (v != v) {
				r[0] = -524288;
				return r;
			}
			var d:int = v < 0 || v === 0 && 1 / v < 0 ? -2147483648 : 0;
			v = Math.abs(v);
			if (v === Number.POSITIVE_INFINITY) {
				r[0] = d | 2146435072;
				return r;
			}
			for (var e:int = 0; v >= 2 && e <= 1023;) {
				e++;
				v /= 2;
			}
			for (; v < 1 && e >= -1022;) {
				e--;
				v *= 2;
			}
			e += 1023;
			if (e == 2047) {
				r[0] = d | 2146435072;
				return r;
			}
			var i:Number;
			if (e == 0) {
				i = v * Math.pow(2, 23) / 2;
				v = Math.round(v * POW_2_52 / 2);
			} else {
				i = v * POW_2_20 - POW_2_20;
				v = Math.round(v * POW_2_52 - POW_2_52);
			}
			r[0] = d | e << 20 & 2147418112 | i & 1048575;
			r[1] = v;
			return r;
		}
		
		public function writeDouble(v:Number):void {
			var parts:Array = getDouble(v);
			this.writeUInt32(parts[0]);
			this.writeUInt32(parts[1]);
		}
		
		public function getResult():String {
			return data.join("");
		}
		
		public function getData():Array {
			return data;
		}
		
		public function reset():void {
			this.objects = [];
			this.objectCount = 0;
			this.traits = {};
			this.traitCount = 0;
			this.strings = {};
			this.stringCount = 0;
			
		}
		
		private function writeStringWithoutType(v:String):void {
			if (v.length == 0) {
				this.writeUInt29(1);
			} else {
				if (!this.stringByReference(v)) {
					this.writeUTF(v, true);
				}
			}
		}
		
		private function stringByReference(v:String):Boolean {
			const strIndex:* = this.strings[v];
			const found:Boolean = strIndex !== undefined;
			if (found) {
				const ref:uint = strIndex;
				this.writeUInt29(ref << 1);
			} else {
				this.strings[v] = this.stringCount++;
			}
			return found;
		}
		
		public function objectByReference(v:Object):Boolean {
			const ref:int = objects.indexOf(v);
			const found:Boolean = ref !== -1;
			if (found) {
				this.writeUInt29(ref << 1);
			} else {
				this.objects.push(v);
				this.objectCount++;
			}
			return found;
		}
		
		private function traitsByReference(props:Array, alias:String):Boolean {
			//@todo review this. Don't think it is necessary to do the long joins with the props
			//maybe alias alone is enough...?
			const s:String = alias + "|" + props.join("|");
			const traitsIndex:* = this.traits[s];
			const found:Boolean = traitsIndex !== undefined;
			if (found) {
				const ref:uint = traitsIndex;
				this.writeUInt29((ref << 2) | 1);
			} else {
				this.traits[s] = this.traitCount++;
			}
			return found;
		}
		
		private function writeAmfInt(v:int):void {
			if (v >= INT28_MIN_VALUE && v <= INT28_MAX_VALUE) {
				v = v & UINT29_MASK;
				this.write(AMF3_INTEGER);
				this.writeUInt29(v);
			} else {
				this.write(AMF3_DOUBLE);
				this.writeDouble(v);
			}
		}
		
		private function writeDate(v:Date):void {
			this.write(AMF3_DATE);
			if (!this.objectByReference(v)) {
				this.writeUInt29(1);
				this.writeDouble(v.getTime());
			}
		}
		
		private function filterSerializableMembers(fieldSet:Object, accessChecks:Object, localTraits:Traits, asAccessors:Boolean = false, excludeTransient:Boolean = true):Array {
			var l:uint;
			var metas:Array;
			var exclude:Boolean;
			var fieldName:String;
			const into:Array = localTraits.props;
			
			for (fieldName in fieldSet) {
				//exclude all static props
				if (fieldName.charAt(0) == '|') continue;
				var field:Object = fieldSet[fieldName];
				exclude = false;
				if (asAccessors) {
					exclude = field.access != 'readwrite';
					if (exclude && into.indexOf(fieldName) == -1) { //<-- if at some level we already have read-write access, then that wins
						//check: does it combine to provide 'readwite' permissions via accessChecks through inheritance chain
						if (accessChecks[fieldName] && accessChecks[fieldName] != field.access) {
							//readonly or writeonly overridde at one level and different at another == readwrite
							exclude = false;
						} else {
							if (!accessChecks[fieldName]) {
								//cache for subsequent cross-checks as above
								accessChecks[fieldName] = field.access;
							}
						}
					}
				}
				if (!exclude && excludeTransient && field.metadata != null) {
					//exclude anything marked as Transient
					metas = field.metadata();
					l = metas.length;
					while (l--) {
						if (metas[l].name == 'Transient') {
							exclude = true;
						}
					}
					if (exclude && into.indexOf(fieldName) != -1) {
						//?possible case where it is marked transient on an ancestor but not in a subclass override
						//it will not have been excluded when processing the subclass, which occurs first, so remove it now
						//@todo untested : check this scenario, assume it should be removed
						into.splice(into.indexOf(fieldName), 1);
					}
				}
				if (!exclude) {
					//set up null/undefined value lookups for undefined field values (when encoding)
					var nullValues:Object = localTraits.nullValues;
					if (field.type == 'Number') {
						nullValues[fieldName] = Number.NaN;
					} else if (field.type == 'Boolean') {
						nullValues[fieldName] = false;
					} else if (field.type == 'int' || field.type == 'uint') {
						nullValues[fieldName] = 0;
					} else if (field.type == '*') {
						nullValues[fieldName] = undefined;
					} else {
						nullValues[fieldName] = null;
					}
					into.push(fieldName);
				}
			}
			return into;
		}
		
		private function populateSerializableMembers(reflectionInfo:Object, accessChecks:Object, localTraits:Traits):Array {
			if (!reflectionInfo) return localTraits.props;
			var fields:Object = reflectionInfo.variables();
			filterSerializableMembers(fields, accessChecks, localTraits, false, true);
			fields = reflectionInfo.accessors();
			filterSerializableMembers(fields, accessChecks, localTraits, true, true);
			return localTraits.props;
		}
		
		private function getLocalTraitsInfo(instance:Object):Traits {
			var classInfo:Object = instance.ROYALE_CLASS_INFO;
			var originalClassInfo:Object;
			var localTraits:Traits;
			if (classInfo) {
				if (classInfo.localTraits) {
					//check alignment with any registerClassAlias changes that might have happened
					//implementation note: @todo a class may have more than one alias point to it
					//@todo integrate with reflection / registerClassAlias changes (either here or there)
					return classInfo.localTraits;
				}
				originalClassInfo = classInfo;
				localTraits = new Traits();
				var alias:String = getAliasByClass(instance.constructor as Class); //<- @todo possible optimization: registerClassAlias implementation stores in the classInfo Object, access directly
				if (alias) localTraits.alias = alias;
				else localTraits.alias = '';
				localTraits.qName = classInfo.names[0].qName;
				localTraits.dynamic = false;
				localTraits.externalizable = /* @todo check interfaces for Externalizable */ false;

//Temporary Special Casing
//a) automatically recognise ArrayCollection as externalized
//b) support ArrayList < --- > ArrayCollection conversions without alias mappings
//This will be removed in favor of either original approaches or some custom alias remapping support
				//so for now:
				if (localTraits.qName == 'org.apache.royale.collections.ArrayList' ||
						localTraits.alias == 'flex.messaging.io.ArrayCollection') {
					localTraits.externalizable = true;
				}
				
				if (localTraits.externalizable) {
					localTraits.count = 0;
				} else {
					var accessChecks:Object = {};
					var c:Object = instance;
					while (classInfo) {
						var reflectionInfo:Object = c.ROYALE_REFLECTION_INFO();
						populateSerializableMembers(reflectionInfo, accessChecks, localTraits);
						if (!c.constructor.superClass_ || !c.constructor.superClass_.ROYALE_CLASS_INFO)
							break;
						classInfo = c.constructor.superClass_.ROYALE_CLASS_INFO;
						c = c.constructor.superClass_;
					}
					localTraits.count = localTraits.props.length;
					//not required, but useful when testing:
					localTraits.props.sort();
				}
				//cache in the classInfo for faster lookups next time
				//@todo Greg to integrate with registerClassAlias so alias information is always aligned on teh cached localTraits
				originalClassInfo.localTraits = localTraits;
			} else {
				//assume dynamic, anon object
				
				var anonFields:Array = [];
				for (var key:String in instance) {
					if (key !== "") {
						if (treatUnderscoresAsPrivateFields && key.indexOf("_") === 0) continue;
						anonFields.push(key);
					}
				}
				localTraits = Traits.getDynObjectTraits(anonFields);
				//not required, but useful when testing:
				localTraits.props.sort();
			}
			return localTraits;
		}
		
		
		/**
		 * @royaleignorecoercion Class
		 * @royaleignorecoercion String
		 * @royaleignorecoercion Number
		 */
		public function writeObject(v:*):void {
			if (v == null) {
				this.write(AMF3_NULL);
				return;
			}
			if (v is Function) {
				//output function value as undefined
				this.write(AMF3_UNDEFINED);
				return;
			}
			if (v is String) {
				this.write(AMF3_STRING);
				this.writeStringWithoutType(v as String);
			} else if (v is Number) {
				var n:Number = v as Number;
				if (n === +n && n === (n | 0)) {
					this.writeAmfInt(n);
				} else {
					this.write(AMF3_DOUBLE);
					this.writeDouble(n);
				}
			} else if (v is Boolean)
				this.write((v
						? AMF3_BOOLEAN_TRUE
						: AMF3_BOOLEAN_FALSE));
			else if (v is Date)
				this.writeDate(v as Date);
			else {
				if (v is Array) {
					if (v.toString().indexOf("[Vector") == 0)
						this.writeVector(v);
					else
						this.writeArray(v as Array);
				} else writeObjectVariant(v);
			}
		}
		
		/**
		 *
		 * @royaleignorecoercion AMFBinaryData
		 * @royaleignorecoercion Array
		 */
		private function writeObjectVariant(v:Object):void {
			if (v is AMFBinaryData || v is BinaryData) {
				this.write(AMF3_BYTEARRAY);
				//@todo what if the source here is the same as the destination, i.e. v == this ?
				var amfBinary:AMFBinaryData;
				if (v is BinaryData) {
					var source:Object = v.array;
					COMPILE::JS {
						source = Array.from(source);
					}
					amfBinary = new AMFBinaryData(source as Array);
					trace('created AMFBinary from Binary');
				} else amfBinary = AMFBinaryData(v);
				var len:uint = amfBinary.data.length;
				writeUInt29(len);
				writeBytes(amfBinary, 0, len);
				return;
			}
			
			this.write(AMF3_OBJECT);
			if (!this.objectByReference(v)) {
				const localTraits:Traits = getLocalTraitsInfo(v);
				if (!localTraits.alias || localTraits.dynamic) {
					writeDynamicObject(v, localTraits);
				} else {
					writeTypedObject(v, localTraits);
				}
			}
		}
		
		private function writeExternalized(v:Object, localTraits:Traits):void {
			//Special case for now (temporary for ArrayCollection)
			if (localTraits.alias == 'flex.messaging.io.ArrayCollection' ||
					localTraits.alias == 'org.apache.royale.collections.ArrayList') {
				writeObject(v.source);
				return;
			}
			//@todo at implementor support  for IDataOutput-ish:
			throw new Error('IExternalizables to be done: Not yet available');
			//v.writeExternal(this);
		}
		
		
		private function writeTypedObject(v:Object, localTraits:Traits):void {
			//we normally only end up in this code if we have an alias, but use qName as a backstop
			//one possibility is that we could offer an 'alias-free' clientside switch to use qNames only as a future feature
			//but implementation inside swf netconnection etc, could be a challenge
			var encodedName:String = localTraits.alias && localTraits.alias.length ? localTraits.alias : localTraits.qName;
			
			//@todo temporary special-casing for now, consider as a feature
			if (localTraits.externalizable && writeArrayCollectionReadArrayList && localTraits.qName == 'org.apache.royale.collections.ArrayList') {
				//do the same for outbound ArrayList -- > written as ArrayCollection
				encodedName = 'flex.messaging.io.ArrayCollection';
			}
			
			if (!traitsByReference(localTraits.props, encodedName)) {
				//@todo double-check that externalized count should be 0 (it seems it should be, but not verified)
				this.writeUInt29(3 | (localTraits.externalizable ? 4 : 0) | (localTraits.dynamic ? 8 : 0) | (localTraits.count << 4));
				this.writeStringWithoutType(encodedName);
				
				if (!localTraits.externalizable) {
					var l:uint = localTraits.count;
					for (var i:uint = 0; i < l; i++) {
						this.writeStringWithoutType(localTraits.props[i]);
					}
				}
			}
			
			if (localTraits.externalizable) {
				writeExternalized(v, localTraits);
			} else {
				l = localTraits.count;
				for (i = 0; i < l; i++) {
					var val:* = v[localTraits.props[i]];
					if (val === null || val === undefined) {
						//coerce null values to the 'correct' types
						val = localTraits.nullValues[localTraits.props[i]];
						
						//handle '*' type which can be undefined or explicitly null
						if (val === undefined && v[localTraits.props[i]] === null) {
							val = null;
						}
					}
					this.writeObject(val);
				}
				
				//@todo handle dynamic as well (either via compiler support, or maybe ES6 Proxy?)
			}
		}
		
		private function writeDynamicObject(v:Object, localTraits:Traits):void {
			if (!this.traitsByReference([], '$DynObject$')) { //<-something to represent an anonymous object
				this.writeUInt29(11 /* 3 | 8 == dynamic */);
				this.writeStringWithoutType(EMPTY_STRING); //class name
			}
			var i:uint = 0;
			var l:uint = localTraits.props.length;
			for (; i < l; i++) {
				this.writeStringWithoutType(localTraits.props[i]);
				this.writeObject(v[localTraits.props[i]]);
			}
			this.writeStringWithoutType(EMPTY_STRING);
		}
		
		
		private function writeArray(v:Array):void {
			this.write(AMF3_ARRAY);
			var len:uint = v.length;
			if (!this.objectByReference(v)) {
				this.writeUInt29((len << 1) | 1);
				this.writeUInt29(1); //empty string implying no named keys
				if (len > 0) {
					for (var i:uint = 0; i < len; i++) {
						this.writeObject(v[i]);
					}
				}
			}
		}
		
		private function writeVector(v:Object):void {
			this.write(v.type);
			var i:uint;
			var len:uint = v.length;
			if (!this.objectByReference(v)) {
				this.writeUInt29((len << 1) | 1);
				this.writeBoolean(v.fixed);
			}
			if (v.type == AMF3_VECTOR_OBJECT) {
				var className:String = "";
				if (len > 0) {
					// TODO: how much of the PHP logic can we do here
					className = v[0].constructor.name;
				}
				this.writeStringWithoutType(className);
				for (i = 0; i < len; i++) {
					this.writeObject(v[i]);
				}
			} else if (v.type == AMF3_VECTOR_INT) {
				for (i = 0; i < len; i++) {
					this.writeInt(v[i]);
				}
			} else if (v.type == AMF3_VECTOR_UINT) {
				for (i = 0; i < len; i++) {
					this.writeUInt32(v[i]);
				}
			} else if (v.type == AMF3_VECTOR_DOUBLE) {
				for (i = 0; i < len; i++) {
					this.writeDouble(v[i]);
				}
			}
		}
		
		
		private var readerLog:Array = []
		
		public function flushReaderLog():String {
			var out:String = readerLog.join("\n");
			readerLog = [];
			return out;
		}
		
		public function read():uint {
			//if (this.pos + 1 > this.datalen) { //this.data.length store in this.datalen
			//  throw "Cannot read past the end of the data.";
			//}
			return this.data[this.pos++];
		}
		
		public function readUIntN(n:int):uint {
			var value:uint = this.read();
			for (var i:int = 1; i < n; i++) {
				value = (value << 8) | this.read();
			}
			return value;
		}
		
		public function readUnsignedShort():uint {
			var c1:uint = this.read();
			var c2:uint = this.read();
			return ((c1 << 8) + (c2 << 0));
		}
		
		public function readInt():int {
			var c1:int = this.read();
			var c2:int = this.read();
			var c3:int = this.read();
			var c4:int = this.read();
			return ((c1 << 24) + (c2 << 16) + (c3 << 8) + (c4 << 0));
		}
		
		public function readUInt32():uint {
			var c1:uint = this.read();
			var c2:uint = this.read();
			var c3:uint = this.read();
			var c4:uint = this.read();
			return (c1 * 0x1000000) + ((c2 << 16) | (c3 << 8) | c4);
		}
		
		public function readUInt29():int {
			var b:uint = this.read() & 255;
			if (b < 128) {
				return b;
			}
			var value:uint = (b & 127) << 7;
			b = this.read() & 255;
			if (b < 128)
				return (value | b);
			value = (value | (b & 127)) << 7;
			b = this.read() & 255;
			if (b < 128)
				return (value | b);
			value = (value | (b & 127)) << 8;
			b = this.read() & 255;
			return (value | b);
		}
		
		public function readFully(buff:Array, start:int, length:int):void {
			for (var i:int = start; i < length; i++) {
				buff[i] = this.read();
			}
		}
		
		public function readUTF(length:uint = 0):String {
			var utflen:uint = length ? length : this.readUnsignedShort();
			var len:uint = this.pos + utflen;
			var chararr:Array = [];
			var c1:int = 0;
			var seqlen:uint = 0;
			
			while (this.pos < len) {
				c1 = this.read() & 0xFF;
				seqlen = 0;
				
				if (c1 <= 0xBF) {
					c1 = c1 & 0x7F;
					seqlen = 1;
				} else if (c1 <= 0xDF) {
					c1 = c1 & 0x1F;
					seqlen = 2;
				} else if (c1 <= 0xEF) {
					c1 = c1 & 0x0F;
					seqlen = 3;
				} else {
					c1 = c1 & 0x07;
					seqlen = 4;
				}
				
				for (var i:int = 1; i < seqlen; ++i) {
					c1 = c1 << 0x06 | this.read() & 0x3F;
				}
				
				if (seqlen === 4) {
					c1 -= 0x10000;
					chararr.push(String.fromCharCode(0xD800 | c1 >> 10 & 0x3FF));
					chararr.push(String.fromCharCode(0xDC00 | c1 & 0x3FF));
				} else {
					chararr.push(String.fromCharCode(c1));
				}
			}
			
			return chararr.join("");
		}
		
		public function readObject():* {
			var type:uint = this.read();
			return this.readObjectValue(type);
		}
		
		public function readString():String {
			var ref:uint = this.readUInt29();
			if ((ref & 1) == 0) {
				return this.getString(ref >> 1);
			} else {
				var len:uint = (ref >> 1);
				if (len == 0) {
					return EMPTY_STRING;
				}
				var str:String = this.readUTF(len);
				this.rememberString(str);
				return str;
			}
		}
		
		private function rememberString(v:String):void {
			this.strings[stringCount++] = v;
		}
		
		private function getString(v:uint):String {
			return this.strings[v];
		}
		
		private function getObject(v:uint):Object {
			
			return this.objects[v];
		}
		
		
		private function getTraits(v:uint):Traits {
			return this.traits[v] as Traits;
		}
		
		private function rememberTraits(v:Traits):void {
			this.traits[traitCount++] = v;
		}
		
		
		private function rememberObject(v:Object):void {
			this.objects.push(v);
		}
		
		private function readTraits(ref:uint):Traits {
			var ti:Traits;
			if ((ref & 3) == 1) {
				ti = this.getTraits(ref >> 2);
				return ti;
			} else {
				ti = new Traits();
				ti.externalizable = ((ref & 4) == 4);
				ti.dynamic = ((ref & 8) == 8);
				ti.count = (ref >> 4);
				var className:String = this.readString();
				if (className != null && className != "") {
					ti.alias = className;
				}
				
				for (var i:int = 0; i < ti.count; i++) {
					ti.props.push(this.readString());
				}
				
				this.rememberTraits(ti);
				return ti;
			}
		}
		
		
		private function readExternalized(v:Object, decodedTraits:Traits):void {
			
			//Special case for now (temporary for ArrayCollection until it and ArrayList implement IExternalizable)
			if (decodedTraits.alias == 'flex.messaging.io.ArrayCollection' ||
					decodedTraits.alias == 'org.apache.royale.collections.ArrayList') {
				//for now, only emulate a call to 'readExternal' as if it was already implemented
				v.source = this.readObject();
				return;
			}
			if (decodedTraits.alias == "DSC") {
				trace('found');
			}
			//maybe check local traits first for Externalizable support before doing this:
			//@todo check what ByteArray does if the traits that were read encode for externalizable and the local aliased class
			//does not implement IExternalizable - probably throw an error in this case because the subsequent
			//encoding format of bytes is not known and therefore is not 'skippable'/recoverable
			
			//@todo implement IExternalizable as a call to the IDataOutput-ish:
			throw new Error("Not yet implemented")
			//v.readExternal(this);
		}
		
		private function readScriptObject():Object {
			var ref:uint = this.readUInt29();
			if ((ref & 1) == 0) {
				//retrieve object from object reference table
				return this.getObject(ref >> 1);
			} else {
				var decodedTraits:Traits = this.readTraits(ref);
				if (decodedTraits.alias == "flex.messaging.io.ArrayCollection") {
					if (writeArrayCollectionReadArrayList) {
						//pretend to be ArrayList
						decodedTraits = new Traits();
						decodedTraits.externalizable = true;
						decodedTraits.alias = 'org.apache.royale.collections.ArrayList';
						decodedTraits.dynamic = false;
						decodedTraits.count = 0;
					}
				} else {
					if (decodedTraits.alias == "flex.messaging.io.ObjectProxy" ||
							decodedTraits.alias == "DSK") {
						decodedTraits.alias = '';
						//@todo implement via IExternalizable
					}
				}
				var obj:Object;
				var localTraits:Traits;
				if (decodedTraits.alias) {
					var c:Class = getClassByAlias(decodedTraits.alias);
					if (c) {
						obj = new c();
						localTraits = getLocalTraitsInfo(obj);
					} else {
						obj = {};
						if (addAliasInfoToAnonymousObjects)
							obj[CLASS_ALIAS] = decodedTraits.alias;
					}
				} else {
					obj = {};
				}
				this.rememberObject(obj);
				if (decodedTraits.externalizable) {
					readExternalized(obj, decodedTraits);
				} else {
					const l:uint = decodedTraits.props.length;
					for (var i:uint = 0; i < l; i++) {
						var fieldValue:* = this.readObject();
						var prop:String = decodedTraits.props[i];
						//@todo if also is dynamic, then the exclusions below may not apply? requires investigation
						if (!localTraits || localTraits.hasProp(prop)) {
							obj[prop] = fieldValue;
						} else {
							if (_debug) {
								trace('[AMFBinaryData] discarding unknown \'' + prop + '\' property value from decoded content', localTraits.qName + "<-->" + decodedTraits.alias);
							}
						}
					}
					if (decodedTraits.dynamic) {
						for (; ;) {
							var name:String = this.readString();
							if (name == null || name.length == 0) {
								break;
							}
							obj[name] = this.readObject();
						}
					}
				}
				return obj;
			}
		}
		
		/**
		 * @royaleignorecoercion Array
		 */
		public function readArray():Array {
			var ref:uint = this.readUInt29();
			if ((ref & 1) == 0)
				return this.getObject(ref >> 1) as Array;
			var len:uint = (ref >> 1);
			var map:Object = null;
			var i:uint = 0;
			while (true) {
				var name:String = this.readString();
				if (!name)
					break;
				if (!map) {
					map = {};
					this.rememberObject(map);
				}
				map[name] = this.readObject();
			}
			if (!map) {
				var array:Array = new Array(len);
				this.rememberObject(array);
				for (i = 0; i < len; i++)
					array[i] = this.readObject();
				return array;
			} else {
				var amap:Array = [];
				for (i = 0; i < len; i++)
					amap[i] = this.readObject();
				return amap;
			}
		}
		
		public function readDouble():Number {
			var c1:uint = this.read() & 255;
			var c2:uint = this.read() & 255;
			if (c1 === 255) {
				if (c2 >= 248) {
					//one quiet NaN range (see https://www.doc.ic.ac.uk/~eedwards/compsys/float/nan.html)
					//skip next 6 bytes
					pos += 6;
					return Number.NaN;
				}
				
				if (c2 === 240) {
					//skip next 6 bytes
					pos += 6;
					return Number.NEGATIVE_INFINITY;
				}
			} else if (c1 === 127) {
				if (c2 >= 248) {
					//another quiet NaN range (see https://www.doc.ic.ac.uk/~eedwards/compsys/float/nan.html)
					//skip next 6 bytes
					pos += 6;
					return Number.NaN;
				}
				
				if (c2 === 240) {
					//skip next 6 bytes
					pos += 6;
					return Number.POSITIVE_INFINITY;
				}
			}
			var c3:uint = this.read() & 255;
			var c4:uint = this.read() & 255;
			var c5:uint = this.read() & 255;
			var c6:uint = this.read() & 255;
			var c7:uint = this.read() & 255;
			var c8:uint = this.read() & 255;
			if (!c1 && !c2 && !c3 && !c4)
				return 0;
			var d:int = (c1 << 4 & 2047 | c2 >> 4) - 1023;
			var e:String = ((c2 & 15) << 16 | c3 << 8 | c4).toString(2);
			for (var i:uint = e.length; i < 20; i++)
				e = "0" + e;
			var f:String = ((c5 & 127) << 24 | c6 << 16 | c7 << 8 | c8).toString(2);
			for (var j:uint = f.length; j < 31; j++)
				f = "0" + f;
			var g:Number = parseInt(e + (c5 >> 7 ? "1" : "0") + f, 2);
			if (g == 0 && d == -1023)
				return 0;
			return (1 - (c1 >> 7 << 1)) * (1 + POW_2_52N * g) * Math.pow(2, d);
		}
		
		/**
		 * @royaleignorecoercion Array
		 */
		public function readDate():Date {
			var ref:uint = this.readUInt29();
			if ((ref & 1) == 0)
				return this.getObject(ref >> 1) as Date;
			var time:Number = this.readDouble();
			var date:Date = new Date(time);
			this.rememberObject(date);
			return date;
		}
		
		public function readByteArray():Array {
			var ref:uint = this.readUInt29();
			if ((ref & 1) == 0)
				return this.getObject(ref >> 1) as Array;
			else {
				var len:uint = (ref >> 1);
				var ba:Array = [];
				this.readFully(ba, 0, len);
				this.rememberObject(ba);
				return ba;
			}
		}
		
		private function readAmf3Vector(type:uint):Object {
			var ref:uint = this.readUInt29();
			if ((ref & 1) == 0)
				return this.getObject(ref >> 1);
			var len:uint = (ref >> 1);
			var vector:Array = toVector(type, [], this.readBoolean());
			var i:uint;
			if (type === AMF3_VECTOR_OBJECT) {
				this.readString(); //className
				for (i = 0; i < len; i++)
					vector.push(this.readObject());
			} else if (type === AMF3_VECTOR_INT) {
				for (i = 0; i < len; i++)
					vector.push(this.readInt());
			} else if (type === AMF3_VECTOR_UINT) {
				for (i = 0; i < len; i++)
					vector.push(this.readUInt32());
			} else if (type === AMF3_VECTOR_DOUBLE) {
				for (i = 0; i < len; i++)
					vector.push(this.readDouble());
			}
			this.rememberObject(vector);
			return vector;
		}
		
		private function readObjectValue(type:uint):Object {
			var value:Object = null;
			var u:uint;
			
			switch (type) {
				case AMF3_STRING:
					value = this.readString();
					break;
				case AMF3_OBJECT:
					try {
						value = this.readScriptObject();
					} catch (e:Error) {
						throw new Error("Failed to deserialize: " + e);
					}
					break;
				case AMF3_ARRAY:
					value = this.readArray();
					break;
				case AMF3_BOOLEAN_FALSE:
					value = false;
					break;
				case AMF3_BOOLEAN_TRUE:
					value = true;
					break;
				case AMF3_INTEGER:
					u = this.readUInt29();
					// Symmetric with writing an integer to fix sign bits for
					// negative values...
					value = (u << 3) >> 3;
					break;
				case AMF3_DOUBLE:
					value = this.readDouble();
					break;
				case AMF3_UNDEFINED:
				case AMF3_NULL:
					break;
				case AMF3_DATE:
					value = this.readDate();
					break;
				case AMF3_BYTEARRAY:
					value = this.readByteArray();
					break;
				case AMF3_VECTOR_INT:
				case AMF3_VECTOR_UINT:
				case AMF3_VECTOR_DOUBLE:
				case AMF3_VECTOR_OBJECT:
					value = this.readAmf3Vector(type);
					break;
				case AMF0_AMF3:
					value = this.readObject();
					break;
				default:
					throw new Error("Unsupported AMF type: " + type);
			}
			return value;
		}
		
		public function readBoolean():Boolean {
			return this.read() === 1;
		}
		
		private function toVector(type:uint, array:Array, fixed:Boolean):Array {
			// TODO (aharui) handle vectors
			return array;
		}
		
		//IDataOutput -------------------------------------------------------------------------------------
		
		public function writeBytes(bytes:AMFBinaryData, offset:uint = 0, length:uint = 0):void {
			this.data = this.data.concat(bytes.data.slice(offset, offset + length));
			pos += length;
		}
		
		public function writeByte(value:int):void {
			write(value & 255)
		}
		
		//IDataInput -------------------------------------------------------------------------------------
		
		public function get bytesAvailable():uint {
			return 0;
		}
		
		public function readUnsignedByte():uint {
			return 0;
		}
	}
	
}

/**
 *  @royalesuppresspublicvarwarning
 */
class Traits {
	private static var _emtpy_object:Traits;
	
	public static function getDynObjectTraits(fields:Array):Traits {
		var traits:Traits;
		if (fields.length == 0) {
			if (_emtpy_object) return _emtpy_object;
			traits = _emtpy_object = new Traits();
			traits.qName = 'Object';
			traits.externalizable = false;
			traits.dynamic = true;
			return traits;
		}
		traits = new Traits();
		traits.qName = 'Object';
		traits.externalizable = false;
		traits.dynamic = true;
		traits.props = fields;
		return traits;
	}
	
	public var alias:String = '';
	public var qName:String;
	public var externalizable:Boolean;
	public var dynamic:Boolean;
	public var count:uint = 0;
	public var props:Array = [];
	public var nullValues:Object = {};
	
	public function hasProp(prop:String):Boolean {
		return props.indexOf(prop) != -1;
	}
	
	public function toString():String {
		return 'Traits for \'' + qName + '\'\n'
				+ 'alias: \'' + alias + '\'\n'
				+ 'externalizable:' + Boolean(externalizable) + '\n'
				+ 'dynamic:' + Boolean(dynamic) + '\n'
				+ 'count:' + count + '\n'
				+ 'props:\n\t' + props.join('\n\t');
	}
}
