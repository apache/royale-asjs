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
package org.apache.flex.utils
{

COMPILE::SWF
{
    import flash.utils.ByteArray;
}


/**
 *  The BinaryData class is a class that represents binary data.  The way
 *  browsers handle binary data varies.  This class abstracts those
 *  differences..
 *
 *  @langversion 3.0
 *  @playerversion Flash 10.2
 *  @playerversion AIR 2.6
 *  @productversion FlexJS 0.0
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
     *  @productversion FlexJS 0.0
     */
    COMPILE::SWF
    public function BinaryData(bytes:ByteArray = null)
    {
        ba = bytes ? bytes : new ByteArray();
    }

    COMPILE::JS
    public function BinaryData(bytes:ArrayBuffer = null)
    {
        ba = bytes ? bytes : new ArrayBuffer(0);
    }

    /**
     *  Utility method to create a BinaryData object from a string.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.7.0
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
     *  This is primarily used for indexed access to the bytes, and internally
     *  where the platform-specific implementation is significant.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.7.0
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
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.7.0
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
     *  The default is the target default which in Javascript is machine dependent.
     *  It is possible to check the default Endianness of the target platform at runtime with
     *  <code>org.apache.flex.utils.Endian.defaultEndian</code>
     *  To ensure portable bytes, set the endian to Endian.BIG_ENDIAN or Endian.LITTLE_ENDIAN as appropriate.
     *  Setting to values other than Endian.BIG_ENDIAN or Endian.LITTLE_ENDIAN is ignored.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.7.0
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
        if (value == Endian.BIG_ENDIAN || Endian.LITTLE_ENDIAN) {
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
    private var ba:ByteArray;

    COMPILE::JS
    private var ba:ArrayBuffer;

    COMPILE::JS
    private var _position:int = 0;

    /**
     * Get the platform-specific data for sending.
     * Generally only used by the network services.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
    public function get data():Object
    {
        return ba;
    }

    /**
     *  Write a Boolean value (as a single byte) at the current position
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
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
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
    public function writeByte(byte:int):void
    {
        COMPILE::SWF
        {
            ba.writeByte(byte);
        }
        COMPILE::JS
        {
            var view:Uint8Array;

            ensureWritableBytes(1);

            view = new Uint8Array(ba, _position, 1);
            view[0] = byte;
            _position++;
        }
    }
    /**
     *  Writes a sequence of <code>length</code> bytes from the <code>source</code> BinaryData, starting
     *  at <code>offset</code> (zero-based index) bytes into the source BinaryData. If length
     *  is omitted or is zero, it will represent the entire length of the source
     *  starting from offset. If offset is omitted also, it defaults to zero.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
    public function writeBytes(source:BinaryData, offset:uint = 0, length:uint = 0):void
    {
        COMPILE::SWF
        {
            ba.writeBytes(source.ba,offset,length);
        }

        COMPILE::JS
        {

            if (length == 0) length = source.length - offset ;

            ensureWritableBytes(length);

            var dest:Uint8Array = new Uint8Array(ba, _position, length);
            var src:Uint8Array = new Uint8Array(source.ba, offset,length);
            dest.set(src);
            _position += length;
        }

    }

    /**
     *  Write a short integer of binary data at the current position
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
    public function writeShort(short:int):void
    {
        COMPILE::SWF
        {
            ba.writeShort(short);
        }
        COMPILE::JS
        {
            if (!_sysEndian) {
                short = (((short & 0xff00) >>> 8) | ((short & 0xff) <<8 ));
            }
            ensureWritableBytes(2);
            new Int16Array(ba, _position, 1)[0] = short;
            _position += 2;
        }
    }

    /**
     *  Write an unsigned int (32 bits) of binary data at the current position
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
    public function writeUnsignedInt(unsigned:uint):void
    {
        COMPILE::SWF
        {
            ba.writeUnsignedInt(unsigned);
        }
        COMPILE::JS
        {
            if (!_sysEndian) {
                unsigned = ((unsigned & 0xff000000) >>> 24) | ((unsigned & 0x00ff0000) >> 8) | ((unsigned & 0x0000ff00) << 8) | (unsigned << 24);
            }
            ensureWritableBytes(4);
            new Uint32Array(ba, _position, 1)[0] = unsigned;
            _position += 4;
        }
    }

    /**
     *  Write a signed int (32 bits) of binary data at the current position
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
    public function writeInt(val:int):void
    {
        COMPILE::SWF
        {
            ba.writeInt(val);
        }
        COMPILE::JS
        {
            if (!_sysEndian) {
                val = (((val & 0xff000000) >>> 24) | ((val & 0x00ff0000) >> 8) | ((val & 0x0000ff00) << 8) | (val << 24)) >> 0;
            }
            ensureWritableBytes(4);
            new Int32Array(ba, _position, 1)[0] = val;
            _position += 4;
        }
    }

    /**
     *  Writes an IEEE 754 single-precision (32-bit) floating-point number to the
     *  BinaryData at the current position
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
    public function writeFloat(value:Number):void
    {
        COMPILE::SWF {
            return ba.writeFloat(value);
        }
        COMPILE::JS {
            var view:Float32Array;

            ensureWritableBytes(4);

            if(_sysEndian)
            {
                view = new Float32Array(ba, _position, 1);
                view[0] = value;
            }
            else
            {
                var dv:DataView = new DataView(ba);
                dv.setFloat32(_position,value,_endian == Endian.LITTLE_ENDIAN);
            }
            _position += 4;
        }
    }
    /**
     *  Writes an IEEE 754 double-precision (64-bit) floating-point number to the
     *  BinaryData at the current position
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
    public function writeDouble(value:Number):void
    {
        COMPILE::SWF {
            return ba.writeDouble(value);
        }
        COMPILE::JS {
            var view:Float64Array;

            ensureWritableBytes(8);

            if(_sysEndian)
            {
                view = new Float64Array(ba, _position, 1);
                view[0] = value;
            }
            else
            {
                var dv:DataView = new DataView(ba);
                dv.setFloat64(_position,value,_endian == Endian.LITTLE_ENDIAN);
            }
            _position += 8;
        }
    }
    /**
     *  Reads a Boolean value (as a single byte) at the current position.
     *  returns true if the byte was non-zero, false otherwise
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */

    public function readBoolean():Boolean
    {
        COMPILE::SWF
        {
            return ba.readBoolean();
        }
        COMPILE::JS
        {
            return Boolean(readUnsignedByte());
        }
    }

    /**
     *  Read a signed byte of binary data at the current position
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
    public function readByte():int
    {
        COMPILE::SWF
        {
            return ba.readByte();
        }
        COMPILE::JS
        {
            var view:Int8Array = new Int8Array(ba, _position, 1);
            _position++;
            return view[0];
        }
    }
    /**
     *  Read an unsigned byte of binary data at the current position
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
    public function readUnsignedByte():uint {
        COMPILE::SWF
        {
            return ba.readUnsignedByte();
        }
        COMPILE::JS
        {
            var view:Uint8Array = new Uint8Array(ba, _position, 1);
            _position++;
            return view[0];
        }
    }

    /**
     *  Reads the number of data bytes, specified by the length parameter, from the BinaryData.
     *  The bytes are read into the BinaryData object specified by the destination parameter,
     *  and the bytes are written into the destination BinaryData starting at the position specified by offset.
     *  If length is omitted or is zero, all bytes are read following offset to the end of this BinaryData.
     *  If offset is also omitted, it defaults to zero.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
    public function readBytes(destination:BinaryData, offset:uint = 0, length:uint = 0):void
    {
        COMPILE::SWF
        {
            ba.readBytes(destination.ba,offset,length);
        }

        COMPILE::JS
        {
            //do we need to check offset and length and sanitize or throw an error?

            if (length == 0) length = ba.byteLength - _position ;
            //extend the destination length if necessary
            var extra:int = offset + length - destination.ba.byteLength;
            if (extra > 0)
                destination.growBuffer(extra);
            var src:Uint8Array = new Uint8Array(ba, _position,length);
            var dest:Uint8Array = new Uint8Array(destination.ba, offset, length);

            dest.set(src);
            //todo: check position behavior vs. flash implementation (do either or both advance their internal position) :
            _position+=length;
        }

    }

    /**
     *  Read a byte of binary data at the specified index. Does not change the <code>position</code> property.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
    public function readByteAt(idx:uint):int
    {
        COMPILE::SWF
        {
            return ba[idx];
        }
        COMPILE::JS
        {
            return getTypedArray()[idx];
        }
    }

    COMPILE::JS
    private var _typedArray:Uint8Array;

    COMPILE::JS
    private function getTypedArray():Uint8Array
    {
        if(_typedArray == null)
            _typedArray = new Uint8Array(ba);
        return _typedArray;
    }


    /**
     *  Writes a byte of binary data at the specified index. Does not change the <code>position</code> property.
     *  This is a method for optimzed writes with no range checking.
     *  If the specified index is out of range, it can throw an error.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
    public function writeByteAt(idx:uint,byte:int):void
    {
        COMPILE::SWF
        {
            ba[idx] = byte;
        }
        COMPILE::JS
        {
            if (idx >= ba.byteLength) {
                setBufferSize(idx+1);
            }
            getTypedArray()[idx] = byte;
        }
    }

    /**
     *  Read a short int of binary data at the current position
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
    public function readShort():int
    {
        COMPILE::SWF
        {
            return ba.readShort();
        }
        COMPILE::JS
        {
            var ret:int = new Int16Array(ba, _position, 1)[0];
            if (!_sysEndian) {
                //special case conversion for short int return value to 32 bit int
                ret = ((((ret & 0xff00) >> 8) | ((ret & 0xff) << 8)) << 16) >> 16;
            }
            _position += 2;
            return ret;
        }
    }

    /**
     *  Read an unsigned int of binary data at the current position
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
    public function readUnsignedInt():uint
    {
        COMPILE::SWF
        {
            return ba.readUnsignedInt();
        }
        COMPILE::JS
        {
            var ret:uint = new Uint32Array(ba, _position, 1)[0];
            if (!_sysEndian) {
                ret = (((ret & 0xff000000) >>> 24) | ((ret & 0x00ff0000) >>> 8) | ((ret & 0x0000ff00) << 8) | (ret << 24)) >>> 0;
            }
            _position += 4;
            return ret;
        }
    }

    /**
     *  Read an unsigned short (16bit) of binary data at the current position
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
    public function readUnsignedShort():uint {
        COMPILE::SWF
        {
            return ba.readUnsignedShort();
        }
        COMPILE::JS
        {

            var ret:uint = new Uint16Array(ba, _position, 1)[0];
            if (!_sysEndian) {
                ret = ((ret & 0xff00) >> 8 ) | ((ret & 0xff) << 8);
            }
            _position += 2;
            return ret;
        }
    }

    /**
     *  Read a signed int of binary data at the current position
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
    public function readInt():int
    {
        COMPILE::SWF
        {
            return ba.readInt();
        }
        COMPILE::JS
        {
            var ret:int = new Int32Array(ba, _position, 1)[0];
            if (!_sysEndian) {
                ret = (((ret & 0xff000000) >>> 24) | ((ret & 0x00ff0000) >>> 8) | ((ret & 0x0000ff00) << 8) | (ret << 24)) >> 0;
            }
            _position += 4;
            return ret;
        }
    }

    /**
     *  Reads an IEEE 754 single-precision (32-bit) floating-point number from the BinaryData.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
    public function readFloat():Number
    {
        COMPILE::SWF {
            return ba.readFloat();
        }
        COMPILE::JS {
            var view:Float32Array;

            if(_sysEndian)
            {
                view = new Float32Array(ba, _position, 1);
                _position += 4;
                return view[0];
            }
            var dv:DataView = new DataView(ba);
            var i:Number = dv.getFloat32(_position,_endian == Endian.LITTLE_ENDIAN);
            _position += 4;
            return i;
        }

    }

    /**
     *  Reads an IEEE 754 double-precision (64-bit) floating-point number from the BinaryData.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
    public function readDouble():Number
    {
        COMPILE::SWF {
            return ba.readDouble();
        }
        COMPILE::JS {
            var view:Float64Array;

            if(_sysEndian)
            {
                view = new Float64Array(ba, _position, 1);
                _position += 8;
                return view[0];
            }
            var dv:DataView = new DataView(ba);
            var i:Number = dv.getFloat64(_position,_endian == Endian.LITTLE_ENDIAN);
            _position += 8;
            return i;
        }
    }


    public function get length():int
    {
        COMPILE::SWF
        {
            return ba.length;
        }
        COMPILE::JS
        {
            return ba.byteLength;
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
    protected function setBufferSize(newSize):void
    {
        var n:uint = ba.byteLength;
        if (n != newSize) {
            //note: ArrayBuffer.slice could be better for buffer size reduction
            //looks like it is only IE11+, so not using it here

            var newView:Uint8Array = new Uint8Array(newSize);
            var oldView:Uint8Array = new Uint8Array(ba, 0, Math.min(newSize,n));
            newView.set(oldView);
            ba = newView.buffer;
            if (_position > newSize) _position = newSize;
            _typedArray = newView;
        }
    }
    /**
     *  The total number of bytes remaining to be read.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
    public function get bytesAvailable():uint
    {
        COMPILE::SWF
        {
            return ba.bytesAvailable;
        }
        COMPILE::JS
        {
            return ba.byteLength - _position;
        }
    }

    /**

     *  Moves, or returns the current position, in bytes, of the pointer into the BinaryData object.
     *  This is the point at which the next call to a read method starts reading or a write method starts writing.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
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
     *  efficient anyway.
     *
     *  @param extra The number of additional bytes.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
    public function growBuffer(extra:uint):void
    {
        COMPILE::SWF
        {
            ba.length += extra;
        }

        COMPILE::JS
        {
            setBufferSize(ba.byteLength + extra);
        }
    }

    COMPILE::JS
    protected function ensureWritableBytes(len:uint):void{
        if (_position + len > ba.byteLength) {
            setBufferSize( _position + len );
        }
    }


    /**
     *  Reads a UTF-8 string from the byte stream.
     *  The string is assumed to be prefixed with an unsigned short indicating the length in bytes.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.7.0
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
     *  Reads a sequence of UTF-8 bytes specified by the length parameter from the byte stream and returns a string.
     *
     *  @param An unsigned short indicating the length of the UTF-8 bytes.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.7.0
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
     *  The length of the UTF-8 string in bytes is written first, as a 16-bit integer,
     *  followed by the bytes representing the characters of the string.
     *  If the byte length of the string is larger than 65535 this will throw a RangeError
     *
     *  @param The string value to be written.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.7.0
     */
    public function writeUTF(value:String):void
    {
        COMPILE::SWF
        {
            ba.writeUTF(value);
        }

        COMPILE::JS
        {
            var utcBytes:Uint8Array = getUTFBytes(value , true);
            _position =  mergeInToArrayBuffer (_position,utcBytes);
        }
    }

    /**
     *  Writes a UTF-8 string to the byte stream. Similar to the writeUTF() method,
     *  but writeUTFBytes() does not prefix the string with a 16-bit length word.
     *
     *  @param The string value to be written.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.7.0
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
    private function mergeInToArrayBuffer(offset:uint, newBytes:Uint8Array):uint {
        var newContentLength:uint = newBytes.length;
        var dest:Uint8Array;
        if (offset + newContentLength > ba.byteLength) {
            dest = new Uint8Array(offset + newContentLength);
            dest.set(new Uint8Array(ba, 0, offset));
            dest.set(newBytes, offset);
            ba = dest.buffer;
            _typedArray = dest;
        } else {
            dest = new Uint8Array(ba, offset, newContentLength);
            dest.set(newBytes);
        }
        return offset + newContentLength;
    }

    COMPILE::JS
    private function getUTFBytes(str:String, prependLength:Boolean):Uint8Array {
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

}
}
