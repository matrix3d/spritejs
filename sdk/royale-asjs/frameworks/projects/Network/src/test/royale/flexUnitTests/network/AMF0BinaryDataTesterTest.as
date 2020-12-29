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
package flexUnitTests.network
{
    
    
    import flexUnitTests.network.support.DynamicPropertyWriter;
    import flexUnitTests.network.support.DynamicTestClass2;
    import flexUnitTests.network.support.TestClass1;
    import flexUnitTests.network.support.TestClass2;
    import flexUnitTests.network.support.TestClass3;
    import flexUnitTests.network.support.TestClass4;
    import flexUnitTests.network.support.DynamicTestClass;
    import flexUnitTests.network.support.TestClass6;
    import flexUnitTests.network.support.TestClass7a;
    import flexUnitTests.network.support.TestClass7b;

    import org.apache.royale.net.remoting.amf.AMFBinaryData;
    import org.apache.royale.net.remoting.amf.AMF0SupportBead;

    import org.apache.royale.test.asserts.*;
    import org.apache.royale.reflection.*;
    

    public class AMF0BinaryDataTesterTest
    {

        [Before]
        public function setUp():void
        {
        }
        
        [After]
        public function tearDown():void
        {
        }
        
        [BeforeClass]
        public static function setUpBeforeClass():void
        {
            ExtraData.addAll();
            //this is simply to avoid adding the bead in the RoyaleUnit Application:
            AMF0SupportBead.installAMF0Support();
        }
        
        [AfterClass]
        public static function tearDownAfterClass():void
        {
        }
        
        private function createAMFOBinaryData():AMFBinaryData{
            var amf:AMFBinaryData = new AMFBinaryData();
            amf.objectEncoding = 0;
            return amf;
        }
        
        
        //util check functions
        private static function bytesMatchExpectedData(bd:AMFBinaryData, expected:Array, offset:int = 0):Boolean
        {
            var len:uint = expected.length;
            var end:uint = offset + len;
            for (var i:int = offset; i < end; i++)
            {
                var check:uint = bd.readByteAt(i);
                if (expected[i - offset] != check)
                {
                    // trace('failed at ',i,expected[i-offset],check);
                    return false;
                }
            }
            return true;
        }
        
        private static function dynamicKeyCountMatches(forObject:Object, expectedCount:uint):Boolean
        {
            var keyCount:uint = 0;
            for (var key:String in forObject)
            {
                keyCount++;
            }
            return keyCount === expectedCount;
            
        }
        
        [Test]
        public function testStringObjectEncoding():void
        {
            var ba:AMFBinaryData = createAMFOBinaryData();
            var testString:String = 'testString';
            
            ba.writeObject(testString);

            assertEquals( ba.length, 13, "post-write length was not correct");
            assertEquals( ba.position, 13, "post-write position was not correct");
            ba.position = 0;
            var readString:String = ba.readObject() as String;
            assertEquals( readString, testString, "post-write read of written string was not correct");

            //test long string
            var baseString:String = '';
            var l:uint = 100;
            while (l) {
                baseString += String.fromCharCode(32+100-l);
                l--;
            }
            var buffer:Array = [];
            while (l<65536) {
                buffer.push(baseString);
                l += 100;
            }
            baseString = buffer.join('');

            ba.length = 0;
            ba.writeObject(baseString);

            assertEquals( ba.length, 68229, "post-write length was not correct");
            assertEquals( ba.position, 68229, "post-write position was not correct");
            ba.position = 0;
            readString = ba.readObject() as String;
            assertEquals( readString, baseString, "post-write read of written string was not correct");

            ba.length=0;
            ba.writeObject('');
            assertEquals( ba.length, 3, "post-write length was not correct");
            assertEquals( ba.position, 3, "post-write position was not correct");
            ba.position = 0;
            readString = ba.readObject() as String;
            assertEquals( readString, '', "post-write read of written string was not correct");
        }
        
        [Test]
        public function testBooleanObjectEncoding():void
        {
            var ba:AMFBinaryData = createAMFOBinaryData();
            
            ba.writeObject(false);
            ba.writeObject(true);
            
            assertEquals( ba.length, 4, "post-write length was not correct");
            assertEquals( ba.position, 4, "post-write position was not correct");
            ba.position = 0;
            
            assertTrue( ba.readObject() === false, "post-write read of written boolean was not correct");
            assertTrue( ba.readObject() === true, "post-write read of written boolean was not correct");
        }
        
        [Test]
        public function testNumberEncoding():void
        {
            var ba:AMFBinaryData = createAMFOBinaryData();
            
            
            ba.writeObject(NaN);
            ba.writeObject(1.0);
            ba.writeObject(-1.0);
            ba.writeObject(1.5);
            ba.writeObject(-1.5);
            ba.writeObject(Infinity);
            ba.writeObject(-Infinity);
            
            assertEquals( ba.length, 63, "post-write length was not correct");
            assertEquals( ba.position, 63, "post-write position was not correct");
            ba.position = 0;
            
            var num:Number = ba.readObject();
            assertTrue( (num is Number), "post-write read of written Number was not correct");
            assertTrue( isNaN(num), "post-write read of written Number was not correct");
            num = ba.readObject();
            assertTrue( (num is Number), "post-write read of written Number was not correct");
            assertTrue( num === 1.0, "post-write read of written Number was not correct");
            num = ba.readObject();
            assertTrue( (num is Number), "post-write read of written Number was not correct");
            assertTrue( num === -1.0, "post-write read of written Number was not correct");
            num = ba.readObject();
            assertTrue( (num is Number), "post-write read of written Number was not correct");
            assertTrue( num === 1.5, "post-write read of written Number was not correct");
            num = ba.readObject();
            assertTrue( (num is Number), "post-write read of written Number was not correct");
            assertTrue( num === -1.5, "post-write read of written Number was not correct");
            num = ba.readObject();
            assertTrue( (num is Number), "post-write read of written Number was not correct");
            assertTrue( !isFinite(num), "post-write read of written Number was not correct");
            assertTrue( (num > 0), "post-write read of written Number was not correct");
            num = ba.readObject();
            assertTrue( (num is Number), "post-write read of written Number was not correct");
            assertTrue( !isFinite(num), "post-write read of written Number was not correct");
            assertTrue( (num < 0), "post-write read of written Number was not correct");
        }

        [Test]
        public function testNullAndUndefinedEncoding():void
        {
            var ba:AMFBinaryData = createAMFOBinaryData();
            ba.writeObject(null);
            ba.writeObject(undefined);

            ba.position = 0;
            var val:* = ba.readObject();
            assertStrictlyEquals(val, null, 'Should be null');
            val = ba.readObject();
            assertStrictlyEquals(val, undefined, 'Should be undefined');
        }
        
        
        [Test]
        public function testArrayInstance():void
        {
            var ba:AMFBinaryData = createAMFOBinaryData();
            var instance:Array = [];
            ba.writeObject(instance);

            assertEquals( ba.length, 8, "post-write length was not correct");
            assertEquals( ba.position, 8, "post-write position was not correct");


            instance = [99];
            ba.length = 0;
            ba.writeObject(instance);
            ba.position = 0;

            assertTrue( bytesMatchExpectedData(ba, [0x08, 0x00, 0x00, 0x00, 0x01, 0x00, 0x01, 0x30, 0x00, 0x40, 0x58, 0xc0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x09]), "post-write bytes did not match expected data");
            instance = ba.readObject() as Array;
            assertTrue( instance.length == 1 && instance[0] == 99, "post-write read did not match expected result");
            //sparse array
            instance = [];
            instance[100] = '100';
            ba.length = 0;
            ba.writeObject(instance);


            assertEquals( ba.length, 19, "post-write length was not correct");
            assertEquals( ba.position, 19, "post-write position was not correct");
            assertTrue( bytesMatchExpectedData(ba, [0x08, 0x00, 0x00, 0x00, 0x65, 0x00, 0x03, 0x31, 0x30, 0x30, 0x02, 0x00, 0x03, 0x31, 0x30, 0x30, 0x00, 0x00, 0x09]), "post-write bytes did not match expected data");
            //check that read matches
            ba.position = 0;
            instance = ba.readObject();
            
            assertEquals( instance.length, 101, "post-write read was not correct");
            assertEquals( instance[100], '100', "post-write read was not correct");
            assertTrue( instance[0] === undefined, "post-write read was not correct");
            //sparse with associative content
            instance = [];
            instance['test'] = true;
            instance[10] = 'I am number 10';
            ba.length = 0;
            ba.writeObject(instance);

            assertEquals( ba.length, 37, "post-write length was not correct");
            assertEquals( ba.position, 37, "post-write position was not correct");
            assertTrue( bytesMatchExpectedData(ba, [0x08, 0x00, 0x00, 0x00, 0x0b, 0x00, 0x02, 0x31, 0x30, 0x02, 0x00, 0x0e, 0x49, 0x20, 0x61, 0x6d, 0x20, 0x6e, 0x75, 0x6d, 0x62, 0x65, 0x72, 0x20, 0x31, 0x30, 0x00, 0x04, 0x74, 0x65, 0x73, 0x74, 0x01, 0x01, 0x00, 0x00, 0x09]), "post-write bytes did not match expected data");
            
            //check that read matches
            ba.position = 0;
            instance = ba.readObject();
            assertEquals( instance.length, 11, "post-write read was not correct");
            assertEquals( instance[10], 'I am number 10', "post-write read was not correct");
            assertEquals( instance['test'], true, "post-write read was not correct");
            assertTrue( instance[0] === undefined, "post-write read was not correct");
            
            //edge cases
            instance = [];
            //length ==2 and Object.keys().length ==2
            //but no dense keys;
            instance[1] = true;
            instance['test'] = true;
            ba.length = 0;
            ba.writeObject(instance);

            assertEquals( ba.length, 21, "post-write length was not correct");
            assertEquals( ba.position, 21, "post-write position was not correct");

            assertTrue( bytesMatchExpectedData(ba, [0x08, 0x00, 0x00, 0x00, 0x02, 0x00, 0x01, 0x31, 0x01, 0x01, 0x00, 0x04, 0x74, 0x65, 0x73, 0x74, 0x01, 0x01, 0x00, 0x00, 0x09]), "post-write bytes did not match expected data");
            
            //empty array with length
            instance = new Array(100);
            assertEquals( instance.length, 100, "pre-write array length was not correct");
            ba.length = 0;
            ba.writeObject(instance);

            assertEquals( ba.length, 8, "post-write length was not correct");
            assertEquals( ba.position, 8, "post-write position was not correct");
            assertTrue( bytesMatchExpectedData(ba, [0x08, 0x00, 0x00, 0x00, 0x64, 0x00, 0x00, 0x09]), "post-write bytes did not match expected data");
            
            ba.position = 0;
            instance = ba.readObject() as Array;

            //AMF0 keeps original array length here, AMF3 does not :
            assertTrue( instance.length == 100, "post-write read did not match expected value");
            
            var ar:Array = [1, 2, 3];
            var f:Function = function ():void
            {
                trace('func')
            };
            ar['__AS3__.vec'] = f;
            ba.length = 0;
            ba.writeObject(ar);

            assertEquals( ba.length, 44, "post-write length was not correct");
            assertEquals( ba.position, 44, "post-write position was not correct");
            assertTrue( bytesMatchExpectedData(ba, [0x08, 0x00, 0x00, 0x00, 0x03, 0x00, 0x01, 0x30, 0x00, 0x3f, 0xf0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x31, 0x00, 0x40, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x32, 0x00, 0x40, 0x08, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x09]), "post-write bytes did not match expected data");
            ar = [f, 1, 2, 3, f];
            ba.length = 0;
            ba.writeObject(ar);

            assertEquals( ba.length, 44, "post-write length was not correct");
            assertEquals( ba.position, 44, "post-write position was not correct");

            assertTrue( bytesMatchExpectedData(ba, [0x08, 0x00, 0x00, 0x00, 0x05, 0x00, 0x01, 0x31, 0x00, 0x3f, 0xf0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x32, 0x00, 0x40, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x33, 0x00, 0x40, 0x08, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x09]), "post-write bytes did not match expected data");

            ba.position = 0;
            ar = ba.readObject();
            //post write read is an array with length of 4 instead of 5 in amf3, but is 5 in amf0.
            assertEquals( ar.length, 5, "post-write read length was not correct");

            
            ar = [Object, 1, 2, 3, Object];
            ba.length = 0;
            ba.writeObject(ar);

            assertEquals( ba.length, 57, "post-write length was not correct");
            assertEquals( ba.position, 57, "post-write position was not correct");
            assertTrue( bytesMatchExpectedData(ba, [0x08, 0x00, 0x00, 0x00, 0x05, 0x00, 0x01, 0x30, 0x03, 0x00, 0x00, 0x09, 0x00, 0x01, 0x31, 0x00, 0x3f, 0xf0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x32, 0x00, 0x40, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x33, 0x00, 0x40, 0x08, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x34, 0x07, 0x00, 0x01, 0x00, 0x00, 0x09]), "post-write bytes did not match expected data");

            //it seems that the flash player always encodes as ecma array, but we should also test reading of an externally encoded 'strict' array (as per spec)
            //strict array = AMF_STRICT_ARRAY 0x0a, count U32, count * (value-type)
            //manual recreation of  array: [99, 'hello', false, null]
            ba.length=0;
            ba.writeByte(0x0a);
            ba.writeUnsignedInt(4);
            ba.writeObject(99);
            ba.writeObject('hello');
            ba.writeObject(false);
            ba.writeObject(null);
            ba.position = 0;

            assertTrue( bytesMatchExpectedData(ba, [0x0a, 0x00, 0x00, 0x00, 0x04, 0x00, 0x40, 0x58, 0xc0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x02, 0x00, 0x05, 0x68, 0x65, 0x6c, 0x6c, 0x6f, 0x01, 0x00, 0x05]), "post-write bytes did not match expected data");
            //now to read the 'strict' definition
            ar = ba.readObject();
            //check whether it matches the expected result
            assertEquals( JSON.stringify(ar), '[99,"hello",false,null]', "post-write read was not correct");

        }
        
        
        [Test]
        public function testAnonObject():void
        {
            var ba:AMFBinaryData = createAMFOBinaryData();
            
            var instance:Object = {};
            ba.writeObject(instance);

            assertEquals( ba.length, 4, "post-write length was not correct");
            assertEquals( ba.position, 4, "post-write position was not correct");
            ba.position = 0;
            
            assertTrue( bytesMatchExpectedData(ba, [0x03, 0x00, 0x00, 0x09]), "post-write bytes did not match expected data");
            instance = ba.readObject();
            assertTrue( dynamicKeyCountMatches(instance, 0), "post-write read did not match expected result");
            
            var obj1:Object = {test: true};
            var obj2:Object = {test: 'maybe'};
            var obj3:Object = {test: true};
            ba.length = 0;
            ba.writeObject([obj1, obj2, obj3]);
            ba.position = 0;

            assertTrue( bytesMatchExpectedData(ba, [0x08, 0x00, 0x00, 0x00, 0x03, 0x00, 0x01, 0x30, 0x03, 0x00, 0x04, 0x74, 0x65, 0x73, 0x74, 0x01, 0x01, 0x00, 0x00, 0x09, 0x00, 0x01, 0x31, 0x03, 0x00, 0x04, 0x74, 0x65, 0x73, 0x74, 0x02, 0x00, 0x05, 0x6d, 0x61, 0x79, 0x62, 0x65, 0x00, 0x00, 0x09, 0x00, 0x01, 0x32, 0x03, 0x00, 0x04, 0x74, 0x65, 0x73, 0x74, 0x01, 0x01, 0x00, 0x00, 0x09, 0x00, 0x00, 0x09]), "post-write bytes did not match expected data");

            ba.writeObject([obj1, obj3, obj1]);
            ba.position = 0;

        }
        
        
        [Test]
        public function testFunction():void
        {
            var ba:AMFBinaryData = createAMFOBinaryData();
            //functions are always encoded as undefined
            var instance:Function = function ():void
            {
            };
            ba.writeObject(instance);
            
            assertEquals( ba.length, 1, "post-write length was not correct");
            assertEquals( ba.position, 1, "post-write position was not correct");
            ba.position = 0;
            
            assertTrue( bytesMatchExpectedData(ba, [0x06]), "post-write bytes did not match expected data");
            instance = ba.readObject();
            
            assertTrue( instance === null, "post-write read did not match expected result");


            //for a property that has a function value, the property is also undefined
            var objectWithFunction:Object = {
                'function': function ():void
                {
                }
            };
            ba.length = 0;
            ba.writeObject(objectWithFunction);

            assertEquals( ba.length, 4, "post-write length was not correct");
            assertEquals( ba.position, 4, "post-write position was not correct");
            ba.position = 0;
            assertTrue( bytesMatchExpectedData(ba, [0x03, 0x00, 0x00, 0x09]), "post-write bytes did not match expected data");
            
            //the dynamic deserialized object has no key for the function value
            var obj:Object = ba.readObject();
            assertTrue( dynamicKeyCountMatches(obj, 0), "post-write read did not match expected result");
            
            ba.length = 0;
            var tc4:TestClass4 = new TestClass4();
            tc4.testField1 = function ():void
            {
            };
            
            ba.writeObject(tc4);

            assertEquals( ba.length, 17, "post-write length was not correct");
            assertEquals( ba.position, 17, "post-write position was not correct");
            
            assertTrue( bytesMatchExpectedData(ba, [0x03, 0x00, 0x0a, 0x74, 0x65, 0x73, 0x74, 0x46, 0x69, 0x65, 0x6c, 0x64, 0x31, 0x06, 0x00, 0x00, 0x09]), "post-write bytes did not match expected data");
            
        }
        
        
        [Test]
        /**
         * @royaleignorecoercion TestClass1
         */
        public function testBasicClassInstance():void
        {
            var ba:AMFBinaryData = createAMFOBinaryData();
            
            var instance:TestClass1 = new TestClass1();
            ba.writeObject(instance);

            assertEquals( ba.length, 19, "post-write length was not correct");
            assertEquals( ba.position, 19, "post-write position was not correct");
            
            ba.position = 0;
            assertTrue( bytesMatchExpectedData(ba, [0x03, 0x00, 0x0a, 0x74, 0x65, 0x73, 0x74, 0x46, 0x69, 0x65, 0x6c, 0x64, 0x31, 0x02, 0x00, 0x00, 0x00, 0x00, 0x09]), "post-write bytes did not match expected data");
            ba.position = 0;
            
            var anonObject:Object = ba.readObject();
            
            assertTrue(anonObject['testField1'] === instance.testField1, "post-write read did not match expected value" );
            
            var multipleDifferentInstances:Array = [new TestClass1(), new TestClass2()];
            ba.length = 0;
            ba.writeObject(multipleDifferentInstances);

            assertEquals( ba.length, 51, "post-write length was not correct");
            assertEquals( ba.position, 51, "post-write position was not correct");
            ba.position = 0;
            
            assertTrue( bytesMatchExpectedData(ba, [0x08, 0x00, 0x00, 0x00, 0x02, 0x00, 0x01, 0x30, 0x03, 0x00, 0x0a, 0x74, 0x65, 0x73, 0x74, 0x46, 0x69, 0x65, 0x6c, 0x64, 0x31, 0x02, 0x00, 0x00, 0x00, 0x00, 0x09, 0x00, 0x01, 0x31, 0x03, 0x00, 0x0a, 0x74, 0x65, 0x73, 0x74, 0x46, 0x69, 0x65, 0x6c, 0x64, 0x31, 0x01, 0x01, 0x00, 0x00, 0x09, 0x00, 0x00, 0x09]), "post-write bytes did not match expected data");
            
        }
        
        [Test]
        public function testDynamicClassInstance():void
        {
            var ba:AMFBinaryData = createAMFOBinaryData();
            var instance:DynamicTestClass = new DynamicTestClass();
            ba.writeObject(instance);

            assertEquals( ba.length, 27, "post-write length was not correct");
            assertEquals( ba.position, 27, "post-write position was not correct");
            ba.position = 0;
            assertTrue( bytesMatchExpectedData(ba, [0x03, 0x00, 0x13, 0x73, 0x65, 0x61, 0x6c, 0x65, 0x64, 0x49, 0x6e, 0x73, 0x74, 0x61, 0x6e, 0x63, 0x65, 0x50, 0x72, 0x6f, 0x70, 0x31, 0x01, 0x00, 0x00, 0x00, 0x09]), "post-write bytes did not match expected data");
            
            instance['someDynamicField'] = 'nonSealedPropValue';
            
            ba.writeObject(instance);

            assertEquals( ba.length, 66, "post-write length was not correct");
            assertEquals( ba.position, 66, "post-write position was not correct");
            ba.position = 0;
            assertTrue( bytesMatchExpectedData(ba, [0x03, 0x00, 0x13, 0x73, 0x65, 0x61, 0x6c, 0x65, 0x64, 0x49, 0x6e, 0x73, 0x74, 0x61, 0x6e, 0x63, 0x65, 0x50, 0x72, 0x6f, 0x70, 0x31, 0x01, 0x00, 0x00, 0x10, 0x73, 0x6f, 0x6d, 0x65, 0x44, 0x79, 0x6e, 0x61, 0x6d, 0x69, 0x63, 0x46, 0x69, 0x65, 0x6c, 0x64, 0x02, 0x00, 0x12, 0x6e, 0x6f, 0x6e, 0x53, 0x65, 0x61, 0x6c, 0x65, 0x64, 0x50, 0x72, 0x6f, 0x70, 0x56, 0x61, 0x6c, 0x75, 0x65, 0x00, 0x00, 0x09]), "post-write bytes did not match expected data");
            
            var instanceAnon:Object = ba.readObject();
            assertTrue(instanceAnon['someDynamicField'] === 'nonSealedPropValue', "post-write read did not match expected value");
            
            
        }
        
    //    [Test]
        public function testByteArray():void
        {
            //on swf it is native ByteArray that encodes to 'ByteArray', in js it is AMFBinaryData
            COMPILE::SWF{
                import flash.utils.ByteArray;
                
                var source:ByteArray = new ByteArray();
            }
            
            COMPILE::JS{
                var source:AMFBinaryData = createAMFOBinaryData();
            }
            
            for (var i:uint = 0; i < 26; i++) source.writeByte(i);
            var ba:AMFBinaryData = createAMFOBinaryData();
            var holder:Array = [source, source];
            
            ba.writeObject(holder);
            assertEquals( ba.length, 33, "post-write error length was not correct");
            assertEquals( ba.position, 33, "post-write error position was not correct");
            ba.position = 0;
            assertTrue( bytesMatchExpectedData(ba, [9, 5, 1, 12, 53, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 12, 2]), "post-write bytes did not match expected data");
        }
        
        
    //    [Test]
        public function testExternalizable():void
        {
            var ba:AMFBinaryData = createAMFOBinaryData();
            var test3:TestClass3 = new TestClass3();
            //TestClass3 is externalizable and does not have an alias, this is an error in flash
            
            var err:Error;
            try
            {
                ba.writeObject(test3);
            } catch (e:Error)
            {
                err = e;
            }
            
            assertTrue( err != null, "externalizable writing should fail without an alias registered");
            assertEquals( ba.length, 1, "post-write error length was not correct");
            assertEquals( ba.position, 1, "post-write error position was not correct");
            ba.position = 0;
            assertTrue( bytesMatchExpectedData(ba, [10]), "post-write bytes did not match expected data");
            
            ba.length = 0;
            //register an alias
            registerClassAlias('TestClass3', TestClass3);
            ba.writeObject(test3);
            assertEquals( ba.length, 18, "post-write length was not correct");
            assertEquals( ba.position, 18, "post-write position was not correct");
            
            ba.position = 0;
            assertTrue( bytesMatchExpectedData(ba, [10, 7, 21, 84, 101, 115, 116, 67, 108, 97, 115, 115, 51, 9, 3, 1, 6, 0]), "post-write bytes did not match expected data");
            
            test3.content[0] = (test3.content[0]).split("").reverse().join("");
            ba.writeObject(test3);
            assertEquals( ba.length, 28, "post-write length was not correct");
            assertEquals( ba.position, 28, "post-write position was not correct");
            assertTrue( bytesMatchExpectedData(ba, [10, 7, 21, 84, 101, 115, 116, 67, 108, 97, 115, 115, 51, 9, 3, 1, 6, 21, 51, 115, 115, 97, 108, 67, 116, 115, 101, 84]), "post-write bytes did not match expected data");
            
            ba.position = 0;
            var test3Read:TestClass3 = ba.readObject() as TestClass3;
            
            //proof that it created a new instance, and that the reversed content string content is present in the new instance
            assertTrue( test3Read.content[0] == test3.content[0], "post-write read did not match expected data");
            
        }
        
        
    //    [Test]
        public function testDynamicPropertyWriter():void
        {
            var ba:AMFBinaryData = createAMFOBinaryData();
            var instance:DynamicTestClass2 = new DynamicTestClass2();
            instance['_underscore'] = 'pseudo - private value';
            instance['raining'] = 'cats and dogs';
            
            ba.writeObject(instance);

            assertEquals( ba.length, 84, "post-write length was not correct");
            assertEquals( ba.position, 84, "post-write position was not correct");
            
            //in this case the order of encoding the dynamic fields is not defined. So we need to account for the valid serialization options of either output sequence of the two fields
            var raining_then_underscore:Array = [10, 27, 1, 39, 115, 101, 97, 108, 101, 100, 73, 110, 115, 116, 97, 110, 99, 101, 80, 114, 111, 112, 49, 2, 15, 114, 97, 105, 110, 105, 110, 103, 6, 27, 99, 97, 116, 115, 32, 97, 110, 100, 32, 100, 111, 103, 115, 23, 95, 117, 110, 100, 101, 114, 115, 99, 111, 114, 101, 6, 45, 112, 115, 101, 117, 100, 111, 32, 45, 32, 112, 114, 105, 118, 97, 116, 101, 32, 118, 97, 108, 117, 101, 1];
            var underscore_then_raining:Array = [10, 27, 1, 39, 115, 101, 97, 108, 101, 100, 73, 110, 115, 116, 97, 110, 99, 101, 80, 114, 111, 112, 49, 2, 23, 95, 117, 110, 100, 101, 114, 115, 99, 111, 114, 101, 6, 45, 112, 115, 101, 117, 100, 111, 32, 45, 32, 112, 114, 105, 118, 97, 116, 101, 32, 118, 97, 108, 117, 101, 15, 114, 97, 105, 110, 105, 110, 103, 6, 27, 99, 97, 116, 115, 32, 97, 110, 100, 32, 100, 111, 103, 115, 1];
            
            ba.position = 0;
            assertTrue( bytesMatchExpectedData(ba, raining_then_underscore) || bytesMatchExpectedData(ba, underscore_then_raining), "post-write bytes did not match expected data");
            
            //now test the same instance with an IDynamicPropertyWriter that ignores the underscored field, only outputting the 'raining' field
            ba.length = 0;
            AMFBinaryData.dynamicPropertyWriter = new DynamicPropertyWriter();
            ba.writeObject(instance);
            assertEquals( ba.length, 48, "post-write length was not correct");
            assertEquals( ba.position, 48, "post-write position was not correct");
            ba.position = 0;
            assertTrue( bytesMatchExpectedData(ba, [10, 27, 1, 39, 115, 101, 97, 108, 101, 100, 73, 110, 115, 116, 97, 110, 99, 101, 80, 114, 111, 112, 49, 2, 15, 114, 97, 105, 110, 105, 110, 103, 6, 27, 99, 97, 116, 115, 32, 97, 110, 100, 32, 100, 111, 103, 115, 1]), "post-write bytes did not match expected data");
            
            //remove the custom dynamicPropertyWriter
            AMFBinaryData.dynamicPropertyWriter = null;
            
        }
        
        [Test]
        public function testXML():void
        {
            var ba:AMFBinaryData = createAMFOBinaryData();
            var xml:XML =   <xml><item/></xml>;
            
            ba.writeObject(xml);

            assertEquals( ba.length, 4, "post-write length was not correct");
            assertEquals( ba.position, 4, "post-write position was not correct");
            ba.position = 0;
            assertTrue( bytesMatchExpectedData(ba, [0x03, 0x00, 0x00, 0x09]), "post-write bytes did not match expected data");


            var xml2:XML = ba.readObject() as XML;

            assertNull(xml2, 'e4X XML does not survive round-tripping via amf0');
            //even attributes are not encoded:
            xml = <xml test="testatt"/>;
            ba.position = 0;
            ba.length=0;
            ba.writeObject(xml);
            assertTrue( bytesMatchExpectedData(ba, [0x03, 0x00, 0x00, 0x09]), "post-write bytes did not match expected data");


            //javascript toXMLString pretty printing may not match exactly flash...
            //assertTrue( xml.toXMLString() === xml2.toXMLString(), "XML round-tripping failed");

        }
    
    
    //    [Test]
        public function testWithCustomNS():void
        {
            var ba:AMFBinaryData = createAMFOBinaryData();
            var test:TestClass6 = new TestClass6();
            ba.writeObject(test);
            ba.position = 0;
            assertEquals(ba.length, 50, 'unexpected serialized content with custom namespaces');
            //cover variation in order
            const validOptions:Array = [
                    '0a23010b6d79566172156d794163636573736f7206177075626c69634d79566172061f7075626c6963206163636573736f72',
                    '0a2301156d794163636573736f720b6d79566172061f7075626c6963206163636573736f7206177075626c69634d79566172'
            ];
            
            assertTrue(validOptions.indexOf(getBytesOut(ba)) != -1, 'unexpected byte content with custom namespace content');
            
            var restored:Object = ba.readObject();
            
            var json:String = JSON.stringify(restored)
            //order may be different... need json object check here for: {"myAccessor":"public accessor","myVar":"publicMyVar"}
        }

   //     [Test]
        public function testTransientAndBindable():void{
            var ba:AMFBinaryData = createAMFOBinaryData();
            registerClassAlias('TestClass7a', TestClass7a);
            registerClassAlias('TestClass7b', TestClass7b);
            var test1:TestClass7a = new TestClass7a();
            test1.something = 'whatever';
            ba.writeObject(test1);

            ba.position = 0;

            var retrieved:Object = ba.readObject();


            assertTrue(retrieved is TestClass7a, 'unexpected deserialization');

            var test2:TestClass7b = new TestClass7b();
            test1.something = 'whatever';
            ba.length = 0;
            ba.writeObject(test2);

            ba.position = 0;

            retrieved = ba.readObject();

            assertTrue(retrieved is TestClass7b, 'unexpected deserialization');

        }


   //     [Test]
        public function testTransientDeserialized():void{
            //if a transient field is already serialized, then we do deserialize it
            //this means it can be sent from the server (for example) but is not sent to the server

            //to test this we will use TestClass7b (where 'something' is not Transient) which will serialize the 'something' field with an alias that matches
            //a subsequent deserialization to a TestClass7a instance (where 'something' is Transient);
            //the expected result will be that the Transient field is still deserialized

            var ba:AMFBinaryData = createAMFOBinaryData();
            registerClassAlias('TestClass7a', TestClass7b);
            var test1:TestClass7b = new TestClass7b();
            test1.something = 'something interesting';
            ba.length = 0;
            //non-transient inbound:
            ba.writeObject(test1);

            //The bytes for the above can differ between swf and js. 54 vs. 57 bytes length
            //It is possible to correct that. But it is the swf output that is serializing the 'something' field twice
            // (second time is string ref for both field and value, so quite compact, but still unnecessary)
            //so not trying to match that exactly, because it is redundant data.

            ba.position = 0;

            //read it back as TestClass7a
            registerClassAlias('TestClass7a', TestClass7a);

            var retrieved:Object = ba.readObject();


            assertTrue(retrieved is TestClass7a, 'unexpected deserialization');
            assertEquals(retrieved.something , 'something interesting', 'unexpected deserialization');
            assertEquals(retrieved.test , 'test', 'unexpected deserialization');

            //this time round it won't be read out because it is Transient inbound:
            ba.position = 0;
            ba.length=0;
            ba.writeObject(retrieved);
            ba.position = 0;
            retrieved = ba.readObject();
            assertTrue(retrieved is TestClass7a, 'unexpected deserialization');
            assertEquals(retrieved.something , null, 'unexpected deserialization');
            assertEquals(retrieved.test , 'test', 'unexpected deserialization');
        }
        
        
        private function getBytesOut(bytes:AMFBinaryData, asTestData:Boolean=false):String{
            var out:Array = [];
            for each(var byte:uint in bytes) {
                if (asTestData)  out.push('0x'+('0'+byte.toString(16)).substr(-2));
                else out.push(('0'+byte.toString(16)).substr(-2));
            }
            return asTestData? '['+out.join(', ') +']':out.join('');
        }
    }
}
