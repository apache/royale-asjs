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
package org.apache.royale.utils {
COMPILE::SWF{
    import flash.utils.ByteArray
}
public interface IBinaryDataInput {

    function readBinaryData(bytes:BinaryData, offset:uint = 0, length:uint = 0):void;

    COMPILE::SWF{
		function readBytes(bytes:ByteArray, offset:uint = 0, length:uint = 0):void;
    }
	
	COMPILE::JS{
		function readBytes(bytes:ArrayBuffer, offset:uint = 0, length:uint = 0):void;
	}
    
    function readBoolean():Boolean;
    function readByte():int;
    function readUnsignedByte():uint;
    function readShort():int;
    function readUnsignedShort():uint;
    function readInt():int;
    function readUnsignedInt():uint;

    function readFloat():Number;
    function readDouble():Number;
  //  function readMultiByte(length:uint, charSet:String):String;
    function readUTF():String;
    function readUTFBytes(length:uint):String;

    function get bytesAvailable():uint;

    function get endian():String;
    function set endian(type:String):void;
}
}
