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

COMPILE::SWF
{
    import flash.utils.ByteArray;
}
COMPILE::JS
{
    import goog.DEBUG;
}
    
/**
 *  Support for Arraylike access (typed index access via []) and also iteration when used with for-each loops.
 *
 *  @langversion 3.0
 *  @playerversion Flash 10.2
 *  @playerversion AIR 2.6
 *  @productversion Royale 0.0
 */
[RoyaleArrayLike(getValue="readByteAt",setValue="writeByteAt",setterArgSequence="index,value",length="length",lengthAccess="getter")]

/**
 *  The BinaryData class is a class that represents binary data.  The way
 *  browsers handle binary data varies.  This class abstracts those
 *  differences..
 *
 *  @langversion 3.0
 *  @playerversion Flash 10.2
 *  @playerversion AIR 2.6
 *  @productversion Royale 0.0
 */
public class BinaryData implements IBinaryDataInput, IBinaryDataOutput
{
    /**
     *  Constructor. The constructor takes an optional bytes argument.
     *  In Flash this should be a ByteArray. In JS this should be an ArrayBuffer
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    COMPILE::SWF
    public function BinaryData(bytes:Object = null)
    {
        ba = bytes ? bytes as ByteArray : new ByteArray();
    }

    /**
    * @royaleignorecoercion ArrayBuffer
    */
    COMPILE::JS
    public function BinaryData(bytes:Object = null)
    {
        if(goog.DEBUG)
        {
            if(bytes && typeof bytes.byteLength != "number" && bytes.buffer !== undefined)
                throw new TypeError("BinaryData can only be initialized with ArrayBuffer");
        }
        ba = bytes ? bytes as ArrayBuffer : new ArrayBuffer(0);
        _len = ba.byteLength;
    }

    /**
     *  Utility method to create a BinaryData object from a string.
     *
     *  @param {String} str The string to convert to BinaryData as UTF-8 bytes.
     *  @return {BinaryData} The BinaryData instance from the UTF-8 bytes of the string.     *
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.7.0
     */
    public static function fromString(str:String):BinaryData
    {
        var bd:BinaryData = new BinaryData();
        bd.writeUTFBytes(str);
        return bd;
    }

    /**
     *  Gets a reference to the internal array of bytes.
     *  On the Flash side, this is  a ByteArray.
     *  On the JS side, it's a Uint8Array.
     *  This is primarily used for indexed access to the bytes, and particularly
     *  where platform-specific performance optimization is required.
     *  To maintain cross-target consistency, you should not alter the length
     *  of the ByteArray in any swf specific code, you should assume its length is fixed
     *  (even though it is not).
     *
     *  @return {ByteArray} The BinaryData backing array as ByteArray on flash.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.7.0

     */
    COMPILE::SWF
    public function get array():ByteArray
    {
        return ba;
    }

    /**
     *  Gets a reference to the internal array of bytes.
     *  On the Flash side, this is  a ByteArray.
     *  On the JS side, it's a Uint8Array.
     *  This is primarily used for indexed (Array) access to the bytes, particularly
     *  where platform-specific performance optimization is required.
     *  To maintain cross-target consistency, you should not alter the length
     *  of the ByteArray in any swf specific code, assume its length is fixed
     *  (even though it is not).
     *
     *  @return {Uint8Array} The BinaryData backing array as Uint8Array in javascript.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.7.0
     */
    COMPILE::JS
    public function get array():Uint8Array
    {
        return getTypedArray();
    }


    COMPILE::JS
    private var _endian:String = Endian.BIG_ENDIAN;

    COMPILE::JS
    private var _sysEndian:Boolean = _endian == Endian.systemEndian;

    /**
     *  Indicates the byte order for the data.
     *  The default is Endian BIG_ENDIAN.
     *  It is possible to check the default system Endianness of the target platform at runtime with
     *  <code>org.apache.royale.utils.Endian.systemEndian</code>.
     *  Setting to values other than Endian.BIG_ENDIAN or Endian.LITTLE_ENDIAN is ignored.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.7.0
     */
    public function get endian():String
    {
        COMPILE::SWF {
            return ba.endian;
        }
        COMPILE::JS {
            return _endian;
        }
    }

