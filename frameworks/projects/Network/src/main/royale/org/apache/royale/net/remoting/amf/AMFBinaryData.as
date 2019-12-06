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
	import org.apache.royale.utils.net.IDataInput;
	import org.apache.royale.utils.net.IDataOutput;
	import org.apache.royale.utils.net.IDynamicPropertyWriter;
	import org.apache.royale.utils.net.IExternalizable;
	import org.apache.royale.utils.BinaryData;
	
	COMPILE::SWF{
		import flash.net.ObjectEncoding;
	}
	
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
	public class AMFBinaryData extends BinaryData implements IDataInput, IDataOutput {

		COMPILE::JS
		private static var _propertyWriter:IDynamicPropertyWriter;
		
		/**
		 * Allows greater control over the serialization of dynamic properties of dynamic objects.
		 * When this property is set to null, the default value, dynamic properties are serialized using native code,
		 * which writes all dynamic properties excluding those whose value is a function.
		 * This value is called only for properties of a dynamic object (objects declared within a dynamic class) or
		 * for objects declared using the new operator.
		 * You can use this property to exclude properties of dynamic objects from serialization; to write values
		 * to properties of dynamic objects; or to create new properties for dynamic objects. To do so,
		 * set this property to an object that implements the IDynamicPropertyWriter interface. For more information,
		 * see the IDynamicPropertyWriter interface.
		 */
		public static function get dynamicPropertyWriter():IDynamicPropertyWriter {
			COMPILE::JS{
				return _propertyWriter;
			}
			COMPILE::SWF{
				var value:flash.net.IDynamicPropertyWriter =  ObjectEncoding.dynamicPropertyWriter;
				var outValue:org.apache.royale.utils.net.IDynamicPropertyWriter = value as org.apache.royale.utils.net.IDynamicPropertyWriter;
				if (value && !outValue) {
					outValue = new ExternallySetDynamicPropertyWriter(value);
				}
				return outValue;
			}
		}
		
		public static function set dynamicPropertyWriter(value:IDynamicPropertyWriter):void {
			COMPILE::JS{
				_propertyWriter = value;
			}
			COMPILE::SWF{
				ObjectEncoding.dynamicPropertyWriter = value;
			}
		}
		
		
		
		public function AMFBinaryData(bytes:Object = null) {
			super(bytes);
		}
		
		COMPILE::SWF
		public function get objectEncoding():uint{
			return 3;
		}
		COMPILE::SWF
		public function set objectEncoding(value:uint):void{
			trace('objectEncoding is always AMF3, setter is ignored');
		}
		
		
		
		COMPILE::JS
		private var _serializationContext:SerializationContext;
		
		COMPILE::JS
		public function writeObject(v:*):void {
			if (!_serializationContext) _serializationContext = new SerializationContext(this);
			_serializationContext.dynamicPropertyWriter = _propertyWriter;
			_position = _serializationContext.writeObjectExternal(v, _position, mergeInToArrayBuffer);
			var err:Error = _serializationContext.getError();
			if (err) {
				throw new Error(err.message);
			}
		}
		
		COMPILE::JS
		public function readObject():* {
			if (!_serializationContext) _serializationContext = new SerializationContext(this);
			var value:* = _serializationContext.readObjectExternal();
			var err:Error = _serializationContext.getError();
			if (err) {
				throw new Error(err.message);
			}
			return value;
		}
		
		COMPILE::SWF
		public function writeObject(v:*):void {
			ba.writeObject(v);
		}
		
		COMPILE::SWF
		public function readObject():* {
			return ba.readObject();
		}
	}
}


COMPILE::SWF
class ExternallySetDynamicPropertyWriter implements IDynamicPropertyWriter{
	
	import flash.net.IDynamicPropertyOutput;
	
	private var _externalImplementation:flash.net.IDynamicPropertyWriter;
	
	public function ExternallySetDynamicPropertyWriter(original:flash.net.IDynamicPropertyWriter) {
		_externalImplementation = original;
	}
	
	public function writeDynamicProperties(obj:Object, output:flash.net.IDynamicPropertyOutput):void {
		_externalImplementation.writeDynamicProperties(obj, output);
	}
	
}

import org.apache.royale.net.remoting.amf.AMFBinaryData;
import org.apache.royale.utils.net.IDynamicPropertyOutput;
import org.apache.royale.utils.net.IDynamicPropertyWriter;
import org.apache.royale.reflection.getAliasByClass;
import org.apache.royale.reflection.getClassByAlias;
import org.apache.royale.reflection.getDynamicFields;
import org.apache.royale.reflection.getDefinitionByName;
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
class SerializationContext extends BinaryData  implements IDataInput, IDataOutput, IDynamicPropertyOutput {
	import goog.DEBUG;
	
	
	private static const AMF0_AMF3:int = 0x11;
	private static const AMF3_OBJECT_ENCODING:int = 0x03;
	
