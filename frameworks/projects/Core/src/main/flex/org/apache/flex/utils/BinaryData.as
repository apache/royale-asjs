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
public class BinaryData
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
            
            growBuffer(1);
            
            view = new Uint8Array(ba, _position, 1);
            view[0] = byte;
            _position++;
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
            var view:Int16Array;
            
            growBuffer(2);
            
            view = new Int16Array(ba, _position, 1);
            view[0] = short;
            _position += 2;
        }
	}
	
    /**
     *  Write an unsigned int of binary data at the current position
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
            var view:Uint32Array;
            
            growBuffer(4);
            
            view = new Uint32Array(ba, _position, 1);
            view[0] = unsigned;
            _position += 4;
        }
	}

    /**
     *  Write a signed int of binary data at the current position
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
	public function writeInt(integer:uint):void
	{
        COMPILE::SWF
        {
            ba.writeInt(integer);                
        }
        COMPILE::JS
        {
            var view:Int32Array;
            
            growBuffer(4);
            
            view = new Int32Array(ba, _position, 1);
            view[0] = integer;
            _position += 4;
        }
	}

    /**
     *  Read a byte of binary data at the current position
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
            var view:Uint8Array;
            
            view = new Uint8Array(ba, _position, 1);
            _position++;
            return view[0];
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
            var view:Int16Array;
            
            view = new Int16Array(ba, _position, 1);
            _position += 2;
            return view[0];
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
            var view:Uint32Array;
            
            view = new Uint32Array(ba, _position, 1);
            _position += 4;
            return view[0];
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
            var view:Int32Array;
            
            view = new Int32Array(ba, _position, 1);
            _position += 4;
            return view[0];
        }
	}

    /**
     *  The total number of bytes of data.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
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
    private function setBufferSize(newSize):void
    {
        var n:int = ba.byteLength;
        var newBuffer:ArrayBuffer = new ArrayBuffer(newSize);
        var newView:Uint8Array = new Uint8Array(newBuffer, 0, n);
        var view:Uint8Array = new Uint8Array(ba, 0, Math.min(newSize,n));
        newView.set(view);
        ba = newBuffer;
    }
    /**
     *  The total number of bytes remaining to be read.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
	public function get bytesAvailable():int
	{
        COMPILE::SWF
        {
            return ba.bytesAvailable;                
        }
        COMPILE::JS
        {
            return ba.byteLength - position;
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
	public function get position():int
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
	public function set position(value:int):void
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
	
    public function doNothing():void
    {
        var b:String = "bla";
    }
    /**
     *  A method to extend the size of the binary data
     *  so you can write more bytes to it.  Not all
     *  browsers have a way to auto-resize a binary
     *  data as you write data to the binary data buffer
     *  and resizing in large chunks in generally more
     *  efficient anyway.
     * 
     *  @param extra The number of additional bytes.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
	public function growBuffer(extra:int):void
	{
		// no need to do anything in AS
        COMPILE::JS
        {
            var newBuffer:ArrayBuffer;
            var newView:Uint8Array;
            var view:Uint8Array;
            var i:int;
            var n:int;
            
            if (_position >= ba.byteLength)
            {
                n = ba.byteLength;
                newBuffer = new ArrayBuffer(n + extra);
                newView = new Uint8Array(newBuffer, 0, n);
                view = new Uint8Array(ba, 0, n);
                for (i = 0; i < n; i++)
                {
                    newView[i] = view[i];
                }
                ba = newBuffer;
            }
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
        // no need to do anything in AS
        COMPILE::JS
        {
            //TODO Doing nothing about the length for now
            return this.readUTFBytes(ba.byteLength);
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
            return out.join('');
        }
    }


    /**
     *  Writes a UTF-8 string to the byte stream.
     *  The length of the UTF-8 string in bytes is written first, as a 16-bit integer,
     *  followed by the bytes representing the characters of the string. 
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
            return ba.writeUTF(value);
        }

        COMPILE::JS
        {
            //TODO Doing nothing about the length for now
            return this.writeUTFBytes(value);
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
            // Code taken from GC
            // Use native implementations if/when available
            var bytes:Uint8Array;
            if('TextEncoder' in window)
            {
                var encoder:TextEncoder = new TextEncoder('utf-8');
                bytes = encoder.encode(str);
                ba = bytes.buffer;
                return;
            }

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
            ba = bytes.buffer;

        }
    }
}
}