    public function set endian(value:String):void
    {
        if (value == Endian.BIG_ENDIAN || value == Endian.LITTLE_ENDIAN) {
            COMPILE::JS {
                _endian = value;
                _sysEndian = value == Endian.systemEndian;
            }
            COMPILE::SWF {
                ba.endian = value;
            }
        }
    }

    COMPILE::SWF
	protected var ba:ByteArray;

    COMPILE::JS
	protected var ba:ArrayBuffer;

    COMPILE::JS
    protected var _position:int = 0;

    /**
     * Get the platform-specific data for sending.
     * Generally only used by the network services.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    public function get data():Object
    {
        return ba;
    }

    /**
	 *  create a string representation of the binary data
	 */
	public function toString():String
	{
        COMPILE::SWF
        {
            return ba.toString();
        }

        COMPILE::JS
        {
            _position = 0;
            return readUTFBytes(length);
        }
	}

    /**
     *  Write a Boolean value (as a single byte) at the current position
     *
     *  @param {Boolean} value The boolean value to write into the BinaryData at the current position
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    public function writeBoolean(value:Boolean):void
    {
        COMPILE::SWF
        {
            ba.writeBoolean(value);
        }

        COMPILE::JS
        {
            writeByte(value ? 1 :0);
        }
    }

    /**
     *  Write a byte of binary data at the current position
     *
     *  @param {int} byte The value to write into the BinaryData at the current position
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    public function writeByte(byte:int):void
    {
        COMPILE::SWF
        {
            ba.writeByte(byte);
        }
        COMPILE::JS
        {
            if (_position + 1 > _len) {
                setBufferSize(_position + 1);
            }
            getTypedArray()[_position++] = byte;
        }
    }
    /**
     *  Writes a sequence of <code>length</code> bytes from the <code>source</code> BinaryData, starting
     *  at <code>offset</code> (zero-based index) bytes into the source BinaryData. If length
     *  is omitted or is zero, it will represent the entire length of the source
     *  starting from offset. If offset is omitted also, it defaults to zero.
     *
     *  @param {BinaryData} source The source BinaryData to write from at the current position
     *  @param {uint} offset The optional offset value of the starting bytes to write inside source
     *  @param {uint} length The optional length value of the bytes to write from offset in source
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     *
     *  @royaleignorecoercion ArrayBuffer
     */
    public function writeBinaryData(bytes:BinaryData, offset:uint = 0, length:uint = 0):void
    {
		if (!bytes) throw new TypeError('Error #2007: Parameter bytes must be non-null.');
		if (bytes == this) throw new Error('Parameter bytes must be another instance.');
        COMPILE::SWF
        {
            ba.writeBytes(bytes.ba,offset,length);
        }

        COMPILE::JS
        {
			writeBytes(bytes.ba as ArrayBuffer,offset,length);
        }

    }
    
	COMPILE::SWF
	public function writeBytes(bytes:ByteArray, offset:uint = 0, length:uint = 0):void {
		ba.writeBytes(bytes, offset, length);
	}
 
	COMPILE::JS
	public function writeBytes(bytes:ArrayBuffer, offset:uint = 0, length:uint = 0):void {
		
		if (!bytes) throw new TypeError('Error #2007: Parameter bytes must be non-null.')
		if (offset > bytes.byteLength) {
			//offset exceeds source length
			throw new RangeError('Error #2006: The supplied index is out of bounds.');
		}
		if (length == 0) length = bytes.byteLength - offset ;
		else if (length > bytes.byteLength - offset) {
			//length exceeds source length
			throw new RangeError('Error #2006: The supplied index is out of bounds.');
		}
		
		if (_position + length > _len) {
			setBufferSize(_position + length);
		}
		var dest:Uint8Array = new Uint8Array(ba, _position, length);
		var src:Uint8Array = new Uint8Array(bytes, offset, length);
		dest.set(src);
		_position += length;
	}