	private static const AMF3_UNDEFINED:int = 0x00;
	private static const AMF3_NULL:int = 0x01;
	private static const AMF3_BOOLEAN_FALSE:int = 0x02;
	private static const AMF3_BOOLEAN_TRUE:int = 0x03;
	private static const AMF3_INTEGER:int = 0x04;
	private static const AMF3_DOUBLE:int = 0x05;
	private static const AMF3_STRING:int = 0x06;
	private static const AMF3_XMLDOCUMENT:int = 0x07;
	private static const AMF3_DATE:int = 0x08;
	private static const AMF3_ARRAY:int = 0x09;
	private static const AMF3_OBJECT:int = 0x0A;
	private static const AMF3_XML:int = 0x0B;
	private static const AMF3_BYTEARRAY:int = 0x0C;
	private static const AMF3_VECTOR_INT:int = 0x0D;
	private static const AMF3_VECTOR_UINT:int = 0x0E;
	private static const AMF3_VECTOR_DOUBLE:int = 0x0F;
	private static const AMF3_VECTOR_OBJECT:int = 0x10;
	private static const AMF3_DICTIONARY:int = 0x11;
	
	
	private static const UINT29_MASK:int = 0x1FFFFFFF;
	private static const INT28_MAX_VALUE:int = 268435455;
	private static const INT28_MIN_VALUE:int = -268435456;
	
	private static const EMPTY_STRING:String = "";
	
	private var owner:AMFBinaryData;
	public var dynamicPropertyWriter:IDynamicPropertyWriter;
	private var writeBuffer:Array;
	
	private var objects:Array ;
	
	private var traits:Object;
	
	private var strings:Object;
	
	private var stringCount:uint;
	private var traitCount:uint;
	private var objectCount:uint;
	
	
	private var writeMode:Boolean = false;
	
	

	private var _numbers:ArrayBuffer;

	private var _numberView:DataView;

	private var _numberBytes:Uint8Array;
	
	private static var _xmlClass:Class;
	private static var _xmlChecked:Boolean;
	
	private var _error:Error;
	public function getError():Error{
		var _err:Error = _error;
		_error = null;
		return _err;
	}
	
	/**
	 * @royaleignorecoercion Class
	 */
	public function SerializationContext(ownerReference:AMFBinaryData){
		owner = ownerReference;
		reset();
		if (!_xmlChecked) {
			_xmlChecked = true;
			try{
				_xmlClass = getDefinitionByName('XML') as Class;
			} catch(e:Error){}
		}
		super();
	}
	
	public function reset():void{
		writeBuffer = [];
		objects = [];
		traits = {};
		strings = {};
		stringCount = 0;
		traitCount = 0;
		objectCount = 0;
	}
	

	/**
	 * used internally as an override to return the writeBuffer Array for use to mimic Uint8Array during writing.
	 * Array is used because it is not usually known what the byte allocation should be in advance,
	 * and length is not mutable with javascript typed arrays, so 'growing' the buffer with each write is not
	 * a good strategy for performance.
	 * The assumption is that, while write access is slower for individual elements, increasing the length of
	 * the 'buffer' is not, and that using Array will be more performant.
	 * @royaleignorecoercion Uint8Array
	 */
	override protected function getTypedArray():Uint8Array{
		return writeMode ? writeBuffer as Uint8Array : super.getTypedArray();
	}
	

	override protected function getDataView():DataView
	{
		if(!writeMode) return super.getDataView();
		//in write mode, return a utility version
		if (!_numberView) {
			_numbers = new ArrayBuffer(8);
			_numberView = new DataView(_numbers);
			_numberBytes = new Uint8Array(_numbers);
		}
		return _numberView;
	}
	
	

	override protected function setBufferSize(newSize:uint):void
	{
		//writing variation: in this subclass, writing  is always using 'Array' so length is not fixed
		_len = newSize;
	}
	

	override public function writeByte(byte:int):void
	{
		writeBuffer[_position++] = byte & 255;
	}
	
	override public function writeByteAt(idx:uint, byte:int):void
	{
		while (idx > _len) {
			writeBuffer[_len++] = 0;
		}
		writeBuffer[idx] = byte & 255;
	}
	
