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
import flash.utils.ByteArray;

    
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
	
	private var ba:ByteArray = new ByteArray();
	
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
		ba.writeByte(byte);
	}
	
    /**
     *  Write a short integer of binary data at the current position
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
	public function writeShort(byte:int):void
	{
		ba.writeShort(byte);
	}
	
    /**
     *  Write an unsigned int of binary data at the current position
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
	public function writeUnsignedInt(byte:uint):void
	{
		ba.writeUnsignedInt(byte);
	}

    /**
     *  Write a signed int of binary data at the current position
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
	public function writeInt(byte:uint):void
	{
		ba.writeInt(byte);
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
		return ba.readByte();
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
		return ba.readShort();
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
		return ba.readUnsignedInt();
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
		return ba.readInt();
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
		return ba.length;
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
		return ba.bytesAvailable;
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
		return ba.position;
	}
	
    /**
     *  @private
     */
	public function set position(value:int):void
	{
		ba.position = value;
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
	}
}
}