    /**
     *  Write a short integer (16 bits, typically represented by a 32 bit int parameter between -32768 and 65535)
     *  of binary data at the current position
     *
     *  @param {int} short The value to write into the BinaryData at the current position
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    public function writeShort(short:int):void
    {
        COMPILE::SWF
        {
            ba.writeShort(short);
        }
        COMPILE::JS
        {
            if (_position + 2 > _len) {
                setBufferSize(_position + 2);
            }
            var arr:Uint8Array = getTypedArray();
            if(endian == Endian.BIG_ENDIAN){
                arr[_position++] = (short & 0x0000ff00) >> 8;
                arr[_position++] = (short & 0x000000ff);
            } else {
                arr[_position++] = (short & 0x000000ff);
                arr[_position++] = (short & 0x0000ff00) >> 8;
            }

        }
    }

    /**
     *  Write an unsigned int (32 bits) of binary data at the current position
     *
     *  @param {uint} val The value to write into the BinaryData at the current position
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    public function writeUnsignedInt(val:uint):void
    {
        COMPILE::SWF
        {
            ba.writeUnsignedInt(val);
        }
        COMPILE::JS
        {
            writeInt(val);
        }
    }

    /**
     *  Write a signed int (32 bits) of binary data at the current position
     *
     *  @param {int} val The value to write into the BinaryData at the current position
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    public function writeInt(val:int):void
    {
        COMPILE::SWF
        {
            ba.writeInt(val);
        }
        COMPILE::JS
        {
            if (_position + 4 > _len) {
                setBufferSize(_position + 4);
            }
            var arr:Uint8Array = getTypedArray();
            if(endian == Endian.BIG_ENDIAN){

                arr[_position++] = (val & 0xff000000) >> 24;
                arr[_position++] = (val & 0x00ff0000) >> 16;
                arr[_position++] = (val & 0x0000ff00) >> 8;
                arr[_position++] = (val & 0x000000ff);
            } else {
                arr[_position++] = (val & 0x000000ff);
                arr[_position++] = (val & 0x0000ff00) >> 8;
                arr[_position++] = (val & 0x00ff0000) >> 16;
                arr[_position++] = (val & 0xff000000) >> 24;
            }
        }
    }

    /**
     *  Writes an IEEE 754 single-precision (32-bit) floating-point number to the
     *  BinaryData at the current position
     *
     *  @param {Number} val The value to write into the BinaryData at the current position
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    public function writeFloat(val:Number):void
    {
        COMPILE::SWF {
            return ba.writeFloat(val);
        }
        COMPILE::JS {
            if (_position + 4 > _len) {
                setBufferSize(_position + 4);
            }
            
            getDataView().setFloat32(_position,val,_endian == Endian.LITTLE_ENDIAN);
            _position += 4;
        }
    }
    /**
     *  Writes an IEEE 754 double-precision (64-bit) floating-point number to the
     *  BinaryData at the current position
     *
     *  @param {Number} val The value to write into the BinaryData at the current position
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    public function writeDouble(val:Number):void
    {
        COMPILE::SWF {
            return ba.writeDouble(val);
        }
        COMPILE::JS {
            if (_position + 8 > _len) {
                setBufferSize(_position + 8);
            }
            getDataView().setFloat64(_position,val,_endian == Endian.LITTLE_ENDIAN);
            _position += 8;
        }
    }
    /**
     *  Reads a Boolean value (as a single byte) at the current position.
     *  returns true if the byte was non-zero, false otherwise
     *
     *  @return {Boolean} The boolean value read from the current position
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */

    public function readBoolean():Boolean
    {
        COMPILE::SWF
        {
            return ba.readBoolean();
        }
        COMPILE::JS
        {
            return Boolean(getTypedArray()[_position++]);
        }
    }

