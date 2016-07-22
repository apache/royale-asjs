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
package flexUnitTests {


    import org.apache.flex.utils.Endian;
    import flexunit.framework.Assert;
    import org.apache.flex.utils.BinaryData


    public class BinaryDataTesterTest {

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


        [Test]
        public function testBasicPositionAndLength():void {
            var ba:BinaryData = new BinaryData();

            Assert.assertEquals("new Instance, position", ba.position, 0);
            Assert.assertEquals("new Instance, length", ba.length, 0);

            ba.position = 100;
            Assert.assertEquals("position change, position", ba.position, 100);
            Assert.assertEquals("position change, length", ba.length, 0);

            ba.length = 100;
            Assert.assertEquals("length change, position", ba.position, 100);
            Assert.assertEquals("length change, length", ba.length, 100);

            ba.length = 50;
            Assert.assertEquals("length change, position", ba.position, 50);
            Assert.assertEquals("length change, length", ba.length, 50);
        }

        [Test]
        public function testAdvancedPositionAndLength():void {
            var ba:BinaryData = new BinaryData();

            ba.position = 100;
            ba.length = 100;

            ba.writeByteAt(49, 255);
            Assert.assertEquals("writeByteAt does not affect position", ba.position, 100);
            Assert.assertEquals("writeByteAt (internal) does not affect length", ba.length, 100);

            ba.readByteAt(48);
            Assert.assertEquals("readByteAt does not affect position", ba.position, 100);
            Assert.assertEquals("readByteAt does not affect length", ba.length, 100);

            ba.writeByteAt(199, 255);
            Assert.assertEquals("writeByteAt (beyond length) does affect length", ba.length, 200);
            Assert.assertEquals("writeByteAt (beyond length) does not affect position", ba.position, 100);

        }


        [Test]
        public function testUTFWritePosition():void {
            var ba:BinaryData = new BinaryData();
            ba.writeUTF('This is a test');
            //writeUTF
            Assert.assertEquals("basic post-writeUTF position", ba.position, 16);
            ba = new BinaryData();
            ba.writeUTFBytes('This is a test');
            //writeUTFBytes
            Assert.assertEquals("basic post-writeUTFBytes position", ba.position, 14);

            //overlapping
            ba.position = 5;
            ba.writeUTFBytes('This is a test');
            Assert.assertEquals("Advanced post-writeUTFBytes position (overlap)", ba.position, 19);

        }

        [Test]
        public function testBooleanRoundTripping():void {
            var ba:BinaryData = new BinaryData();
            ba.writeBoolean(true);
            ba.writeBoolean(false);
            ba.position = 0;
            Assert.assertTrue(ba.readBoolean());
            Assert.assertFalse(ba.readBoolean());
        }

        [Test]
        public function testByteRoundTripping():void {
            var ba:BinaryData = new BinaryData();
            ba.writeByte(255);
            ba.writeByte(-257);
            ba.writeByte(-50);
            ba.writeByte(50);
            ba.position = 0;


            Assert.assertEquals("Error testing post writeByte/readByte roundtripping", ba.readByte(), -1);
            Assert.assertEquals("Error testing post writeByte/readByte roundtripping", ba.readByte(), -1);
            Assert.assertEquals("Error testing post writeByte/readByte roundtripping", ba.readByte(), -50);
            Assert.assertEquals("Error testing post writeByte/readByte roundtripping", ba.readByte(), 50);
        }


        [Test]
        public function testUnsignedByteRoundTripping():void {
            var ba:BinaryData = new BinaryData();
            ba.writeByte(255);
            ba.writeByte(-257);
            ba.writeByte(-50);
            ba.writeByte(50);
            ba.position = 0;
            //check read values
            Assert.assertEquals("Error testing post writeByte/readByte roundtripping", ba.readUnsignedByte(), 255);
            Assert.assertEquals("Error testing post writeByte/readByte roundtripping", ba.readUnsignedByte(), 255);
            Assert.assertEquals("Error testing post writeByte/readByte roundtripping", ba.readUnsignedByte(), 206);
            Assert.assertEquals("Error testing post writeByte/readByte roundtripping", ba.readUnsignedByte(), 50);
        }


        [Test]
        public function testBasicEndian():void {
            var defaultEndian:String = Endian.defaultEndian;
            //check we have a decisive default
            Assert.assertTrue(defaultEndian != null && defaultEndian != Endian.UNKNOWN_ENDIAN);
            var alternateEndian:String = (defaultEndian == Endian.BIG_ENDIAN) ? Endian.LITTLE_ENDIAN : Endian.BIG_ENDIAN;

            var ba:BinaryData = new BinaryData();
            var expected:Object = {};
            expected[Endian.BIG_ENDIAN] = 1718379896;
            expected[Endian.LITTLE_ENDIAN] = 2019912806;
            var bytes:Array = [102, 108, 101, 120];
            for each(var byte:uint in bytes) ba.writeByte(byte);
            ba.position = 0;

            Assert.assertEquals("testing endian:" + defaultEndian, ba.readUnsignedInt(), expected[defaultEndian]);

            ba.position = 0;
            ba.endian = alternateEndian;
            Assert.assertEquals("testing endian:" + alternateEndian, ba.readUnsignedInt(), expected[alternateEndian]);
        }

        [Test]
        public function testShortRoundTripping():void {
            var ba:BinaryData = new BinaryData();
            ba.writeShort(255);
            ba.writeShort(-50);
            ba.writeShort(50);
            ba.position = 0;

            Assert.assertEquals("Error testing post writeShort/readShort roundtripping", ba.length, 6);
            Assert.assertEquals("Error testing post writeShort/readShort roundtripping", ba.readShort(), 255);
            Assert.assertEquals("Error testing post writeShort/readShort roundtripping", ba.readShort(), -50);
            Assert.assertEquals("Error testing post writeShort/readShort roundtripping", ba.readShort(), 50);
        }


        [Test]
        public function testcShortRoundTripping():void {
            var ba:BinaryData = new BinaryData();
            ba.writeShort(255);
            ba.writeShort(-50);
            ba.writeShort(50);
            ba.position = 0;

            Assert.assertEquals("Error testing post unsigned writeShort/readShort roundtripping", ba.length, 6);
            Assert.assertEquals("Error testing post unsigned writeShort/readShort roundtripping", ba.readUnsignedShort(), 255);
            Assert.assertEquals("Error testing post unsigned writeShort/readShort roundtripping", ba.readUnsignedShort(), 65486);
            Assert.assertEquals("Error testing post unsigned writeShort/readShort roundtripping", ba.readUnsignedShort(), 50);
        }

        [Test]
        public function testIntRoundTripping():void {
            var ba:BinaryData = new BinaryData();
            ba.writeInt(65536);
            ba.writeInt(-50);
            ba.writeInt(50);
            ba.position = 0;

            Assert.assertEquals("Error testing post writeInt/readInt roundtripping", ba.length, 12);
            Assert.assertEquals("Error testing post writeInt/readInt roundtripping", ba.readInt(), 65536);
            Assert.assertEquals("Error testing post writeInt/readInt roundtripping", ba.readInt(), -50);
            Assert.assertEquals("Error testing post writeInt/readInt roundtripping", ba.readInt(), 50);
        }


        [Test]
        public function testUnsignedIntRoundTripping():void {
            var ba:BinaryData = new BinaryData();
            ba.writeUnsignedInt(65536);
            ba.writeUnsignedInt(-50);
            ba.writeUnsignedInt(50);
            ba.position = 0;

            Assert.assertEquals("Error testing post writeInt/readInt roundtripping", ba.length, 12);
            Assert.assertEquals("Error testing post writeInt/readInt roundtripping", ba.readUnsignedInt(), 65536);
            Assert.assertEquals("Error testing post writeInt/readInt roundtripping", ba.readUnsignedInt(), 4294967246);
            Assert.assertEquals("Error testing post writeInt/readInt roundtripping", ba.readUnsignedInt(), 50);
        }

        [Test]
        public function testFloatRoundTripping():void {
            var ba:BinaryData = new BinaryData();

            ba.writeFloat(86.54);
            ba.writeFloat(-50.5);
            ba.writeFloat(0);
            ba.position = 0;

            Assert.assertEquals("Error testing post writeFloat/readFloat roundtripping", ba.length, 12);

            //check bytes to account for precision loss between double and float comparisons
            var expected:Array = [66, 173, 20, 123];
            if (ba.endian == Endian.LITTLE_ENDIAN) expected = expected.reverse();

            for (var i:int = 0; i < 4; i++) {
                Assert.assertEquals("Error testing post writeFloat/readFloat roundtripping", ba.readUnsignedByte(), expected[i]);
            }


            Assert.assertEquals("Error testing post writeFloat/readFloat roundtripping", ba.readFloat(), -50.5);
            Assert.assertEquals("Error testing post writeFloat/readFloat roundtripping", ba.readFloat(), 0);
        }


        [Test]
        public function testDoubleRoundTripping():void {
            var ba:BinaryData = new BinaryData();
            ba.writeDouble(86.54);
            ba.writeDouble(-50.5);
            ba.writeDouble(0);
            ba.position = 0;

            Assert.assertEquals("Error testing post writeDouble/readDouble roundtripping", ba.length, 24);
            Assert.assertEquals("Error testing post writeDouble/readDouble roundtripping", ba.readDouble(), 86.54);
            Assert.assertEquals("Error testing post writeDouble/readDouble roundtripping", ba.readDouble(), -50.5);
            Assert.assertEquals("Error testing post writeDouble/readDouble roundtripping", ba.readDouble(), 0);
        }


        [Test]
        public function testWriteBytes():void {
            var ba:BinaryData = new BinaryData();
            for (var i:int = 0; i < 50; i++) ba.writeByte(i);


            var newBa:BinaryData = new BinaryData();
            newBa.writeBytes(ba);

            Assert.assertEquals("BinaryData writeBytes: length", 50, newBa.length);
            Assert.assertEquals("BinaryData writeBytes: position", 50, newBa.position);

            for (i = 0; i < 50; i++) {
                Assert.assertEquals("BinaryData writeBytes: content check", i, newBa.array[i]);
            }

            newBa = new BinaryData();

        }

        [Test]
        public function testReadBytes():void {
            var ba:BinaryData = new BinaryData();
            for (var i:int = 0; i < 50; i++) ba.writeByte(i);
            ba.position = 0;
            var newBa:BinaryData = new BinaryData();

            ba.readBytes(newBa, 5, 10);
            Assert.assertEquals("BinaryData readBytes: position", 10, ba.position);
            Assert.assertEquals("BinaryData readBytes: length", 15, newBa.length);
            Assert.assertEquals("BinaryData readBytes: position", 0, newBa.position);
            var expected:Array = [0, 0, 0, 0, 0, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
            for (i = 5; i < 15; i++) {
                Assert.assertEquals("BinaryData readBytes: content check", expected[i], newBa.array[i]);
            }
        }


    }
}
