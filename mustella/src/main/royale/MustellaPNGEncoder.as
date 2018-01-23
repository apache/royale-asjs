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

/**
 * writes bitmaps into PNG format. 
 * original author, Ely
 */
package  {

	import flash.display.*;
	import flash.geom.*;
	import flash.utils.*;
	import flash.net.*;
	
public class MustellaPNGEncoder {
	
	
	private var _png:ByteArray;

	// empty constructor
	public function MustellaPNGEncoder () { 
	}
	
	public function encode(img:BitmapData):ByteArray
	{
		var imgWidth:uint = img.width;
		var imgHeight:uint = img.height;

		var imgData:ByteArray = img.getPixels(new Rectangle(0,0,imgWidth,imgHeight));
				
		_png = new ByteArray();
		
		_png.writeByte(137);
		_png.writeByte(80);
		_png.writeByte(78);
		_png.writeByte(71);
		_png.writeByte(13);
		_png.writeByte(10);
		_png.writeByte(26);
		_png.writeByte(10);
		
		var IHDR:ByteArray = new ByteArray();
		IHDR.writeInt(imgWidth);
		IHDR.writeInt(imgHeight);
		IHDR.writeByte(8); // color depth: 8 bpp
		IHDR.writeByte(6); // color type: RGBA
		IHDR.writeByte(0); // compression: ZLIB
		IHDR.writeByte(0); // filter method
		IHDR.writeByte(0); // not interlaced;
		
		writeChunk([0x49,0x48,0x44,0x52],IHDR);
		
		var IDAT:ByteArray= new ByteArray();
		for(var i:uint=0;i<imgHeight;i++) {
			IDAT.writeByte(0);
			for(var j:uint=0;j<imgWidth;j++) {
				var p:uint = img.getPixel32(j,i);
				IDAT.writeByte((p>>16)&0xFF);
				IDAT.writeByte((p>> 8)&0xFF);
				IDAT.writeByte((p    )&0xFF);
				IDAT.writeByte((p>>24)&0xFF);
			}
		}		
		
		IDAT.compress();
		writeChunk([0x49,0x44,0x41,0x54],IDAT);



		writeChunk([0x49,0x45,0x4E,0x44],null);
		return _png;
	}

	public function dump():String
	{
		_png.position = 0;
		var out:String ="";
		for(var i:uint=0;i<_png.length;i++) {
			var code:String = "0123456789abcdef";
			var v:uint = _png.readUnsignedByte();
			out += code.charAt((v & 0xF0) >> 4);
			out += code.charAt(v & 0xF);
			out += " ";
		}
		return out;
	}
	private function writeChunk(type:Array,data:ByteArray):void
	{
		var len:uint = 0;
		if(data != null)
			len = data.length; // data length
		_png.writeUnsignedInt(len);

		var p:uint = _png.position;

		_png.writeByte(type[0]);
		_png.writeByte(type[1]);
		_png.writeByte(type[2]);
		_png.writeByte(type[3]);
		if(data != null)
			_png.writeBytes(data);
		
		var endP:uint = _png.position;
		_png.position = p;
		var c:uint = crc(_png,endP-p);
		_png.position = endP;
		_png.writeUnsignedInt(c);
	}

   /* Table of CRCs of all 8-bit messages. */
   private static var crc_table:Array;
   
   /* Flag: has the table been computed? Initially false. */
   private static var crc_table_computed:Boolean = false;
   
   /* Make the table for a fast CRC. */
   private function make_crc_table():void
   {
     var c:uint;
     var n:int;
     var k:int;
   
   	 crc_table = [];
   	 
     for (n = 0; n < 256; n++) {
       c = n;
       for (k = 0; k < 8; k++) {
         if (c & 1)
           c = uint(uint(0xedb88320) ^ uint(c >>> 1));
         else
           c = uint(c >>> 1);
       }
       crc_table[n] = c;
     }
     crc_table_computed = true;
   }
   
   /* Update a running CRC with the bytes buf[0..len-1]--the CRC
      should be initialized to all 1's, and the transmitted value
      is the 1's complement of the final running CRC (see the
      crc() routine below)). */
   
   private function update_crc(crc:uint, buf:ByteArray,
                            len:uint):uint
   {
     var c:uint = crc;
     var n:int;
	var v:uint;
	   
     if (!crc_table_computed)
       make_crc_table();
     for (n = 0; n < len; n++) {
     	v = buf.readUnsignedByte();
       c = uint(crc_table[(c ^ v) & uint(0xff)] ^ uint(c >>> 8));
     }
     return c;
   }
   
   /* Return the CRC of the bytes buf[0..len-1]. */
   private function crc(buf:ByteArray, len:uint):uint
   {
     var cc:uint = update_crc(uint(0xffffffff), buf, len);
     return uint(cc ^ uint(0xffffffff));
   }	
	
}
}