	public function writeUInt29(v:uint):void {
		const write:Function = writeByte;
		if (v < 128) {
			write(v);
		} else if (v < 16384) {
			write(((v >> 7) & 127) | 128);
			write(v & 127);
		} else if (v < 2097152) {
			write(((v >> 14) & 127) | 128);
			write(((v >> 7) & 127) | 128);
			write(v & 127);
		} else if (v < 0x40000000) {
			write(((v >> 22) & 127) | 128);
			write(((v >> 15) & 127) | 128);
			write(((v >> 8) & 127) | 128);
			write(v & 255);
		} else {
			throw "Integer out of range: " + v;
		}
	}
	
	protected function addByteSequence(array:Array):void{
		var length:uint = array.length;
		if (_position == _len) {
			writeBuffer = writeBuffer.concat(array);
			_len = _len + length;
			/*if (_len != writeBuffer.length) {
				throw new Error('code review')
			}*/
		} else {
			if (_position + length > _len) {
				//overwrite beyond
				//first truncate to _position
				writeBuffer.length = _position;
				//then append the new content
				writeBuffer = writeBuffer.concat(array);
				_len = _position + length;
				if (_len != writeBuffer.length) {
					throw new Error('code review')
				}
				
			} else {
				//overwrite within - concatenate left and right slices with the new content between
				writeBuffer = writeBuffer.slice(0, _position).concat(array, writeBuffer.slice(_position + length));
				
				if (_len != writeBuffer.length) {
					throw new Error('code review')
				}
			}
		}
		_position += length;
	}
	
	
	override public function writeBytes(bytes:ArrayBuffer, offset:uint = 0, length:uint = 0):void
	{
		if (length == 0) length = bytes.byteLength - offset ;
		if (!length) return;
		var src:Uint8Array = new Uint8Array(bytes, offset, offset + length);
		var srcArray:Array = [].slice.call(src);
		addByteSequence(srcArray);
	}
	
	override public function writeUTF(str:String):void
	{
		var utcBytes:Uint8Array = getUTFBytes(str , true);
		var srcArray:Array = [].slice.call(utcBytes);
		addByteSequence(srcArray);
	}
	
	override public function writeUTFBytes(str:String):void
	{
		var utcBytes:Uint8Array = getUTFBytes(str, false);
		var srcArray:Array = [].slice.call(utcBytes);
		addByteSequence(srcArray);
	}
	
	protected function copyNumericBytes(byteCount:uint):void{
		//arr here is actually an Array, not Uint8Array
		var arr:Uint8Array = getTypedArray();
		var numbers:Uint8Array = _numberBytes;
		var idx:uint = 0;
		while(byteCount--) {
			arr[_position++] = numbers[idx++];
		}
	}
	
	override public function writeFloat(val:Number):void
	{
		//always big endian
		getDataView().setFloat32(0,val,false);
		copyNumericBytes(4);
	}
	
	override public function writeDouble(val:Number):void
	{
		//always big endian
		getDataView().setFloat64(0,val,false);
		copyNumericBytes(8);
	}
	
	private function writeAMF_UTF(string:String):void{
		var utcBytes:Uint8Array = getUTFBytes(string , false);
		var srcArray:Array = [].slice.call(utcBytes);
		writeUInt29((srcArray.length << 1) | 1);
		addByteSequence(srcArray);
	}
	
	private function writeStringWithoutType(v:String):void {
		if (v.length == 0) {
			writeUInt29(1);
		} else {
			if (!this.stringByReference(v)) {
				writeAMF_UTF(v);
			}
		}
	}
	
	private function stringByReference(v:String):Boolean {
		const strIndex:* = strings[v];
		const found:Boolean = strIndex !== undefined;
		if (found) {
			const ref:uint = strIndex;
			writeUInt29(ref << 1);
		} else {
			strings[v] = stringCount++;
		}
		return found;
	}
	
	public function objectByReference(v:Object):Boolean {
		const ref:int = objects.indexOf(v);
		const found:Boolean = ref !== -1;
		if (found) {
			writeUInt29(ref << 1);
		} else {
			objects.push(v);
			objectCount++;
		}
		return found;
	}
	
	private function traitsByReference(props:Array, alias:String):Boolean {
		//@todo review this. Don't think it is necessary to do the long joins with the props
		//maybe alias alone is enough...?
		const s:String = alias + "|" + props.join("|");
		const traitsIndex:* = traits[s];
		const found:Boolean = traitsIndex !== undefined;
		if (found) {
			const ref:uint = traitsIndex;
			writeUInt29((ref << 2) | 1);
		} else {
			traits[s] = traitCount++;
		}
		return found;
	}
	
