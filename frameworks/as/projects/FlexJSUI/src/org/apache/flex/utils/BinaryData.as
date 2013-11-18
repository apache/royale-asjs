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

public class BinaryData
{
	public function BinaryData()
	{
		
	}
	
	private var ba:ByteArray = new ByteArray();
	
	/**
	 * Get the platform-specific data for sending.
	 * Generally only used by the network services.
	 */
	public function get data():Object
	{
		return ba;
	}
	
	public function writeByte(byte:int):void
	{
		ba.writeByte(byte);
	}
	
	public function writeShort(byte:int):void
	{
		ba.writeShort(byte);
	}
	
	public function writeUnsignedInt(byte:uint):void
	{
		ba.writeUnsignedInt(byte);
	}

	public function writeInt(byte:uint):void
	{
		ba.writeInt(byte);
	}

	public function readByte():int
	{
		return ba.readByte();
	}
	
	public function readShort():int
	{
		return ba.readShort();
	}
	
	public function readUnsignedInt():uint
	{
		return ba.readUnsignedInt();
	}
	
	public function readInt():int
	{
		return ba.readInt();
	}

	public function get length():int
	{
		return ba.length;
	}
	
	public function get bytesAvailable():int
	{
		return ba.bytesAvailable;
	}

	public function get position():int
	{
		return ba.position;
	}
	
	public function set position(value:int):void
	{
		ba.position = value;
	}
	
	public function growBuffer(extra:int):void
	{
		// no need to do anything in AS
	}
}
}
