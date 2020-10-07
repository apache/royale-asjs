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


import org.apache.royale.net.remoting.amf.AMFBinaryData;
import org.apache.royale.net.remoting.amf.AMFContext;
import org.apache.royale.utils.net.IDynamicPropertyOutput;
import org.apache.royale.utils.net.IDynamicPropertyWriter;
import org.apache.royale.reflection.getAliasByClass;
import org.apache.royale.reflection.getClassByAlias;
import org.apache.royale.reflection.getDynamicFields;
import org.apache.royale.reflection.getDefinitionByName;
import org.apache.royale.reflection.getQualifiedClassName;
import org.apache.royale.reflection.isDynamicObject;
import org.apache.royale.utils.net.IDataInput;
import org.apache.royale.utils.net.IDataOutput;
import org.apache.royale.utils.BinaryData;
import org.apache.royale.utils.net.IExternalizable;
import org.apache.royale.utils.net.IDataInput;
import org.apache.royale.utils.net.IDataOutput;


	COMPILE::JS
	/**
	 * @royalesuppressexport
	 */
	internal class AMF0AMF3Context extends AMFContext {
		import goog.DEBUG;

		import org.apache.royale.utils.Language;


		internal static function install():void{
			AMFBinaryData.installAlternateContext(AMF0AMF3Context);
		}

		//@todo :
		private static const AMF0_AMF3:int = 0x11;

		private static const AMF0_NUMBER:uint = 0x0;
		private static const AMF0_BOOLEAN:uint =0x1;
		private static const AMF0_STRING:uint = 0x2;
		private static const AMF0_OBJECT:uint = 0x3;
		/*private static const AMF0_MOVIECLIP:uint =  0x4; NOT USED */
		private static const AMF0_NULL:uint = 0x05;
		private static const AMF0_UNDEFINED:uint = 0x06;
		private static const AMF0_REFERENCE:uint = 0x07;
		private static const AMF0_ECMA_ARRAY:uint = 0x08; //includes non-numeric keys
		private static const AMF0_OBJECT_END:uint = 0x09;
		private static const AMF0_STRICT_ARRAY:uint = 0x0A; //only numeric keys (this does not seem to be used for client-side serialization)
		private static const AMF0_DATE:uint = 0x0B;
		private static const AMF0_LONG_STRING:uint = 0x0C;
		private static const AMF0_UNSUPPORTED:uint = 0x0D;
		/*private static const AMF0_RECORDSET:uint = 0x0E; NOT USED */
		private static const AMF0_XMLDOCUMENT:int = 0x0F; //
		private static const AMF0_TYPED_OBJECT:int = 0x10;



		public function AMF0AMF3Context(ownerReference:AMFBinaryData) {
			super(ownerReference);
		}

		override public function supportsAMFEncoding(type:uint):Boolean{
			return type == 3 || type == 0;
		}

		override public function writeObject(v:*):void {
			trace('to check here')
			super.writeObject(v)
		}

		/**
		 * @royaleignorecoercion Class
		 * @royaleignorecoercion String
		 * @royaleignorecoercion Number
		 * @royaleignorecoercion Array
		 */
		override public function writeAmf0Object(v:*):void{
			if (v == null) {
				if (v === undefined) {
					writeByte(AMF0_UNDEFINED);
				} else {
					writeByte(AMF0_NULL);
				}
				return;
			}
			if (isFunctionValue(v)) {
				//output function value as undefined
				writeByte(AMF0_UNDEFINED);
				return;
			}
			if (v is String) {
				var str:String = v as String;
				if (str == '') {
					writeByte(AMF0_STRING);
					writeByte(0);
					writeByte(0);
				} else {
					var bytes:Uint8Array = getUTFBytes(str, false);
					if (bytes.length < 65536) {
						writeByte(AMF0_STRING);
						writeShort(bytes.length );
					} else {
						writeByte(AMF0_LONG_STRING);
						writeUnsignedInt(bytes.length);
					}
					var srcArray:Array = [].slice.call(bytes);
					addByteSequence(srcArray);
				}
			} else if (v is Number) {
				var n:Number = v as Number;
				writeByte(AMF0_NUMBER);
				writeDouble(n);
			} else if (v is Boolean) {
				writeByte(AMF0_BOOLEAN);
				writeByte( v ? 1 : 0);
			}
			else if (v is Date) {
				writeAMF0Date(v as Date);
			}
			else if (AMFContext._xmlClass && v is AMFContext._xmlClass) {
				writeAMF0XML(v);
			}
			else {
				if (v is Array) {
					if (v[Language.SYNTH_TAG_FIELD] != undefined) {
						writeAMF0Vector(v); //writes as Object with fields 'fixed' and 'length', similar to ecma array
					} else {
						writeAMF0Array(v as Array);
					}
				} else writeAMF0ObjectVariant(v);
			}
		}

		private function writeAMF0Date(v:Date):void {
			//writeByte(AMF3_DATE);
			if (!amf0ObjectByReference(v)) {
				writeByte(AMF0_DATE);
				writeDouble(v.getTime());
				//timezone offset is mandatory but never used
				//it is a S16 in spec, but because it is always zero, cheat:
				writeByte(0);
				writeByte(0);
			}
		}

		private function writeAMF0Vector(v:Object):void {
			throw new Error('@todo');
		}

		private function writeAMF0Array(v:Array):void {
			//is it strict or associative
			var key:String;
			var val:*;
			if (!this.amf0ObjectByReference(v)) {
				var len:uint = v.length;
				var i:uint = 0;
				var akl:uint = 0; //associative keys length
				var denseLength:uint = len;
				var keys:Array = Object.keys(v);
				//profile the array
				//es6 specifies a generalized traversal order we can rely upon going forward
				//testing in IE11 shows the same order applies in that es5 Array implementation, so we assume it here:
				/*
				Property keys are traversed in the following order:

				First, the keys that are integer indices, in ascending numeric order.
				note non-integers: '02' round-tripping results in the different string '2'.
					'3.141' is not an integer index, because 3.141 is not an integer.
				Then, all other string keys, in the order in which they were added to the object.
				Lastly, all symbol keys, in the order in which they were added to the object.
				We don't need to worry about Symbols here
				 */
				var kl:uint = keys.length;
				//Assumption - based on the above,
				//if the last key in the keys is an integer index, and length matches the array.length then it is a pure strict array
				//if not, it is non-strict
				//	var isFunctionValue:Function = this.isFunctionValue;
				//discriminate between strict and ecma by any inclusion or not of non-ordinal keys only. dense vs. non-dense is not a factor
				if ((((keys[kl-1])>>0).toString() !== keys[kl-1])) {
					//ecma
					//var firstAssociative:int = keys.length ? keys.lastIndexOf(''+ (keys.length)): 0;
					//var count:uint = len + keys.length - firstAssociative;
					writeByte(AMF0_ECMA_ARRAY);
					writeUnsignedInt(len);
					len = keys.length;
					if (len) {
						for (i = 0;i<len; i++) {
							key = keys[i]
							val = v[key];
							if (!isFunctionValue(val)) {
								writeUTF(key)
								writeAmf0Object(val);
							}
						}
					}
					//end of object
					writeByte(0);
					writeByte(0);
					writeByte(AMF0_OBJECT_END);

				} else {
					//strict
					//encode as ecma anyway... because player seems to do that
					writeByte(AMF0_ECMA_ARRAY);
					writeUnsignedInt(len); //array length
					len = keys.length; //now keys length
					for (i = 0; i < len; i++) {
						key = keys[i]
						val = v[key];
						if (!isFunctionValue(val)) {
							writeUTF(key)
							writeAmf0Object(val);
						}
					}
					writeByte(0);
					writeByte(0);
					writeByte(AMF0_OBJECT_END);

					//in theory this should be it, but it looks like player always encodes as ecma (above)
					/*writeByte(AMF0_STRICT_ARRAY);
					writeUnsignedInt(len);
					if (len) {
						for (i = 0; i < len; i++) {
							writeObject(v[i]);
						}
					}*/
				}
			}
		}

		public function amf0ObjectByReference(v:Object):Boolean {
			const ref:int = objects.indexOf(v);
			const found:Boolean = ref !== -1;
			if (found) {
				writeByte(AMF0_REFERENCE);
				writeShort(ref);
			} else {
				objects.push(v);
				objectCount++;
			}
			return found;
		}

		private function writeAMF0ObjectVariant(v:Object):void {
			if (!this.amf0ObjectByReference(v)) {
				const localTraits:Traits = getLocalTraitsInfo(v);
				/*if (localTraits.externalizable && !localTraits.alias) {
					//in flash player if you try to write an object with no alias that is externalizable it does this:
					throw new Error("ArgumentError: Error #2004: One of the parameters is invalid.");
				}*/
				writeAMF0TypedObject(v, localTraits);
			}
		}

		private function writeAMF0TypedObject(v:Object, localTraits:Traits):void {

			if (!localTraits.alias) {
				writeByte(AMF0_OBJECT);
			} else {
				writeByte(AMF0_TYPED_OBJECT);
				writeUTF(localTraits.alias);
			}
			var l:uint;
			var i:uint;
			l = localTraits.count;
			for (i = 0; i < l; i++) {
				//sealed props
				var val:* = localTraits.getterSetters[localTraits.props[i]].getValue(v);
				if (val === null || val === undefined) {
					//coerce null values to the 'correct' types
					val = localTraits.nullValues[localTraits.props[i]];

					//handle '*' type which can be undefined or explicitly null
					if (val === undefined && localTraits.getterSetters[localTraits.props[i]].getValue(v) === null) {
						val = null;
					}
				}
				this.writeUTF(localTraits.props[i]);
				this.writeAmf0Object(val);
			}

			if (localTraits.isDynamic) {
				/*if (dynamicPropertyWriter != null) {
					dynamicPropertyWriter.writeDynamicProperties(v, this);
				} else {*/
				//default implementation
				var dynFields:Array = getDynamicFields(v);
				i = 0;
				l = dynFields.length;
				for (; i < l; i++) {
					val = v[dynFields[i]];
					if (isFunctionValue(val)) {
						//skip this name-value pair, don't even write it out as undefined (match flash)
						continue;
					}
					this.writeUTF(dynFields[i]);
					this.writeAmf0Object(val);
				}
			}

			writeByte(0);
			writeByte(0);
			writeByte(AMF0_OBJECT_END);

		}


		private function writeAMF0XML(v:Object):void{
			//e4x XML does not exist in AMF0.
			//so send to 'Object'
			writeAMF0ObjectVariant(v)
		}



		/**
		 * This serialization context is passed as the 2nd parameter to an IDynamicPropertyWriter
		 * implementation's writeDynamicProperties method call. The resolved properties are written here
		 * @param name property name
		 * @param value property value
		 */
		override public function writeDynamicProperty(name:String, value:*):void {
			trace('to check writeDynamicProperty');
			super.writeDynamicProperty(name, value);
		}



		override public function readObject():* {
			trace('@todo')
			return super.readObject();
		}

		override public function readAmf0Object():* {
			var amfType:uint = readUnsignedByte();
			return readAmf0ObjectValue(amfType);
		}

		private function readAmf0ObjectValue(amfType:uint):Object {
			var value:Object = null;
			var u:uint;

			switch (amfType) {
				case AMF0_NUMBER:
					value = readDouble();
					break;
				case AMF0_BOOLEAN:
					value = readUnsignedByte() ? true : false;
					break;
				case AMF0_STRING:
					//readUTF reads the unsigned short (U16) length as well
					value = readUTF();
					break;
				case AMF0_OBJECT:
					value = readAMF0ScriptObject(null);
					break;
				case AMF0_NULL:
					value = null;
					break;
				case AMF0_UNDEFINED:
					value = undefined;
					break;
				case AMF0_REFERENCE:
					value = getObject(readUnsignedShort());

					break;
				case AMF0_ECMA_ARRAY:
					value = readAMF0Array(true);
					break;
				case AMF0_OBJECT_END:
					throw 'unexpected'; //this should already be encountered during Object deserialization
					break;
				case AMF0_STRICT_ARRAY:
					value = readAMF0Array(false);
					break;
				case AMF0_DATE:
					value = readAMF0Date();
					break;
				case AMF0_LONG_STRING:
					var len:uint = readUnsignedInt();
					value = readUTFBytes(len);
					break;
				case AMF0_XMLDOCUMENT:
					throw 'unimplemented' ; //should we provide an option to deserialize as as3 XML ?
					break;


				case AMF0_TYPED_OBJECT:
					var className:String = readUTF();
					value= readAMF0ScriptObject(className);
					break;

				default:
					throw new Error("Unsupported AMF type: " + amfType);
			}
			return value;
		}



		private function readAMF0ScriptObject(alias:String):Object {
			var obj:Object;
			var localTraits:Traits;
			var hasProp:Boolean;
			if (alias) {
				var c:Class = getClassByAlias(alias);
				if (c) {
					obj = new c();
					localTraits = getLocalTraitsInfo(obj);
				}
			}
			if (!obj) {
				obj = {};
				localTraits = Traits.getBaseObjectTraits();
			}

			rememberObject(obj);
			var more:Boolean = true;
			while(more) {
				var key:String = readUTF();
				if (key == '') {
					more = false;

				} else {
					var fieldValue:* = readAmf0Object();
					hasProp = localTraits &&  (localTraits.hasProp(key) || localTraits.isTransient(key)) ;
					if (hasProp) {
						localTraits.getterSetters[key].setValue(obj, fieldValue);
					} else if (localTraits.isDynamic) {
						obj[key] = fieldValue;
					} else {
						//@todo
						trace('unknown field ', key)
						if (goog.DEBUG) {
							trace('ReferenceError: Error #1056: Cannot create property ' + key + ' on ' + localTraits.qName);
						}
					}
				}
			}

			var check:uint = readUnsignedByte();
			if (check != AMF0_OBJECT_END) {
				throw 'unexpected. should be AMF0_OBJECT_END';
			}
			return obj;
		}

		private function readAMF0Array(ecma:Boolean):Array {
			var array:Array = [];
			rememberObject(array);
			var len:uint = readUnsignedInt();
			var i:uint = 0;
			if (ecma) {
				array.length = len;
				var more:Boolean=true;
				while(more) {
					var key:String = readUTF();
					if (key == '') {
						more = false;
					} else {
						array[key] = readAmf0Object();
					}
				}
				var byte:uint = readUnsignedByte();
				if (byte != AMF0_OBJECT_END)  throw 'unexpected. should be AMF0_OBJECT_END';
			} else {
				while(i < len) {
					array[i] = readAmf0Object();
					i++;
				}
			}
			return array;
		}

		private function readAMF0Date():Date{
			var time:Number = readDouble();
			var date:Date = new Date(time);
			rememberObject(date);
			//skip the S16 timezone data (not used)
			_position += 2;
			return date;
		}


	}
}


