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
package flexUnitTests
{
    import org.apache.royale.utils.date.*;
    import org.apache.royale.core.Strand;
    import org.apache.royale.test.asserts.*;
    
    public class DateUtilsTest
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
        }
        
        [AfterClass]
        public static function tearDownAfterClass():void
        {
        }
        
        [Test]
        public function testAddDays():void
        {
            var date:Date = new Date(1995, 11, 17);
            var newDate:Date = addDays(date);

            assertTrue(date != newDate,"Dates should not be equal");
            assertEquals(date.getDate() + 1, newDate.getDate(), "New date should be next day");
            newDate = addDays(date,2);
            assertTrue(date != newDate,"Dates should not be equal");
            assertEquals(date.getDate() + 2, newDate.getDate(), "New date should be two days later");
            newDate = addDays(date,-2);
            assertTrue(date != newDate,"Dates should not be equal");
            assertEquals(date.getDate() - 2, newDate.getDate(), "New date should be two days earlier");
        }

        [Test]
        public function testAddHours():void
        {
            var date:Date = new Date(1995, 11, 17, 10, 5, 11);
            var newDate:Date = addHours(date);

            assertTrue(date != newDate,"Dates should not be equal");
            assertEquals(date.getHours() + 1, newDate.getHours(), "New date should be next hour");
            newDate = addHours(date,2);
            assertTrue(date != newDate,"Dates should not be equal");
            assertEquals(date.getHours() + 2, newDate.getHours(), "New date should be two hours later");
            newDate = addHours(date,-2);
            assertTrue(date != newDate,"Dates should not be equal");
            assertEquals(date.getHours() - 2, newDate.getHours(), "New date should be two hours earlier");
        }

        [Test]
        public function testAddMinutes():void
        {
            var date:Date = new Date(1995, 11, 17, 10, 5, 11);
            var newDate:Date = addMinutes(date);

            assertTrue(date != newDate,"Dates should not be equal");
            assertEquals(date.getMinutes() + 1, newDate.getMinutes(), "New date should be next minute");
            newDate = addMinutes(date,2);
            assertTrue(date != newDate,"Dates should not be equal");
            assertEquals(date.getMinutes() + 2, newDate.getMinutes(), "New date should be two minutes later");
            newDate = addMinutes(date,-2);
            assertTrue(date != newDate,"Dates should not be equal");
            assertEquals(date.getMinutes() - 2, newDate.getMinutes(), "New date should be two minutes earlier");
        }

        [Test]
        public function testAddMonths():void
        {
            var date:Date = new Date(1995, 9, 17, 10, 5, 11);
            var newDate:Date = addMonths(date);

            assertTrue(date != newDate,"Dates should not be equal");
            assertEquals(date.getMonth() + 1, newDate.getMonth(), "New date should be next month");
            newDate = addMonths(date,2);
            assertTrue(date != newDate,"Dates should not be equal");
            assertEquals(date.getMonth() + 2, newDate.getMonth(), "New date should be two months later");
            newDate = addMonths(date,-2);
            assertTrue(date != newDate,"Dates should not be equal");
            assertEquals(date.getMonth() - 2, newDate.getMonth(), "New date should be two months earlier");
        }

        [Test]
        public function testAddSeconds():void
        {
            var date:Date = new Date(1995, 11, 17, 10, 5, 11);
            var newDate:Date = addSeconds(date);

            assertTrue(date != newDate,"Dates should not be equal");
            assertEquals(date.getSeconds() + 1, newDate.getSeconds(), "New date should be next second");
            newDate = addSeconds(date,2);
            assertTrue(date != newDate,"Dates should not be equal");
            assertEquals(date.getSeconds() + 2, newDate.getSeconds(), "New date should be two seconds later");
            newDate = addSeconds(date,-2);
            assertTrue(date != newDate,"Dates should not be equal");
            assertEquals(date.getSeconds() - 2, newDate.getSeconds(), "New date should be two seconds earlier");
        }

        [Test]
        public function testAddYears():void
        {
            var date:Date = new Date(1995, 11, 17, 10, 5, 11);
            var newDate:Date = addYears(date);

            assertTrue(date != newDate,"Dates should not be equal");
            assertEquals(date.getFullYear() + 1, newDate.getFullYear(), "New date should be next year");
            newDate = addYears(date,2);
            assertTrue(date != newDate,"Dates should not be equal");
            assertEquals(date.getFullYear() + 2, newDate.getFullYear(), "New date should be two years later");
            newDate = addYears(date,-2);
            assertTrue(date != newDate,"Dates should not be equal");
            assertEquals(date.getFullYear() - 2, newDate.getFullYear(), "New date should be two years earlier");
        }

    }
}
