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
    import org.apache.royale.core.UIBase;
    import org.apache.royale.geom.Rectangle;
    import org.apache.royale.test.asserts.*;
    import org.apache.royale.utils.DisplayUtils;

    public class DisplayUtilsTest
    {
        private var target:UIBase;

        COMPILE::JS
        private var fixture:HTMLElement;

        COMPILE::JS
        private var originalScrollX:Number;

        COMPILE::JS
        private var originalScrollY:Number;

        [Before]
        public function setUp():void
        {
            COMPILE::JS
            {
                originalScrollX = window.pageXOffset;
                originalScrollY = window.pageYOffset;
                window.scrollTo(0, 0);

                fixture = document.createElement("div") as HTMLElement;
                fixture.style.position = "absolute";
                fixture.style.left = "0px";
                fixture.style.top = "0px";
                fixture.style.width = "1px";
                fixture.style.height = "3000px";
                document.body.appendChild(fixture);

                target = new UIBase();
                target.element.style.position = "absolute";
                target.element.style.left = "37px";
                target.element.style.top = "600px";
                target.element.style.width = "80px";
                target.element.style.height = "40px";
                fixture.appendChild(target.element);
            }
        }

        [After]
        public function tearDown():void
        {
            COMPILE::JS
            {
                window.scrollTo(originalScrollX, originalScrollY);
                document.body.removeChild(fixture);
                fixture = null;
                target = null;
            }
        }

        [Test]
        public function testScreenBoundsAtPageOffsetZero():void
        {
            COMPILE::JS
            {
                var clientBounds:Object = target.element.getBoundingClientRect();
                var bounds:Rectangle = DisplayUtils.getScreenBoundingRect(target);

                assertRectangleMatchesClientBounds(bounds, clientBounds);
            }
        }

        [Test]
        public function testScreenBoundsAfterDocumentScroll():void
        {
            COMPILE::JS
            {
                var before:Rectangle = DisplayUtils.getScreenBoundingRect(target);
                window.scrollTo(0, 200);
                var clientBounds:Object = target.element.getBoundingClientRect();
                var after:Rectangle = DisplayUtils.getScreenBoundingRect(target);

                assertRectangleMatchesClientBounds(after, clientBounds);
                assertNear(before.top - 200, after.top, "Document scrolling should move viewport bounds");
            }
        }

        [Test]
        public function testScreenBoundsInsideScrollingContainer():void
        {
            COMPILE::JS
            {
                var scroller:HTMLElement = document.createElement("div") as HTMLElement;
                scroller.style.position = "absolute";
                scroller.style.left = "150px";
                scroller.style.top = "100px";
                scroller.style.width = "200px";
                scroller.style.height = "100px";
                scroller.style.overflow = "auto";
                fixture.appendChild(scroller);

                target.element.style.left = "20px";
                target.element.style.top = "300px";
                scroller.appendChild(target.element);
                var before:Rectangle = DisplayUtils.getScreenBoundingRect(target);

                scroller.scrollTop = 120;
                var clientBounds:Object = target.element.getBoundingClientRect();
                var after:Rectangle = DisplayUtils.getScreenBoundingRect(target);

                assertRectangleMatchesClientBounds(after, clientBounds);
                assertNear(before.top - 120, after.top, "Ancestor scrolling should move viewport bounds");
            }
        }

        [Test]
        public function testBoundsBeforeTransformIsUsed():void
        {
            COMPILE::JS
            {
                var suppliedBounds:Rectangle = new Rectangle(10, 20, 30, 40);
                var bounds:Rectangle = DisplayUtils.getScreenBoundingRect(target, suppliedBounds);

                assertStrictlyEquals(suppliedBounds, bounds);
                assertEquals(10, bounds.left);
                assertEquals(20, bounds.top);
                assertEquals(40, bounds.right);
                assertEquals(60, bounds.bottom);
            }
        }

        [Test]
        public function testObjectsOverlapUsesViewportBounds():void
        {
            COMPILE::JS
            {
                var other:UIBase = new UIBase();
                other.element.style.position = "absolute";
                other.element.style.left = "100px";
                other.element.style.top = "620px";
                other.element.style.width = "40px";
                other.element.style.height = "40px";
                fixture.appendChild(other.element);

                assertTrue(DisplayUtils.objectsOverlap(target, other));

                other.element.style.left = "200px";
                assertFalse(DisplayUtils.objectsOverlap(target, other));
            }
        }

        COMPILE::JS
        private function assertRectangleMatchesClientBounds(bounds:Rectangle, clientBounds:Object):void
        {
            assertNear(clientBounds.left, bounds.left, "Incorrect left viewport coordinate");
            assertNear(clientBounds.top, bounds.top, "Incorrect top viewport coordinate");
            assertNear(clientBounds.right, bounds.right, "Incorrect right viewport coordinate");
            assertNear(clientBounds.bottom, bounds.bottom, "Incorrect bottom viewport coordinate");
        }

        COMPILE::JS
        private function assertNear(expected:Number, actual:Number, message:String):void
        {
            assertTrue(Math.abs(expected - actual) < 0.01, message + ": expected " + expected + " but was " + actual);
        }
    }
}