    /**
     *  Read a signed byte of binary data at the current position
     *
     *  @return {int} An int value in the range -128 to 127, read from the current position
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    public function readByte():int
    {
        COMPILE::SWF
        {
            return ba.readByte();
        }
        COMPILE::JS
        {
            return readUnsignedByte() << 24 >> 24;
        }
    }
    /**
     *  Read an unsigned byte of binary data at the current position
     *
     *  @return {uint} An uint value in the range 0 to 255, read from the current position
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    public function readUnsignedByte():uint {
        COMPILE::SWF
        {
            return ba.readUnsignedByte();
        }
        COMPILE::JS
        {
            return getTypedArray()[_position++];
        }
    }

    /**
     *  Reads the number of data bytes, specified by the length parameter, from the BinaryData.
     *  The bytes are read into the BinaryData object specified by the destination parameter,
     *  and the bytes are written into the destination BinaryData starting at the position specified by offset.
     *  If length is omitted or is zero, all bytes are read following the current position to the end
     *  of this BinaryData. If offset is also omitted, it defaults to zero.
     *
     *  @param {BinaryData} bytes The destination BinaryData to write bytes into from the current position
     *  @param {uint} offset The optional offset value of the starting bytes to write inside destination
     *  @param {uint} length The optional length value of the bytes to read
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    public function readBinaryData(bytes:BinaryData, offset:uint = 0, length:uint = 0):void
    {
		if (!bytes) throw new TypeError('Error #2007: Parameter bytes must be non-null.');
        if (bytes == this) throw new Error('Parameter bytes must be another instance.');
        COMPILE::SWF
        {
            ba.readBytes(bytes.ba,offset,length);
        }

        COMPILE::JS
        {
			if (length == 0) length = _len - _position ;
            bytes.mergeInToArrayBuffer(offset,new Uint8Array(ba, _position, length));
			_position+=length;
        }
    }
    
    COMPILE::SWF
    public function readBytes(bytes:ByteArray, offset:uint = 0, length:uint = 0):void {
        ba.readBytes(bytes, offset, length);
    }
    
	
	COMPILE::JS
    public function readBytes(bytes:ArrayBuffer, offset:uint = 0, length:uint = 0):void {
		if (!bytes) throw new TypeError('Error #2007: Parameter bytes must be non-null.');
        if(bytes == ba) throw new Error('cannot read into internal ArrayBuffer as both destination and source');
		if (length == 0) length = _len - _position ;
		//extend the destination length if necessary
		var extra:int = offset + length - bytes.byteLength;
        if (extra > 0)  throw new Error('cannot read into destination ArrayBuffer, insufficient fixed length');
		var src:Uint8Array = new Uint8Array(ba, _position, length);
		var dest:Uint8Array = new Uint8Array(bytes, offset, length);
		
		dest.set(src);
		_position+=length;
    }
	

    /**
     *  Read a byte of binary data at the specified index. Does not change the <code>position</code> property.
     *  If an index is out of range (beyond the current length) this will return zero.
     *
     *  @return {uint} A byte value in the range 0-255 from the index
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    public function readByteAt(idx:uint):uint
    {
        COMPILE::SWF
        {
            return ba[idx];
        }
        COMPILE::JS
        {
            return getTypedArray()[idx] >> 0;
        }
    }

    COMPILE::JS
	protected var _typedArray:Uint8Array;

    COMPILE::JS
    protected function getTypedArray():Uint8Array
    {
        if(_typedArray == null)
            _typedArray = new Uint8Array(ba);
        return _typedArray;
    }

    COMPILE::JS
	protected var _dataView:DataView;

    COMPILE::JS
	protected function getDataView():DataView
    {
        if(!_dataView)
            _dataView = new DataView(ba);
        return _dataView;
    }


    /**
     *  Writes a byte of binary data at the specified index. Does not change the <code>position</code> property.
     *  This is a method for optimzed writes with no range checking.
     *  If the specified index is out of range, it can throw an error.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    public function writeByteAt(idx:uint,byte:int):void
    {
        COMPILE::SWF
        {
            ba[idx] = byte;
        }
        COMPILE::JS
        {
            if (idx >= _len) {
                setBufferSize(idx+1);
            }
            getTypedArray()[idx] = byte;
        }
    }

    /**
     *  Read a short int of binary data at the current position
     *
     *  @return {int} An int value in the range -32768 to 32767, read from the current position
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    public function readShort():int
    {
        COMPILE::SWF
        {
            return ba.readShort();
        }
        COMPILE::JS
        {
           return readUnsignedShort() << 16 >> 16;
        }
    }

    /**
     *  Read an unsigned int (32bit) of binary data at the current position
     *
     *  @return {uint} A uint value, read from the current position
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    public function readUnsignedInt():uint
    {
        COMPILE::SWF
        {
            return ba.readUnsignedInt();
        }
        COMPILE::JS
        {
            var arr:Uint8Array = getTypedArray();
            if(endian == Endian.BIG_ENDIAN){
                return ((arr[_position++] << 24) >>> 0) + (arr[_position++] << 16) + ( arr[_position++] << 8) + arr[_position++];
            } else {
                return arr[_position++] + ( arr[_position++] << 8) + (arr[_position++] << 16) + ((arr[_position++] << 24) >>> 0);
            }
        }
    }

    /**
     *  Read an unsigned short (16bit) of binary data at the current position
     *
     *  @return {uint} A uint value in the range 0 to 65535, read from the current position
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    public function readUnsignedShort():uint {
        COMPILE::SWF
        {
            return ba.readUnsignedShort();
        }
        COMPILE::JS
        {
            var arr:Uint8Array = getTypedArray();
            if(endian == Endian.BIG_ENDIAN){
                return ( arr[_position++] << 8) + arr[_position++];
            } else {
                return arr[_position++] + ( arr[_position++] << 8);
            }
        }
    }

    /**
     *  Read a signed int (32bit) of binary data at the current position
     *
     *  @return {int} An int value, read from the current position
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    public function readInt():int
    {
        COMPILE::SWF
        {
            return ba.readInt();
        }
        COMPILE::JS
        {
            return readUnsignedInt() << 32 >> 32;
        }
    }

    /**
     *  Reads an IEEE 754 single-precision (32-bit) floating-point number from the BinaryData.
     *
     *  @return {Number} A Number value, read from the current position
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    public function readFloat():Number
    {
        COMPILE::SWF {
            return ba.readFloat();
        }
        COMPILE::JS {
            var ret :Number = getDataView().getFloat32(_position,_endian == Endian.LITTLE_ENDIAN);
            _position += 4;
            return ret;
        }

    }

    /**
     *  Reads an IEEE 754 double-precision (64-bit) floating-point number from the BinaryData.
     *
     *  @return {Number} A Number value, read from the current position
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    public function readDouble():Number
    {
        COMPILE::SWF {
            return ba.readDouble();
        }
        COMPILE::JS {
            var ret:Number = getDataView().getFloat64(_position,_endian == Endian.LITTLE_ENDIAN);
            _position += 8;
            return ret;
        }
    }

    COMPILE::JS
    protected var _len:uint;

    /**
     *  The length of this BinaryData, in bytes.
     *  If the length is set to a value that is larger than the current length, the right side
     *  of the BinaryData is filled with zeros.
     *  If the length is set to a value that is smaller than the current length, the BinaryData is truncated.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.7.0
     */
    public function get length():int
    {
        COMPILE::SWF
        {
            return ba.length;
        }
        COMPILE::JS
        {
            return _len;
        }
    }

