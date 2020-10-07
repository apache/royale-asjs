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

	COMPILE::JS{
		import goog.DEBUG;
	}
	
	COMPILE::SWF{
		import flash.net.ObjectEncoding;
		import flash.utils.ByteArray;
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
		COMPILE::JS
		private static var _amfContextClass:Class;

		COMPILE::JS
		internal static function installAlternateContext(clazz:Class):void{
			//this should always be a valid subclass of AMFContext (only AMF0 support)
			_amfContextClass = clazz;
		}
		COMPILE::JS
		private static var _defaultEncoding:uint = 3;
		public static function get defaultObjectEncoding() : uint{
			COMPILE::JS{
				return _defaultEncoding;
			}
			COMPILE::SWF{
				return ByteArray.defaultObjectEncoding;
			}
		}
		public static function set defaultObjectEncoding(value:uint) : void{
			COMPILE::JS{
				_defaultEncoding = value;
			}
			COMPILE::SWF{
				ByteArray.defaultObjectEncoding = value;
			}
		}

		/**
		 *
		 * @royaleignorecoercion org.apache.royale.net.remoting.amf.AMFContext
		 */
		COMPILE::JS
		private static function createSerializationContext(forInstance:AMFBinaryData):AMFContext{
			var clazz:Class = _amfContextClass;
			if (!clazz) clazz = _amfContextClass = AMFContext;
			return new clazz(forInstance) as AMFContext;
		}
		
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
			COMPILE::JS{
				if (_objectEncoding != _defaultEncoding) _objectEncoding = _defaultEncoding;
			}
		}

		COMPILE::JS
		private var _objectEncoding:int=3;


		public function get objectEncoding():uint{
			COMPILE::SWF{
				return ba.objectEncoding;
			}
			COMPILE::JS{
				return _objectEncoding;
			}
		}

		public function set objectEncoding(value:uint):void{
			COMPILE::SWF{
				ba.objectEncoding = value;
			}
			COMPILE::JS{
				if (([0,3]).indexOf(value) == -1) {
					throw new Error('ArgumentError: Error #2008: Parameter objectEncoding must be one of the accepted values.')
				} else {
					_objectEncoding = value;
				}
			}
		}
		
		
		
		COMPILE::JS
		private var _serializationContext:AMFContext;
		
		COMPILE::JS
		public function writeObject(v:*):void {
			if (!_serializationContext) _serializationContext = createSerializationContext(this);
			_serializationContext.dynamicPropertyWriter = _propertyWriter;
			_position = _serializationContext.writeObjectExternal(v, _position, mergeInToArrayBuffer);
			var err:Error = _serializationContext.getError();
			if (err) {
				throw new Error(err.message);
			}
		}
		
		COMPILE::JS
		public function readObject():* {
			if (!_serializationContext) _serializationContext = createSerializationContext(this);
			var value:* = _serializationContext.readObjectExternal();
			var err:Error = _serializationContext.getError();
			if (err) {
				if (goog.DEBUG){
					console.log('%c[AMFBinaryData.readObject] - Deserialization Error :'+ err.message,'color:red');
				}
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

import org.apache.royale.utils.net.IDynamicPropertyWriter;
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