	private function writeAmfInt(v:int):void {
		if (v >= INT28_MIN_VALUE && v <= INT28_MAX_VALUE) {
			v = v & UINT29_MASK;
			writeByte(AMF3_INTEGER);
			writeUInt29(v);
		} else {
			writeByte(AMF3_DOUBLE);
			writeDouble(v);
		}
	}
	
	private function writeDate(v:Date):void {
		writeByte(AMF3_DATE);
		if (!objectByReference(v)) {
			writeUInt29(1);
			writeDouble(v.getTime());
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
			//exclude all non-public namespaces (identified by '::' between uri and name)
			if (fieldName.indexOf('::') != -1) continue;
			var field:Object = fieldSet[fieldName];
			exclude = false;
			if (asAccessors) {
				exclude = field.access != 'readwrite';
				if (exclude && into.indexOf(fieldName) == -1) { //<-- if at some level we already have read-write access, then that wins
					//check: does it combine to provide 'readwrite' permissions via accessChecks through inheritance chain
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
				if (asAccessors) {
					localTraits.getterSetters[fieldName] = Traits.createInstanceAccessorGetterSetter(fieldName);
				} else {
					//variable
					localTraits.getterSetters[fieldName] = Traits.createInstanceVariableGetterSetter(field.get_set, field.type);
				}
			}
		}
		return into;
	}
	
	private const nothing:Object = {};
	private function populateSerializableMembers(reflectionInfo:Object, accessChecks:Object, localTraits:Traits):Array {
		if (!reflectionInfo) return localTraits.props;
		var fields:Object = reflectionInfo.variables ? reflectionInfo.variables() : nothing;
		filterSerializableMembers(fields, accessChecks, localTraits, false, true);
		fields = reflectionInfo.accessors ? reflectionInfo.accessors() : nothing;
		filterSerializableMembers(fields, accessChecks, localTraits, true, true);
		return localTraits.props;
	}
	
	private function getLocalTraitsInfo(instance:Object):Traits {
		var classInfo:Object = instance.ROYALE_CLASS_INFO;
		var originalClassInfo:Object;
		var localTraits:Traits;
		if (classInfo) {
			localTraits = classInfo.localTraits;
			if (localTraits) {
				//implementation note: @todo a class may have more than one alias point to it
				//update alias, in case of registration of alias changed since traits was last cached.
				localTraits.alias = classInfo.alias || '';
				return classInfo.localTraits;
			}
			originalClassInfo = classInfo;
			localTraits = new Traits();
			var alias:String = classInfo.alias;// getAliasByClass(instance.constructor as Class); //<- @todo possible optimization: registerClassAlias implementation stores in the classInfo Object, access directly
			if (alias) localTraits.alias = alias;
			else localTraits.alias = '';
			localTraits.qName = classInfo.names[0].qName;
			localTraits.isDynamic = Boolean(classInfo.names[0].isDynamic);
			localTraits.externalizable = instance is IExternalizable;
			
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
			originalClassInfo.localTraits = localTraits;
		} else {
			//assume dynamic, anon object
			if (Object == instance.constructor) {
				localTraits = Traits.getBaseObjectTraits();
			} else {
				//could be a class object
				var anonFields:Array = [];
				for (var key:String in instance) {
					if (key !== "") {
						anonFields.push(key);
					}
				}
				localTraits = Traits.getDynObjectTraits(anonFields);
			}
			//not required, but useful when testing:
			localTraits.props.sort();
			
		}
		return localTraits;
	}
	
	public function writeObjectExternal(v:*, position:uint, mergeIntoOwner:Function):uint {
		writeMode = true;
		_position = 0;
		_len = 0;
		try{
			writeObject(v);
		} catch (e:Error) {
			_error = e;
		}
		var output:Uint8Array = new Uint8Array(writeBuffer);
		reset();
		writeMode = false;
		return mergeIntoOwner(position, output);
	}
	
	/**
	 * @royaleignorecoercion Class
	 * @royaleignorecoercion String
	 * @royaleignorecoercion Number
	 * @royaleignorecoercion Array
	 */
	public function writeObject(v:*):void {
		if (v == null) {
			writeByte(AMF3_NULL);
			return;
		}
		if (isFunctionValue(v)) {
			//output function value as undefined
			writeByte(AMF3_UNDEFINED);
			return;
		}
		if (v is String) {
			writeByte(AMF3_STRING);
			writeStringWithoutType(v as String);
		} else if (v is Number) {
			var n:Number = v as Number;
			if (n === +n && n === (n | 0)) {
				writeAmfInt(n);
			} else {
				writeByte(AMF3_DOUBLE);
				writeDouble(n);
			}
		} else if (v is Boolean) {
			writeByte((v
					? AMF3_BOOLEAN_TRUE
					: AMF3_BOOLEAN_FALSE));
		}
		else if (v is Date) {
			writeDate(v as Date);
		}
		else if (_xmlClass && v is _xmlClass) {
			writeXML(v);
		}
		else {
			if (v is Array) {
				if (v.toString().indexOf("[Vector") == 0)
					writeVector(v);
				else
					writeArray(v as Array);
			} else writeObjectVariant(v);
		}
	}
	
	
	private function writeXML(v:Object):void{
		writeByte(AMF3_XML);
		if (!this.objectByReference(v)) {
			var source:String = v.toXMLString();
			//don't use the regular string writing... it is not added to the String reference table (it seems)
			//this.writeStringWithoutType(source);
			writeAMF_UTF(source);
		}
	}
	
	
	/**
	 *
	 * @royaleignorecoercion BinaryData
	 * @royaleignorecoercion ArrayBuffer
	 */
	private function writeObjectVariant(v:Object):void {
		if (v is AMFBinaryData || v is BinaryData) {
			writeByte(AMF3_BYTEARRAY);
			if (!this.objectByReference(v)) {
				var binaryData:BinaryData = v as BinaryData;
				var len:uint = binaryData.length;
				this.writeUInt29((len << 1) | 1);
				writeBytes(binaryData.data as ArrayBuffer);
			}
			return;
		}
		
		writeByte(AMF3_OBJECT);
		if (!this.objectByReference(v)) {
			const localTraits:Traits = getLocalTraitsInfo(v);
			if (localTraits.externalizable && !localTraits.alias) {
				//in flash player if you try to write an object with no alias that is externalizable it does this:
				throw new Error("ArgumentError: Error #2004: One of the parameters is invalid.");
			}
			writeTypedObject(v, localTraits);
		}
	}
	
	/**
	 * This serialization context is passed as the 2nd parameter to an IDynamicPropertyWriter
	 * implementation's writeDynamicProperties method call. The resolved properties are written here
	 * @param name property name
	 * @param value property value
	 */
	public function writeDynamicProperty(name:String, value:*):void {
		this.writeStringWithoutType(name);
		this.writeObject(value);
	}
	
	
	private function writeTypedObject(v:Object, localTraits:Traits):void {
		var encodedName:String = localTraits.alias && localTraits.alias.length ? localTraits.alias : ']:' + localTraits.qName + ":[";
		
		if (!traitsByReference(localTraits.props, encodedName)) {
			this.writeUInt29(3 | (localTraits.externalizable ? 4 : 0) | (localTraits.isDynamic ? 8 : 0) | (localTraits.count << 4));
			this.writeStringWithoutType(localTraits.alias);
			
			if (!localTraits.externalizable) {
				var l:uint = localTraits.count;
				for (var i:uint = 0; i < l; i++) {
					this.writeStringWithoutType(localTraits.props[i]);
				}
			}
		}
		
		if (localTraits.externalizable) {
			v.writeExternal(this);
		} else {
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
				this.writeObject(val);
			}
			
			if (localTraits.isDynamic) {
				if (dynamicPropertyWriter != null) {
					dynamicPropertyWriter.writeDynamicProperties(v, this);
				} else {
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
						this.writeStringWithoutType(dynFields[i]);
						this.writeObject(val);
					}
				}
				//end of dynamic properties marker
				this.writeStringWithoutType(EMPTY_STRING);
			}
		}
	}
	
	private var _comparator:String;
	
	/**
	 * javascript does not differentiate between 'Class' and 'Function'
	 * So in javascript : Object instanceof Function is true, in flash it is not (Object instanceof Class *is* true).
	 * The function below is an attempt to discriminate between a pure function and a 'constructor' function
	 * @param value the value to inspect
	 * @return true if considered to be a 'pure' function value (not a constructor)
	 */
	private function isFunctionValue(value:*):Boolean {
		if (value instanceof Function) {
			var comparator:String = _comparator;
			var checkBase:Array;
			if (!comparator) {
				//var ff:Function = function f():void {};
				checkBase = Object.getOwnPropertyNames(function():void {});
				if (checkBase.indexOf('name') != -1) {
					checkBase.splice(checkBase.indexOf('name'), 1);
				}
				_comparator = comparator = checkBase.join(",");
			}
			checkBase = Object.getOwnPropertyNames(value);
			if (checkBase.indexOf('name') != -1) {
				checkBase.splice(checkBase.indexOf('name'), 1);
			}
			var check:String = checkBase.join(",");
			return check == comparator ;
		}
		return false;
	}

	/**
	 *
	 * @royaleignorecoercion String
	 */
	private function writeArray(v:Array):void {
		writeByte(AMF3_ARRAY);
		var len:uint = v.length;
		var i:uint = 0;
		var akl:uint = 0; //associative keys length
		if (!this.objectByReference(v)) {
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
			var isFunctionValue:Function = this.isFunctionValue;
			if (kl != len || (((keys[kl-1])>>0).toString() !== keys[kl-1]) || v.some(isFunctionValue)) {
				//Array is not strict
				if (len) {
					//the array has at least some integer keys
					
					//find denseLength
					for (i=0;i<len;i++) {
						if (keys[i] != ""+i ) break;
						//also seems to be true in avm:
						if (isFunctionValue(v[i])) break;
						
					}
					denseLength = i;
					//remove dense keys,
					//leaving only associative keys (which may include valid integer keys outside the dense part)
					keys.splice(0, denseLength);
				}// else all keys are associative keys, and denseLength is zero
				akl = keys.length;
			}
			this.writeUInt29((denseLength << 1) | 1);
			
			if (akl) {
				//name-value pairs of associative keys
				for (i = 0; i < akl; i++) {
					var val:* = v[keys[i]];
					if (isFunctionValue(val)) {
						continue;
					}
					this.writeStringWithoutType(keys[i] as String);
					this.writeObject(val);
				}
			}
			//empty string 'terminates' associative keys block - no more associative keys (if there were any)
			writeStringWithoutType(EMPTY_STRING);
			if (denseLength) {
				for (i = 0; i < denseLength; i++) {
					writeObject(v[i]);
				}
			}
		}
	}
	
	private function writeVector(v:Object):void {
		writeByte(v.type);
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
				writeObject(v[i]);
			}
		} else if (v.type == AMF3_VECTOR_INT) {
			for (i = 0; i < len; i++) {
				writeInt(v[i]);
			}
		} else if (v.type == AMF3_VECTOR_UINT) {
			for (i = 0; i < len; i++) {
				writeUnsignedInt(v[i]);
			}
		} else if (v.type == AMF3_VECTOR_DOUBLE) {
			for (i = 0; i < len; i++) {
				writeDouble(v[i]);
			}
		}
	}
	
	public function readUInt29():int {
		const read:Function = readUnsignedByte;
		var b:uint = read() & 255;
		if (b < 128) {
			return b;
		}
		var value:uint = (b & 127) << 7;
		b = read() & 255;
		if (b < 128)
			return (value | b);
		value = (value | (b & 127)) << 7;
		b = read() & 255;
		if (b < 128)
			return (value | b);
		value = (value | (b & 127)) << 8;
		b = read() & 255;
		return (value | b);
	}
	
	/**
	 *
	 * @royaleignorecoercion ArrayBuffer
	 */
	public function readObjectExternal():* {
		if (ba != owner.data) {
			ba = owner.data as ArrayBuffer;
			_typedArray = new Uint8Array(ba);
		}
		_position = owner.position;
		_len = owner.length;
		try{
			var result:* = readObject();
		} catch (e:Error) {
			_error = e;
		}
		reset();
		owner.position = _position;
		return result;
	}
	
	public function readObject():* {
		var amfType:uint = readUnsignedByte();
		return readObjectValue(amfType);
	}
	
	public function readXML():Object{
		var ref:uint = readUInt29();
		if ((ref & 1) == 0)
			return getObject(ref >> 1);
		else {
			var len:uint = (ref >> 1);
			var stringSource:String = readUTFBytes(len);
			if (!_xmlClass) {
				throw new Error("XML class is not linked in, as required for deserialization");
			}
			var xml:Object = new _xmlClass(stringSource);
			rememberObject(xml);
			return xml;
		}
	}
	
	public function readString():String {
		var ref:uint = readUInt29();
		if ((ref & 1) == 0) {
			return getString(ref >> 1);
		} else {
			var len:uint = (ref >> 1);
			if (len == 0) {
				return EMPTY_STRING;
			}
			var str:String = readUTFBytes(len);
			rememberString(str);
			return str;
		}
	}
	
	private function rememberString(v:String):void {
		strings[stringCount++] = v;
	}
	
	private function getString(v:uint):String {
		return strings[v];
	}
	
	private function getObject(v:uint):Object {
		
		return objects[v];
	}
	
	
	private function getTraits(v:uint):Traits {
		return traits[v] as Traits;
	}
	
	private function rememberTraits(v:Traits):void {
		traits[traitCount++] = v;
	}
	
	
	private function rememberObject(v:Object):void {
		objects.push(v);
	}
	
	private function readTraits(ref:uint):Traits {
		var ti:Traits;
		if ((ref & 3) == 1) {
			ti = getTraits(ref >> 2);
			return ti;
		} else {
			ti = new Traits();
			ti.externalizable = ((ref & 4) == 4);
			ti.isDynamic = ((ref & 8) == 8);
			ti.count = (ref >> 4);
			var className:String = readString();
			if (className != null && className != "") {
				ti.alias = className;
			}
			
			for (var i:int = 0; i < ti.count; i++) {
				ti.props.push(readString());
			}
			
			rememberTraits(ti);
			return ti;
		}
	}
	
	private function readScriptObject():Object {
		var ref:uint = readUInt29();
		if ((ref & 1) == 0) {
			//retrieve object from object reference table
			return getObject(ref >> 1);
		} else {
			var decodedTraits:Traits = readTraits(ref);
			var obj:Object;
			var localTraits:Traits;
			if (decodedTraits.alias) {
				var c:Class = getClassByAlias(decodedTraits.alias);
				if (c) {
					obj = new c();
					localTraits = getLocalTraitsInfo(obj);
				} else {
					obj = {};
				}
			} else {
				obj = {};
			}
			rememberObject(obj);
			if (decodedTraits.externalizable) {
				obj.readExternal(this);
			} else {
				const l:uint = decodedTraits.props.length;
				var hasProp:Boolean;
				for (var i:uint = 0; i < l; i++) {
					var fieldValue:* = readObject();
					var prop:String = decodedTraits.props[i];
					hasProp = localTraits &&  (localTraits.hasProp(prop) || localTraits.isDynamic);
					if (hasProp) {
						localTraits.getterSetters[prop].setValue(obj, fieldValue);
					} else {
						if (!localTraits) {
							obj[prop] = fieldValue;
						} else {
							//@todo add debug-only logging for error checks (e.g. ReferenceError: Error #1074: Illegal write to read-only property)
							if (goog.DEBUG) {
								trace('ReferenceError: Error #1056: Cannot create property ' + prop + ' on ' + decodedTraits.alias);
							}
						}
					}
				}
				if (decodedTraits.isDynamic) {
					for (; ;) {
						var name:String = readString();
						if (name == null || name.length == 0) {
							break;
						}
						obj[name] = readObject();
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
		var ref:uint = readUInt29();
		if ((ref & 1) == 0)
			return getObject(ref >> 1) as Array;
		var denseLength:uint = (ref >> 1);
		var array:Array = [];
		rememberObject(array);
		while (true) {
			var name:String = readString();
			if (!name)
				break;
			//associative keys first
			array[name] = readObject();
		}
		//then dense array keys
		for (var i:uint = 0; i < denseLength; i++) {
			array[i] = readObject();
		}
		return array;
	}
	
	/**
	 * @royaleignorecoercion Array
	 */
	public function readDate():Date {
		var ref:uint = readUInt29();
		if ((ref & 1) == 0)
			return getObject(ref >> 1) as Date;
		var time:Number = readDouble();
		var date:Date = new Date(time);
		rememberObject(date);
		return date;
	}
	
	public function readByteArray():AMFBinaryData {
		var ref:uint = readUInt29();
		if ((ref & 1) == 0)
			return getObject(ref >> 1) as AMFBinaryData;
		else {
			var len:uint = (ref >> 1);
			var bytes:Uint8Array = new Uint8Array(len);
			bytes.set(new Uint8Array(this.ba, _position, len));
			_position += len;
			var ba:AMFBinaryData = new AMFBinaryData(bytes.buffer);
			rememberObject(ba);
			return ba;
		}
	}
	
	private function toVector(type:uint, array:Array, fixed:Boolean):Array {
		// TODO (aharui) handle vectors
		return array;
	}
	
	private function readAmf3Vector(amfType:uint):Object {
		var ref:uint = readUInt29();
		if ((ref & 1) == 0)
			return getObject(ref >> 1);
		var len:uint = (ref >> 1);
		var vector:Array = toVector(amfType, [], readBoolean());
		var i:uint;
		if (amfType === AMF3_VECTOR_OBJECT) {
			readString(); //className
			for (i = 0; i < len; i++)
				vector.push(readObject());
		} else if (amfType === AMF3_VECTOR_INT) {
			for (i = 0; i < len; i++)
				vector.push(readInt());
		} else if (amfType === AMF3_VECTOR_UINT) {
			for (i = 0; i < len; i++)
				vector.push(readUnsignedInt());
		} else if (amfType === AMF3_VECTOR_DOUBLE) {
			for (i = 0; i < len; i++)
				vector.push(readDouble());
		}
		rememberObject(vector);
		return vector;
	}
	
	private function readObjectValue(amfType:uint):Object {
		var value:Object = null;
		var u:uint;
		
		switch (amfType) {
			case AMF3_STRING:
				value = readString();
				break;
			case AMF3_OBJECT:
				try {
					value = readScriptObject();
				} catch (e:Error) {
					throw new Error("Failed to deserialize: " + e);
				}
				break;
			case AMF3_ARRAY:
				value = readArray();
				break;
			case AMF3_BOOLEAN_FALSE:
				value = false;
				break;
			case AMF3_BOOLEAN_TRUE:
				value = true;
				break;
			case AMF3_INTEGER:
				u = readUInt29();
				// Symmetric with writing an integer to fix sign bits for
				// negative values...
				value = (u << 3) >> 3;
				break;
			case AMF3_DOUBLE:
				value = readDouble();
				break;
			case AMF3_UNDEFINED:
			case AMF3_NULL:
				break;
			case AMF3_DATE:
				value = readDate();
				break;
			case AMF3_BYTEARRAY:
				value = readByteArray();
				break;
			case AMF3_XML:
				value = readXML();
				break;
			case AMF3_VECTOR_INT:
			case AMF3_VECTOR_UINT:
			case AMF3_VECTOR_DOUBLE:
			case AMF3_VECTOR_OBJECT:
				value = readAmf3Vector(amfType);
				break;
			case AMF0_AMF3:
				value = readObject();
				break;
			default:
				throw new Error("Unsupported AMF type: " + amfType);
		}
		return value;
	}
}

COMPILE::JS
/**
 *  @royalesuppresspublicvarwarning
 *  @royalesuppressexport
 */
class Traits {
	import goog.DEBUG;
	
	
	public static function createInstanceVariableGetterSetter(reflectionFunction:Function, type:String):Object{
		var ret:Object = {
			setValue: function(inst:Object, value:*):void {
				reflectionFunction(inst, value);
			}
		};
		
		if (type == "*") {
			ret.getValue =
			 	function(inst:Object):* {
					return reflectionFunction(inst, reflectionFunction);
				}
		} else {
			ret.getValue =
				function(inst:Object):* {
					return reflectionFunction(inst);
				}
		}
		return ret;
	}
	
	public static function createInstanceAccessorGetterSetter(fieldName:String):Object{
		return {
			getValue: function(inst:Object):* {
				return inst[fieldName];
			},
			setValue: function(inst:Object, value:*):void {
				inst[fieldName] = value;
			}
		};
	}
	
	private static var _emtpy_object:Traits;
	
	
	
	public static function getClassTraits(fields:Array, qName:String):Traits{
		var traits:Traits = new Traits();
		traits.qName = '[Class] '+ qName;
		traits.isDynamic = true;
		traits.externalizable = false;
		traits.props = fields;
		
		return traits;
	}
	
	public static function getBaseObjectTraits():Traits {
		if (_emtpy_object) return _emtpy_object;
		var traits:Traits = _emtpy_object = new Traits();
		traits.qName = 'Object';
		traits.externalizable = false;
		traits.isDynamic = true;
		return traits;
	}
	
	public static function getDynObjectTraits(fields:Array):Traits {
		var traits:Traits;
		traits = new Traits();
		traits.qName = 'Object';
		traits.externalizable = false;
		traits.isDynamic = true;
		traits.props = fields;
		return traits;
	}
	
	public var alias:String = '';
	public var qName:String;
	public var externalizable:Boolean;
	public var isDynamic:Boolean;
	public var count:uint = 0;
	public var props:Array = [];
	public var nullValues:Object = {};
	
	public var getterSetters:Object = {};
	
	public function hasProp(prop:String):Boolean {
		return props.indexOf(prop) != -1;
	}
	
	public function toString():String {
		if (goog.DEBUG) {
			return 'Traits for \'' + qName + '\'\n'
					+ 'alias: \'' + alias + '\'\n'
					+ 'externalizable:' + Boolean(externalizable) + '\n'
					+ 'isDynamic:' + Boolean(isDynamic) + '\n'
					+ 'count:' + count + '\n'
					+ 'props:\n\t' + props.join('\n\t');
		} else {
			return 'Traits';
		}
	}
}