    public function set length(value:int):void
    {
        COMPILE::SWF
        {
            ba.length = value;
        }

        COMPILE::JS
        {
            setBufferSize(value);
        }

    }

    COMPILE::JS
    protected function setBufferSize(newSize:uint):void
    {
        var n:uint = _len;
        if (n != newSize) {
            //note: ArrayBuffer.slice could be better for buffer size reduction
            //looks like it is only IE11+, so not using it here

            var newView:Uint8Array = new Uint8Array(newSize);
            var oldView:Uint8Array = new Uint8Array(ba, 0, Math.min(newSize,n));
            newView.set(oldView);
            ba = newView.buffer;
            if (_position > newSize) _position = newSize;
            _typedArray = newView;
            _dataView = null;
            _len = newSize;
        }
    }
    /**
     *  The total number of bytes available to read from the current position.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    public function get bytesAvailable():uint
    {
        COMPILE::SWF
        {
            return ba.bytesAvailable;
        }
        COMPILE::JS
        {
            return _position < _len ? _len - _position : 0;
        }
    }

    /**

     *  Moves, or returns the current position, in bytes, of the pointer into the BinaryData object.
     *  This is the point at which the next call to a read method starts reading or a write method starts writing.
     *
     *  Setting the position beyond the end of the current length value is possible and will increase the length
     *  during write operations, but will throw an error during read operations.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    public function get position():uint
    {
        COMPILE::SWF
        {
            return ba.position;
        }
        COMPILE::JS
        {
            return _position;
        }
    }

    /**
     *  @private
     */
    public function set position(value:uint):void
    {
        COMPILE::SWF
        {
            ba.position = value;
        }
        COMPILE::JS
        {
            _position = value;
        }
    }

