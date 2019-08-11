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


    import org.apache.royale.utils.Endian;
    import org.apache.royale.test.asserts.*;
    import org.apache.royale.utils.BinaryData


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

            assertEquals(ba.position, 0, "new Instance, position");
            assertEquals(ba.length, 0, "new Instance, length");

            ba.position=100;
            assertEquals(ba.position,100, "position change, position");
            assertEquals(ba.length, 0, "position change, length");
            assertEquals(ba.bytesAvailable, 0, "position change, length");

            ba.length=100;
            assertEquals(ba.position,100, "length change, position");
            assertEquals(ba.length, 100, "length change, length");

            ba.length=50;
            assertEquals(ba.position,50, "length change, position");
            assertEquals(ba.length, 50, "length change, length");


        }

        [Test]
        public function testAdvancedPositionAndLength():void
        {
            var ba:BinaryData = new BinaryData();

            ba.position=100;
            ba.length=100;

            ba.writeByteAt(49,255);
            assertEquals(ba.position,100, "writeByteAt does not affect position");
            assertEquals(ba.length,100, "writeByteAt (internal) does not affect length");

            ba.readByteAt(48);
            assertEquals(ba.position,100, "readByteAt does not affect position");
            assertEquals(ba.length,100, "readByteAt does not affect length");

            ba.writeByteAt(199,255);
            assertEquals(ba.length, 200, "writeByteAt (beyond length) does affect length");
            assertEquals(ba.position,100, "writeByteAt (beyond length) does not affect position");

            assertStrictlyEquals(ba.readByteAt(205),0, "out of range byte read request");

        }


        [Test]
        public function testUTFWritePosition():void
        {
            var ba:BinaryData = new BinaryData();
            ba.writeUTF('This is a test');
            //writeUTF
            assertEquals(ba.position, 16, "basic post-writeUTF position");
            ba=new BinaryData();
            ba.writeUTFBytes('This is a test');
            //writeUTFBytes
            assertEquals(ba.position, 14, "basic post-writeUTFBytes position");

            //overlapping
            ba.position=5;
            ba.writeUTFBytes('This is a test');
            assertEquals(ba.position, 19, "Advanced post-writeUTFBytes position (overlap)");

        }

        [Test]
        public function testBooleanRoundTripping():void
        {
            var ba:BinaryData = new BinaryData();
            ba.writeBoolean(true);
            ba.writeBoolean(false);
            ba.position = 0;
            assertTrue(ba.readBoolean());
            assertFalse(ba.readBoolean());
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


            assertEquals(ba.readByte(), -1, "Error testing post writeByte/readByte round-tripping");
            assertEquals(ba.readByte(), 0, "Error testing post writeByte/readByte round-tripping");
            assertEquals(ba.readByte(), 0, "Error testing post writeByte/readByte round-tripping");
            assertEquals(ba.readByte(), -1, "Error testing post writeByte/readByte round-tripping");
            assertEquals(ba.readByte(), -128, "Error testing post writeByte/readByte round-tripping");
            assertEquals(ba.readByte(), -128, "Error testing post writeByte/readByte round-tripping");
            assertEquals(ba.readByte(), 127, "Error testing post writeByte/readByte round-tripping");
            assertEquals(ba.readByte(), -50, "Error testing post writeByte/readByte round-tripping");
            assertEquals(ba.readByte(), 50, "Error testing post writeByte/readByte round-tripping");
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

            assertEquals(ba.readUnsignedByte(), 255, "Error testing post writeByte/readUnsignedByte round-tripping");
            assertEquals(ba.readUnsignedByte(), 0, "Error testing post writeByte/readUnsignedByte round-tripping");
            assertEquals(ba.readUnsignedByte(), 0, "Error testing post writeByte/readUnsignedByte round-tripping");
            assertEquals(ba.readUnsignedByte(), 255, "Error testing post writeByte/readUnsignedByte round-tripping");
            assertEquals(ba.readUnsignedByte(), 128, "Error testing post writeByte/readUnsignedByte round-tripping");
            assertEquals(ba.readUnsignedByte(), 128, "Error testing post writeByte/readUnsignedByte round-tripping");
            assertEquals(ba.readUnsignedByte(), 127, "Error testing post writeByte/readUnsignedByte round-tripping");
            assertEquals(ba.readUnsignedByte(), 206, "Error testing post writeByte/readUnsignedByte round-tripping");
            assertEquals(ba.readUnsignedByte(), 50, "Error testing post writeByte/readUnsignedByte round-tripping");
        }


        [Test]
        public function testBasicEndian():void
        {

            var systemEndian:String = Endian.systemEndian;
            //check we have a decisive systemEndian detection
            assertNotNull(systemEndian );


            var ba:BinaryData = new BinaryData();
            var defaultEndian:String = ba.endian;

            var alternateEndian:String = (defaultEndian == Endian.BIG_ENDIAN) ? Endian.LITTLE_ENDIAN : Endian.BIG_ENDIAN;
            var expected:Object ={};
            expected[Endian.BIG_ENDIAN] = 218038271;
            expected[Endian.LITTLE_ENDIAN] = 4294966796;
            var bytes:Array = [12, 254, 255, 255];
            for each(var byte:uint in bytes) ba.writeByte(byte);
            ba.position = 0;

            assertEquals(ba.readUnsignedInt(), expected[defaultEndian], "testing endian:"+defaultEndian);

            ba.position = 0;
            ba.endian = alternateEndian;
            var result:uint =  ba.readUnsignedInt();

            assertEquals(result, expected[alternateEndian], "testing endian:"+alternateEndian);

            ba.position = 0;
            ba.endian = defaultEndian;
            assertEquals(ba.readInt(), int(expected[defaultEndian]), "testing endian:"+defaultEndian);

            ba.position = 0;
            ba.endian = alternateEndian;
            assertEquals(ba.readInt(), int(expected[alternateEndian]), "testing endian:"+alternateEndian);

            var leBA:BinaryData = new BinaryData();
            leBA.endian = Endian.LITTLE_ENDIAN;
            var beBA:BinaryData = new BinaryData();
            beBA.endian = Endian.BIG_ENDIAN;
            //int writing
            beBA.writeInt(-500);
            leBA.writeInt(-500);
            //check they represent reversed byte sequence
            assertTrue(reversedBytesMatch(beBA,leBA,4));
            beBA.position=0;
            leBA.position=0;
            //check they each read back to the same uint value
            assertEquals(beBA.readUnsignedInt(),4294966796, 'big endian');
            assertEquals(leBA.readUnsignedInt(),4294966796, 'little endian');

            beBA.position=0;
            leBA.position=0;
            //uint writing
            beBA.writeUnsignedInt(4294966796);
            leBA.writeUnsignedInt(4294966796);
            //check they represent reversed byte sequence
            assertTrue(reversedBytesMatch(beBA,leBA,4));
            beBA.position=0;
            leBA.position=0;
            //check they each read back to the same uint value
            assertEquals(beBA.readUnsignedInt(),4294966796, 'big endian');
            assertEquals(leBA.readUnsignedInt(),4294966796, 'little endian');


            beBA.position=0;
            leBA.position=0;

            //check they each read back to the same int value
            assertEquals(beBA.readInt(),-500, 'big endian');
            assertEquals(leBA.readInt(),-500, 'little endian');


            beBA.position=0;
            leBA.position=0;

            //short writing
            beBA.writeShort(-500);
            leBA.writeShort(-500);
            //check they represent reversed byte sequence
            assertTrue(reversedBytesMatch(beBA,leBA,2));
            beBA.position=0;
            leBA.position=0;
            //check they each read back to the same uint value
            assertEquals(beBA.readUnsignedShort(),65036, 'big endian');
            assertEquals(leBA.readUnsignedShort(),65036, 'little endian');


            beBA.position=0;
            leBA.position=0;

            //check they each read back to the same int value
            assertEquals(beBA.readShort(),-500, 'big endian');
            assertEquals(leBA.readShort(),-500, 'little endian');

        }


        [Test]
        public function testUTFRoundtripping():void
        {

            //test big-endian round-tripping
            var ba:BinaryData = new BinaryData();
            ba.endian = Endian.BIG_ENDIAN;
            ba.writeUTF('This is a test');
            //writeUTF
            assertEquals(ba.position, 16, "basic post-writeUTF position");
            ba.position = 0;
            assertEquals(ba.readUTF(), 'This is a test', "utf big endian round-tripping");

            ba = new BinaryData();
            //test little-endian round-tripping
            ba.endian = Endian.LITTLE_ENDIAN;
            ba.writeUTF('This is a test');
            //writeUTF
            assertEquals(ba.position, 16, "basic post-writeUTF position");
            ba.position = 0;
            assertEquals(ba.readUTF(), 'This is a test', "utf big endian round-tripping");

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

            assertEquals(ba.length, 6, "Error testing post writeShort/readShort round-tripping");
            assertEquals(ba.readShort(), 255, "Error testing post writeShort/readShort round-tripping");
            assertEquals(ba.readShort(), -50, "Error testing post writeShort/readShort round-tripping");
            assertEquals(ba.readShort(), 50, "Error testing post writeShort/readShort round-tripping");

            //test BIG_ENDIAN round-tripping

            ba.position = 0;
            ba.endian = Endian.BIG_ENDIAN ;
            ba.writeShort(255);
            ba.writeShort(-50);
            ba.writeShort(50);
            ba.position = 0;

            assertEquals(ba.length, 6, "Error testing post writeShort/readShort round-tripping");
            assertEquals(ba.readShort(), 255, "Error testing post writeShort/readShort round-tripping");
            assertEquals(ba.readShort(), -50, "Error testing post writeShort/readShort round-tripping");
            assertEquals(ba.readShort(), 50, "Error testing post writeShort/readShort round-tripping");
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

            assertEquals(ba.length, 6, "Error testing post unsigned writeShort/readShort round-tripping");
            assertEquals(ba.readUnsignedShort(), 255, "Error testing post unsigned writeShort/readShort round-tripping");
            assertEquals(ba.readUnsignedShort(), 65486, "Error testing post unsigned writeShort/readShort round-tripping");
            assertEquals(ba.readUnsignedShort(), 50, "Error testing post unsigned writeShort/readShort round-tripping");

            //test BIG_ENDIAN round-tripping

            ba.position = 0;
            ba.endian = Endian.BIG_ENDIAN ;
            ba.writeShort(255);
            ba.writeShort(-50);
            ba.writeShort(50);
            ba.position = 0;

            assertEquals(ba.length, 6, "Error testing post unsigned writeShort/readShort round-tripping");
            assertEquals(ba.readUnsignedShort(), 255, "Error testing post unsigned writeShort/readShort round-tripping");
            assertEquals(ba.readUnsignedShort(), 65486, "Error testing post unsigned writeShort/readShort round-tripping");
            assertEquals(ba.readUnsignedShort(), 50, "Error testing post unsigned writeShort/readShort round-tripping");
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

            assertEquals(ba.length, 12, "Error testing post writeInt/readInt round-tripping");
            assertEquals(ba.readInt(), 65536, "Error testing post writeInt/readInt round-tripping");
            assertEquals(ba.readInt(), -50, "Error testing post writeInt/readInt round-tripping");
            assertEquals(ba.readInt(), 50, "Error testing post writeInt/readInt round-tripping");

            //test BIG_ENDIAN round-tripping

            ba.position = 0;
            ba.endian = Endian.BIG_ENDIAN ;
            ba.writeInt(65536);
            ba.writeInt(-50);
            ba.writeInt(50);
            ba.position = 0;

            assertEquals(ba.length, 12, "Error testing post writeInt/readInt round-tripping");
            assertEquals(ba.readInt(), 65536, "Error testing post writeInt/readInt round-tripping");
            assertEquals(ba.readInt(), -50, "Error testing post writeInt/readInt round-tripping");
            assertEquals(ba.readInt(), 50, "Error testing post writeInt/readInt round-tripping");
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

            assertEquals(ba.length, 12, "Error testing post writeInt/readInt round-tripping");
            assertEquals(ba.readUnsignedInt(),65536, "Error testing post writeInt/readInt round-tripping");
            assertEquals(ba.readUnsignedInt(), 4294967246, "Error testing post writeInt/readInt round-tripping");
            assertEquals(ba.readUnsignedInt(), 50, "Error testing post writeInt/readInt round-tripping");

            //test BIG_ENDIAN round-tripping

            ba.position = 0;
            ba.endian = Endian.BIG_ENDIAN ;
            ba.writeUnsignedInt(65536);
            ba.writeUnsignedInt(-50);
            ba.writeUnsignedInt(50);
            ba.position = 0;

            assertEquals(ba.length, 12, "Error testing post writeInt/readInt round-tripping");
            assertEquals(ba.readUnsignedInt(),65536, "Error testing post writeInt/readInt round-tripping");
            assertEquals(ba.readUnsignedInt(), 4294967246, "Error testing post writeInt/readInt round-tripping");
            assertEquals(ba.readUnsignedInt(), 50, "Error testing post writeInt/readInt round-tripping");
        }

        [Test]
        public function testFloatRoundTripping():void
        {
            var ble:BinaryData = new BinaryData();
            //test LITTLE_ENDIAN round-tripping
            ble.endian = Endian.LITTLE_ENDIAN;
            ble.writeFloat(86.54);


            assertEquals(ble.length, 4, "Error testing post writeFloat/readFloat round-tripping");
            assertEquals(ble.position, 4, "Error testing post writeFloat/readFloat round-tripping");
            //check bytes to account for precision loss between double and float comparisons
            assertTrue(bytesMatchExpectedData(ble,[123,20,173,66]), "Error testing post writeFloat/readFloat round-tripping");

            var bbe:BinaryData = new BinaryData();
            //test BIG_ENDIAN round-tripping
            bbe.endian = Endian.BIG_ENDIAN;
            bbe.writeFloat(86.54);


            assertEquals(bbe.length, 4, "Error testing post writeFloat/readFloat round-tripping");
            assertEquals(bbe.position, 4, "Error testing post writeFloat/readFloat round-tripping");
            //check bytes to account for precision loss between double and float comparisons
            assertTrue(bytesMatchExpectedData(bbe,[66,173,20,123]), "Error testing post writeFloat/readFloat round-tripping");


        }
    
    
        [Test]
        public function testDoubleRoundTripping():void
        {
        
            var ble:BinaryData = new BinaryData();
            //test LITTLE_ENDIAN round-tripping
            ble.endian = Endian.LITTLE_ENDIAN;
            ble.writeDouble(86.54);
        
        
            assertEquals(ble.length, 8, "Error testing post writeDouble/readDouble round-tripping");
            assertEquals(ble.position, 8, "Error testing post writeDouble/readDouble round-tripping");
        
            //check bytes
            assertTrue(bytesMatchExpectedData(ble,[195,245,40,92,143,162,85,64]), "Error testing post writeDouble/readDouble round-tripping");
        
            var bbe:BinaryData = new BinaryData();
            //test BIG_ENDIAN round-tripping
            bbe.endian = Endian.BIG_ENDIAN;
            bbe.writeDouble(86.54);
        
        
            assertEquals(bbe.length, 8, "Error testing post writeDouble/readDouble round-tripping");
            assertEquals(bbe.position, 8, "Error testing post writeDouble/readDouble round-tripping");
            //check bytes
        
            assertTrue(bytesMatchExpectedData(bbe,[64,85,162,143,92,40,245,195]), "Error testing post writeDouble/readDouble round-tripping");
        
        
            ble.position = 0;
            bbe.position = 0;
            assertEquals(bbe.readDouble(), 86.54, "Error testing post writeDouble/readDouble round-tripping");
            assertEquals(ble.readDouble(), 86.54, "Error testing post writeDouble/readDouble round-tripping");
        
            assertEquals(bbe.position, 8, "Error testing post writeDouble/readDouble round-tripping");
            assertEquals(ble.position, 8, "Error testing post writeDouble/readDouble round-tripping");
        
        }
    
    
    
        [Test]
        public function testWriteBinaryData():void
        {
            var ba:BinaryData = new BinaryData();
            for (var i:int=0;i<50;i++) ba.writeByte(i);
        
        
            var newBa:BinaryData = new BinaryData();
            newBa.writeBinaryData(ba);
        
            assertEquals(50, newBa.length, "BinaryData writeBinaryData: length");
            assertEquals(50, newBa.position, "BinaryData writeBinaryData: position");
        
            for (i=0;i<50;i++) {
                assertEquals(i, newBa.array[i], "BinaryData writeBinaryData: content check");
            }
        
        
        
        }
        
        [Test]
        public function testReadBinaryData():void
        {
            var ba:BinaryData = new BinaryData();
            for (var i:int = 0; i < 50; i++) ba.writeByte(i);
            ba.position = 0;
            var newBa:BinaryData = new BinaryData();
            
            ba.readBinaryData(newBa, 5, 10);
            assertEquals(10, ba.position, "BinaryData readBinaryData: position");
            assertEquals(15, newBa.length, "BinaryData readBinaryData: length");
            assertEquals(0, newBa.position, "BinaryData readBinaryData: position");
            var expected:Array = [0, 0, 0, 0, 0, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
            for (i = 0; i < 15; i++)
            {
                assertEquals(expected[i], newBa.array[i], "BinaryData readBinaryData: content check");
            }
            newBa.position = 15;
            ba.readBinaryData(newBa, 5, 10);
            expected = [0, 0, 0, 0, 0, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19];
            for (i = 0; i < 15; i++)
            {
                assertEquals(expected[i], newBa.array[i], "BinaryData readBinaryData: content check");
            }
            assertEquals(15, newBa.length, "BinaryData readBinaryData: length");
            assertEquals(15, newBa.position, "BinaryData readBinaryData: position");
        }
        
        [Test]
        public function testReadOddBytes():void
        {
            var ba:BinaryData = new BinaryData();
            for (var i:int = 0; i < 50; i++) ba.writeByte(i);
            ba.endian = Endian.BIG_ENDIAN;
            ba.position = 0;
            assertEquals( 0, ba.readByte(),"BinaryData readByte: should be 0");
            assertEquals( 258, ba.readShort(),"BinaryData readShort: should be 258");
            assertEquals( 50595078, ba.readInt(), "BinaryData readInt: should be 50595078");
            ba.endian = Endian.LITTLE_ENDIAN;
            ba.position = 0;
            assertEquals( 0, ba.readByte(), "BinaryData readByte: should be 0");
            assertEquals( 513, ba.readShort(),"BinaryData readShort: should be 513");
            assertEquals(100992003, ba.readInt(), "BinaryData readInt: should be 100992003");
        
            ba = new BinaryData();
            ba.writeByte(25);
            ba.writeShort(65535);
            ba.writeUnsignedInt(4294967295);
            ba.position = 0;
            assertEquals(25, ba.readByte(), "BinaryData readByte: should be 25");
            assertEquals(65535, ba.readUnsignedShort(), "BinaryData readUnsignedShort: should be 65535");
            assertEquals( 4294967295, ba.readUnsignedInt(), "BinaryData readInt: should be 4294967295");
        
            ba = new BinaryData();
            ba.writeByte(-25);
            ba.writeShort(-1029);
            ba.writeInt(-131072);
            ba.writeFloat(12345.2);
            ba.writeDouble(3.1415927410);
            ba.position = 0;
            assertEquals(-25, ba.readByte(), "BinaryData readByte: should be -25");
            assertEquals( -1029, ba.readShort(), "BinaryData readShort: should be -1029");
            assertEquals( -131072, ba.readInt(), "BinaryData readInt: should be -131072");
            assertEquals( 12345.2, Math.round(ba.readFloat() * 100) / 100, "BinaryData readFloat: should be 12345.2");
            assertEquals( 3.1415927410, ba.readDouble(), "BinaryData readDouble: should be 3.1415927410");
            ba = new BinaryData()
            ba.writeFloat(12345.2);
            ba.position = 0;
            assertEquals( 12345.2, Math.round(ba.readFloat() * 100) / 100, "BinaryData readFloat: should be 12345.2");
            ba.position = 0;
            ba.writeDouble(3.1415927410);
            ba.position = 0;
            assertEquals( 3.1415927410, ba.readDouble(), "BinaryData readDouble: should be 3.1415927410");
        }

}
}
