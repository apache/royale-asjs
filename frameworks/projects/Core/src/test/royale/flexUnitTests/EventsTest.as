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
    import org.apache.royale.core.IParent;
    import org.apache.royale.utils.string.*;
    import org.apache.royale.test.asserts.*;

    import org.apache.royale.html.Group;
    import org.apache.royale.core.UIBase;
    import org.apache.royale.events.Event;
    
    public class EventsTest
    {

        private static var bubblingTopMostGroup:Group;
        private static var deepestInstance:UIBase;
        private static function createBubblingChain():void{
            var currentParent:IParent = bubblingTopMostGroup;
            var nesting:uint=10;
            while (nesting) {
                var child:UIBase = new UIBase();
                child.id = 'nested_'+(11-nesting);
                currentParent.addElement(child);
                nesting--;
                currentParent = child;
            }
            deepestInstance = child;
        }


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
            bubblingTopMostGroup = FlexUnitRoyaleApplication.getInstance().eventsTestParent;
            createBubblingChain();
        }
        
        [AfterClass]
        public static function tearDownAfterClass():void
        {
            bubblingTopMostGroup.removeElement(bubblingTopMostGroup.getElementAt(0));
            deepestInstance = null;
        }


        
        [Test]
        public function testDispatchNonBubblingChangeResult():void{
            var e:org.apache.royale.events.Event =  new org.apache.royale.events.Event(org.apache.royale.events.Event.CHANGE);
            var received:org.apache.royale.events.Event ;
            var receivedCurrentTarget:UIBase;
            var receivedTarget:UIBase;
            function localListener(e:org.apache.royale.events.Event):void{
                received = e;
                receivedTarget = e.target as UIBase;
                receivedCurrentTarget = e.currentTarget as UIBase;
            }
            deepestInstance.addEventListener(org.apache.royale.events.Event.CHANGE,localListener);
            deepestInstance.dispatchEvent(e);
            deepestInstance.removeEventListener(org.apache.royale.events.Event.CHANGE,localListener);


            assertEquals(received,e, 'the received event should be the same as the dispatched event');
            assertEquals(deepestInstance,receivedTarget, 'the bubbling event currentTarget is wrong');
            assertEquals(deepestInstance,receivedCurrentTarget, 'the bubbling event currentTarget is wrong');
        }

        [Test]
        public function testDispatchBubblingChangeResult():void{
            var e:org.apache.royale.events.Event =  new org.apache.royale.events.Event(org.apache.royale.events.Event.CHANGE,true);
            var received:org.apache.royale.events.Event ;
            var receivedCurrentTarget:UIBase;
            var receivedTarget:UIBase;
            function localListener(e:org.apache.royale.events.Event):void{
                received = e;
                receivedTarget = e.target as UIBase;
                receivedCurrentTarget = e.currentTarget as UIBase;

            }
            bubblingTopMostGroup.addEventListener(org.apache.royale.events.Event.CHANGE,localListener);
            deepestInstance.dispatchEvent(e);
            bubblingTopMostGroup.removeEventListener(org.apache.royale.events.Event.CHANGE,localListener);


            assertEquals(received,e, 'the received event should be the same as the dispatched event');
            assertEquals(deepestInstance,receivedTarget, 'the bubbling event currentTarget is wrong');
            assertEquals(bubblingTopMostGroup,receivedCurrentTarget, 'the bubbling event currentTarget is wrong');
        }


    }
}
