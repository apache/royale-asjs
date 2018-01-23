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
package flexUnitTests.core
{


    import org.apache.royale.utils.Endian;
    import flexunit.framework.Assert;
    import org.apache.royale.utils.BinaryData


    public class BinaryDataTesterTest 
	{

		[Before]
		public function setUp():void {
		}

		[After]
		public function tearDown():void {
		}

		[BeforeClass]
		public static function setUpBeforeClass():void {
		}

		[AfterClass]
		public static function tearDownAfterClass():void {
		}


		//util check functions
		private static function bytesMatchExpectedData(bd:BinaryData,expected:Array,offset:int=0):Boolean{
			var len:uint = expected.length;
			var end:uint=offset+len;
			for (var i:int=offset;i<end;i++) {
				var check:uint = bd.readByteAt(i);
				if (expected[i-offset]!=check) {
					// trace('failed at ',i,expected[i-offset],check);
					return false;
				}
			}
			return true;
		}

		private static function reversedBytesMatch(bd1:BinaryData,bd2:BinaryData,len:uint,offset:int=0):Boolean{
			var end:uint=offset+len;
			for (var i:int=offset;i<end;i++) {
				if (bd1.readByteAt(i) != bd2.readByteAt(end-1-i)) return false;
			}
			return true;

		}


		[Test]
		public function testBasicPositionAndLength():void
		{
			var ba:BinaryData = new BinaryData();

			Assert.assertEquals("new Instance, position", 0, ba.position);
			Assert.assertEquals("new Instance, length", 0, ba.length);

			ba.position=100;
			Assert.assertEquals("position change, position", 100, ba.position);
			Assert.assertEquals("position change, length", 0, ba.length);
			Assert.assertEquals("position change, length", 0, ba.bytesAvailable);

			ba.length=100;
			Assert.assertEquals("length change, position", 100, ba.position);
			Assert.assertEquals("length change, length", 100, ba.length);

			ba.length=50;
			Assert.assertEquals("length change, position", 50, ba.position);
			Assert.assertEquals("length change, length", 50, ba.length);


		}

		[Test]
		public function testAdvancedPositionAndLength():void
		{
			var ba:BinaryData = new BinaryData();

			ba.position=100;
			ba.length=100;

			ba.writeByteAt(49,255);
			Assert.assertEquals("writeByteAt does not affect position",100, ba.position);
			Assert.assertEquals("writeByteAt (internal) does not affect length",100, ba.length);

			ba.readByteAt(48);
			Assert.assertEquals("readByteAt does not affect position",100, ba.position);
			Assert.assertEquals("readByteAt does not affect length",100, ba.length);

			ba.writeByteAt(199,255);
			Assert.assertEquals("writeByteAt (beyond length) does affect length",200, ba.length);
			Assert.assertEquals("writeByteAt (beyond length) does not affect position",100, ba.position);

			Assert.assertStrictlyEquals("out of range byte read request",0 ,ba.readByteAt(205));

		}


		[Test]
		public function testUTFWritePosition():void
		{
			var ba:BinaryData = new BinaryData();
			ba.writeUTF('This is a test');
			//writeUTF
			Assert.assertEquals("basic post-writeUTF position", 16, ba.position);
			ba=new BinaryData();
			ba.writeUTFBytes('This is a test');
			//writeUTFBytes
			Assert.assertEquals("basic post-writeUTFBytes position", 14, ba.position);

			//overlapping
			ba.position=5;
			ba.writeUTFBytes('This is a test');
			Assert.assertEquals("Advanced post-writeUTFBytes position (overlap)", 19, ba.position);

		}

		[Test]
		public function testBooleanRoundTripping():void
		{
			var ba:BinaryData = new BinaryData();
			ba.writeBoolean(true);
			ba.writeBoolean(false);
			ba.position = 0;
			Assert.assertTrue(ba.readBoolean());
			Assert.assertFalse(ba.readBoolean());
		}

		[Test]
		public function testByteRoundTripping():void
		{
			var ba:BinaryData = new BinaryData();
			ba.writeByte(255);
			ba.writeByte(256);
			ba.writeByte(-256);
			ba.writeByte(-257);
			ba.writeByte(-128);
			ba.writeByte(128);
			ba.writeByte(127);
			ba.writeByte(-50);
			ba.writeByte(50);
			ba.position = 0;


			Assert.assertEquals("Error testing post writeByte/readByte round-tripping", -1, ba.readByte());
			Assert.assertEquals("Error testing post writeByte/readByte round-tripping", 0, ba.readByte());
			Assert.assertEquals("Error testing post writeByte/readByte round-tripping", 0, ba.readByte());
			Assert.assertEquals("Error testing post writeByte/readByte round-tripping", -1, ba.readByte());
			Assert.assertEquals("Error testing post writeByte/readByte round-tripping", -128, ba.readByte());
			Assert.assertEquals("Error testing post writeByte/readByte round-tripping", -128, ba.readByte());
			Assert.assertEquals("Error testing post writeByte/readByte round-tripping", 127, ba.readByte());
			Assert.assertEquals("Error testing post writeByte/readByte round-tripping", -50, ba.readByte());
			Assert.assertEquals("Error testing post writeByte/readByte round-tripping", 50, ba.readByte());
		}


		[Test]
		public function testUnsignedByteRoundTripping():void
		{
			var ba:BinaryData = new BinaryData();
			ba.writeByte(255);
			ba.writeByte(256);
			ba.writeByte(-256);
			ba.writeByte(-257);
			ba.writeByte(-128);
			ba.writeByte(128);
			ba.writeByte(127);
			ba.writeByte(-50);
			ba.writeByte(50);
			ba.position = 0;
			//check read values

			Assert.assertEquals("Error testing post writeByte/readUnsignedByte round-tripping", 255, ba.readUnsignedByte());
			Assert.assertEquals("Error testing post writeByte/readUnsignedByte round-tripping", 0, ba.readUnsignedByte());
			Assert.assertEquals("Error testing post writeByte/readUnsignedByte round-tripping", 0, ba.readUnsignedByte());
			Assert.assertEquals("Error testing post writeByte/readUnsignedByte round-tripping", 255, ba.readUnsignedByte());
			Assert.assertEquals("Error testing post writeByte/readUnsignedByte round-tripping", 128, ba.readUnsignedByte());
			Assert.assertEquals("Error testing post writeByte/readUnsignedByte round-tripping", 128, ba.readUnsignedByte());
			Assert.assertEquals("Error testing post writeByte/readUnsignedByte round-tripping", 127, ba.readUnsignedByte());
			Assert.assertEquals("Error testing post writeByte/readUnsignedByte round-tripping", 206, ba.readUnsignedByte());
			Assert.assertEquals("Error testing post writeByte/readUnsignedByte round-tripping", 50, ba.readUnsignedByte());
		}


		[Test]
		public function testBasicEndian():void
		{

			var systemEndian:String = Endian.systemEndian;
			//check we have a decisive systemEndian detection
			Assert.assertNotNull(systemEndian );


			var ba:BinaryData = new BinaryData();
			var defaultEndian:String = ba.endian;

			var alternateEndian:String = (defaultEndian == Endian.BIG_ENDIAN) ? Endian.LITTLE_ENDIAN : Endian.BIG_ENDIAN;
			var expected:Object ={};
			expected[Endian.BIG_ENDIAN] = 218038271;
			expected[Endian.LITTLE_ENDIAN] = 4294966796;
			var bytes:Array = [12, 254, 255, 255];
			for each(var byte:uint in bytes) ba.writeByte(byte);
			ba.position = 0;

			Assert.assertEquals("testing endian:"+defaultEndian, expected[defaultEndian] , ba.readUnsignedInt());

			ba.position = 0;
			ba.endian = alternateEndian;
			var result:uint =  ba.readUnsignedInt();

			Assert.assertEquals("testing endian:"+alternateEndian, expected[alternateEndian], result);

			ba.position = 0;
			ba.endian = defaultEndian;
			Assert.assertEquals("testing endian:"+defaultEndian, int(expected[defaultEndian]), ba.readInt());

			ba.position = 0;
			ba.endian = alternateEndian;
			Assert.assertEquals("testing endian:"+alternateEndian, int(expected[alternateEndian]), ba.readInt());

			var leBA:BinaryData = new BinaryData();
			leBA.endian = Endian.LITTLE_ENDIAN;
			var beBA:BinaryData = new BinaryData();
			beBA.endian = Endian.BIG_ENDIAN;
			//int writing
			beBA.writeInt(-500);
			leBA.writeInt(-500);
			//check they represent reversed byte sequence
			Assert.assertTrue(reversedBytesMatch(beBA,leBA,4));
			beBA.position=0;
			leBA.position=0;
			//check they each read back to the same uint value
			Assert.assertEquals('big endian',4294966796,beBA.readUnsignedInt());
			Assert.assertEquals('little endian',4294966796,leBA.readUnsignedInt());

			beBA.position=0;
			leBA.position=0;
			//uint writing
			beBA.writeUnsignedInt(4294966796);
			leBA.writeUnsignedInt(4294966796);
			//check they represent reversed byte sequence
			Assert.assertTrue(reversedBytesMatch(beBA,leBA,4));
			beBA.position=0;
			leBA.position=0;
			//check they each read back to the same uint value
			Assert.assertEquals('big endian',4294966796,beBA.readUnsignedInt());
			Assert.assertEquals('little endian',4294966796,leBA.readUnsignedInt());


			beBA.position=0;
			leBA.position=0;

			//check they each read back to the same int value
			Assert.assertEquals('big endian',-500,beBA.readInt());
			Assert.assertEquals('little endian',-500,leBA.readInt());


			beBA.position=0;
			leBA.position=0;

			//short writing
			beBA.writeShort(-500);
			leBA.writeShort(-500);
			//check they represent reversed byte sequence
			Assert.assertTrue(reversedBytesMatch(beBA,leBA,2));
			beBA.position=0;
			leBA.position=0;
			//check they each read back to the same uint value
			Assert.assertEquals('big endian',65036,beBA.readUnsignedShort());
			Assert.assertEquals('little endian',65036,leBA.readUnsignedShort());


			beBA.position=0;
			leBA.position=0;

			//check they each read back to the same int value
			Assert.assertEquals('big endian',-500,beBA.readShort());
			Assert.assertEquals('little endian',-500,leBA.readShort());

		}


		[Test]
		public function testUTFRoundtripping():void
		{

			//test big-endian round-tripping
			var ba:BinaryData = new BinaryData();
			ba.endian = Endian.BIG_ENDIAN;
			ba.writeUTF('This is a test');
			//writeUTF
			Assert.assertEquals("basic post-writeUTF position", 16, ba.position);
			ba.position = 0;
			Assert.assertEquals("utf big endian round-tripping", 'This is a test', ba.readUTF());

			ba = new BinaryData();
			//test little-endian round-tripping
			ba.endian = Endian.LITTLE_ENDIAN;
			ba.writeUTF('This is a test');
			//writeUTF
			Assert.assertEquals("basic post-writeUTF position", 16, ba.position);
			ba.position = 0;
			Assert.assertEquals("utf big endian round-tripping", 'This is a test', ba.readUTF());

		}


		[Test]
		public function testShortRoundTripping():void
		{
			var ba:BinaryData = new BinaryData();
			//test LITTLE_ENDIAN round-tripping
			ba.endian = Endian.LITTLE_ENDIAN;
			ba.writeShort(255);
			ba.writeShort(-50);
			ba.writeShort(50);
			ba.position = 0;

			Assert.assertEquals("Error testing post writeShort/readShort round-tripping", 6, ba.length);
			Assert.assertEquals("Error testing post writeShort/readShort round-tripping", 255, ba.readShort());
			Assert.assertEquals("Error testing post writeShort/readShort round-tripping", -50, ba.readShort());
			Assert.assertEquals("Error testing post writeShort/readShort round-tripping", 50, ba.readShort());

			//test BIG_ENDIAN round-tripping

			ba.position = 0;
			ba.endian = Endian.BIG_ENDIAN ;
			ba.writeShort(255);
			ba.writeShort(-50);
			ba.writeShort(50);
			ba.position = 0;

			Assert.assertEquals("Error testing post writeShort/readShort round-tripping", 6, ba.length);
			Assert.assertEquals("Error testing post writeShort/readShort round-tripping", 255, ba.readShort());
			Assert.assertEquals("Error testing post writeShort/readShort round-tripping", -50, ba.readShort());
			Assert.assertEquals("Error testing post writeShort/readShort round-tripping", 50, ba.readShort());
		}


		[Test]
		public function testUnsignedShortRoundTripping():void
		{
			var ba:BinaryData = new BinaryData();
			//test LITTLE_ENDIAN round-tripping
			ba.endian = Endian.LITTLE_ENDIAN;
			ba.writeShort(255);
			ba.writeShort(-50);
			ba.writeShort(50);
			ba.position = 0;

			Assert.assertEquals("Error testing post unsigned writeShort/readShort round-tripping", 6, ba.length);
			Assert.assertEquals("Error testing post unsigned writeShort/readShort round-tripping", 255, ba.readUnsignedShort());
			Assert.assertEquals("Error testing post unsigned writeShort/readShort round-tripping", 65486, ba.readUnsignedShort());
			Assert.assertEquals("Error testing post unsigned writeShort/readShort round-tripping", 50, ba.readUnsignedShort());

			//test BIG_ENDIAN round-tripping

			ba.position = 0;
			ba.endian = Endian.BIG_ENDIAN ;
			ba.writeShort(255);
			ba.writeShort(-50);
			ba.writeShort(50);
			ba.position = 0;

			Assert.assertEquals("Error testing post unsigned writeShort/readShort round-tripping", 6, ba.length);
			Assert.assertEquals("Error testing post unsigned writeShort/readShort round-tripping", 255, ba.readUnsignedShort());
			Assert.assertEquals("Error testing post unsigned writeShort/readShort round-tripping", 65486, ba.readUnsignedShort());
			Assert.assertEquals("Error testing post unsigned writeShort/readShort round-tripping", 50, ba.readUnsignedShort());
		}

		[Test]
		public function testIntRoundTripping():void
		{
			var ba:BinaryData = new BinaryData();
			//test LITTLE_ENDIAN round-tripping
			ba.endian = Endian.LITTLE_ENDIAN;
			ba.writeInt(65536);
			ba.writeInt(-50);
			ba.writeInt(50);
			ba.position = 0;

			Assert.assertEquals("Error testing post writeInt/readInt round-tripping", 12, ba.length);
			Assert.assertEquals("Error testing post writeInt/readInt round-tripping", 65536, ba.readInt());
			Assert.assertEquals("Error testing post writeInt/readInt round-tripping", -50, ba.readInt());
			Assert.assertEquals("Error testing post writeInt/readInt round-tripping", 50, ba.readInt());

			//test BIG_ENDIAN round-tripping

			ba.position = 0;
			ba.endian = Endian.BIG_ENDIAN ;
			ba.writeInt(65536);
			ba.writeInt(-50);
			ba.writeInt(50);
			ba.position = 0;

			Assert.assertEquals("Error testing post writeInt/readInt round-tripping", 12, ba.length);
			Assert.assertEquals("Error testing post writeInt/readInt round-tripping", 65536, ba.readInt());
			Assert.assertEquals("Error testing post writeInt/readInt round-tripping", -50, ba.readInt());
			Assert.assertEquals("Error testing post writeInt/readInt round-tripping", 50, ba.readInt());
		}


		[Test]
		public function testUnsignedIntRoundTripping():void
		{
			var ba:BinaryData = new BinaryData();
			//test LITTLE_ENDIAN round-tripping
			ba.endian = Endian.LITTLE_ENDIAN;
			ba.writeUnsignedInt(65536);
			ba.writeUnsignedInt(-50);
			ba.writeUnsignedInt(50);
			ba.position = 0;

			Assert.assertEquals("Error testing post writeInt/readInt round-tripping", 12, ba.length);
			Assert.assertEquals("Error testing post writeInt/readInt round-tripping",65536, ba.readUnsignedInt());
			Assert.assertEquals("Error testing post writeInt/readInt round-tripping", 4294967246, ba.readUnsignedInt());
			Assert.assertEquals("Error testing post writeInt/readInt round-tripping", 50, ba.readUnsignedInt());

			//test BIG_ENDIAN round-tripping

			ba.position = 0;
			ba.endian = Endian.BIG_ENDIAN ;
			ba.writeUnsignedInt(65536);
			ba.writeUnsignedInt(-50);
			ba.writeUnsignedInt(50);
			ba.position = 0;

			Assert.assertEquals("Error testing post writeInt/readInt round-tripping", 12, ba.length);
			Assert.assertEquals("Error testing post writeInt/readInt round-tripping",65536, ba.readUnsignedInt());
			Assert.assertEquals("Error testing post writeInt/readInt round-tripping", 4294967246, ba.readUnsignedInt());
			Assert.assertEquals("Error testing post writeInt/readInt round-tripping", 50, ba.readUnsignedInt());
		}

		[Test]
		public function testFloatRoundTripping():void
		{
			var ble:BinaryData = new BinaryData();
			//test LITTLE_ENDIAN round-tripping
			ble.endian = Endian.LITTLE_ENDIAN;
			ble.writeFloat(86.54);


			Assert.assertEquals("Error testing post writeFloat/readFloat round-tripping", 4, ble.length);
			Assert.assertEquals("Error testing post writeFloat/readFloat round-tripping", 4, ble.position);
			//check bytes to account for precision loss between double and float comparisons
			Assert.assertTrue("Error testing post writeFloat/readFloat round-tripping", bytesMatchExpectedData(ble,[123,20,173,66]));

			var bbe:BinaryData = new BinaryData();
			//test BIG_ENDIAN round-tripping
			bbe.endian = Endian.BIG_ENDIAN;
			bbe.writeFloat(86.54);


			Assert.assertEquals("Error testing post writeFloat/readFloat round-tripping", 4, bbe.length);
			Assert.assertEquals("Error testing post writeFloat/readFloat round-tripping", 4, bbe.position);
			//check bytes to account for precision loss between double and float comparisons
			Assert.assertTrue("Error testing post writeFloat/readFloat round-tripping", bytesMatchExpectedData(bbe,[66,173,20,123]));


		}


		[Test]
		public function testDoubleRoundTripping():void
		{

			var ble:BinaryData = new BinaryData();
			//test LITTLE_ENDIAN round-tripping
			ble.endian = Endian.LITTLE_ENDIAN;
			ble.writeDouble(86.54);


			Assert.assertEquals("Error testing post writeDouble/readDouble round-tripping", 8, ble.length);
			Assert.assertEquals("Error testing post writeDouble/readDouble round-tripping", 8, ble.position);

			//check bytes
			Assert.assertTrue("Error testing post writeDouble/readDouble round-tripping", bytesMatchExpectedData(ble,[195,245,40,92,143,162,85,64]));

			var bbe:BinaryData = new BinaryData();
			//test BIG_ENDIAN round-tripping
			bbe.endian = Endian.BIG_ENDIAN;
			bbe.writeDouble(86.54);


			Assert.assertEquals("Error testing post writeDouble/readDouble round-tripping", 8, bbe.length);
			Assert.assertEquals("Error testing post writeDouble/readDouble round-tripping", 8, bbe.position);
			//check bytes

			Assert.assertTrue("Error testing post writeDouble/readDouble round-tripping", bytesMatchExpectedData(bbe,[64,85,162,143,92,40,245,195]));


			ble.position = 0;
			bbe.position = 0;
			Assert.assertEquals("Error testing post writeDouble/readDouble round-tripping", 86.54, bbe.readDouble());
			Assert.assertEquals("Error testing post writeDouble/readDouble round-tripping", 86.54, ble.readDouble());

			Assert.assertEquals("Error testing post writeDouble/readDouble round-tripping", 8, bbe.position);
			Assert.assertEquals("Error testing post writeDouble/readDouble round-tripping", 8, ble.position);

		}



		[Test]
		public function testWriteBytes():void
		{
			var ba:BinaryData = new BinaryData();
			for (var i:int=0;i<50;i++) ba.writeByte(i);


			var newBa:BinaryData = new BinaryData();
			newBa.writeBytes(ba);

			Assert.assertEquals("BinaryData writeBytes: length", 50, newBa.length);
			Assert.assertEquals("BinaryData writeBytes: position", 50, newBa.position);

			for (i=0;i<50;i++) {
				Assert.assertEquals("BinaryData writeBytes: content check", i, newBa.array[i]);
			}



		}

		[Test]
		public function testReadBytes():void
		{
			var ba:BinaryData = new BinaryData();
			for (var i:int=0;i<50;i++) ba.writeByte(i);
			ba.position=0;
			var newBa:BinaryData = new BinaryData();

			ba.readBytes(newBa,5,10);
			Assert.assertEquals("BinaryData readBytes: position", 10, ba.position);
			Assert.assertEquals("BinaryData readBytes: length", 15, newBa.length);
			Assert.assertEquals("BinaryData readBytes: position", 0, newBa.position);
			var expected:Array = [0,0,0,0,0,0,1,2,3,4,5,6,7,8,9];
			for (i=5;i<15;i++) {
				Assert.assertEquals("BinaryData readBytes: content check", expected[i], newBa.array[i]);
			}
		}


	}
}