    /**
     *  A convenience method to extend the length of the BinaryData
     *  so you can efficiently write more bytes to it. Not all
     *  browsers have a way to auto-resize a binary
     *  data as you write data to the binary data buffer
     *  and resizing in large chunks is generally more
     *  efficient anyway. Preallocating bytes to write into
     *  is also more efficient on the swf target.
     *
     *  @param extra The number of additional bytes.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    public function growBuffer(extra:uint):void
    {
        COMPILE::SWF
        {
            ba.length += extra;
        }

        COMPILE::JS
        {
            setBufferSize(_len + extra);
        }
    }


    /**
     *  Reads a UTF-8 string from the BinaryData.
     *  The string is assumed to be prefixed with an unsigned short indicating the length in bytes.
     *  The <code>position</code> is advanced to the first byte following the string's bytes.
     *
     *  @return {String} The utf-8 decoded string
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.7.0
     */
    public function readUTF():String
    {
        COMPILE::SWF
        {
            return ba.readUTF();
        }

        COMPILE::JS
        {
            var bytes:uint = readUnsignedShort();
            return this.readUTFBytes(bytes);
        }
    }

    /**
     *  Reads a sequence of UTF-8 bytes specified by the length parameter
     *  from the BinaryData and returns a string.
     *  The <code>position</code> is advanced to the first byte following the string's bytes.
     *
     *  @param {uint} length An unsigned integer indicating the length of the UTF-8 bytes.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.7.0
     */
    public function readUTFBytes(length:uint):String
    {
        COMPILE::SWF
        {
            return ba.readUTFBytes(length);
        }

        COMPILE::JS
        {
            // Code taken from GC
            // Use native implementations if/when available
            if (_position + length > _len) {
                throw new Error('Error #2030: End of file was encountered.');
            }
            var bytes:Uint8Array = new Uint8Array(ba,_position,length);
            if('TextDecoder' in window)
            {
                var decoder:TextDecoder = new TextDecoder('utf-8');
                _position += length;
                return decoder.decode(bytes);
            }

            var out:Array = [];
            var pos:int = 0;
            var c:int = 0;
            var c1:int;
            var c2:int;
            var c3:int;
            var c4:int;
            while (pos < bytes.length)
            {
                c1 = bytes[pos++];
                if (c1 < 128) {
                    out[c++] = String.fromCharCode(c1);
                }
                else if (c1 > 191 && c1 < 224)
                {
                    c2 = bytes[pos++];
                    out[c++] = String.fromCharCode((c1 & 31) << 6 | c2 & 63);
                }
                else if (c1 > 239 && c1 < 365)
                {
                    // Surrogate Pair
                    c2 = bytes[pos++];
                    c3 = bytes[pos++];
                    c4 = bytes[pos++];
                    var u:int = ((c1 & 7) << 18 | (c2 & 63) << 12 | (c3 & 63) << 6 | c4 & 63) - 0x10000;
                    out[c++] = String.fromCharCode(0xD800 + (u >> 10));
                    out[c++] = String.fromCharCode(0xDC00 + (u & 1023));
                }
                else
                {
                    c2 = bytes[pos++];
                    c3 = bytes[pos++];
                    out[c++] = String.fromCharCode((c1 & 15) << 12 | (c2 & 63) << 6 | c3 & 63);
                }
            }
            _position += length;
            return out.join('');
        }
    }


    /**
     *  Writes a UTF-8 string to the byte stream.
     *  The length of the UTF-8 string in bytes is written first, as a 16-bit unsigned integer,
     *  followed by the bytes representing the characters of the string.
     *  If the byte length of the string is larger than 65535 this will throw a RangeError
     *  The <code>position</code> is advanced to the first byte following the string's bytes.
     *
     *  @param {String} str The string value to be written.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.7.0
     */
    public function writeUTF(str:String):void
    {
        COMPILE::SWF
        {
            ba.writeUTF(str);
        }

        COMPILE::JS
        {
            var utcBytes:Uint8Array = getUTFBytes(str , true);
            _position =  mergeInToArrayBuffer (_position,utcBytes);
        }
    }

