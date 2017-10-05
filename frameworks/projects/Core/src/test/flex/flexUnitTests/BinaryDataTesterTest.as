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
    import flexunit.framework.Assert;
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

            Assert.assertEquals("new Instance, position", ba.position, 0);
            Assert.assertEquals("new Instance, length", ba.length, 0);

            ba.position=100;
            Assert.assertEquals("position change, position", ba.position,100);
            Assert.assertEquals("position change, length", ba.length, 0);
            Assert.assertEquals("position change, length", ba.bytesAvailable, 0);

            ba.length=100;
            Assert.assertEquals("length change, position", ba.position,100);
            Assert.assertEquals("length change, length", ba.length, 100);

            ba.length=50;
            Assert.assertEquals("length change, position", ba.position,50);
            Assert.assertEquals("length change, length", ba.length, 50);


        }

        [Test]
        public function testAdvancedPositionAndLength():void
        {
            var ba:BinaryData = new BinaryData();

            ba.position=100;
            ba.length=100;

            ba.writeByteAt(49,255);
            Assert.assertEquals("writeByteAt does not affect position", ba.position,100);
            Assert.assertEquals("writeByteAt (internal) does not affect length", ba.length,100);

            ba.readByteAt(48);
            Assert.assertEquals("readByteAt does not affect position", ba.position,100);
            Assert.assertEquals("readByteAt does not affect length", ba.length,100);

            ba.writeByteAt(199,255);
            Assert.assertEquals("writeByteAt (beyond length) does affect length", ba.length,200);
            Assert.assertEquals("writeByteAt (beyond length) does not affect position", ba.position,100);

            Assert.assertStrictlyEquals("out of range byte read request",ba.readByteAt(205),0);

        }


        [Test]
        public function testUTFWritePosition():void
        {
            var ba:BinaryData = new BinaryData();
            ba.writeUTF('This is a test');
            //writeUTF
            Assert.assertEquals("basic post-writeUTF position", ba.position, 16);
            ba=new BinaryData();
            ba.writeUTFBytes('This is a test');
            //writeUTFBytes
            Assert.assertEquals("basic post-writeUTFBytes position", ba.position, 14);

            //overlapping
            ba.position=5;
            ba.writeUTFBytes('This is a test');
            Assert.assertEquals("Advanced post-writeUTFBytes position (overlap)", ba.position, 19);

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


            Assert.assertEquals("Error testing post writeByte/readByte round-tripping", ba.readByte(), -1);
            Assert.assertEquals("Error testing post writeByte/readByte round-tripping", ba.readByte(), 0);
            Assert.assertEquals("Error testing post writeByte/readByte round-tripping", ba.readByte(), 0);
            Assert.assertEquals("Error testing post writeByte/readByte round-tripping", ba.readByte(), -1);
            Assert.assertEquals("Error testing post writeByte/readByte round-tripping", ba.readByte(), -128);
            Assert.assertEquals("Error testing post writeByte/readByte round-tripping", ba.readByte(), -128);
            Assert.assertEquals("Error testing post writeByte/readByte round-tripping", ba.readByte(), 127);
            Assert.assertEquals("Error testing post writeByte/readByte round-tripping", ba.readByte(), -50);
            Assert.assertEquals("Error testing post writeByte/readByte round-tripping", ba.readByte(), 50);
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

            Assert.assertEquals("Error testing post writeByte/readUnsignedByte round-tripping", ba.readUnsignedByte(), 255);
            Assert.assertEquals("Error testing post writeByte/readUnsignedByte round-tripping", ba.readUnsignedByte(), 0);
            Assert.assertEquals("Error testing post writeByte/readUnsignedByte round-tripping", ba.readUnsignedByte(), 0);
            Assert.assertEquals("Error testing post writeByte/readUnsignedByte round-tripping", ba.readUnsignedByte(), 255);
            Assert.assertEquals("Error testing post writeByte/readUnsignedByte round-tripping", ba.readUnsignedByte(), 128);
            Assert.assertEquals("Error testing post writeByte/readUnsignedByte round-tripping", ba.readUnsignedByte(), 128);
            Assert.assertEquals("Error testing post writeByte/readUnsignedByte round-tripping", ba.readUnsignedByte(), 127);
            Assert.assertEquals("Error testing post writeByte/readUnsignedByte round-tripping", ba.readUnsignedByte(), 206);
            Assert.assertEquals("Error testing post writeByte/readUnsignedByte round-tripping", ba.readUnsignedByte(), 50);
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

            Assert.assertEquals("testing endian:"+defaultEndian, ba.readUnsignedInt(), expected[defaultEndian]);

            ba.position = 0;
            ba.endian = alternateEndian;
            var result:uint =  ba.readUnsignedInt();

            Assert.assertEquals("testing endian:"+alternateEndian, result, expected[alternateEndian]);

            ba.position = 0;
            ba.endian = defaultEndian;
            Assert.assertEquals("testing endian:"+defaultEndian, ba.readInt(), int(expected[defaultEndian]));

            ba.position = 0;
            ba.endian = alternateEndian;
            Assert.assertEquals("testing endian:"+alternateEndian, ba.readInt(), int(expected[alternateEndian]));

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
            Assert.assertEquals('big endian',beBA.readUnsignedInt(),4294966796);
            Assert.assertEquals('little endian',leBA.readUnsignedInt(),4294966796);

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
            Assert.assertEquals('big endian',beBA.readUnsignedInt(),4294966796);
            Assert.assertEquals('little endian',leBA.readUnsignedInt(),4294966796);


            beBA.position=0;
            leBA.position=0;

            //check they each read back to the same int value
            Assert.assertEquals('big endian',beBA.readInt(),-500);
            Assert.assertEquals('little endian',leBA.readInt(),-500);


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
            Assert.assertEquals('big endian',beBA.readUnsignedShort(),65036);
            Assert.assertEquals('little endian',leBA.readUnsignedShort(),65036);


            beBA.position=0;
            leBA.position=0;

            //check they each read back to the same int value
            Assert.assertEquals('big endian',beBA.readShort(),-500);
            Assert.assertEquals('little endian',leBA.readShort(),-500);

        }


        [Test]
        public function testUTFRoundtripping():void
        {

            //test big-endian round-tripping
            var ba:BinaryData = new BinaryData();
            ba.endian = Endian.BIG_ENDIAN;
            ba.writeUTF('This is a test');
            //writeUTF
            Assert.assertEquals("basic post-writeUTF position", ba.position, 16);
            ba.position = 0;
            Assert.assertEquals("utf big endian round-tripping", ba.readUTF(), 'This is a test');

            ba = new BinaryData();
            //test little-endian round-tripping
            ba.endian = Endian.LITTLE_ENDIAN;
            ba.writeUTF('This is a test');
            //writeUTF
            Assert.assertEquals("basic post-writeUTF position", ba.position, 16);
            ba.position = 0;
            Assert.assertEquals("utf big endian round-tripping", ba.readUTF(), 'This is a test');

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

            Assert.assertEquals("Error testing post writeShort/readShort round-tripping", ba.length, 6);
            Assert.assertEquals("Error testing post writeShort/readShort round-tripping", ba.readShort(), 255);
            Assert.assertEquals("Error testing post writeShort/readShort round-tripping", ba.readShort(), -50);
            Assert.assertEquals("Error testing post writeShort/readShort round-tripping", ba.readShort(), 50);

            //test BIG_ENDIAN round-tripping

            ba.position = 0;
            ba.endian = Endian.BIG_ENDIAN ;
            ba.writeShort(255);
            ba.writeShort(-50);
            ba.writeShort(50);
            ba.position = 0;

            Assert.assertEquals("Error testing post writeShort/readShort round-tripping", ba.length, 6);
            Assert.assertEquals("Error testing post writeShort/readShort round-tripping", ba.readShort(), 255);
            Assert.assertEquals("Error testing post writeShort/readShort round-tripping", ba.readShort(), -50);
            Assert.assertEquals("Error testing post writeShort/readShort round-tripping", ba.readShort(), 50);
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

            Assert.assertEquals("Error testing post unsigned writeShort/readShort round-tripping", ba.length, 6);
            Assert.assertEquals("Error testing post unsigned writeShort/readShort round-tripping", ba.readUnsignedShort(), 255);
            Assert.assertEquals("Error testing post unsigned writeShort/readShort round-tripping", ba.readUnsignedShort(), 65486);
            Assert.assertEquals("Error testing post unsigned writeShort/readShort round-tripping", ba.readUnsignedShort(), 50);

            //test BIG_ENDIAN round-tripping

            ba.position = 0;
            ba.endian = Endian.BIG_ENDIAN ;
            ba.writeShort(255);
            ba.writeShort(-50);
            ba.writeShort(50);
            ba.position = 0;

            Assert.assertEquals("Error testing post unsigned writeShort/readShort round-tripping", ba.length, 6);
            Assert.assertEquals("Error testing post unsigned writeShort/readShort round-tripping", ba.readUnsignedShort(), 255);
            Assert.assertEquals("Error testing post unsigned writeShort/readShort round-tripping", ba.readUnsignedShort(), 65486);
            Assert.assertEquals("Error testing post unsigned writeShort/readShort round-tripping", ba.readUnsignedShort(), 50);
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

            Assert.assertEquals("Error testing post writeInt/readInt round-tripping", ba.length, 12);
            Assert.assertEquals("Error testing post writeInt/readInt round-tripping", ba.readInt(), 65536);
            Assert.assertEquals("Error testing post writeInt/readInt round-tripping", ba.readInt(), -50);
            Assert.assertEquals("Error testing post writeInt/readInt round-tripping", ba.readInt(), 50);

            //test BIG_ENDIAN round-tripping

            ba.position = 0;
            ba.endian = Endian.BIG_ENDIAN ;
            ba.writeInt(65536);
            ba.writeInt(-50);
            ba.writeInt(50);
            ba.position = 0;

            Assert.assertEquals("Error testing post writeInt/readInt round-tripping", ba.length, 12);
            Assert.assertEquals("Error testing post writeInt/readInt round-tripping", ba.readInt(), 65536);
            Assert.assertEquals("Error testing post writeInt/readInt round-tripping", ba.readInt(), -50);
            Assert.assertEquals("Error testing post writeInt/readInt round-tripping", ba.readInt(), 50);
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

            Assert.assertEquals("Error testing post writeInt/readInt round-tripping", ba.length, 12);
            Assert.assertEquals("Error testing post writeInt/readInt round-tripping", ba.readUnsignedInt(),65536);
            Assert.assertEquals("Error testing post writeInt/readInt round-tripping", ba.readUnsignedInt(), 4294967246);
            Assert.assertEquals("Error testing post writeInt/readInt round-tripping", ba.readUnsignedInt(), 50);

            //test BIG_ENDIAN round-tripping

            ba.position = 0;
            ba.endian = Endian.BIG_ENDIAN ;
            ba.writeUnsignedInt(65536);
            ba.writeUnsignedInt(-50);
            ba.writeUnsignedInt(50);
            ba.position = 0;

            Assert.assertEquals("Error testing post writeInt/readInt round-tripping", ba.length, 12);
            Assert.assertEquals("Error testing post writeInt/readInt round-tripping", ba.readUnsignedInt(),65536);
            Assert.assertEquals("Error testing post writeInt/readInt round-tripping", ba.readUnsignedInt(), 4294967246);
            Assert.assertEquals("Error testing post writeInt/readInt round-tripping", ba.readUnsignedInt(), 50);
        }

        [Test]
        public function testFloatRoundTripping():void
        {
            var ble:BinaryData = new BinaryData();
            //test LITTLE_ENDIAN round-tripping
            ble.endian = Endian.LITTLE_ENDIAN;
            ble.writeFloat(86.54);


            Assert.assertEquals("Error testing post writeFloat/readFloat round-tripping", ble.length, 4);
            Assert.assertEquals("Error testing post writeFloat/readFloat round-tripping", ble.position, 4);
            //check bytes to account for precision loss between double and float comparisons
            Assert.assertTrue("Error testing post writeFloat/readFloat round-tripping", bytesMatchExpectedData(ble,[123,20,173,66]));

            var bbe:BinaryData = new BinaryData();
            //test BIG_ENDIAN round-tripping
            bbe.endian = Endian.BIG_ENDIAN;
            bbe.writeFloat(86.54);


            Assert.assertEquals("Error testing post writeFloat/readFloat round-tripping", bbe.length, 4);
            Assert.assertEquals("Error testing post writeFloat/readFloat round-tripping", bbe.position, 4);
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


        Assert.assertEquals("Error testing post writeDouble/readDouble round-tripping", ble.length, 8);
        Assert.assertEquals("Error testing post writeDouble/readDouble round-tripping", ble.position, 8);

        //check bytes
        Assert.assertTrue("Error testing post writeDouble/readDouble round-tripping", bytesMatchExpectedData(ble,[195,245,40,92,143,162,85,64]));

        var bbe:BinaryData = new BinaryData();
        //test BIG_ENDIAN round-tripping
        bbe.endian = Endian.BIG_ENDIAN;
        bbe.writeDouble(86.54);


        Assert.assertEquals("Error testing post writeDouble/readDouble round-tripping", bbe.length, 8);
        Assert.assertEquals("Error testing post writeDouble/readDouble round-tripping", bbe.position, 8);
        //check bytes

        Assert.assertTrue("Error testing post writeDouble/readDouble round-tripping", bytesMatchExpectedData(bbe,[64,85,162,143,92,40,245,195]));


        ble.position = 0;
        bbe.position = 0;
        Assert.assertEquals("Error testing post writeDouble/readDouble round-tripping", bbe.readDouble(), 86.54);
        Assert.assertEquals("Error testing post writeDouble/readDouble round-tripping", ble.readDouble(), 86.54);

        Assert.assertEquals("Error testing post writeDouble/readDouble round-tripping", bbe.position, 8);
        Assert.assertEquals("Error testing post writeDouble/readDouble round-tripping", ble.position, 8);

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
