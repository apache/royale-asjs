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
     *  Constructor.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
	public function BinaryData()
	{
		
	}
	
    COMPILE::SWF
	private var ba:ByteArray = new ByteArray();
	
    COMPILE::JS
    private var ba:ArrayBuffer = new ArrayBuffer(0);
    
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
            var view:Int8Array;
            
            growBuffer(1);
            
            view = new Int8Array(ba, _position, 1);
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
            var view:Int8Array;
            
            view = new Int8Array(ba, _position, 1);
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
            var newView:Int8Array;
            var view:Int8Array;
            var i:int;
            var n:int;
            
            if (_position >= ba.byteLength)
            {
                n = ba.byteLength;
                newBuffer = new ArrayBuffer(n + extra);
                newView = new Int8Array(newBuffer, 0, n);
                view = new Int8Array(ba, 0, n);
                for (i = 0; i < n; i++)
                {
                    newView[i] = view[i];
                }
                ba = newBuffer;
            }
        }
	}
}
}