    /**
     *  Writes a UTF-8 string to the BinaryData. Similar to the writeUTF() method,
     *  but writeUTFBytes() does not prefix the string with a 16-bit length word, and
     *  therefore also permits strings longer than 65535 bytes (note: byte length will not
     *  necessarily be the same as string length because some characters can be
     *  multibyte characters).
     *
     *  @param {String} str The string value to be written.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.7.0
     */
    public function writeUTFBytes(str:String):void
    {
        COMPILE::SWF
        {
            ba.writeUTFBytes(str);
        }

        COMPILE::JS
        {
            var utcBytes:Uint8Array = getUTFBytes(str , false);
            _position = mergeInToArrayBuffer (_position , utcBytes);
        }
    }

    COMPILE::JS
    protected function mergeInToArrayBuffer(offset:uint, newBytes:Uint8Array):uint {
        var newContentLength:uint = newBytes.length;
        var dest:Uint8Array;
		var mergeUpperBound:uint = offset + newContentLength;
        if (mergeUpperBound > _len) {
            dest = new Uint8Array(mergeUpperBound);
            if (_len) {
                var copyOffset:uint = Math.min(offset, _len);
				if (copyOffset > 0){
					dest.set(new Uint8Array(ba, 0, copyOffset));
				}
            }
            dest.set(newBytes, offset);
            ba = dest.buffer;
            _typedArray = dest;
            _dataView = null;
			_len = mergeUpperBound;
        } else {
            dest = new Uint8Array(ba, offset, newContentLength);
            dest.set(newBytes);
        }
        return mergeUpperBound;
    }

    COMPILE::JS
    protected function getUTFBytes(str:String, prependLength:Boolean):Uint8Array {
        // Code taken from GC
        // Use native implementations if/when available
        var bytes:Uint8Array;
        if('TextEncoder' in window)
        {
            var encoder:TextEncoder = new TextEncoder('utf-8');
            bytes = encoder.encode(str);
        } else {
            var out:Array = [];
            var p:int = 0;
            var c:int;
            for (var i:int = 0; i < str.length; i++)
            {
                c = str.charCodeAt(i);
                if (c < 128)
                {
                    out[p++] = c;
                }
                else if (c < 2048)
                {
                    out[p++] = (c >> 6) | 192;


                    out[p++] = (c & 63) | 128;
                }
                else if (((c & 0xFC00) == 0xD800) && (i + 1) < str.length &&
                        ((str.charCodeAt(i + 1) & 0xFC00) == 0xDC00))
                {
                    // Surrogate Pair
                    c = 0x10000 + ((c & 0x03FF) << 10) + (str.charCodeAt(++i) & 0x03FF);
                    out[p++] = (c >> 18) | 240;
                    out[p++] = ((c >> 12) & 63) | 128;
                    out[p++] = ((c >> 6) & 63) | 128;
                    out[p++] = (c & 63) | 128;
                }
                else
                {
                    out[p++] = (c >> 12) | 224;
                    out[p++] = ((c >> 6) & 63) | 128;
                    out[p++] = (c & 63) | 128;
                }
            }

            bytes = new Uint8Array(out);
        }
        if (prependLength) {
            var len:uint = bytes.length;
            if (len > 0xffff) {
                //throw error, similar to swf ByteArray behavior:
                throw new RangeError("UTF max string length of 65535 bytes exceeded : BinaryData.writeUTF");
            }
            var temp:Uint8Array = new Uint8Array(bytes.length + 2);
            temp.set(bytes , 2);
            //pre-convert to alternate endian if needed
            new Uint16Array(temp.buffer,0,1)[0] =
                    _sysEndian ? len : (((len & 0xff00) >> 8) | ((len & 0xff) << 8));

            bytes = temp;
        }
        return bytes;
    }
    
    //required for interface compatibility on swf
    COMPILE::SWF
    public function readMultiByte(length:uint, charSet:String):String {
        return ba.readMultiByte(length, charSet);
    }
	
	COMPILE::SWF
	public function writeMultiByte(value:String, charSet:String):void{
		ba.writeMultiByte(value, charSet);
	}

}
}
